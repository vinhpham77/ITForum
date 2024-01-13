import 'package:cay_khe/repositories/user_repository.dart';
import 'package:cay_khe/ui/views/profile/blocs/personal_tab/personal_tab_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalTabProvider extends StatelessWidget {
  final Widget child;
  final String username;

  const PersonalTabProvider(
      {super.key, required this.child, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalTabBloc>(
      create: (context) {
        final bloc = PersonalTabBloc(userRepository: UserRepository())
          ..add(LoadUserEvent(username: username));

        return bloc;
      },
      child: child,
    );
  }
}
