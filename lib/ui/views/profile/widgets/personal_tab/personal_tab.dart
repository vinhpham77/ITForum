import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/user_dto.dart';
import '../../../../../models/user.dart';
import '../../../../widgets/add_image.dart';
import '../../../../widgets/user_avatar.dart';
import '../../blocs/personal_tab/personal_tab_bloc.dart';
import '../../blocs/personal_tab/personal_tab_provider.dart';

final displayNameController = TextEditingController();
final bioController = TextEditingController();
final emailController = TextEditingController();
final dateController = TextEditingController();
final displayNameFocusNode = FocusNode();
final birthdayFocusNode = FocusNode();
final emailFocusNode = FocusNode();

final _formKey = GlobalKey<FormState>();

class PersonalTab extends StatelessWidget {
  final String username;

  const PersonalTab({super.key, required this.username});

  bool get isAuthorised => JwtPayload.sub != null && JwtPayload.sub == username;

  @override
  Widget build(BuildContext context) {
    return PersonalTabProvider(
        username: username,
        child: BlocListener<PersonalTabBloc, PersonalTabState>(
          listener: (context, state) {
            if (state is PersonalTabErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
            } else if (state is UserUpdatedState) {
              showTopRightSnackBar(context, "Cập nhật thông tin thành công", NotifyType.success);
            }
          },
          child: BlocBuilder<PersonalTabBloc, PersonalTabState>(
            builder: (context, state) {
              if (state is PersonalTabSubState) {
                displayNameController.text = state.user.displayName;
                bioController.text = state.user.bio ?? '';
                emailController.text = state.user.email;
                dateController.text = getBirthdateText(state.user.birthdate) ?? '';
                displayNameFocusNode.addListener(() {
                  if (!displayNameFocusNode.hasFocus) {
                    _formKey.currentState!.validate();
                  }
                });
                emailFocusNode.addListener(() {
                  if (!emailFocusNode.hasFocus) {
                    _formKey.currentState!.validate();
                  }
                });
                birthdayFocusNode.addListener(() {
                  if (!birthdayFocusNode.hasFocus) {
                    _formKey.currentState!.validate();
                  }
                });

                return _buildPersonalTabContent(context, state);
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

  Widget _buildPersonalTabContent(
      BuildContext context, PersonalTabSubState state) {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 8,
        right: 8,
      ),
      child: isAuthorised
          ? _buildViewAsAuthorContainer(context, state)
          : _buildViewAsMemberContainer(context, state),
    );
  }

  Widget _buildViewAsAuthorContainer(context, state) {
    bool isUpdating = state is UserUpdatingState;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: _buildAvatarContainer(context, state)),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 14),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1,
                          ),
                        ),
                      ),
                      child: _buildProfileInfoContainer(context, state))),
            ],
          ),
          const SizedBox(height: 16),
          _buildBioArea(context, state),
          const SizedBox(height: 16),
      FilledButton(
        onPressed: isUpdating
            ? null
            : () {
          updateProfile(context, state);
        },
        child: Stack(
            alignment: Alignment.center,
            children: [
              const Text('Cập nhật', style: TextStyle(fontSize: 16)),
              if (isUpdating)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                )
            ],
          ),
      )
        ],
      ),
    );
  }

  Widget _buildBioArea(BuildContext context, PersonalTabSubState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '⦿ Giới thiệu',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                buildSwitchModeButton(
                    context, 'Chỉnh sửa', true, state.isEditingMode, state),
                buildSwitchModeButton(
                    context, 'Xem trước', false, state.isEditingMode, state)
              ],
            ),
          ],
        ),
        Divider(color: Colors.grey.shade500),
        const SizedBox(height: 16),
        state.isEditingMode ? _buildBioEditor() : _buildBioContainer(context, state),
      ],
    );
  }

  Widget _buildBioEditor() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            color: Colors.white,
          ),
          height: 480,
          child: TextFormField(
            controller: bioController,
            maxLines: null,
            decoration: const InputDecoration.collapsed(
                hintText: 'Viết nội dung giới thiệu ở đây...'),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: AddImage(imageCallback: insertText),
        ),
      ],
    );
  }

  TextButton buildSwitchModeButton(BuildContext context, String text,
      bool origin, bool active, PersonalTabSubState state) {
    return TextButton(
      onPressed: () {
        if (origin == active) {
          return;
        }

        context.read<PersonalTabBloc>().add(SwitchModeEvent(
            user: getNewUser(state),
            isEditingMode: origin));
      },
      child: Text(text, style: _getTextStyle(origin == active)),
    );
  }

  User getNewUser(PersonalTabSubState state) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = dateController.text;
    DateTime? date;
    try {
      date = inputFormat.parseStrict(inputDate);
    } catch (e) {
      date = null;
    }

    return state.user.copyWith(
        bio: bioController.text,
        displayName: displayNameController.text,
        email: emailController.text,
        birthdate: date);
  }

  TextStyle _getTextStyle(bool active) {
    if (active) {
      return const TextStyle(
          color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500);
    }

    return const TextStyle(
        color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w400);
  }

  Widget _buildAvatarContainer(
      BuildContext context, PersonalTabSubState state) {
    bool isChangingAvatar = state is AvatarChangingState;

    return Column(
      children: [
        ClipOval(
            child: UserAvatar(size: 160, imageUrl: state.user.avatarUrl),
        ),
        SizedBox(height: (state.user.avatarUrl != null ? 24 : 8)),
        Row(
          children: [
            FilledButton(
              onPressed: isChangingAvatar ? null : () {
                 context.read<PersonalTabBloc>().add(ChangeAvatarEvent(
                      user: getNewUser(state),
                      isEditingMode: state.isEditingMode));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text('Thay đổi',
                      style: TextStyle(color: Colors.white)),
                  if (isChangingAvatar)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                ],
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: isChangingAvatar ? null : () {
                context.read<PersonalTabBloc>().add(DeleteAvatarEvent(
                    user: getNewUser(state),
                    isEditingMode: state.isEditingMode));
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepOrange[100]),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text('Xoá', style: TextStyle(color: Colors.red)),
                  if (isChangingAvatar)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProfileInfoContainer(
      BuildContext context, PersonalTabSubState state) {
    return Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⦿ Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                )),
            const SizedBox(height: 16),
            _buildFormField(
                'Tên người dùng',
                TextFormField(
                  initialValue: state.user.username,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    fillColor: Colors.black12,
                    filled: true
                  ),

                  style: const TextStyle(fontSize: 16),
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFormField(
                      'Tên hiển thị',
                      isRequired: true,
                      TextFormField(
                        controller: displayNameController,
                        focusNode: displayNameFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên hiển thị';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            hintText: 'Nhập tên hiển thị của bạn'),
                        style: const TextStyle(fontSize: 16),
                      )),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildFormField(
                    'Email',
                    isRequired: true,
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }

                        String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Vui lòng nhập email hợp lệ';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          hintText: 'Nhập email của bạn'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Ngày sinh',
                    TextFormField(
                      controller: dateController,
                      focusNode: birthdayFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }

                        String pattern = r'^\d{2}\/\d{2}\/\d{4}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Vui lòng nhập ngày sinh hợp lệ';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          hintText: 'Nhập ngày sinh (dd/MM/yyyy)'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildFormField(
                    'Giới tính',
                    Wrap(alignment: WrapAlignment.center, spacing: 6.0, children: [
                      InputChip(
                          label: const Text('Nam'),
                          selected: state.user.gender != null && state.user.gender!,
                          onSelected: (bool selected) {
                            bool? gender;

                            if (state.user.gender == null || state.user.gender == false) {
                              gender = true;
                            }
                            else {
                              gender = null;
                            }

                            context.read<PersonalTabBloc>().add(ChangeGenderEvent(
                                user: getNewUser(state),
                                gender: gender,
                                isEditingMode: state.isEditingMode));
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.4)
                      ),
                      InputChip(
                          label: const Text('Nữ'),
                          selected: state.user.gender != null && state.user.gender == false,
                          onSelected: (bool selected) {
                            bool? gender;

                            if (state.user.gender == null || state.user.gender == true) {
                              gender = false;
                            }
                            else {
                              gender = null;
                            }

                            context.read<PersonalTabBloc>().add(ChangeGenderEvent(
                                user: getNewUser(state),
                                gender: gender,
                                isEditingMode: state.isEditingMode));
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.4)
                      ),
                    ]),
                  ),
                ),

              ],
            )
          ],
        ));
  }

  Widget _buildFormField(String label, Widget formField,
      {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isRequired)
              const Text(
                '* ',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
            Text(label,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                )),
          ],
        ),
        const SizedBox(height: 8),
        formField,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildViewAsMemberContainer(
      BuildContext context, PersonalTabSubState state) {
    return Column(
      children: [
        _buildInfoContainer(
            'Thông tin cá nhân', _buildBasicInfoContainer(context, state)),
        const SizedBox(height: 16),
        _buildInfoContainer('Giới thiệu', _buildBioContainer(context, state)),
      ],
    );
  }

  Widget _buildInfoContainer(String label, Widget infoContainer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 24),
          width: 176,
          child: Text(
            '⦿ $label',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            softWrap: true,
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
            child: Container(
                padding: const EdgeInsets.only(left: 14),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade500,
                      width: 1,
                    ),
                  ),
                ),
                child: infoContainer)),
      ],
    );
  }

  Widget _buildBasicInfoContainer(
      BuildContext context, PersonalTabSubState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInfo(Icons.mail, state.user.email, "Chưa cập nhật email"),
          const SizedBox(height: 16),
          _buildBasicInfo(getGenderIcon(state.user.gender),
              getGenderText(state.user.gender), "Chưa cập nhật giới tính"),
          const SizedBox(height: 16),
          _buildBasicInfo(Icons.cake, getBirthdateText(state.user.birthdate),
              "Chưa cập nhật ngày sinh"),
        ],
      ),
    );
  }

  Widget _buildBioContainer(BuildContext context, PersonalTabSubState state) {
    return Container(
      transform: Matrix4.translationValues(0, -16, 0),
      child: Markdown(
        data: state.user.bio ?? "> Chưa cập nhật giới thiệu",
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          h1: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 32),
          h2: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 22),
          h3: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
          h6: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13),
          p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
          listBullet:
              const TextStyle(fontSize: 16), // Custom list item bullet style
        ),
        softLineBreak: true,
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildBasicInfo(IconData icon, String? text, String altText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Text(text ?? altText,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ),
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

  void insertText(String input) {
    final text = bioController.text;
    final textSelection = bioController.selection;
    final String newText;
    final int cursorPosition = textSelection.isValid ? textSelection.end : text.length;

    newText = text.replaceRange(cursorPosition, cursorPosition, input);

    final textSelectionNew = TextSelection.collapsed(offset: cursorPosition + input.length);

    bioController.text = newText;
    bioController.selection = textSelectionNew;
  }

  updateProfile(BuildContext context, PersonalTabSubState state) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = dateController.text;
    DateTime? date;
    try {
      date = inputFormat.parseStrict(inputDate);
    } catch (e) {
      date = null;
    }

    UserDTO newUser = UserDTO(
      email: emailController.text,
      gender: state.user.gender,
      birthdate: date,
      avatarUrl: state.user.avatarUrl,
      bio: bioController.text,
      displayName: displayNameController.text
    );

    context.read<PersonalTabBloc>().add(UpdateProfileEvent(
        newUser: newUser,
        user: getNewUser(state),
        isEditingMode: state.isEditingMode));
  }
}
