import 'package:cay_khe/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc bloc;

  bool _showPass = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = LoginBloc(context);
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            width: constraints.maxWidth,
            //  padding: EdgeInsets.all(80),
            constraints: const BoxConstraints.expand(),
            color: Colors.white,
            child: Center(
              child: SizedBox(
                  width: 480,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                          child: Text("STARFRUIT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 50)),
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: StreamBuilder(
                              stream: bloc.userStream,
                              builder: (context, snapshot) => TextField(
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    labelText: "Username",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: const TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.passStream,
                                  builder: (context, snapshot) => TextField(
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _passwordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Password",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: const TextStyle(
                                                color: Color(0xff888888),
                                                fontSize: 15)),
                                      )),
                              GestureDetector(
                                  onTap: onToggleShowPass,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Text(_showPass ? "Hide" : "Show",
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ))
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
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                onPressed: () => onSignInClicked(context),
                                child: const Text("Đăng nhập",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                        SizedBox(
                          height: 130,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  navigateToForgotPasswordPage(context);
                                },
                                child: const MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    "Quên mật khẩu",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () => navigateToSignupPage(context),
                                  child: const MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text("Tạo tài khoản",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue))))
                            ],
                          ),
                        ),
                      ])),
            ));
      }),
    );
  }

  void onSignInClicked(BuildContext context) async {
    bool isValid = await bloc.isValidInfo(
        _usernameController.text, _passwordController.text);

    if (isValid) {
      GoRouter.of(context).go("/");
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void navigateToForgotPasswordPage(BuildContext context) {
    GoRouter.of(context).go("/forgotpass");
  }

  void navigateToSignupPage(BuildContext context) {
    GoRouter.of(context).go('/register');
  }

 
}
