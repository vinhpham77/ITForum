import 'package:cay_khe/blocs/forgotPassword_bloc.dart';
import 'package:cay_khe/ui/router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();

  bool showOtpInput = false;
  late ForgotPasswordBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = ForgotPasswordBloc(context);
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text("Quên mật khẩu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30)),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text(
                              "Chúng tôi sẽ gửi một mã OTP đến email mà bạn đã đăng ký tài khoản bên dưới để bạn có thể đặt lại mật khẩu.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15)),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: StreamBuilder(
                              stream: bloc.usernameStream,
                              builder: (context, snapshot) => TextField(
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    labelText: "Tài khoản của bạn",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: const TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
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
                                onPressed: () => onSubmitClicked(context),
                                child: const Text("Gửi email",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ])),
            ));
      }),
    );
  }

  void onSubmitClicked(BuildContext context) async {
    bool isValid = await bloc.isValidInfo(_usernameController.text);

    if (isValid) {
      appRouter.go("/resetPass");
    }
  }

  
}
