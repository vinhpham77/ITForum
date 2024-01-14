import 'package:cay_khe/blocs/changePassword_bloc.dart';
import 'package:cay_khe/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late ChangePasswordBloc bloc;

  bool _showCurentPass = false;
  bool _showNewPass = false;
  final bool _showReNewPass=false;
  final TextEditingController _curentPassController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reRewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = ChangePasswordBloc(context);
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("Đổi mật khẩu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30)),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: bloc.curentPasStream,
                                  builder: (context, snapshot) => TextField(
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _curentPassController,
                                     obscureText: !_showCurentPass,
                                    decoration: InputDecoration(
                                        labelText: "Nhập mật khẩu hiện tại",
                                        errorText: snapshot.hasError
                                            ? snapshot.error.toString()
                                            : null,
                                        labelStyle: const TextStyle(
                                            color: Color(0xff888888),
                                            fontSize: 15)),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: onToggleShowCurentPass,
                                    child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(_showCurentPass ? "Hide" : "Show",
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold))))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: bloc.pasStream,
                                  builder: (context, snapshot) => TextField(
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    controller: _newPasswordController,
                                    obscureText: !_showNewPass,
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
                                        child: Text(_showNewPass ? "Hide" : "Show",
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold))))
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: bloc.repassStream,
                                  builder: (context, snapshot) => TextField(
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        controller: _reRewPasswordController,
                                        obscureText: !_showReNewPass,
                                        decoration: InputDecoration(
                                            labelText: "Nhập lại mật khẩu mới",
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
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
        LoginBloc.usernameGlobal,
        _curentPassController.text,
        _newPasswordController.text,
        _reRewPasswordController.text);
    if (isValid) {
      // Thực hiện các công việc cần thiết khi thông tin hợp lệ
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showNewPass = !_showNewPass;
    });
  }
  void onToggleShowCurentPass(){
      setState(() {
      _showCurentPass = !_showCurentPass;
    });
  }
}
