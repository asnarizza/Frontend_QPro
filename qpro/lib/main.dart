import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qpro/pages/splashscreen.dart';
import 'package:qpro/repository/auth_repo.dart';
import 'bloc/authentication/login/login_bloc.dart';
import 'bloc/authentication/login/login_state.dart';
import 'bloc/authentication/register/register_bloc.dart';
import 'bloc/authentication/register/register_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize("2c9ce8b1-a075-4864-83a3-009c8497310e");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'QPro';
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(LoginInitState(), AuthRepository()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(RegisterInitState(), AuthRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.lightBlue[100],
            fontFamily: 'Times New Roman',
            textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
                bodyLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                )
            ),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              color: Colors.black,
            )
        ),
        home:Splash(),
      ),
    );
  }
}