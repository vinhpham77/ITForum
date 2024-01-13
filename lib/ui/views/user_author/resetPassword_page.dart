import 'package:flutter/material.dart';
import 'package:cay_khe/blocs/forgotPassword_bloc.dart';
import 'package:cay_khe/blocs/resetPassword_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late ResetPasswordBloc bloc;

  bool _showPass = false;

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reRewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = ResetPasswordBloc(context);
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
                          child: Text("Đặt lại mật khẩu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30)),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: StreamBuilder(
                              stream: bloc.otpStream,
                              builder: (context, snapshot) => TextField(
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _otpController,
                                decoration: InputDecoration(
                                    labelText: "Nhập mã OTP",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: const TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: bloc.pasStream,
                                  builder: (context, snapshot) => TextField(
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _newPasswordController,
                                    decoration: InputDecoration(
                                        labelText: "Nhập mật khẩu mới",
                                        errorText: snapshot.hasError
                                            ? snapshot.error.toString()
                                            : null,
                                        labelStyle: const TextStyle(
                                            color: Color(0xff888888),
                                            fontSize: 15)),
                                  ),
                                ),
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
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.repassStream,
                                  builder: (context, snapshot) => TextField(
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _reRewPasswordController,
                                        obscureText: !_showPass,
                                        decoration: InputDecoration(
                                            labelText: "Xác nhận lại mật khẩu",
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
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
                                onPressed: () => onChangePassClicked(context),
                                child: const Text("Đổi mật khẩu",
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
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
}
