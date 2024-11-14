import 'package:edu_earn_admin/firebase_options.dart';
import 'package:edu_earn_admin/shared/theme/theme.dart';
import 'package:edu_earn_admin/src/Home/bloc/menu_bloc.dart';
import 'package:edu_earn_admin/src/Home/presentation/home.dart';

import 'package:edu_earn_admin/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:edu_earn_admin/src/auth/presentation/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  di.init();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<AuthBloc>()),
      BlocProvider(create: (_) => MenuBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) => Center(
        child: SpinKitFadingCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 50.0,
        ),
      ),
      overlayColor: Colors.black12,
      overlayWholeScreen: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            }),
      ),
    );
  }
}
