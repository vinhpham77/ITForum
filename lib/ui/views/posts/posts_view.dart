import 'package:cay_khe/ui/widgets/pagination.dart';
import 'package:cay_khe/ui/widgets/post_feed_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsView extends StatefulWidget {
  const PostsView({this.indexSelected = 0});
  final int indexSelected;
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  List<NavigationPost> listSelectBtn = [
    NavigationPost(index: 0, text: "Mới nhất"),
    NavigationPost(index: 1, text: "Đang theo dõi"),
    NavigationPost(index: 2, text: "Series"),
    NavigationPost(index: 3, text: "Bookmark của tôi")
  ];
  @override
  Widget build(BuildContext context) {

    listSelectBtn[widget.indexSelected].isSelected = true;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: Container(
            width: constraints.maxWidth,
            child: Center(
              child: Container(
                width: 1200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listSelectBtn.map((selectBtn) {
                            return selectBtn.isSelected ? buttonSelected(selectBtn.index) : buttonSelect(selectBtn.index);
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Container(width: 680, child: PostFeedItem()),
                            Pagination(routeStr: "", totalItem: 101)
                          ],
                        ),
                      ),
                    ),
                    Container(width: 280,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buttonSelect(int index) {
    return Container(
      width: 180,
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: TextStyle(color: Colors.black),),
        ),
        onPressed: () {},
        onHover: (value) {listSelectBtn[index].isSelected = value;},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(listSelectBtn[index].isSelected ? Color.fromRGBO(242, 242, 242, 1) : Colors.white),
        ),
      ),
    );
  }

  Widget buttonSelected(int index) {
    return Container(
      width: 180,
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(242, 242, 242, 1)),
        ),
      ),
    );
  }
}

class NavigationPost {
  final int index;
  String text;
  bool isSelected;
  String route;
  NavigationPost({required this.index,this.text = "", this.isSelected = false, this.route = ""});
}