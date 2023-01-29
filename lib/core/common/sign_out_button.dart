import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/auth/controller/auth_controller.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({Key? key}) : super(key: key);

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  // WidgetRef will allow our widgets to interact with other Providers
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.lightBlue, backgroundColor: Colors.deepPurple,
      ),
      icon: const FaIcon(FontAwesomeIcons.google),
      label: const Text(
        'Sign Out',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () => logOut(ref),
    );
  }
}
