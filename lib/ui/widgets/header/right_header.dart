import 'package:cay_khe/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemMenu {
  ItemMenu({required this.name, required this.icon, required this.route});
  final String name;
  final IconData icon;
  final String route;
}

class RightHeader extends StatefulWidget {
  RightHeader();

  @override
  _RightHeaderState createState() => _RightHeaderState();
}

class _RightHeaderState extends State<RightHeader> {
  List<ItemMenu> creatMenu = [
    ItemMenu(name: "Bài viết", icon: Icons.create, route: "/publish/post"),
    ItemMenu(name: "Series", icon: Icons.list, route: "/publish/series"),
    ItemMenu(name: "Đặt câu hỏi", icon: Icons.help, route: "/publish/ask")
  ];

  List<ItemMenu> profilerMenu = [
    ItemMenu(name: "Trang cá nhân", icon: Icons.person, route: "/publish/post"),
    ItemMenu(
        name: "Đổi mật khẩu",
        icon: Icons.change_circle,
        route: "/changepass"),
    ItemMenu(
        name: "Quên mật khẩu", icon: Icons.vpn_key, route: "/forgotpass"),
    ItemMenu(name: "Đăng xuất", icon: Icons.logout, route: "/publish/post")
  ];

  final searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 268,
          height: 32,
          child: TextField(
            style: TextStyle(fontSize: 16.0, height: 1.0, color: Colors.black),
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 32,
          child: FloatingActionButton(
            hoverColor: Colors.black38,
            backgroundColor: Colors.black,
            onPressed: () {
              GoRouter.of(context).go('/search/${searchController.text}');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: const Icon(Icons.search),
          ),
        ),
        SizedBox(width: 10),
        
        widgetSignIn(),
        
        SizedBox(width: screenSize.width / 10),
      ],
    );
  }

  Widget widgetSignIn() => Row(
    children: [
      MenuAnchor(
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.edit_note),
              iconSize: 24,
              splashRadius: 16,
              tooltip: 'Viết',
            );
          },
          menuChildren: List<MenuItemButton>.generate(
            creatMenu.length,
            (int index) => MenuItemButton(
                onPressed: () =>
                    {GoRouter.of(context).go(creatMenu[index].route)},
                child: Row(
                  children: [
                    Icon(creatMenu[index].icon),
                    SizedBox(
                      width: 20,
                    ),
                    Text(creatMenu[index].name)
                  ],
                )),
          ),
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.notifications_none),
          iconSize: 24,
          splashRadius: 16,
        ),
        SizedBox(width: 10),
        MenuAnchor(
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.account_circle),
              iconSize: 32,
              splashRadius: 16,
              tooltip: 'Profiler',
            );
          },
          menuChildren: List<MenuItemButton>.generate(
            creatMenu.length,
            (int index) => MenuItemButton(
                onPressed: () =>
                    {GoRouter.of(context).go(profilerMenu[index].route)},
                child: Row(
                  children: [
                    Icon(profilerMenu[index].icon),
                    SizedBox(
                      width: 20,
                    ),
                    Text(profilerMenu[index].name)
                  ],
                )),
          ),
        ),
    ],
  );
}
