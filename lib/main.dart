import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/core/common/error_text.dart';
import 'package:iasblog/core/common/loader.dart';
import 'package:iasblog/features/auth/controller/auth_controller.dart';
import 'package:iasblog/models/user_model.dart';
import 'package:iasblog/route.dart';
import 'package:iasblog/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    print('getData called');
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.email.toString())
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    print('userModel in build: $userModel');

    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            // if The data available means user is logged in
            debugShowCheckedModeBanner: false,
            title: 'ISBlog',
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  print('data != null ? : $data');
                  // if (userModel != null) {
                  if (ref.watch(userProvider) != null) {
                    print(
                        'userProvider.notifier: ${ref.read(userProvider.notifier)}');
                    return loggedInRouter;
                  // }
                  } else {
                    getData(ref, data);
                  }
                }
                return loggedOutRouter;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
