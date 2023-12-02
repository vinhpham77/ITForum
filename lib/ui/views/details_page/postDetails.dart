import 'dart:js_interop';

import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/post_detail_dto.dart';
import 'package:cay_khe/models/tag.dart';
import 'package:cay_khe/repositories/bookmark_repository.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/tag_repository.dart';
import 'package:cay_khe/repositories/auth_repository.dart';
import 'package:cay_khe/repositories/vote_repository.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../dtos/jwt_payload.dart';
import '../../../dtos/notify_type.dart';
import '../../../models/post.dart';
import 'package:markdown/markdown.dart' as markdown;
import '../../../models/user.dart';
import '../../../models/vote.dart';
import '../../../repositories/user_repository.dart';
import 'TableOfContents.dart';
// import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

class PostDetailsPage extends StatefulWidget {
  final String id;

  const PostDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<PostDetailsPage> createState() => _PostDetailsPage();
}

class _PostDetailsPage extends State<PostDetailsPage> {
  bool enableButton = true;
  bool statevote = false;
  String avatarUrl = '';
  bool upvote = false;
  bool downvote = false;

  String usernames = JwtPayload.sub ?? ' ';
  String idVote = '';
  bool typeVote = false;
  bool isCheckBookmark = false;
  int score = 0;
  bool isBookmarked = false;
  bool isHovered = false;
  bool isLoading = true;
  String usernamePost = '';

  IconData? get icon => Icons.add;
  Color textColor = Colors.grey;
  final postRepository = PostRepository();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final tagRepository = TagRepository();
  final voteRepository = VoteRepository();
  final bookmarkRepository = BookmarkRepository();
  final userRepository = UserRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _updateAtController = TextEditingController();

  DateTime upDateAt = DateTime.now();
  List<DateTime> listDateTime = [];
  List<Post> posts = [];
  Tag? selectedTag;
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];

  late List<String> listTitlePost;

  @override
  void initState() {
    super.initState();
    print("JWT: ");
    print(JwtPayload.sub);
    print(JwtPayload.displayName);
    print("end jwt");
    _loadPost(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          color: Colors.white,
          child: Center(
            child: SizedBox(
              width: 1500,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildColumn1(),
                    const SizedBox(width: 20),
                    _buildColumn2(),
                    const SizedBox(width: 20),
                    _buildColumn3(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumn1() {
    return Container(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildVoteSection(),
          const SizedBox(
            height: 10,
          ),
          _buildBookmarkSection(),
          const SizedBox(
            height: 10,
          ),
          _buildSocialShareSection(),
        ],
      ),
    );
  }

  Widget _buildVoteSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_drop_up,
              ),
              onPressed: () => !statevote ? _upVote() : null,
              iconSize: 36,
              color: upvote ? Colors.blue : null),
          Text('$score', style: const TextStyle(fontSize: 20)),
          IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              onPressed: () => !statevote ? _downVote() : null,
              color: downvote ? Colors.blue : null),
        ],
      ),
    );
  }

  Widget _buildBookmarkSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
          onPressed: _toggleBookmark,
          color: isBookmarked ? Colors.blue : null),
    );
  }

  Widget _buildSocialShareSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () =>
                _shareFacebook('http://localhost:8000/posts/${widget.id}'),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () =>
                _sharePost('http://localhost:8000/posts/${widget.id}'),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn2() {
    // _builderTitlePostContent();
    var postPreview = isLoading
        ? Container(
            height: 600,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        : Column(
            children: [
              Container(
                height: 600,
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
                        .copyWith(fontSize: 48),
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
                    p: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                    blockquote:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                    // Custom blockquote style
                    listBullet: const TextStyle(
                        fontSize: 16), // Custom list item bullet style
                  ),
                  softLineBreak: true,
                ),
              ),
            ],
          );
    return Container(
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _builderAuthortPostContent(),
          // const SizedBox(
          //   height: 10,
          // ),

          // _buildMenuAnchor(),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            child: postPreview,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuAnchor() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return {'Option 1', 'Option 2'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: MenuItemButton(label: choice),
                );
              }).toList();
            },
            child: TextButton(
              onPressed: () {},
              child: Text('Open Menu'),
            ),
          ),
          // Add more buttons or widgets as needed
        ],
      ),
    );
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    // String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    print("start content");
    print(content);
    print("end content");
    h1:
    TextStyle(fontSize: 54);
    return '$title \n $content';
  }

  String convertDateString(String inputDateString) {
    DateTime dateTime = DateTime.parse(inputDateString);
    String outputDateString = DateFormat("MMMM d, y h:mm a").format(dateTime);

    return outputDateString;
  }

  Future<void> _loadPost(String id) async {
    setState(() {
      isLoading = true;
    });
    var future = postRepository.getOneDetails(id);
    future.then((response) {
      setState(() async {
        PostDetailDTO postDetailDTO = PostDetailDTO.fromJson(response.data);
        _contentController.text = postDetailDTO.content;
        print(response.data);
        _titleController.text = postDetailDTO.title;

        _nameController.text = postDetailDTO.user.displayName;
        _nickNameController.text = '@${postDetailDTO.user.username}';
        usernamePost = postDetailDTO.user.username;
        upDateAt = postDetailDTO.updatedAt;
        _updateAtController.text = convertDateString(upDateAt.toString());
        score = postDetailDTO.score;
        await _loadPostsByTheSameAuthor(postDetailDTO.user.username);
      });
    }).catchError((error) {
      print("lỗi");
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
    });
    await _loadCheckVote(widget.id, usernames);
    await _loadCheckBookmark(widget.id, usernames);
    print("usernamepost: $usernamePost");
    await _loadAvatar(usernamePost);
    isLoading = false;
  }

  Future<void> _loadCheckVote(String postId, String username) async {
    if (username != null) {
      print("ten: $usernames");
      var futureVote = await voteRepository.checkVote(widget.id, username!);
      print("start vote");
      print(futureVote.data);
      print("end vote");
      if (futureVote.data is Map<String, dynamic>) {
        Vote vote = Vote.fromJson(futureVote.data);
        upvote = vote.type;
        downvote = !vote.type;
      } else {
        print('Dữ liệu không phải là Map<String, dynamic>: ${futureVote.data}');
        upvote = false;
        downvote = false;
      }
    } else {
      upvote = false;
      downvote = false;
    }
  }

  Future<void> _loadCheckBookmark(String postId, String username) async {
    Response<dynamic> response =
        await bookmarkRepository.checkBookmark(widget.id, username!);
    if (response.statusCode == 200) {
      setState(() {
        print("bookmark $isBookmarked");
        isBookmarked = response.data;
      });
    } else {
      throw Exception('Failed to check bookmark: ${response.statusCode}');
    }
  }

  Future<void> _loadAvatar(String username) async {
    var response = await userRepository.getUser(username!);
   User user = User.fromJson(response.data);
    if (response.statusCode == 200) {
      setState(() {
        avatarUrl=user.avatarUrl!;
      });
    } else {
      throw Exception('Failed to check bookmark: ${response.statusCode}');
    }
  }

  Future<void> _loadPostsByTheSameAuthor(String authorName) async {
    var future = postRepository.getPostsSameAuthor(authorName);
    future.then((response) {
      setState(() {
        List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(response.data);

        posts = jsonDataList.map((json) => Post.fromJson(json)).toList();
        listTitlePost = posts.map((post) => post.title).toList();
        listDateTime = posts.map((post) => post.updatedAt).toList();
      });
    }).catchError((error) {
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Widget _menuAnchor() {
    String title = 'hành động';
    return ListTile(
      title: Text(title),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text('item1'),
            value: 'a',
          ),
          PopupMenuItem(child: Text('item2'), value: 'b')
        ],
        onSelected: (String value) {
          setState(() {
            title = value;
          });
        },
      ),
    );
  }

  Widget _builderAuthortPostContent() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserDetails(),
          _buildPostDetails(),
        ],
      ),
    );
  }

  Widget _builderTitlePostContent() {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Text(
        _titleController.text,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Container(
      height: 50,
      child: Row(

        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: _buildPostImage(avatarUrl ?? ""),
            ),
          ),
          const SizedBox(width: 16),
          _buildUserProfile(),
          const SizedBox(width: 16),
          _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        SizedBox(
          // width: 200,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(_nameController.text),
            SizedBox(
              width: 16,
            ),
            Text(_nickNameController.text),
          ]),
        ),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconWithText(Icons.star, '174'),
              const SizedBox(width: 12),
              _buildIconWithText(Icons.verified_user_sharp, '9'),
              const SizedBox(width: 12),
              _buildIconWithText(Icons.pending_actions, '4'),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildIconWithText(IconData icon, String text) {
    String messageValue = "";
    switch (icon) {
      case Icons.star:
        messageValue = 'reputation';
        break;
      case Icons.verified_user_sharp:
        messageValue = 'Người theo dõi';
        break;
      case Icons.pending_actions:
        messageValue = 'Bài viết';
        break;
      default:
        messageValue = 'Default Message';
    }
    ;
    return Tooltip(
      message: messageValue,
      child: Row(
        children: [
          Container(
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
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            //padding: const EdgeInsets.all(16),
            backgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
              const Text(
                "Theo dõi",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPostDetails() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Column(
            children: [Text(_updateAtController.text)],
          ),
        ],
      ),
    );
  }

  Future<bool> checkVote(String postId, String username) async {
    Future<bool> isFuture;
    var future = voteRepository.checkVote(postId, username);
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
      print('checkvoteloi');
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isFuture;
  }

  void _upVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      //GoRouter.of(context).go('/login');
    } else {
      if (statevote == false) {
        setState(() {
          statevote = true;
        });
        hasVoted = await checkVote(widget.id, JwtPayload.sub!);
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
            upvote = true;
            downvote = false;
          });
        } else {
          if (hasVoted == true && typeVote == true) {
            var postScore =
                await postRepository.updateScore(widget.id, score - 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upvote = false;
              downvote = false;
            });
            await voteRepository.deleteVote(idVote);
          } else {
            if (hasVoted == true && typeVote == false) {
              var postScore =
                  await postRepository.updateScore(widget.id, score + 1);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                upvote = false;
                downvote = false;
              });
              await voteRepository.deleteVote(idVote);
            }
          }
        }
        setState(() {
          statevote = false;
        });
      }
    }
  }

  void _downVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      GoRouter.of(context).go('/login');
    } else {
      if (statevote == false) {
        setState(() {
          statevote == true;
        });

        hasVoted = await checkVote(widget.id, JwtPayload.sub!);
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
            downvote = true;
            upvote = false;
          });
        } else {
          if (hasVoted == true && typeVote == false) {
            var postScore =
                await postRepository.updateScore(widget.id, score + 1);
            Post post = Post.fromJson(postScore.data);
            setState(() {
              score = post.score;
              upvote = false;
              downvote = false;
            });
            await voteRepository.deleteVote(idVote);
          } else {
            if (hasVoted == true && typeVote == true) {
              var postScore =
                  await postRepository.updateScore(widget.id, score - 1);
              Post post = Post.fromJson(postScore.data);
              setState(() {
                score = post.score;
                downvote = false;
                upvote = false;
              });

              await voteRepository.deleteVote(idVote);
            }
          }
        }
        setState(() {
          statevote = false;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (JwtPayload.sub != null) {
      if (isBookmarked == true) {
        var unBookmark =
            await bookmarkRepository.unBookmark(widget.id, JwtPayload.sub!);
        //delete postid trong list post;
        //update bookmarks
        setState(() {
          isBookmarked = !isBookmarked;
        });
      } else {
        if (isBookmarked == false) {
          var addbookmark =
              await bookmarkRepository.addBookmark(widget.id, JwtPayload.sub!);
          setState(() {
            isBookmarked = !isBookmarked;
          });
        }
      }
    } else {
      ////
      appRouter.go('/login');
      // String message = "Bạn chưa đăng nhập";
      //  showTopRightSnackBar(context, message, NotifyType.error);
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

  onPressed() {
    // Hàm này sẽ được gọi khi người dùng nhấn vào một trong những hành động cụ thể
  }

  Widget _buildColumn3() {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_tableOfContents(), _relatedArticles()],
      ),
    );
  }

  List<String> extractHeadingsFromMarkdown(String markdownText) {
    List<String> headings = [];

    // Parse nội dung Markdown
    List<markdown.Node> nodes = markdown.Document(
      extensionSet: markdown.ExtensionSet.gitHubWeb,
    ).parseLines(markdownText.split('\n'));

    // Lặp qua các nút để trích xuất tiêu đề
    for (var node in nodes) {
      if (node is markdown.Element && node.tag == 'h1') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h2') {
        headings.add(node.textContent);
      } else if (node is markdown.Element && node.tag == 'h3') {
        headings.add(node.textContent);
      }
      // Thêm các điều kiện cho các cấp tiêu đề khác (h4, h5, ...)
    }

    return headings;
  }

  Widget _tableOfContents() {
    // Lấy danh sách tiêu đề từ nội dung Markdown
    List<String> headings =
        extractHeadingsFromMarkdown(_contentController.text);

    // Tạo một ScrollController
    ScrollController _scrollController = ScrollController();

    return TableOfContents(
        headings: headings, scrollController: _scrollController);
  }

  Widget _relatedArticles() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleRelatedArticles(),
          _bodyRelatedArticles(),
        ]);
  }

  Widget _titletableOfContents() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Mục lục",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 20,
          width: 100,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0, // Độ dày của border
              ),
            ),
          ),
        )
      ],
    );
  }

//// open cac bai viet lien quan

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
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(convertDateString(post.updatedAt.toString())),
                  ),
                  // _feedItem(),
                  Container(
                    height: 1,
                    width: 300,
                    decoration: BoxDecoration(
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
    GoRouter.of(context).go('/posts/$postId');
    _loadPost(postId);
  }

  Widget _feedItem() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Tooltip(
            message: "Lượt xem",
            child: Row(
              children: [
                Icon(
                  Icons.remove_red_eye, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('30'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Bình luận",
            child: Row(
              children: [
                Icon(
                  Icons.comment, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('18'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Đã bookmark",
            child: Row(
              children: [
                Icon(
                  Icons.bookmark, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('12'),
              ],
            ),
          ),
          SizedBox(width: 12),
          Tooltip(
            message: "Điểm",
            child: Row(
              children: [
                Icon(
                  Icons.score, // Mã Unicode của biểu tượng con mắt
                  color: Color.fromARGB(255, 212, 211, 211),
                  // Màu của biểu tượng,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('9'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String avatarUrl) {
    if (avatarUrl != null) {
      return Image.network(
        avatarUrl!,
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

  Widget _ownArticles(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          textColor = Colors.black;
        });
      },
      onExit: (_) {
        setState(() {
          textColor = Colors.grey;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

Widget _bodyTableOfContents() {
  return const Padding(
    padding: EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1. Process'),
        Text('2. Thread'),
        Text('3. IPc'),
        Text('4. Time of disscustion')
      ],
    ),
  );
}

///// close cac bai viet lien quan
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
      Container(
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
      )
    ],
  );
}

class MenuItemButton extends StatelessWidget {
  final String label;

  const MenuItemButton({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Handle the press for the menu item
        // You can perform any action or navigation here
      },
      child: Text(label),
    );
  }
}
