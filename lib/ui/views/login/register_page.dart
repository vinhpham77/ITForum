import 'package:cay_khe/blocs/register_bloc.dart';
import 'package:cay_khe/ui/views/login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
   late RegisterBloc bloc ; 

  bool _showPass = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc =RegisterBloc(context);
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            width: constraints.maxWidth,
            //  padding: EdgeInsets.all(80),
            constraints: BoxConstraints.expand(),
            color: Colors.white,
            child: Center(
              child: Container(
                  width: 480,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                              child: Text("STARFRUIT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 50))),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("Đăng ký",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.fullnameStream,
                                  builder: (context, snapshot) => TextField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _fullnameController,
                                        decoration: InputDecoration(
                                            labelText: "Tên người dùng",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: TextStyle(
                                                color: Color(0xff888888),
                                                fontSize: 15)),
                                      )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: StreamBuilder(
                                  stream: bloc.emailController,
                                  builder: (context, snapshot) => TextField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: "Địa chỉ email",
                                      errorText: snapshot.hasError
                                          ? snapshot.error.toString()
                                          : null,
                                      labelStyle: TextStyle(
                                          color: Color(0xff888888),
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      16), // Add some space between the text fields
                              Expanded(
                                child: StreamBuilder(
                                  stream: bloc.userStream,
                                  builder: (context, snapshot) => TextField(
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: "Tên tài khoản",
                                      errorText: snapshot.hasError
                                          ? snapshot.error.toString()
                                          : null,
                                      labelStyle: TextStyle(
                                          color: Color(0xff888888),
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.passStream,
                                  builder: (context, snapshot) => TextField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _passwordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Password",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: TextStyle(
                                                color: Color(0xff888888),
                                                fontSize: 15)),
                                      )),
                              GestureDetector(
                                  onTap: onToggleShowPass,
                                  child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text(_showPass ? "Hide" : "Show",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold))))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.rePasswordController,
                                  builder: (context, snapshot) => TextField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _rePasswordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Nhập lại Password",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: TextStyle(
                                                color: Color(0xff888888),
                                                fontSize: 15)),
                                      )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                onPressed: () => onSignUpClicked(context),
                                child: Text("Đăng ký",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => clickOnSignin(context),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])),
            ));
      }),
    );
  }

  void onSignUpClicked(BuildContext context) async {
    bool isValid = await bloc.isValidInfo(
        _usernameController.text,
        _passwordController.text,
        _rePasswordController.text,
        _emailController.text,
        _fullnameController.text);
    if (isValid) {
      print(isValid);
      print("đăng ký thành công");
      // Thực hiện các công việc cần thiết khi thông tin hợp lệ
      GoRouter.of(context).go("/login");
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void clickOnSignin(context) {
    GoRouter.of(context).go("/login");
  }

  Widget gotoHome(BuildContext context) {
    return HomePage();
  }
}
