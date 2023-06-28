import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  // sebagai penanda untuk menampilkan fungsi login atau logout
  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
              onPressed: () {
                // sesuai dengan boolean, Action dari button akan berubah
                !loggedIn ? context.push('/sign-in') : signOut();
              },
              // sesuai dengan boolean, Text dari button akan berubah
              child: !loggedIn ? const Text('Login') : const Text('Logout')),
        ),
      ],
    );
  }
}