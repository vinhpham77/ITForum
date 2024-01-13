import 'package:cay_khe/blocs/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late RegisterBloc bloc;

  bool _showPass = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = RegisterBloc(context);
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("STARFRUIT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 50)),
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
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _fullnameController,
                                        decoration: InputDecoration(
                                            labelText: "Tên người dùng",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: const TextStyle(
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
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: "Địa chỉ email",
                                      errorText: snapshot.hasError
                                          ? snapshot.error.toString()
                                          : null,
                                      labelStyle: const TextStyle(
                                          color: Color(0xff888888),
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      16), // Add some space between the text fields
                              Expanded(
                                child: StreamBuilder(
                                  stream: bloc.userStream,
                                  builder: (context, snapshot) => TextField(
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: "Tên tài khoản",
                                      errorText: snapshot.hasError
                                          ? snapshot.error.toString()
                                          : null,
                                      labelStyle: const TextStyle(
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
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _rePasswordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Nhập lại Password",
                                            errorText: snapshot.hasError
                                                ? snapshot.error.toString()
                                                : null,
                                            labelStyle: const TextStyle(
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
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                onPressed: () => onSignUpClicked(context),
                                child: const Text("Đăng ký",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => clickOnSignin(context),
                                child: const MouseRegion(
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

  
}
