
import 'package:cay_khe/models/user.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
class StickySidebar extends StatefulWidget {
  final String idPost;
  final User AuthorSeries;
  final User user;
  final bool isFollow;
  final bool isBookmark;
  final Function() onFollowPressed;
  final Function() onBookmarkPressed;

  const StickySidebar({
    Key? key,
    required this.idPost,
    required this.AuthorSeries,
    required this.user,
    required this.isFollow,
    required this.isBookmark,
    required this.onFollowPressed,
    required this.onBookmarkPressed,
  }) : super(key: key);

  @override
  _StickySidebarState createState() => _StickySidebarState();
}

class _StickySidebarState extends State<StickySidebar> {
   bool isHoveredUserLink=false;
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
                    child: UserAvatar(imageUrl: widget.AuthorSeries.avatarUrl, size: 48),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                       setState(() {
                         isHoveredUserLink=true;
                       });
                      },
                      onExit: (_) {
                        setState(() {
                          isHoveredUserLink=false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          print('Navigate to: ');
                        },
                        child: Text(
                          widget.AuthorSeries.displayName,
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
                     Text("@${widget.AuthorSeries.username}"),
                    const SizedBox(height: 8),
                    if(widget.AuthorSeries.id==widget.user.id)
                    ElevatedButton(
                      onPressed: widget.onFollowPressed,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isFollow ? Icon(Icons.check) : Icon(Icons.add),
                          widget.isFollow ? Text("Đã theo dõi") : Text('Theo dõi'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                child: ElevatedButton(
                  onPressed: widget.onBookmarkPressed,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isBookmark? Icon(Icons.bookmark) : Icon(Icons.bookmark_add_outlined),
                      widget.isBookmark? Text('HỦY BOOKMARK SERIES'):  Text('BOOKMARK SERIES NÀY'),
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
             onPressed: () => _shareTwitter("http://localhost:8000/posts/${idPost}","Đã share lên Twitter")

           ),
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

}