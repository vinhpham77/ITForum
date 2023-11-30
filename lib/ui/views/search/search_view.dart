import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/ui/common/utils/app_constants.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';

import '../../widgets/pagination.dart';
import '../../widgets/post_feed_item.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.params});

  final Map<String, String> params;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late ResultCount<PostAggregation> resultCount =
      ResultCount(resultList: [], count: 0);
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
    postBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int page = int.parse(widget.params['page'] ?? "1");
    Map<String, SortOption> mapSortOption = {
      'fit': SortOption(
          index: 0,
          route: getQuery(params: widget.params, sortField: "", page: page)),
      'score': SortOption(
          index: 1,
          route:
              getQuery(params: widget.params, sortField: "score", page: page)),
      'updatedAt': SortOption(
          index: 2,
          route: getQuery(
              params: widget.params, sortField: "updatedAt", page: page)),
      'updatedAtASC': SortOption(
          index: 3,
          route: getQuery(
              params: widget.params,
              sortField: "updatedAt",
              sort: "ASC",
              page: page))
    };
    searchController.text = widget.params['searchContent'] ?? "";

    List<String> listSortOption = [
      "Phù hợp nhất",
      "Lượt vote giảm dần",
      "Mới nhất",
      "Cũ nhất"
    ];
    String sortSelected;
    if (!widget.params.containsKey('sortField') ||
        widget.params['sortField'] == "") {
      sortSelected = 'fit';
    } else if (widget.params['sortField'] == "updatedAt" &&
        widget.params['sort'] == "ASC") {
      sortSelected = 'updatedAtASC';
    } else {
      sortSelected = widget.params['sortField'] ?? "fit";
    }
    postBloc = PostBloc(context: context);
    postBloc.loadPost(params: widget.params);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: SizedBox(
            width: constraints.maxWidth,
            child: Center(
              child: SizedBox(
                width: maxContent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 12.0),
                                          hintText: 'Nhập từ khóa tìm kiếm...',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)))),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                SizedBox(
                                  height: 36,
                                  width: 80,
                                  child: FloatingActionButton(
                                    hoverColor: Colors.black38,
                                    backgroundColor: Colors.black,
                                    onPressed: () {
                                      appRouter.go(getSearchQuery(
                                          params: widget.params,
                                          searchStr: searchController.text,
                                          page: page));
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    ),
                                    child: const Text(
                                      "Tìm kiếm",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            page < 1
                                ? const Center(
                                    child: Text(
                                    "Lỗi! Page không thể nhỏ hơn 1",
                                    style: TextStyle(color: Colors.red),
                                  ))
                                : StreamBuilder(
                                    stream: postBloc.postStream,
                                    builder: (context, snapshot) {
                                      if (!mapSortOption
                                          .containsKey(sortSelected)) {
                                        return Center(
                                            child: Text(
                                          "Lỗi! Không thể sort theo ${widget.params['sortField']}",
                                          style: const TextStyle(color: Colors.red),
                                        ));
                                      }
                                      if (snapshot.hasData) {
                                        ResultCount<PostAggregation>
                                            resultCount = snapshot.data;
                                        if (resultCount.resultList.isNotEmpty) {
                                          return Column(
                                            //build lai
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    8, 16, 8, 4),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors
                                                                .black38))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onHover: (value) {
                                                            setState(() {
                                                              value
                                                                  ? _isPostHovering =
                                                                      true
                                                                  : _isPostHovering =
                                                                      false;
                                                            });
                                                          },
                                                          onTap: () {},
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'Bài viết',
                                                                style: TextStyle(
                                                                    color: _isPostHovering
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text("Sắp xếp theo:"),
                                                        DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                          value: listSortOption[
                                                              mapSortOption[
                                                                          sortSelected]
                                                                      ?.index ??
                                                                  0],
                                                          onChanged: (String?
                                                              newValue) {
                                                            int index =
                                                                listSortOption
                                                                    .indexOf(
                                                                        newValue ??
                                                                            "");
                                                            String key = "fit";
                                                            for (var entry
                                                                in mapSortOption
                                                                    .entries) {
                                                              if (entry.value
                                                                      .index ==
                                                                  index) {
                                                                key = entry.key;
                                                                break;
                                                              }
                                                            }
                                                            appRouter.go(
                                                                mapSortOption[
                                                                            key]
                                                                        ?.route ??
                                                                    "/viewsearch/");
                                                          },
                                                          items: listSortOption.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child:
                                                                    Text(value),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          focusColor:
                                                              const Color.fromRGBO(
                                                                  242,
                                                                  238,
                                                                  242,
                                                                  1),
                                                        ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Column(
                                                      children: resultCount
                                                          .resultList
                                                          .map((e) {
                                                    return PostFeedItem(
                                                        postAggregation: e);
                                                  }).toList()),
                                                  Pagination(
                                                    path: "/viewsearch",
                                                    totalItem:
                                                        resultCount.count,
                                                    params: widget.params,
                                                    selectedPage: page,
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        } else {
                                          if (resultCount.resultList.isEmpty) {
                                            return const Center(
                                                child: Text(
                                                    "Không có bài viết nào"));
                                          }
                                          int totalPages =
                                              (resultCount.count / limitPage)
                                                  .ceil();
                                          if (page > totalPages) {
                                            return Center(
                                                child: Text(
                                              "Lỗi! Tổng số trang là $totalPages, không thể truy cập trang $page",
                                              style:
                                                  const TextStyle(color: Colors.red),
                                            ));
                                          }
                                        }
                                      }
                                      if (snapshot.hasError) {
                                        return const Center(
                                            child: Text(
                                          "Lỗi! Không thể load được vui lòng thử lại sau",
                                          style: TextStyle(color: Colors.red),
                                        ));
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 368,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "CÚ PHÁP TÌM KIẾM",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Text("Cú pháp 1 là [Nội dung]"),
                          Text("Cú pháp 2 là [Tên trường]:[Nội dung]")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getQuery(
      {required Map<String, String> params,
      required sortField,
      sort = "DESC",
      required page}) {
    return "/viewsearch/searchContent=${params['searchContent'] ?? ""}&searchField=${params['searchField'] ?? ""}&sort=$sort&sortField=$sortField&page=$page";
  }

  String getSearchQuery(
      {required Map<String, String> params,
      required String searchStr,
      required page}) {
    int index = searchStr.indexOf(':');
    if (index == -1) {
      return "/viewsearch/searchContent=$searchStr&sort=${widget.params['sort'] ?? ""}&sortField=${widget.params['sortField'] ?? ""}&page=$page";
    }
    String firstPart = searchStr.substring(0, index);
    String secondPart = searchStr.substring(index + 1);
    return "/viewsearch/searchContent=$secondPart&searchField=$firstPart&sort=${widget.params['sort'] ?? ""}&sortField=${widget.params['sortField'] ?? ""}&page=$page";
  }

  Widget demoBtn(String text) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromRGBO(244, 244, 245, 1)),
        side: MaterialStateProperty.all(
          const BorderSide(
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
          const EdgeInsets.all(4), // your padding value here
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color.fromRGBO(144, 147, 153, 1), fontSize: 12),
      ),
    );
  }
}

class SortOption {
  int? index;
  bool isSelected;
  String route;

  SortOption(
      {required this.index, required this.route, this.isSelected = false});
}
