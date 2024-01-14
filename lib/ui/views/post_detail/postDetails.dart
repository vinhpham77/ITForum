import 'dart:async';
import 'package:cay_khe/dtos/follow_dto.dart';
import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:cay_khe/dtos/post_detail_dto.dart';
import 'package:cay_khe/models/bookmarkInfo.dart';
import 'package:cay_khe/models/follow.dart';
import 'package:cay_khe/repositories/bookmark_repository.dart';
import 'package:cay_khe/repositories/follow_repository.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/tag_repository.dart';
import 'package:cay_khe/repositories/vote_repository.dart';
import 'package:cay_khe/ui/common/utils/date_time.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/series_detail/votes_side.dart';
import 'package:cay_khe/ui/widgets/comment/comment_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../dtos/jwt_payload.dart';
import '../../../models/post.dart';
import 'package:markdown/markdown.dart' as markdown;
import '../../../models/user.dart';
import '../../../models/vote.dart';
import '../../../repositories/user_repository.dart';
import 'TableOfContents.dart';
import 'menuAnchor.dart';

class PostDetailsPage extends StatefulWidget {
  final String id;

  const PostDetailsPage({super.key, required this.id});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPage();
}

class _PostDetailsPage extends State<PostDetailsPage> {
  bool stateVote = false;
  bool upVote = false;
  bool downVote = false;
  bool typeVote = false;
  bool isBookmark = false;
  bool isLoading = true;
  bool isFollow = false;
  String type = "bài viết";
  String username = JwtPayload.sub ?? '';
  String idVote = '';
  String updatedAt = '';
  String _currentId = "";
  int totalPost = 0;
  int totalFollow = 0;
  int score = 0;
  List<String> listTag = [];
  List<DateTime> listDateTime = [];
  List<Post> posts = [];
  late List<String> listTitlePost;
  PostDetailDTO postDetailDTO = PostDetailDTO.empty();
  User user = User.empty();
  Follow follow = Follow.empty();
  final postRepository = PostRepository();
  final tagRepository = TagRepository();
  final voteRepository = VoteRepository();
  final bookmarkRepository = BookmarkRepository();
  final userRepository = UserRepository();
  final followRepository = FollowRepository();

  @override
  void initState() {
    super.initState();
    initPost(widget.id);
  }

  @override
  void didUpdateWidget(PostDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != _currentId) {
      _currentId = widget.id;
      initPost(_currentId);
    }
  }

  Future<void> initPost(String id) async {
    setState(() {
      isLoading = true;
    });
    await _loadPost(id);
    await _loadUser(JwtPayload.sub ?? '');
    await _loadCheckVote(id);
    await _loadBookmark(id);
    await _loadPostsByTheSameAuthor(postDetailDTO.user.username, widget.id);
    await _loadTotalPost(postDetailDTO.user.username);
    await _loadFollow(username, postDetailDTO.user.username);
    await _loadTotalFollower(postDetailDTO.user.username);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return checkPrivate(widget.id, JwtPayload.sub ?? '',
                postDetailDTO.user.username, postDetailDTO.private)
            ? SizedBox(
                width: constraints.maxWidth,
                child: Center(
                  child: SizedBox(
                    width: 1200,
                    child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _postActions(),
                                const SizedBox(width: 10),
                                _postBody(),
                                const SizedBox(width: 20),
                                _sidebar(),
                              ],
                            ),
                            CommentView(postId: widget.id)
                          ],
                        )),
                  ),
                ),
              )
            : const Center(
                child: Text(
                "Bạn không có quyền xem bài viết này",
                style: TextStyle(fontSize: 28),
              ));
      },
    );
  }

  Widget _postActions() {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          VoteSection(
              stateVote: stateVote,
              upVote: upVote,
              downVote: downVote,
              score: score,
              onUpVote: _upVote,
              onDownVote: _downVote),
          const SizedBox(height: 10),
          _buildBookmarkSection(isBookmark),
          const SizedBox(height: 10),
          _buildSocialShareSection(widget.id),
        ],
      ),
    );
  }

  Widget _buildBookmarkSection(bool isBookmark) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
          icon: Icon(isBookmark ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () => _toggleBookmark(),
          color: isBookmark ? Colors.blue : null),
    );
  }

  Widget _buildSocialShareSection(String idPost) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () =>
                _shareFacebook('http://localhost:8000/posts/$idPost'),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () => _sharePost('http://localhost:8000/posts/$idPost'),
          ),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareTwitter(
                  "http://localhost:8000/posts/$idPost",
                  "Đã share lên Twitter")),
        ],
      ),
    );
  }

  void _shareTwitter(String url, String text) async {
    final twitterUrl = 'https://twitter.com/intent/tweet?text=$text&url=$url';

    if (await canLaunchUrlString(twitterUrl)) {
      await launchUrlString(twitterUrl);
    } else {
      throw 'Could not launch $twitterUrl';
    }
  }

  Widget buildTagButton(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  bool checkPrivate(
      String postId, String userName, String authorName, bool isPrivate) {
    if (isPrivate && userName == authorName || !isPrivate) {
      return true;
    } else {
      return false;
    }
  }

  Widget _postBody() {
    var postPreview = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8.0,
                children: listTag.map((tag) => buildTagButton(tag)).toList(),
              ),
            ),
            MoreHoriz(
                idContent: widget.id,
                type: type,
                authorname: postDetailDTO.user.username,
                username: JwtPayload.sub ?? ''),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
              //   color: Colors.white,
              ),
          child: Markdown(
            data: getMarkdown(),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor: 1.4,
              h1: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 22),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18),
              h6: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 13),
              p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
              blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
              listBullet: const TextStyle(
                  fontSize: 16), // Custom list item bullet style
            ),
            softLineBreak: true,
            shrinkWrap: true,
          ),
        ),
      ],
    );
    return Expanded(
      child: isLoading
          ? Container(
              height: 600,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _builderAuthorPostContent(),
                postPreview,
              ],
            ),
    );
  }

  getMarkdown() {
    String titleRaw = postDetailDTO.title;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String content = postDetailDTO.content;
    String tags = "#";
    tags = tags + listTag.join('\t#');
    return '$title \n $content';
  }

  Future<void> _loadPost(String id) async {
    var future = postRepository.getOneDetails(id);
    future.then((response) {
      postDetailDTO = PostDetailDTO.fromJson(response.data);
      listTag = postDetailDTO.tags;
      updatedAt = "Đã đăng vào ${getTimeAgo(postDetailDTO.updatedAt)}";
      score = postDetailDTO.score;
    }).catchError((error) {
      appRouter.go("/not-found");
    });
  }

  Future<void> _loadUser(String username) async {
    try {
      var futureUser = await userRepository.getUser(username);
      if (mounted) {
        user = User.fromJson(futureUser.data);
      }
    } catch (error) {
      print("Người dùng chưa đăng nhập");
    }
  }

  Future<void> _loadCheckVote(String postId) async {
    var futureVote = await voteRepository.checkVote(postId);
    if (futureVote.data is Map<String, dynamic>) {
      Vote vote = Vote.fromJson(futureVote.data);
      if (mounted) {
        setState(() {
          upVote = vote.type;
          downVote = !vote.type;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          upVote = false;
          downVote = false;
        });
      }
    }
  }

  Future<void> _loadTotalPost(String username) async {
    var future = await postRepository.totalPost(username);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalPost = future.data;
        });
      }
    }
  }

  Future<void> _loadTotalFollower(String followedId) async {
    var future = await followRepository.totalFollower(followedId);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalFollow = future.data;
        });
      }
    } else {
      if (kDebugMode) {
        print("Error load total follower ");
      }
    }
  }

  void _follow() async {
    if (JwtPayload.sub == null) {
      appRouter.go("/login");
    } else {
      if (isFollow == true) {
        var future =
            await followRepository.checkFollow(postDetailDTO.user.username);
        if (future.data != "Follow not found") {
          Follow follow = Follow.fromJson(future.data);
          await followRepository.delete(follow.id);
          if (mounted) {
            setState(() {
              isFollow = false;
            });
          }
        }
      } else {
        FollowDTO newFollow = FollowDTO(
            follower: user.username,
            followed: postDetailDTO.user.username,
            createdAt: DateTime.now());
        await followRepository.add(newFollow);
        if (mounted) {
          setState(() {
            isFollow = true;
          });
        }
      }
      _loadTotalFollower(postDetailDTO.user.username);
    }
  }

  Future<void> _loadFollow(String follower, String followed) async {
    if (JwtPayload.sub == null) {
      return;
    }
    var future = await followRepository.checkFollow(followed);
    if (future.data is Map<String, dynamic>) {
      if (mounted) {
        setState(() {
          follow = Follow.fromJson(future.data);
          isFollow = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isFollow = false;
        });
      }
    }
  }

  Future<void> _loadBookmark(String itemId) async {
    var future = await bookmarkRepository.checkBookmark(itemId);
    if (future.data != null && future.data is bool) {
      bool isBookmarked = future.data;
      if (mounted) {
        isBookmark = isBookmarked;
      }
    } else {
      print("Error load bookmark");
    }
  }

  Future<void> _loadPostsByTheSameAuthor(
      String authorName, String postId) async {
    var future = postRepository.getPostsSameAuthor(authorName, postId);
    future.then((response) {
      setState(() {
        List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(response.data);
        posts = jsonDataList.map((json) => Post.fromJson(json)).toList();
        posts = posts.length > 5 ? posts.take(5).toList() : List.from(posts);
        listTitlePost = posts.map((post) => post.title).toList();
        listDateTime = posts.map((post) => post.updatedAt).toList();
      });
    }).catchError((error) {
      error.toString();
    });
  }

  Widget _builderAuthorPostContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildUserDetails(), Text(updatedAt)],
    );
  }

  Widget _buildUserDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            appRouter.go("/profile/${postDetailDTO.user.username}/posts");
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _buildPostImage(postDetailDTO.user.avatarUrl ?? ""),
          ),
        ),
        const SizedBox(width: 16),
        _buildUserProfile(),
        const SizedBox(width: 16),
        if (user.id != postDetailDTO.user.id) _buildFollowButton(),
      ],
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    appRouter
                        .go("/profile/${postDetailDTO.user.username}/posts");
                  },
                  child: Text(
                    postDetailDTO.user.displayName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 16),
                Text("@${postDetailDTO.user.username}"),
              ]),
        ),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconWithText(
                  Icons.verified_user_sharp, totalFollow.toString()),
              const SizedBox(width: 12),
              _buildIconWithText(Icons.pending_actions, totalPost.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    String messageValue = "";
    switch (icon) {
      case Icons.verified_user_sharp:
        messageValue = 'Người theo dõi';
        break;
      case Icons.pending_actions:
        messageValue = 'Bài viết';
        break;
      default:
        messageValue = 'Default Message';
    }
    return Tooltip(
      message: messageValue,
      child: Row(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: Center(child: Icon(icon)),
          ),
          const SizedBox(width: 2),
          Center(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: () => _follow(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF6C83FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isFollow ? const Icon(Icons.check, color: Colors.white,size: 16) : const Icon(Icons.add, color: Colors.white,size: 16),
          const SizedBox(width: 4),
          isFollow ? const Text("Đã theo dõi", style: TextStyle(color: Colors.white)) : const Text('Theo dõi', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<bool> checkVote(String postId) async {
    Future<bool> isFuture;
    var future = voteRepository.checkVote(postId);
    isFuture = future.then((response) {
      if (response.data == null) {
        return Future<bool>.value(false);
      } else {
        Vote vote = Vote.fromJson(response.data);
        idVote = vote.id;
        typeVote = vote.type;
        return Future<bool>.value(true);
      }
    }).catchError((error) {
      return Future<bool>.value(false);
    });
    return isFuture;
  }

  void _upVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote = true;
        });
        hasVoted = await checkVote(widget.id);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
              postId: widget.id,
              username: JwtPayload.sub,
              type: true,
              updatedAt: DateTime.now());
          await voteRepository.createVote(voteDTO);
          var postScore =
              await postRepository.updateScore(widget.id, score + 1);
          Post post = Post.fromJson(postScore.data);
          setState(() {
            score = post.score;
            upVote = true;
            downVote = false;
          });
        } else {
          if (hasVoted == true && upVote == true) {
            var postScore =
                await postRepository.updateScore(widget.id, score - 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(idVote);
          } else {
            if (hasVoted == true && downVote == true) {
              var postScore =
                  await postRepository.updateScore(widget.id, score + 2);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                upVote = true;
                downVote = false;
              });
            }
          }
        }
        setState(() {
          stateVote = false;
        });
      }
    }
  }

  void _downVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote == true;
        });

        hasVoted = await checkVote(widget.id);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
              postId: widget.id,
              username: JwtPayload.sub,
              type: false,
              updatedAt: DateTime.now());
          await voteRepository.createVote(voteDTO);
          var postScore =
              await postRepository.updateScore(widget.id, score - 1);
          Post post = Post.fromJson(postScore.data);
          setState(() {
            score = post.score;
            downVote = true;
            upVote = false;
          });
        } else {
          if (hasVoted == true && downVote == true) {
            var postScore =
                await postRepository.updateScore(widget.id, score + 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(idVote);
          } else {
            if (hasVoted == true && upVote == true) {
              var postScore =
                  await postRepository.updateScore(widget.id, score - 2);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                downVote = true;
                upVote = false;
              });
            }
          }
        }
        setState(() {
          stateVote = false;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (JwtPayload.sub != null) {
      if (isBookmark == true) {
        await bookmarkRepository.unBookmark(widget.id);
        setState(() {
          isBookmark = !isBookmark;
        });
      } else {
        if (isBookmark == false) {
          BookmarkInfo bookmarkInfo =
              BookmarkInfo(itemId: widget.id, type: "post");
          await bookmarkRepository.addBookmark(bookmarkInfo, JwtPayload.sub!);
          setState(() {
            isBookmark = !isBookmark;
          });
        }
      }
    } else {
      appRouter.go("/login");
    }
  }

  void _sharePost(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link đã được sao chép')),
    );
  }

  void _shareFacebook(String url) async {
    url =
        'https://www.youtube.com/watch?v=GbVfBSZE1Zc&t=977s&ab_channel=ACDAcademyChannel';
    final fbUrl = 'https://www.facebook.com/sharer/sharer.php?u=$url';
    if (await canLaunchUrlString(fbUrl)) {
      await launchUrlString(fbUrl);
    } else {
      throw 'Could not launch $fbUrl';
    }
  }

  Widget _sidebar() {
    Widget? tableOfContentsWidget = _tableOfContents();
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titletableOfContents(),
          if (tableOfContentsWidget != null)
            tableOfContentsWidget
          else
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                "Không có mục lục",
                style: TextStyle(fontSize: 16),
              ),
            ),
          _relatedArticles(),
        ],
      ),
    );
  }

  List<String> extractHeadingsFromMarkdown(String markdownText) {
    List<String> headings = [];
    List<markdown.Node> nodes = markdown.Document(
      extensionSet: markdown.ExtensionSet.gitHubWeb,
    ).parseLines(markdownText.split('\n'));
    for (var node in nodes) {
      if (node is markdown.Element && node.tag == 'h1') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h2') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h3') {
        headings.add(node.textContent);
      }
    }
    return headings;
  }

  Widget? _tableOfContents() {
    List<String> headings = extractHeadingsFromMarkdown(postDetailDTO.content);
    if (headings.isEmpty) {
      return null;
    }
    ScrollController scrollController = ScrollController();
    return TableOfContents(
      headings: headings,
      scrollController: scrollController,
    );
  }

  Widget _relatedArticles() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleRelatedArticles(),
          posts.isEmpty
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    "Không còn bài viết nào",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : _bodyRelatedArticles(),
        ]);
  }

  Widget _titletableOfContents() {
    return Row(
      children: [
        const Text(
          "Mục lục",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0, // Độ dày của border
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _bodyRelatedArticles() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var post in posts)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _openRelatedArticle(post.id),
                        child: RichText(
                          text: TextSpan(
                            text: post.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(getTimeAgo(post.updatedAt)),
                  ),
                  Container(
                    height: 1,
                    width: 300,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _openRelatedArticle(String postId) {
    appRouter.go('/posts/$postId');
  }

  Widget _buildPostImage(String avatarUrl) {
    if (avatarUrl != null) {
      return Image.network(
        avatarUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Icon(Icons.account_circle_rounded,
              size: 48, color: Colors.black54);
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle_rounded,
              size: 48, color: Colors.black54);
        },
      );
    } else {
      return const Icon(Icons.account_circle_rounded,
          size: 48, color: Colors.black54);
    }
  }
}

Widget _titleRelatedArticles() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const Text(
        "Các bài viết liên quan",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Container(
          height: 20,
          width: 50,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0, // Độ dày của border
              ),
            ),
          ),
        ),
      )
    ],
  );
}
