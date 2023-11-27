import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/models/post_detail_dto.dart';
import 'package:cay_khe/models/tag.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/tag_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../models/post.dart';
// import 'package:share_plus/share_plus.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPage();
}

class _PostDetailsPage extends State<PostDetailsPage> {
  int score = 0;
  bool isBookmarked = false;

  IconData? get icon => Icons.add;
  Color textColor = Colors.grey;
  final postRepository = PostRepository();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final tagRepository = TagRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _updateAtController = TextEditingController();
  final TextEditingController _titlePostSameAuthor = TextEditingController();

  late DateTime upDateAt;

  Tag? selectedTag;
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];
  String id = '654d3e139d8e142b7fadc7ca';
  late List<String> listTitlePost;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

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
              onPressed: () => _updateVote(1),
              iconSize: 36),
          Text('$score', style: const TextStyle(fontSize: 20)),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 36,
            onPressed: () => _updateVote(-1),
          ),
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
      ),
    );
  }

  Widget _buildSocialShareSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: _sharePost,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePost,
          ),
        ],
      ),
    );
  }

  Widget _buildColumn2() {
    var postPreview = Column(
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
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 28),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
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
          const SizedBox(
            height: 10,
          ),
          _builderTitlePostContent(),
          postPreview,
          // Mở rộng chiều rộng của container để text tự động xuống hàng
        ],
      ),
    );
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    // String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$content';
  }

  // Chuyển đổi chuỗi thành Instant
  String convertDateString(String inputDateString) {
    // Chuyển đổi chuỗi thành DateTime
    DateTime dateTime = DateTime.parse(inputDateString);

    // Định dạng lại DateTime theo định dạng mong muốn
    String outputDateString = DateFormat("MMMM d, y h:mm a").format(dateTime);

    return outputDateString;
  }

  Future<void> _loadPost() async {
    var future = postRepository.getOneDetails(id);
    future.then((response) {
      PostDetailDTO postDetailDTO = PostDetailDTO.fromJson(response.data);
      _contentController.text = postDetailDTO.content;
      _titleController.text = postDetailDTO.title;
      _nameController.text = postDetailDTO.user.displayName;
      _nickNameController.text = '@${postDetailDTO.user.username}';
      upDateAt = postDetailDTO.updatedAt;
      _updateAtController.text = convertDateString(upDateAt.toString());
      _loadPostsByTheSameAuthor(postDetailDTO.user.username);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Future<void> _loadPostsByTheSameAuthor(String authorName) async {
    var future = postRepository.getPostsSameAuthor(authorName);
    future.then((response) {
      print(response.data);
      List<Map<String, dynamic>> jsonDataList =
          List<Map<String, dynamic>>.from(response.data);
      
      List<Post> posts =
          jsonDataList.map((json) => Post.fromJson(json)).toList();
      listTitlePost = posts.map((post) => post.title).toList();
      print(listTitlePost);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Widget _menuAnchor() {
    String title = 'hành động';
    return ListTile(
      title: Text(title),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
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
        style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildUserAvatar(),
        const SizedBox(width: 16),
        _buildUserProfile(),
        const SizedBox(width: 2),
        _buildFollowButton(),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
          Text(_nickNameController.text)  ,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.grey,
            //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
        ),
      ],
    );
  }

  Widget _buildPostDetails() {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Column(
            children: [Text(_updateAtController.text)],
          ),
        ],
      ),
    );
  }

  void _updateVote(int value) {
    setState(() {
      score += value;
    });
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void _sharePost() {
    // String postTitle =
    //     'Tiêu đề bài viết'; // Thay thế bằng tiêu đề thực tế của bài viết
    // String postLink =
    //     'https://example.com/bai-viet'; // Thay thế bằng liên kết thực tế của bài viết

    // Share.share('Check out this post: $postTitle\n$postLink');
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

  Widget _tableOfContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titletableOfContents(),
        _bodyTableOfContents(),
      ],
    );
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
        children: [
          for (var title in listTitlePost)
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: title,
                    // Các thuộc tính khác của TextStyle có thể được thêm vào ở đây
                  ),
                ),
                _feedItem(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _feedItem() {
    return const Row(
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
    );
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
