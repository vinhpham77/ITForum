import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../blocs/personal_tab/personal_tab_bloc.dart';
import '../../blocs/personal_tab/personal_tab_provider.dart';

const Map<String, String> options = {
  "Thông tin cơ bản": "/basic-info",
  "Giới thiệu": "/bio"
};

class PersonalTab extends StatelessWidget {
  final String username;
  final bool isBasicInfoOption;

  const PersonalTab({
    super.key,
    required this.username,
    required this.isBasicInfoOption,
  });

  bool get isAuthorised => JwtPayload.sub != null && JwtPayload.sub == username;

  @override
  Widget build(BuildContext context) {
    return PersonalTabProvider(
        username: username,
        child: BlocListener<PersonalTabBloc, PersonalTabState>(
          listener: (context, state) {
            if (state is PersonalTabErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
            }
          },
          child: BlocBuilder<PersonalTabBloc, PersonalTabState>(
            builder: (context, state) {
              if (state is PersonalTabSubState) {
                return _buildUserView(context, state);
              } else if (state is UserLoadErrorState) {
                return _buildSimpleContainer(
                    child: Center(child: Text(state.message)));
              }

              return _buildSimpleContainer(
                  child: const Center(child: CircularProgressIndicator()));
            },
          ),
        ));
  }

  Container _buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: child);

  Widget _buildUserInfoView(BuildContext context, PersonalTabSubState state) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(0, 20, 8, 8),
      child: Row(
        children: [
          _buildUserView(context, state)
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Container();
  }

  Widget _buildUserView(BuildContext context, PersonalTabSubState state) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(0, 20, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserPersonalInfo(
                    Icons.mail, state.user.email, "Chưa cập nhật email"),
                _buildUserPersonalInfo(
                    getGenderIcon(state.user.gender),
                    getGenderText(state.user.gender),
                    "Chưa cập nhật giới tính"),
                _buildUserPersonalInfo(
                    Icons.cake,
                    getBirthdateText(state.user.birthdate),
                    "Chưa cập nhật ngày sinh"),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildUserPersonalInfo(IconData icon, String? text, String altText) {
    return Row(
      children: [
        Icon(icon, size: 36, color: Colors.black54),
        const SizedBox(width: 16),
        Text(text ?? altText, style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  IconData getGenderIcon(bool? gender) {
    if (gender == null) {
      return Icons.transgender;
    }

    return gender ? Icons.male : Icons.female;
  }

  String? getGenderText(bool? gender) {
    if (gender == null) {
      return null;
    }

    return gender ? "Nam" : "Nữ";
  }

  String? getBirthdateText(DateTime? birthdate) {
    if (birthdate == null) {
      return null;
    }

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(birthdate);
  }
}
