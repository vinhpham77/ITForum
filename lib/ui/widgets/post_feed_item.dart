import 'package:cay_khe/models/post_aggregation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostFeedItem extends StatelessWidget {
  final PostAggregation postAggregation;
  const PostFeedItem({required this.postAggregation});
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
                                child: Text(postAggregation.user.displayName),
                                onTap: () {},
                              ),
                            ),
                            Text(DateFormat('dd/MM/yyyy').format(postAggregation.updatedAt))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: InkWell(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                postAggregation.title,
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
                              children: postAggregation.tags.map((e) => tagBtn(e)).toList(),
                            ),
                            Text(postAggregation.score.toString())
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

  Widget tagBtn(String text) {
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
      child: Text(text, style: TextStyle(color: Color.fromRGBO(144, 147, 153, 1), fontSize: 12),),
    );
  }
}