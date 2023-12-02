
import 'package:flutter/material.dart';

import '../../common/app_constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required String username});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxContent,
        child: Row(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/user_profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
                Expanded(
                    child: Column(children: [
                  Text(
                    'Nguyễn Văn A',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text('@nguyenvana'),
                  const Text('data'),
                ])),
              ],
            ),
            Container(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
