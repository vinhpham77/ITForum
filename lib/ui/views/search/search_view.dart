import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:flutter/material.dart';

import 'package:cay_khe/models/post_aggregation.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.params});
  final Map<String, String> params;
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late ResultCount<PostAggregation> resultCount = ResultCount(resultList: [], count: 0);
  late PostBloc postBloc;
  bool _isPostHovering = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    postBloc = PostBloc(context: context);
    postBloc.loadPost(params: widget.params);
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
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(right: 32),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Container(
                                    height: 36,
                                    child: TextField(
                                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                          hintText: 'Nhập từ khóa tìm kiếm...',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(4)))),
                                    ),
                                  ),),
                                  SizedBox(width: 16,),
                                  SizedBox(
                                    height: 36,
                                    width: 80,
                                    child: FloatingActionButton(
                                      hoverColor: Colors.black38,
                                      backgroundColor: Colors.black,
                                      onPressed: () {
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      child: const Text(
                                        "Tìm kiếm",
                                        style: TextStyle(color: Colors.white,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onHover: (value) {
                                            setState(() {
                                              value ? _isPostHovering = true : _isPostHovering = false;
                                            });
                                          },
                                          onTap: () {
                                          },
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                               Text(
                                                'Bài viết',
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Sắp xếp theo:")
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          // StreamBuilder(
                          //     stream: postBloc.postStream,
                          //     builder: (context, snapshot) {
                          //       if(snapshot.hasData) {
                          //         resultCount = snapshot.data;
                          //         return Column(
                          //           children: [
                          //             Column(
                          //                 children:resultCount.resultList.map((e) {
                          //                   return PostFeedItem(postAggregation: e);
                          //                 }).toList()
                          //             ),
                          //             Pagination(path: "/viewposts", totalItem: resultCount.count, params: widget.params, selectedPage: int.parse(widget.params['page'] ?? '1'),)
                          //           ],
                          //         );
                          //       }
                          //       return Center(child:CircularProgressIndicator());
                          //     }
                          // )
                      ),
                    ),
                    Container(width: 368,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class sortOption{
  String text;
  bool isSelected;
  String route;

  sortOption({required this.text, required this.route, this.isSelected = false});
}