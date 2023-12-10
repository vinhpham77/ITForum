import 'package:cay_khe/ui/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../posts_view.dart';

class LeftMenu extends StatelessWidget {
  final List<NavigationPost> listSelectBtn;

  const LeftMenu({required this.listSelectBtn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listSelectBtn.map((selectBtn) {
          return selectBtn.isSelected ? buttonSelected(selectBtn.index) : buttonSelect(selectBtn.index);
        }).toList(),
      ),
    );
  }

  Widget buttonSelect(int index) {
    return Container(
      width: 180,
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: TextStyle(color: Colors.black),),
        ),
        onPressed: () => appRouter.go(listSelectBtn[index].path, extra: {}),
        onHover: (value) {listSelectBtn[index].isSelected = value;},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(listSelectBtn[index].isSelected ? Color.fromRGBO(242, 238, 242, 1) : Colors.white),
        ),
      ),
    );
  }

  Widget buttonSelected(int index) {
    return Container(
      width: 180,
      child: TextButton(
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        onPressed: () => appRouter.go(listSelectBtn[index].path, extra: {}),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(242, 242, 242, 1)),
        ),
      ),
    );
  }
}