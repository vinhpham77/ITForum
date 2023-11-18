
import 'package:cay_khe/blocs/login_bloc.dart';
import 'package:cay_khe/ui/views/login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc =new LoginBloc();

  bool _showPass = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Container(
                      child: Text("STARFRUIT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 50))),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Text("Đăng nhập",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 30)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: StreamBuilder(
                      stream:bloc.userStream,
                      builder: (context, snapshot) => TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: "Username",
                            errorText: snapshot.hasError? snapshot.error.toString():null,
                            labelStyle: TextStyle(
                                color: Color(0xff888888), fontSize: 15)),
                      ),
                      
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                     StreamBuilder(stream: bloc.passStream, builder: (context,snapshot)=> TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: _passwordController,
                        obscureText: !_showPass,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText:  snapshot.hasError? snapshot.error.toString():null,
                            labelStyle: TextStyle(
                                color: Color(0xff888888), fontSize: 15)),
                      )),
                      GestureDetector(
                          onTap: onToggleShowPass,
                          child: Text(_showPass ? "Hide" : "Show",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)))
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
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                        onPressed: () =>  onSignInClicked(context),
                        child: Text("SIGN IN",
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                Container(
                  height: 130,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Quên mật khẩu",
                          style: TextStyle(fontSize: 15, color: Colors.blue)),
                      Text("Tạo tài khoản",
                          style: TextStyle(fontSize: 15, color: Colors.blue))
                    ],
                  ),
                ),
              ])),
        ));
      }),
    );
  }

   void onSignInClicked(BuildContext context) async {
  bool isValid = await bloc.isValidInfo(_usernameController.text, _passwordController.text);
  
  if (isValid) {
    // Thực hiện các công việc cần thiết khi thông tin hợp lệ
    GoRouter.of(context).go("/");
  } else {
    // Xử lý trường hợp thông tin không hợp lệ
  }
}

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  Widget gotoHome(BuildContext context) {
    return HomePage();
  }
}
