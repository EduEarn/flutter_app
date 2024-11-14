import 'package:edu_earn/shared/theme/theme.dart';
import 'package:edu_earn/src/applications/presentation/bloc/job_application_bloc.dart';
import 'package:edu_earn/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edu_earn/src/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:edu_earn/src/home/presentation/screens/main_page.dart';
import 'package:edu_earn/src/notification/service/notification.dart';
import 'package:edu_earn/src/onboarding/presentation/screens/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wiredash/wiredash.dart';
import 'injection_container.dart' as di;

import 'firebase_options.dart';
import 'injection_container.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'shared/theme/theme_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  di.init();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<BookmarkBloc>()),
        BlocProvider(create: (_) => sl<JobApplicationBloc>()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
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
          child: Wiredash(
            projectId: 'edu-earn-2e5ubh3',
            secret: 'amfscqPIifg0QxSMOIVFSO6q1W2pri6D',
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Edu Earn',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.themeMode,
              home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return const MainPage();
                    } else {
                      return const OnBoardingPage();
                    }
                  }),
            ),
          ),
        );
      },
    );
  }
}
