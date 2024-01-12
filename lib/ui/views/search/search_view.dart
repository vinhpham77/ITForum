
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/search/widgets/search_post_view.dart';
import 'package:cay_khe/ui/views/search/widgets/search_series_view.dart';
import 'package:cay_khe/ui/views/search/widgets/search_tap_view.dart';
import 'package:flutter/material.dart';

import '../posts/posts_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.params, required this.indexSelected});

  final Map<String, String> params;
  final int indexSelected;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchController = TextEditingController();
  late List<NavigationPost> listSelectBtn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
  }

  @override
  void didUpdateWidget(SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getNavigation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void getNavigation() {
    listSelectBtn = navigations;
    listSelectBtn[widget.indexSelected].isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    int page = int.parse(widget.params['page'] ?? "1");
    searchController.text = widget.params['searchContent'] ?? "";

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
                                const SizedBox(width: 16,),
                                SizedBox(
                                  height: 36,
                                  width: 80,
                                  child: FloatingActionButton(
                                    hoverColor: Colors.black38,
                                    backgroundColor: Colors.black,
                                    onPressed: () {
                                      appRouter.go(getSearchQuery(
                                          path: listSelectBtn[widget.indexSelected].path,
                                          params: widget.params,
                                          searchStr: searchController.text,
                                          page: page));
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                    ),
                                    child: const Text("Tìm kiếm",
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
                                :Column(
                                children: [
                                  SearchTapView(params: widget.params, index: widget.indexSelected, navigation: listSelectBtn),
                                  listSelectBtn[widget.indexSelected].widget
                                ]
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 368,
                      child: Column(
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
                          Text("Cú pháp 2 là [Tên trường]:[Nội dung]"),
                          Text(""),
                          Text("Ví dụ: title:Git"),
                          Text(
                              "Các trường có thể tìm kiếm là: title, content, username, tag")
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

  List<NavigationPost> get navigations =>
      [
        NavigationPost(
            index: 0,
            text: "bài viết",
            path: "/viewsearch",
            widget: SearchPostView(
              params: widget.params,
              page: getPage(widget.params['page'] ?? "1"),
            )),
        NavigationPost(
            index: 1,
            text: "Series",
            path: "/viewsearchSeries",
            widget: SearchSeriesView(
              params: widget.params,
              page: getPage(widget.params['page'] ?? "1"),
            )),
      ];

  String getSearchQuery({required Map<String, String> params,
    required path,
    required String searchStr,
    required page}) {
    return path + "/searchContent=$searchStr&sort=${widget.params['sort'] ??
        ""}&sortField=${widget.params['sortField'] ?? ""}&page=$page";
  }

}

class SortOption {
  int? index;
  bool isSelected;
  String route;

  SortOption(
      {required this.index, required this.route, this.isSelected = false});
}
