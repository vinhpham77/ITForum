import 'package:cay_khe/blocs/forgotPassword_bloc.dart';
import 'package:cay_khe/dtos/user_dto.dart';
import 'package:cay_khe/ui/views/login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  ForgotPasswordBloc bloc = new ForgotPasswordBloc();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _usernameController=new TextEditingController();

  bool showOtpInput = false;

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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              "Gửi email của bạn. Chúng tôi sẽ gửi một liên kết đến email đó để bạn có thể đặt lại mật khẩu.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15)),
                        ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: StreamBuilder(
                              stream: bloc.usernameStream,
                              builder: (context, snapshot) => TextField(
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    labelText: "Tài khoản của bạn",
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    labelStyle: TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 15)),
                              ),
                            )),
                        // Padding(
                        //     padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                        //     child: StreamBuilder(
                        //       stream: bloc.emailStream,
                        //       builder: (context, snapshot) => TextField(
                        //         style: TextStyle(
                        //             fontSize: 18, color: Colors.black),
                        //         controller: _emailController,
                        //         decoration: InputDecoration(
                        //             labelText: "Email của bạn",
                        //             errorText: snapshot.hasError
                        //                 ? snapshot.error.toString()
                        //                 : null,
                        //             labelStyle: TextStyle(
                        //                 color: Color(0xff888888  ),
                        //                 fontSize: 15)),
                        //       ),
                        //     )),
                            
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
                                onPressed: () => onSignInClicked(context),
                                child: Text("Gửi email",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ])),
            ));
      }),
    );
  }

  void onSignInClicked(BuildContext context) async {
    try {
      User? isValid = await bloc.isValidInfo(_usernameController.text);

      if (isValid != null) {
        // Thực hiện các công việc cần thiết khi thông tin hợp lệ
        GoRouter.of(context).go("/");
      } else {
        print("Thông tin không hợp lệ hoặc có lỗi xảy ra");
      }
    } catch (error) {
      print("Lỗi xảy ra: $error");
    }
  }

  Widget gotoHome(BuildContext context) {
    return HomePage();
  }
}
