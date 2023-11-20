import 'package:cay_khe/blocs/changePassword_bloc.dart';
import 'package:cay_khe/blocs/forgotPassword_bloc.dart';
import 'package:cay_khe/blocs/login_bloc.dart';
import 'package:cay_khe/blocs/resetPassword_bloc.dart';

import 'package:cay_khe/ui/views/login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  ResetPasswordBloc bloc = new ResetPasswordBloc();
  ForgotPasswordBloc forgotpassBloc = new ForgotPasswordBloc();
  bool _showPass = false;

  TextEditingController _otpController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _reRewPasswordController = new TextEditingController();

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
                          child: Text("Đặt lại mật khẩu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30)),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: StreamBuilder(
                              stream: bloc.otpStream,
                              builder: (context, snapshot) => TextField(
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _otpController,
                                decoration: InputDecoration(
                                    labelText: "Nhập mã OTP",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: StreamBuilder(
                              stream: bloc.pasStream,
                              builder: (context, snapshot) => TextField(
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _newPasswordController,
                                decoration: InputDecoration(
                                    labelText: "Nhập mật khẩu mới",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.repassStream,
                                  builder: (context, snapshot) => TextField(
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _reRewPasswordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Xác nhận lại mật khẩu",
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
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
                                onPressed: () => onChangePassClicked(context),
                                child: Text("Đổi mật khẩu",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ])),
            ));
      }),
    );
  }

  void onChangePassClicked(BuildContext context) async {
    bool isValid = await bloc.isValidInfo(
        ForgotPasswordBloc.requestname,
        _otpController.text,
        _newPasswordController.text,
        _reRewPasswordController.text);

    if (isValid) {
      // Thực hiện các công việc cần thiết khi thông tin hợp lệ
      GoRouter.of(context).go("/login");
    } else {
      print("khong thuc hien duoc");

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
