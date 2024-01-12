
import 'package:cay_khe/ui/views/search/widgets/search_post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../router.dart';
import '../../posts/posts_view.dart';

class SearchTapView extends StatefulWidget {
  const SearchTapView({super.key, required this.params, required this.index, required this.navigation});

  final Map<String, String> params;
  final int index;
  final List<NavigationPost> navigation;

  @override
  State<SearchTapView> createState() => _SearchTapViewState();
}

class _SearchTapViewState extends State<SearchTapView> {
  List<String> listSortOption = [
    "Phù hợp nhất",
    "Lượt vote giảm dần",
    "Mới nhất",
    "Cũ nhất"
  ];



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
      'updatedAtDESC': SortOption(
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
    String sortSelected;
    if (!widget.params.containsKey('sortField') ||
        widget.params['sortField'] == "") {
      sortSelected = 'fit';
    } else if (widget.params['sortField'] == "updatedAt") {
      sortSelected = (widget.params['sortField']! + (widget.params['sort'] ?? "DESC"))!;
    } else {
      sortSelected = widget.params['sortField'] ?? "fit";
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black38))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.navigation.map((selectBtn) {

              return selectBtn.isSelected ? buttonSelected(selectBtn.index) : buttonSelect(selectBtn.index);
            }).toList(),
          ),
          Row(
            children: [
              const Text("Sắp xếp theo:"),
              DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: listSortOption[mapSortOption[sortSelected] ?.index ?? 0],
                    onChanged: (String? newValue) {
                      int index = listSortOption.indexOf(newValue ?? "");
                      String key = "fit";
                      for (var entry in mapSortOption.entries) {
                        if (entry.value.index == index) {
                          key = entry.key;
                          break;
                        }
                      }
                      appRouter.go(widget.navigation[widget.index].path + (mapSortOption[key]?.route ?? "/viewsearch/"));
                    },
                    items: listSortOption.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Text(value),
                        ),
                      );
                    }).toList(),
                    focusColor: const Color.fromRGBO(242, 238, 242, 1),
                  ))
            ],
          )
        ],
      ),
    );
  }

  String getQuery({required Map<String, String> params,
    required sortField,
    sort = "DESC",
    required page}) {
    return "/searchContent=${params['searchContent'] ??
        ""}&searchField=${params['searchField'] ??
        ""}&sort=$sort&sortField=$sortField&page=$page";
  }

  Widget buttonSelect(int index) {
    return Container(
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.navigation[index].text, style: TextStyle(color: Colors.black),),
        ),
        onPressed: () => appRouter.go(widget.navigation[index].path, extra: {}),
        onHover: (value) {widget.navigation[index].isSelected = value;},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.navigation[index].isSelected ? Color.fromRGBO(242, 238, 242, 1) : Colors.white),
        ),
      ),
    );
  }

  Widget buttonSelected(int index) {
    return Container(
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.navigation[index].text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        onPressed: () => appRouter.go(widget.navigation[index].path, extra: {}),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
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