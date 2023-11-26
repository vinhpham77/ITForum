import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/models/post_detail_dto.dart';
import 'package:cay_khe/models/tag.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/tag_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  Tag? selectedTag;
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];
  String id = '6562e98f3f5baa104a327aa8';
  @override
  void initState() {
    super.initState();
    print('init');
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
              width: 1200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  // _buildColumn1(),
                  // const SizedBox(width: 50),
                    _buildColumn2(),
                  // const SizedBox(width: 50),
                  // _buildColumn3(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumn1() {
    return Container(
      width: 100,
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
          height: 500,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 32,
            bottom: 32,
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
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _builderAuthortPostContent(),
          _builderTitlePostContent(),
          const SizedBox(
            height: 10,
          ),
          postPreview, // Mở rộng chiều rộng của container để text tự động xuống hàng
        ],
      ),
    );
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$title  \n###### $tags\n  # \n  $content';
  }

  Future<void> _loadPost() async {
    print('a');
    var future = postRepository.getOneDetails(id);

    future.then((response) {
      print('b');
      if (response.data == null) print('null');
      else
      print('co du lieu');
      PostDetailDTO postDetailDTO = PostDetailDTO.fromJson(response.data);
      print(postDetailDTO.content);
      print('after postdetails');
      setState(() {
        _titleController.text = postDetailDTO.title;
        _contentController.text = postDetailDTO.content;
      });
    }).catchError((error) {
      print("loi khong lay duo du lieu");
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
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Tìm hiểu về lập trình dự báo theo chuỗi thời gian từ tổng quát đến chi tiết",
        style: TextStyle(
          fontWeight: FontWeight.w800, // in đậm
          fontSize: 40.0, // kích thước chữ
        ),
      ),
    );
  }

  Widget _builderContent() {
    return Container(
      child: RichText(
        text: const TextSpan(
          text:
              'Mỗi người sinh ra đã có một số phận khác nhau, mang trong mình những ước mơ, hoài bão khác nhau và con đường hoàn thiện bản thân khác nhau. Trên con đường đó, chúng ta sẽ gặp không ít những thất bại cũng như thành công. Tuy nhiên, sau những điều đó, ta lại tìm thấy giá trị cao đẹp của bản thân cũng như cuộc sống của mình. Thành công là việc mỗi người đạt được mục tiêu, ước mơ mà bản thân mình đề ra sau một quá trình dài cố gắng, phấn đấu không ngừng nghỉ. Còn thất bại đối lập với thành công, là cảm giác buồn bã, thất vọng khi chúng ta không đạt được thành quả mong muốn. Thành công và thất bại là những điều mà con người ai cũng sẽ gặp phải trên con đường hoàn thiện bản thân, thực hiện mục tiêu của mình. Thành công của mỗi người đều được đánh đổi bằng những khó khăn, thử thách và cả những lần vấp ngã, nản chí. Thất bại càng cay đắng, đau khổ bao nhiêu thì thành công càng rực rỡ bấy nhiêu, những giá trị cao đẹp chúng ta nhận lại càng ngọt ngào bấy nhiêu. Sau những khó khăn, thất bại, ta sẽ rút ra được những bài học vô cùng quý giá trong cuộc sống mà không có bất cứ trường lớp nào có thể dạy ta, từ đó ta có thêm những bài học căn bản để hoàn thiện bản thân mình, tạo ra những giá trị tốt đẹp nhất cho cuộc sống của mình. Nếu xã hội con người ai cũng có cho mình một ý chí kiên cường, vượt lên thất bại để đến thành công thì xã hội ấy sẽ tốt đẹp và phát triển phồn thịnh hơn. Là một người học sinh được sống trong hoàn cảnh mới, thời bình của đất nước, chúng ta phải có nhận thức đúng đắn về việc rèn luyện, trau dồi bản thân mình để cống hiến những điều tốt đẹp nhất cho quê hương, đất nước. Bên cạnh đó, để cuộc sống tốt đẹp hơn, ta cần phải sống chan hòa, yêu thương mọi người xung quanh để xây dựng một xã hội văn minh, tiến bộ. Thất bại là mẹ thành công, không có thất bại sẽ không có thành công và giá trị con người không được nâng lên. Chúng ta hãy sống với tinh thần cầu tiến, ý chí mạnh mẽ vượt qua khó khăn, thử thách để có được thành quả ngọt ngào cho bản thân mình.Bài 2Trong cuộc sống bộn bề và tấp nập, đã có bao lần chúng ta vấp ngã để trở nên trưởng thành, vững bước trên đường đời cam go. Phải trải qua những thất bại, ta mới đúc rút được kinh nghiệm vươn tới thành công, và cũng qua những sai lầm dẫn tới thất bại, ta mới hiểu được, giá trị của thành công nằm ở chỗ nào. Thành công là những kết quả khả quan sau một quá trình dài gây dựng, phát triển. Đối với một đứa trẻ, thành công là khi được điểm mười đỏ chói sau những đêm dài thức khuya học tập. Với một doanh nhân, thành công tỉ lệ thuận với số dư tài khoản, với danh tiếng và địa vị.Ngược lại, thất bại là khi ta không đạt được mục tiêu mong muốn, gặp khó khăn, trắc trở khiến ra nhụt chí. Hai khái niệm tưởng chừng xa lạ này lại luôn song hành tồn tại và bổ trợ tương thông cho nhau, tạo nên một xã hội hoàn chỉnh, đòi hỏi con người không ngừng phấn đấu và hoàn thiện bản thân. Có những người sau thất bại có khả năng sửa chữa lỗi lầm, vững bước trên con đường tiến tới thành công. Trong khi đó, thất bại thường quật ngã những người chưa có ý chí và quyết tâm vững vàng, dễ từ bỏ. Có được thành công hay không hoàn toàn phụ thuộc vào bản thân mỗi chúng ta.Nói về thành công, nhiều người nghĩ ngay đến tiền bạc, danh vọng, điều đó không sai nhưng chẳng phải trường hợp nào cũng tuyệt đối như vậy. Một người ốm yếu nằm trên giường, thành công không phải có từng núi tiền xếp dưới chân mà là can đảm chiến thắng bệnh tật, giành lại sự sống từ tay tử thần. Sự thành công bắt buộc phải trả giá bằng những mất mát, những lần thất bại đau đớn để từ đó có thể tích lũy thêm hành trang vào đời. Trải qua gian nan thử thách, ý chí con người được tôi rèn, tâm hồn trở nên mạnh mẽ và khát khao thành công được hun đúc thành động lực. Để trở thành một diễn viên xiếc lão luyện, kể làm sao hết những lần tập luyện thất bại, những chấn thương thể xác đau đớn vô biên. Ánh đèn sân khấu lấp lánh ngoài kia là sự thành công, nhưng để chạm tới nó, ắt hẳn phải trải qua những năm tháng khổ luyện, những giọt nước mắt và thậm chí là đổ máu. Phải có thất bại thì mới có thành công, và thành công chỉ trọn vẹn khi con đường dẫn tới nó có nhiều gai nhọnThất bại là điều hiển nhiên trong cuộc đời mỗi con người. Do thiếu kinh nghiệm, thiếu hiểu biết, do còn non nớt chưa có người dẫn đường chỉ lối, do chưa đủ quyết tâm, động lực vượt qua khó khăn,... Người tài giỏi không phải người chưa từng thất bại, mà là người biết đứng lên sau những vấp ngã, trưởng thành và hoàn thiện sau những cú trượt dài. Thành công được tạo nên bởi kinh nghiệm, tinh thần học hỏi và tâm huyết của mỗi người. Không một cây ăn trái nào có thể đậu quả mà không bắt nguồn từ một thân cây nhỏ bé, yếu ớt. Quan trọng rằng khi bão giông ập tới, khi bị dồn vào bước đường cùng, cây con ấy có dám đứng thẳng, có dám cắm sâu rễ vào lòng đất, có dám đương đầu với gió dập sóng vùi để vươn tới ngày đâm hoa kết trái hay không. Cổ nhân có câu "Thất bại là mẹ thành công", thất bại chính là nền tảng cốt cán cho thành công, từng nấc thang dẫn tới thành công có vững chắc hay không đều phụ thuộc vào việc bản thân đã học được những gì qua thất bại.Không con đường nào dẫn tới thành công mà chỉ trải đầy hoa hồng. Những gập ghềnh khó khăn của cuộc sống chính là những bài học quý giá, thất bại có thể làm con đường dẫn tới thành công chậm lại, nhưng nhờ có nó, ta sẽ không bị vấp ngã lần nữa, tâm trí cũng đanh thép hơn, sẵn sàng đối mặt với mọi thử thách. Vì vậy, đừng sợ khó, sợ khổ, sợ thất bại, sợ người đời cười chê mà để lỡ những cơ hội của mình. Một bản nhạc hay cần có khúc trầm khúc bổng, một quyển sách hay cần có những tình huống vui buồn đan xen, và một con người hoàn hảo là khi họ đã trải qua đủ hỉ nộ ái ố để có thể ngồi trên đỉnh vinh quang.Thành công đến quá sớm, thành công được người khác sắp đặt cho, nản chí khi thất bại, sợ hãi không dám đối mặt với thất bại, đó là ranh giới chúng ta cần vượt qua khi nhắc tới thành công và thất bại. Hãy nhớ rằng, thước đo của thành công không nằm ở chỗ bạn có bao nhiêu tiền, đi xe gì, nhà cao bao nhiêu, mà là khi đứng trước sóng gió cuộc đời, bạn mỉm cười thảnh thơi đối mặt, vì thất bại đã cho bạn đủ sức mạnh trưởng thành.',
          style: TextStyle(
              // Các thuộc tính văn bản như font, size, màu sắc, độ dày, ...
              // Đặt softWrap thành true để cho phép tự động xuống hàng
              ),
        ),
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
        const SizedBox(
          width: 200,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text("Thành Quốc"),
            SizedBox(
              width: 16,
            ),
            Text("@quoc1907"),
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
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          child: Center(child: Icon(icon)),
        ),
        const SizedBox(width: 2),
        Center(child: Text(text)),
      ],
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
      child: const Row(
        children: [
          Column(
            children: [Text("Đã đăng vào: 17 giờ trước")],
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
    String postTitle =
        'Tiêu đề bài viết'; // Thay thế bằng tiêu đề thực tế của bài viết
    String postLink =
        'https://example.com/bai-viet'; // Thay thế bằng liên kết thực tế của bài viết

    // Share.share('Check out this post: $postTitle\n$postLink');
  }

  onPressed() {
    // Hàm này sẽ được gọi khi người dùng nhấn vào một trong những hành động cụ thể
  }
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
        _feedItem(),
        _ownerArticles()
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
    child: SizedBox(
      child: Column(
        children: [
          RichText(
              text: const TextSpan(
            text:
                '[CI-CD] Triển Khai Ứng Dụng Node.js lên Cloud Run với GitHub Actions',
          ))
        ],
      ),
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
              color: Color.fromARGB(255, 212, 211, 211), // Màu của biểu tượng,
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
              color: Color.fromARGB(255, 212, 211, 211), // Màu của biểu tượng,
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
              color: Color.fromARGB(255, 212, 211, 211), // Màu của biểu tượng,
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
              color: Color.fromARGB(255, 212, 211, 211), // Màu của biểu tượng,
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

class _ownerArticles extends StatefulWidget {
  @override
  State<_ownerArticles> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<_ownerArticles> {
  Color textColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return _ownArticles("Thành Quốc 1907");
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
