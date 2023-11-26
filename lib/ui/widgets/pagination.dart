import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  int selectedPage;
  String routeStr;
  int totalItem;

  Pagination({this.selectedPage = 1, required this.routeStr, required this.totalItem});

  @override
  Widget build(BuildContext context) {
    int totalPasge = (totalItem/20).toInt() + 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  selectedPage > 1 ? pageBtn(text: "<", route: "route") : Container(),
                  selectedPage > 1 ? pageBtn(text: "1", route: "route"): Container(),
                  selectedPage > 3 ? pageBtn(text: "...",): Container(),
                  selectedPage > 3 ? pageBtn(text: (selectedPage - 1).toString(), route: "route"): Container(),
                  pageBtn(text: selectedPage.toString(), route: "route", isSelect: true),
                  selectedPage < totalPasge - 1 ? pageBtn(text: (selectedPage + 1).toString(), route: "route"): Container(),
                  selectedPage < totalPasge - 1 ? pageBtn(text: "..."): Container(),
                  selectedPage < totalPasge ? pageBtn(text: totalPasge.toString(), route: "route"): Container(),
                  selectedPage < totalPasge ? pageBtn(text: ">", route: "route"): Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget pageBtn({String text = "", String route = "", bool isSelect = false}) {
    return TextButton(
      onPressed: route == "" ? null : () {},
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
    );
  }
}