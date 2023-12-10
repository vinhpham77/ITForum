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
import 'package:cay_khe/ui/views/details_page/menuAnchor.dart';
import 'package:cay_khe/ui/views/posts/widgets/post/post_feed_item.dart';
import 'package:cay_khe/ui/views/profile/widgets/posts_tab/post_tab_item.dart';
import 'package:cay_khe/ui/views/series_detail/seriesContent.dart';
import 'package:cay_khe/ui/views/series_detail/skickeySidebar.dart';
import 'package:cay_khe/ui/views/series_detail/votes_side.dart';
import 'package:cay_khe/ui/widgets/post_feed_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../dtos/jwt_payload.dart';
import '../../../dtos/vote_dto.dart';
import '../../../models/vote.dart';
import '../../../repositories/post_repository.dart';
import '../../../repositories/sp_repository.dart';
import '../../../repositories/vote_repository.dart';
import '../../router.dart';

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
  bool isHoveredUserlink = false;
  bool isClickedUserlink = false;
  bool isHoveredTitle = false;
  bool isClickedTitle = false;
  bool isHoveredUserLink = false;
  bool isFollow = false;
  bool isBookmark = false;
  int score = 0;
  String idVote = '';
  String type="series";
  String username = JwtPayload.sub ?? '';
  User user = User.empty();
  User AuthorSeries = User.empty();
  int totalSeries =0;
int totalFollow=0;
  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initState() async {
    await _loadCheckVote(widget.id, JwtPayload.sub ?? '');
    await _loadScoreSeries(widget.id);
    await _loadListPost(widget.id);
    await _loadUser(username);
//    await _loadFollow(user.id, AuthorSeries.id);
    await _loadBookmark(widget.id, username);
 //   await _loadTotalSeries(AuthorSeries.username);
 //  await _loadTotalFollower(AuthorSeries.id);
  }

  @override
  Widget build(BuildContext context) {
    seriesDetailBloc = SeriesDetailBloc(context: context);
    seriesDetailBloc.getOneSP(widget.id);

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        child: Center(
          child: Container(
            width: 1200,
            child: Row(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<Sp>(
                        stream: seriesDetailBloc.spStream,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return SeriesContentWidget(sp: snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else {
                            return _buildLoadingIndicator();
                          }
                        },
                      ),
                      _sectionTitleLine(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listPostDetail.map((e) {
                            return PostTabItem(postUser: e);
                          }).toList()),
                     if(AuthorSeries.id==user.id) MoreHoriz(type:type,idContent:widget.id),
                    ],
                  ),

                ),
                const SizedBox(width: 12),
                StickySidebar(
                  idPost: widget.id,
                  AuthorSeries: AuthorSeries,
                  user: user,
                 // isFollow: isFollow,
                  isBookmark: isBookmark,
                 // totalFollow: totalFollow,
                 // totalSeries: totalSeries,
                  //onFollowPressed: () {
                   // _follow();
                    // Xử lý sự kiện khi nhấn vào nút theo dõi
                  //},
                  onBookmarkPressed: () {
                    _toggleBookmark();
                    // Xử lý sự kiện khi nhấn vào nút bookmark
                  },

                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _sectionTitleLine() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.end,
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
        Row(
          children: [
            IconButton(onPressed: () => {}, icon: const Icon(Icons.add)),
            Text("Add my post to this series")
          ],
        )
      ],
    );
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
      print('Không thấy vote');
      // String message = getMessageFromException(error);
      // showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isFuture;
  }

  Future<void> _loadCheckVote(String postId, String username) async {
    if (username != null) {
      var futureVote = await voteRepository.checkVote(postId, username!);
      if (futureVote.data is Map<String, dynamic>) {
        Vote vote = Vote.fromJson(futureVote.data);
        setState(() {
          upVote = vote.type;
          downVote = !vote.type;
        });
      }
    }
  }

  Future<void> _loadTotalSeries(String username)async {
    var future= await seriesRepository.totalSeries(username);
    if(future.data is int){
      if(mounted){
        setState(() {
          totalSeries= future.data;
        });
      }
    }
  }
  Future<void> _loadTotalFollower(String followedId)async {
    var future= await followRepository.totalFollower(followedId);
    if(future.data is int){
      setState(() {
        totalFollow= future.data;
      });

    }
  }

  Future<void> _loadScoreSeries(String postId) async {
    var futureSp = await spRepository.getOne(postId);
    Sp sp = Sp.fromJson(futureSp.data);
    if (mounted) {
      setState(() {
        score = sp.score;
      });
    }
  }

  Future<void> _loadListPost(String seriesId) async {
    var futureSeries = await spRepository.getOne(seriesId);
    Sp sp = Sp.fromJson(futureSeries.data);
    AuthorSeries = sp.user;
    for (var e in sp.posts) {
      PostAggregation p = PostAggregation.empty();
      p.user = AuthorSeries;
      p.title = e.title;
      p.id = e.id;
      p.score = e.score;
      p.content = e.content;
      p.updatedAt = e.updatedAt;
      p.tags = e.tags;
      p.private = e.isPrivate;
      if (mounted) {
        setState(() {
          listPostDetail.add(p);
        });
      }
    }
  }

  Future<void> _loadUser(String username) async {
    var futureUser = await userRepository.getUser(username);
    user = User.fromJson(futureUser.data);
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

  Future<void> _loadFollow(String followerId, String followedId) async {
    if (JwtPayload.sub == null) {
      return;
    }
    var future = await followRepository.checkfollow(followerId, followedId);

    if (future.data != "Follow not found") {
      if (mounted) {
        setState(() {
          isFollow = true;
          follow = Follow.fromJson(future.data);
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

  // void _follow() async {
  //   if (JwtPayload.sub == null) {
  //     appRouter.go("/login");
  //   } else {
  //     if (isFollow == true) {
  //       var future = await followRepository.checkfollow(user.id, AuthorSeries.id);
  //       if (future.data != "Follow not found") {
  //         Follow follow = Follow.fromJson(future.data);
  //         await followRepository.delete(follow.id);
  //         if (mounted) {
  //           setState(() {
  //             isFollow = false;
  //           });
  //         }
  //       }
  //     } else {
  //       FollowDTO newFollow = FollowDTO(
  //           followerId: user.id,
  //           followedId: AuthorSeries.id,
  //           createdAt: DateTime.now());
  //       await followRepository.add(newFollow);
  //       if (mounted) {
  //         setState(() {
  //           isFollow = true;
  //         });
  //       }
  //     }
  //     _loadTotalFollower(AuthorSeries.id);
  //   }
  // }

  Future<void> _toggleBookmark() async {
    if (JwtPayload.sub != null) {
      if (isBookmark == true) {
        await bookmarkRepository.unBookmark(widget.id, JwtPayload.sub!);
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
      ////
      appRouter.go('/login');
      // String message = "Bạn chưa đăng nhập";
      //  showTopRightSnackBar(context, message, NotifyType.error);
    }
  }

  void _upVote() async {
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
      if (hasVoted == true && typeVote == true) {
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
        if (hasVoted == true && typeVote == false) {
          var seriesScore =
              await seriesRepository.updateScore(widget.id, score + 1);
          Series series = Series.fromJson(seriesScore.data);
          setState(() {
            score = series.score;
            upVote = false;
            downVote = false;
          });
          await voteRepository.deleteVote(idVote);
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
          if (hasVoted == true && typeVote == false) {
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
            if (hasVoted == true && typeVote == true) {
              var seriesScore =
                  await seriesRepository.updateScore(widget.id, score - 1);
              Series series = Series.fromJson(seriesScore.data);
              setState(() {
                score = series.score;
                downVote = false;
                upVote = false;
              });

              await voteRepository.deleteVote(idVote);
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
