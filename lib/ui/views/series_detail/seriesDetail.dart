import 'dart:async';
import 'package:cay_khe/blocs/seriesDetail_bloc.dart';
import 'package:cay_khe/dtos/follow_dto.dart';
import 'package:cay_khe/models/bookmarkInfo.dart';
import 'package:cay_khe/models/follow.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/series.dart';
import 'package:cay_khe/models/sp.dart';
import 'package:cay_khe/models/user.dart';
import 'package:cay_khe/repositories/bookmark_repository.dart';
import 'package:cay_khe/repositories/follow_repository.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/repositories/user_repository.dart';
import 'package:cay_khe/ui/views/profile/widgets/posts_tab/post_tab_item.dart';
import 'package:cay_khe/ui/views/series_detail/seriesContent.dart';
import 'package:cay_khe/ui/views/series_detail/votes_side.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../dtos/jwt_payload.dart';
import '../../../dtos/notify_type.dart';
import '../../../dtos/vote_dto.dart';
import '../../../models/vote.dart';
import '../../../repositories/post_repository.dart';
import '../../../repositories/sp_repository.dart';
import '../../../repositories/vote_repository.dart';
import '../../common/utils/message_from_exception.dart';
import '../../router.dart';
import '../../widgets/comment/comment_view.dart';
import '../../widgets/notification.dart';
import '../post_detail/menuAnchor.dart';

class SeriesDetail extends StatefulWidget {
  final String id;

  const SeriesDetail({super.key, required this.id});

  @override
  State<SeriesDetail> createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  final postRepository = PostRepository();
  final seriesRepository = SeriesRepository();
  final voteRepository = VoteRepository();
  final spRepository = SpRepository();
  final userRepository = UserRepository();
  final followRepository = FollowRepository();
  final bookmarkRepository = BookmarkRepository();
  late SeriesDetailBloc seriesDetailBloc;
  late List<String> listTagsPost;
  late List<String> listTagsSeries;
  late Follow follow;
  late List<PostAggregation> listPostDetail = [];
  bool stateVote = false;
  bool upVote = false;
  bool downVote = false;
  bool typeVote = false;
  bool isHoveredTitle = false;
  bool isClickedTitle = false;
  bool isHoveredUserLink = false;
  bool isFollow = false;
  bool isBookmark = false;
  bool isLoading = false;
  bool isPrivate = false;
  String idVote = '';
  String type = "series";
  String username = JwtPayload.sub ?? '';
  String _currentId = '';
  int totalSeries = 0;
  int totalFollow = 0;
  int score = 0;
  User user = User.empty();
  User authorSeries = User.empty();
  List<String> listTag = [];
  String textPrivate = "";
  int scoreNormal = 0;
  Sp sp = Sp.constructor();
  bool isView = false;
  bool loi = false;

  @override
  void initState() {
    super.initState();
    _initSeries(widget.id);
  }

  @override
  void didUpdateWidget(SeriesDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != _currentId) {
      _currentId = widget.id;
      _initSeries(_currentId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initSeries(String id) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await _loadListPost(widget.id);
    var futureCheckVote = _loadCheckVote(widget.id, JwtPayload.sub ?? '');
    var futureUser = _loadUser(username);
    var futureFollow = _loadFollow(user.username, authorSeries.username);
    var futureBookmark = _loadBookmark(widget.id, username);
    var futureTotalSeries = _loadTotalSeries(sp.createdBy);
    var futureTotalFollower = _loadTotalFollower(authorSeries.username);
    await Future.wait([
      futureCheckVote,
      futureUser,
      futureFollow,
      futureBookmark,
      futureTotalSeries,
      futureTotalFollower
    ]);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    // await _loadingCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          child: !loi
              ? !isLoading
                  ? Center(
                      child: SizedBox(
                          width: 1200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VoteSection(
                                      stateVote: stateVote,
                                      upVote: upVote,
                                      downVote: downVote,
                                      score: score,
                                      onUpVote: _upVote,
                                      onDownVote: _downVote),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MoreHoriz(
                                            type: type,
                                            idContent: widget.id,
                                            authorname: authorSeries.username,
                                            username: username),
                                        if (sp != null)
                                          SeriesContentWidget(sp: sp)
                                        else
                                          const CircularProgressIndicator(),
                                        _sectionTitleLine(),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: listPostDetail.map((e) {
                                              return PostTabItem(postUser: e);
                                            }).toList()),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  stickySideBar(),
                                ],
                              ),
                              CommentView(postId: widget.id)
                            ],
                          )),
                    )
                  : _buildLoadingIndicator()
              : const Center(
              child: Text(
                "Bạn không có quyền xem bài viết này",
                style: TextStyle(fontSize: 28),
              )));
    });
  }

  Widget _sectionTitleLine() {
    return Row(
      children: [
        const Text(
          "Nội dung",
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
        ),
        // Row(
        //   children: [
        //     IconButton(onPressed: () => {}, icon: const Icon(Icons.add)),
        //     const Text("Add my post to this series")
        //   ],
        // )
      ],
    );
  }

  bool checkPrivate(String userName, String authorName, bool isPrivate) {
    if (isPrivate && userName == authorName || !isPrivate) {
      textPrivate = "";
      return true;
    } else {
      textPrivate = "Bạn không có quyền xem bài viết này";
      return false;
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 600,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
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
      return Future<bool>.value(false);
    });
    return isFuture;
  }

  Future<void> _loadCheckVote(String postId, String username) async {
    if (username != null) {
      var futureVote = await voteRepository.checkVote(postId, username);
      if (futureVote.data is Map<String, dynamic>) {
        Vote vote = Vote.fromJson(futureVote.data);
        setState(() {
          upVote = vote.type;
          downVote = !vote.type;
        });
      }
    }
  }

  Future<void> _loadTotalSeries(String username) async {
    var future = await seriesRepository.totalSeries(username);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalSeries = future.data;
        });
      }
    }
  }

  Future<void> _loadTotalFollower(String followed) async {
    var future = await followRepository.totalFollower(followed);
    if (future.data is int) {
      if (mounted) {
        setState(() {
          totalFollow = future.data;
        });
      }
    }
  }

  Future<void> _loadScoreSeries(String postId) async {
    var futureSp = await spRepository.getOne(postId);
    Sp sp = Sp.fromJson(futureSp.data);
    if (mounted) {
      setState(() {
        score = sp.score;
        isPrivate = sp.isPrivate;
      });
    }
  }

  Widget stickySideBar() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    appRouter.go("/profile/${authorSeries.username}/posts");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                        UserAvatar(imageUrl: authorSeries.avatarUrl, size: 48),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        setState(() {
                          isHoveredUserLink = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHoveredUserLink = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          appRouter
                              .go("/profile/${authorSeries.username}/posts");
                        },
                        child: Text(
                          authorSeries.displayName,
                          style: TextStyle(
                            color: isHoveredUserLink
                                ? Colors.lightBlueAccent
                                : Colors.indigo,
                            decoration: isHoveredUserLink
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("@${authorSeries.username}"),
                    const SizedBox(height: 8),
                    if (authorSeries.id != user.id)
                      ElevatedButton(
                        onPressed: () => _follow(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isFollow
                                ? const Icon(Icons.check)
                                : const Icon(Icons.add),
                            isFollow ? const Text("Đã theo dõi") : const Text('Theo dõi'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIconWithText(
                    Icons.verified_user_sharp, totalFollow.toString()),
                const SizedBox(width: 12),
                _buildIconWithText(
                    Icons.pending_actions, totalSeries.toString()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: authorSeries.id != user.id
                    ? () => _toggleBookmark()
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isBookmark
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_add_outlined),
                    isBookmark
                        ? const Text('HỦY BOOKMARK SERIES')
                        : const Text('BOOKMARK SERIES NÀY'),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
          width: 200,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0, // Độ dày của border
              ),
            ),
          ),
        ),
        _buildSocialShareSection(widget.id)
      ],
    );
  }

  Widget _buildSocialShareSection(String idPost) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
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
          const SizedBox(width: 16),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareTwitter(
                  "http://localhost:8000/posts/$idPost",
                  "Đã share lên Twitter")),
        ],
      ),
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

  void _sharePost(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link đã được sao chép')),
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

  Future<void> _loadListPost(String seriesId) async {
    try {
      var fufutureSeries = await seriesRepository.getOneDetail(seriesId);
      sp = Sp.fromJson(fufutureSeries.data);
      authorSeries = sp.user;
      for (var e in sp.posts) {
        PostAggregation p = PostAggregation.empty();
        p.user = authorSeries;
        p.title = e.title;
        p.id = e.id;
        p.score = e.score;
        p.content = e.content;
        p.updatedAt = e.updatedAt;
        p.tags = e.tags;
        p.private = e.isPrivate;
        score = sp.score;
        isPrivate = sp.isPrivate;
        if (listPostDetail.length < sp.posts.length) {
          listPostDetail.add(p);
        }
      }
    } catch (error) {
      loi = true;
    }

    // var fufutureSeries=seriesRepository.getOneDetail(seriesId);
    // fufutureSeries.then((value) {
    //   setState(() {
    //     sp = Sp.fromJson(value.data);
    //     authorSeries = sp.user;
    //     for (var e in sp.posts) {
    //       PostAggregation p = PostAggregation.empty();
    //       p.user = authorSeries;
    //       p.title = e.title;
    //       p.id = e.id;
    //       p.score = e.score;
    //       p.content = e.content;
    //       p.updatedAt = e.updatedAt;
    //       p.tags = e.tags;
    //       p.private = e.isPrivate;
    //       score = sp.score;
    //       isPrivate = sp.isPrivate;
    //       if (listPostDetail.length < sp.posts.length) {
    //         listPostDetail.add(p);
    //       }
    //     }
    //   });
    //
    // } ).catchError((error){
    //   print("loi");
    //     loi = true;
    //   });
    //

    // Map<String, int> uniqueTagCount = countUniqueTags(listTag);
    // List<String> getTop5Tags = this.getTop5Tags(uniqueTagCount);
    // listTag = getTop5Tags;
  }

  List<String> getTop5Tags(Map<String, int> tagCount) {
    var sortedEntries = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var top5Entries = sortedEntries.take(5);
    List<String> top5Tags = top5Entries.map((entry) => entry.key).toList();

    return top5Tags;
  }

  Map<String, int> countUniqueTags(List<String> tags) {
    Map<String, int> tagCount = {};

    for (String tag in tags) {
      if (tagCount.containsKey(tag)) {
        tagCount[tag] = (tagCount[tag]! + 1);
      } else {
        tagCount[tag] = 1;
      }
    }

    return tagCount;
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

  Future<void> _loadUser(String username) async {
    if (JwtPayload.sub != null) {
      var futureUser = await userRepository.get(username);
      user = User.fromJson(futureUser.data);
    }
  }

  Future<void> _loadSeriesDetail(String id) async {
    var future = seriesRepository.getOneDetail(id);
    future.then((response) {
      sp = Sp.fromJson(response.data);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Future<void> _loadBookmark(String itemId, String username) async {
    var future = await bookmarkRepository.checkBookmark(itemId, username);
    if (future.data == true) {
      if (mounted) {
        setState(() {
          isBookmark = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isBookmark = false;
        });
      }
    }
  }

  Future<void> _loadFollow(String follower, String followed) async {
    if (user.username == '') {
      return;
    }
    var future = await followRepository.checkfollow(follower, followed);
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

  void _follow() async {
    if (JwtPayload.sub == null) {
      appRouter.go("/login");
    } else {
      if (isFollow == true) {
        var future = await followRepository.checkfollow(
            user.username, authorSeries.username);
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
            followed: authorSeries.username,
            createdAt: DateTime.now());
        await followRepository.add(newFollow);
        if (mounted) {
          setState(() {
            isFollow = true;
          });
        }
      }
      _loadTotalFollower(authorSeries.username);
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
              BookmarkInfo(itemId: widget.id, type: "series");
          await bookmarkRepository.addBookmark(bookmarkInfo, JwtPayload.sub!);
          setState(() {
            isBookmark = !isBookmark;
          });
        }
      }
    } else {
      appRouter.go('/login');
      // String message = "Bạn chưa đăng nhập";
      //  showTopRightSnackBar(context, message, NotifyType.error);
    }
  }

  void _upVote() async {
    if (typeVote == true) {
      scoreNormal = score - 1;
    } else {
      if (typeVote == false) {
        scoreNormal = score + 1;
      }
    }
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      return;
    }
    if (stateVote) return;
    setState(() {
      stateVote = true;
    });

    hasVoted = await checkVote(widget.id, JwtPayload.sub!);
    if (hasVoted == false) {
      VoteDTO voteDTO = VoteDTO(
          postId: widget.id,
          username: JwtPayload.sub,
          type: true,
          updatedAt: DateTime.now());
      await voteRepository.createVote(voteDTO);
      var seriesScore =
          await seriesRepository.updateScore(widget.id, score + 1);
      Series series = Series.fromJson(seriesScore.data);
      setState(() {
        score = series.score;
        upVote = true;
        downVote = false;
      });
    } else {
      if (hasVoted == true && upVote == true) {
        var seriesScore =
            await seriesRepository.updateScore(widget.id, score - 1);
        Series series = Series.fromJson(seriesScore.data);
        setState(() {
          score = series.score;
          upVote = false;
          downVote = false;
        });
        await voteRepository.deleteVote(idVote);
      } else {
        if (hasVoted == true && downVote == true) {
          var seriesScore =
              await seriesRepository.updateScore(widget.id, score + 2);
          Series series = Series.fromJson(seriesScore.data);
          setState(() {
            score = series.score;
            upVote = true;
            downVote = false;
          });
          //await voteRepository.deleteVote(idVote);
        }
      }
    }
    setState(() {
      stateVote = false;
    });
  }

  void _downVote() async {
    bool hasVoted;
    if (JwtPayload.sub == null) {
      appRouter.go('/login');
      GoRouter.of(context).go('/login');
    } else {
      if (stateVote == false) {
        setState(() {
          stateVote = true;
        });
        hasVoted = await checkVote(widget.id, JwtPayload.sub!);
        if (hasVoted == false) {
          VoteDTO voteDTO = VoteDTO(
              postId: widget.id,
              username: JwtPayload.sub,
              type: false,
              updatedAt: DateTime.now());
          await voteRepository.createVote(voteDTO);
          var seriesScore =
              await seriesRepository.updateScore(widget.id, score - 1);

          Series series = Series.fromJson(seriesScore.data);
          setState(() {
            score = series.score;
            downVote = true;
            upVote = false;
          });
        } else {
          if (hasVoted == true && downVote == true) {
            var seriesScore =
                await seriesRepository.updateScore(widget.id, score + 1);
            Series series = Series.fromJson(seriesScore.data);
            setState(() {
              score = series.score;
              upVote = false;
              downVote = false;
            });
            await voteRepository.deleteVote(idVote);
          } else {
            if (hasVoted == true && upVote == true) {
              var seriesScore =
                  await seriesRepository.updateScore(widget.id, score - 2);
              Series series = Series.fromJson(seriesScore.data);
              setState(() {
                score = series.score;
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
}
