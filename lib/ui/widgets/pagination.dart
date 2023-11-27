import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  int selectedPage;
  String routeStr;
  int totalItem;

  Pagination({this.selectedPage = 1, required this.routeStr, required this.totalItem});

  @override
  Widget build(BuildContext context) {
    int totalPasge = (totalItem/2).ceil();
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
                  selectedPage > 1 ? pageBtn(text: "<", route: "route") : Container(),
                  SizedBox(width: 8,),
                  selectedPage > 1 ? pageBtn(text: "1", route: "route"): Container(),
                  SizedBox(width: 8,),
                  selectedPage > 3 ? pageBtn(text: "...",): Container(),
                  SizedBox(width: 8,),
                  selectedPage > 2 ? pageBtn(text: (selectedPage - 1).toString(), route: "route"): Container(),
                  SizedBox(width: 8,),
                  pageBtn(text: selectedPage.toString(), route: "route", isSelect: true),
                  SizedBox(width: 8,),
                  selectedPage < totalPasge - 1 ? pageBtn(text: (selectedPage + 1).toString(), route: "route"): Container(),
                  SizedBox(width: 8,),
                  selectedPage < totalPasge - 2 ? pageBtn(text: "..."): Container(),
                  SizedBox(width: 8,),
                  selectedPage < totalPasge ? pageBtn(text: totalPasge.toString(), route: "route"): Container(),
                  SizedBox(width: 8,),
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