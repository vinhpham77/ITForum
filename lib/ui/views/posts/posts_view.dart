import 'package:flutter/cupertino.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 180,
                  child: Text(""),
                ),
                Expanded(
                    child: Container(width: 680,),
                ),
                Container(width: 280,)
              ],
            ),
          ),
        );
      },
    );
  }
}