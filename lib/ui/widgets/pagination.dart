import 'package:cay_khe/dtos/limit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;

import '../router.dart';

class Pagination extends StatelessWidget {
  int selectedPage;
  String path;
  int totalItem;
  Map<String, String> params;

  Pagination({this.selectedPage = 1, required this.path, required this.totalItem, required this.params});

  @override
  Widget build(BuildContext context) {
    int totalPasge = (totalItem/limitPage).ceil();
    if(params.isEmpty)
      params = {'page': '1'};
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  selectedPage > 1 ? pageBtn(text: "<", route: "$path/${converPageParams(params, (selectedPage - 1).toString())}", context: context) : Container(),
                  selectedPage > 1 ? pageBtn(text: "1", route: "$path/${converPageParams(params, '1')}", context: context): Container(),
                  selectedPage > 3 ? pageBtn(text: "...", context: context): Container(),
                  selectedPage > 2 ? pageBtn(text: (selectedPage - 1).toString(), route: "$path/${converPageParams(params, (selectedPage - 1).toString())}", context: context): Container(),
                  pageBtn(text: selectedPage.toString(), route: "$path/${converPageParams(params, selectedPage.toString())}", isSelect: true, context: context),
                  selectedPage < totalPasge - 1 ? pageBtn(text: (selectedPage + 1).toString(), route: "$path/${converPageParams(params, (selectedPage + 1).toString())}", context: context): Container(),
                  selectedPage < totalPasge - 2 ? pageBtn(text: "...", context: context): Container(),
                  selectedPage < totalPasge ? pageBtn(text: totalPasge.toString(), route: "$path/${converPageParams(params, totalPasge.toString())}", context: context): Container(),
                  selectedPage < totalPasge ? pageBtn(text: ">", route: "$path/${converPageParams(params, (selectedPage + 1).toString())}", context: context): Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget pageBtn({String text = "", String route = "", bool isSelect = false, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: TextButton(
        onPressed: (route == "" || isSelect) ? null : () => appRouter.go(route),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
            BorderSide(
              color: isSelect? Color.fromRGBO(84, 136, 199, 1) : Color.fromRGBO(155, 155, 155, 1), // your color here
              width: 2,
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
        child: Text(text,
          style: TextStyle(
              color: isSelect ? Color.fromRGBO(84, 136, 199, 1) : Color.fromRGBO(155, 155, 155, 1),
              fontSize: 16
          ),
        ),
      ),
    );
  }

  String converPageParams(Map<String, String> params, String page) {
    return params.entries.map((e) => e.key == 'page'? '${e.key}=$page' : '${e.key}=${e.value}').join('&');
  }
}