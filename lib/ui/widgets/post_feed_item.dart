import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostFeedItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          return Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(217, 217, 217, 1),
                    )
                )
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.account_circle),
                      iconSize: 32,
                      splashRadius: 16,
                      tooltip: 'Profiler',
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth - 56,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: InkWell(
                                child: Text('Full name'),
                                onTap: () {},
                              ),
                            ),
                            Text("02/12/2023")
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: InkWell(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Title",
                                style: TextStyle(fontSize: 24),
                                softWrap: true,
                              ),
                            ),
                            onTap: () {}
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                tagBtn()
                              ],
                            ),
                            Text("8")
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget tagBtn() {
    return TextButton(
      onPressed: (){},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(244, 244, 245, 1)),
        side: MaterialStateProperty.all(
          BorderSide(
            color: Color.fromRGBO(233, 233, 235, 1), // your color here
            width: 1,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // your radius here
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.all(4), // your padding value here
        ),
      ),
      child: Text('Example', style: TextStyle(color: Color.fromRGBO(144, 147, 153, 1), fontSize: 12),),
    );
  }
}