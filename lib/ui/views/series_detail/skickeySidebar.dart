import 'package:cay_khe/models/follow.dart';
import 'package:cay_khe/models/user.dart';
import 'package:cay_khe/repositories/follow_repository.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StickySidebar extends StatefulWidget {
  final String idPost;
  final User authorSeries;
  final User user;
  final bool isFollow;
  final bool isBookmark;

   final Function() onFollowPressed;
  final Function() onBookmarkPressed;

   final totalFollow;

  const StickySidebar({
    super.key,
    required this.idPost,
    required this.authorSeries,
    required this.user,
     required this.isFollow,
    required this.isBookmark,
     required this.onFollowPressed,
    required this.onBookmarkPressed,
     required this.totalFollow,
  });

  @override
  _StickySidebarState createState() => _StickySidebarState();
}

class _StickySidebarState extends State<StickySidebar> {
  final followRepository = FollowRepository();
  final seriesRespository = SeriesRepository();
  int totalFollow = 0;
  int totalSeries = 0;
  bool isFollow = false;
  bool isHoveredUserLink = false;
  late Follow follow;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async{
      if (widget.user != null) {
        await _load();
      }
    });


  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future<void> _load() async {
    await _loadTotalFollower(widget.authorSeries.id);
    await _loadFollow(widget.user.username, widget.authorSeries.username);
   // await _loadTotalSeries(widget.AuthorSeries.username);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: UserAvatar(
                        imageUrl: widget.authorSeries.avatarUrl, size: 48),
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
                          print('Navigate to: ');
                        },
                        child: Text(
                          widget.authorSeries.displayName,
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
                    Text("@${widget.authorSeries.username}"),
                    const SizedBox(height: 8),
                    if (widget.authorSeries.id != widget.user.id)
                      ElevatedButton(
                        onPressed: () => widget.onFollowPressed,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isFollow ? const Icon(Icons.check) : const Icon(Icons.add),
                            isFollow ? Text("Đã theo dõi") : Text('Theo dõi'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
              child: Container(
                child: ElevatedButton(
                  onPressed: widget.authorSeries.id != widget.user.id
                      ? widget.onBookmarkPressed
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isBookmark
                          ? Icon(Icons.bookmark)
                          : Icon(Icons.bookmark_add_outlined),
                      widget.isBookmark
                          ? Text('HỦY BOOKMARK SERIES')
                          : Text('BOOKMARK SERIES NÀY'),
                    ],
                  ),
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
        _buildSocialShareSection(widget.idPost)
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
                _shareFacebook('http://localhost:8000/posts/${idPost}'),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () =>
                _sharePost('http://localhost:8000/posts/${idPost}'),
          ),
          const SizedBox(width: 16),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareTwitter(
                  "http://localhost:8000/posts/${idPost}",
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
    // Đường dẫn của trang chia sẻ Twitter
    final twitterUrl = 'https://twitter.com/intent/tweet?text=$text&url=$url';

    // Kiểm tra xem có thể mở đường dẫn không
    if (await canLaunchUrlString(twitterUrl)) {
      // Nếu có thể, mở đường dẫn
      await launchUrlString(twitterUrl);
    } else {
      // Nếu không thể mở đường dẫn, thông báo lỗi
      throw 'Could not launch $twitterUrl';
    }
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

  Future<void> _loadTotalFollower(String followedId) async {
    if(followedId!='')
      {
        var future = await followRepository.totalFollower(followedId);
        if (future.data is int) {
          setState(() {
            totalFollow = future.data;
          });
        }
      }
    else {
      print("id followedId không có");
    }

  }

  Future<void> _loadFollow(String follower, String followed) async {
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
}
