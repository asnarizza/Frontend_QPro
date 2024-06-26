import 'package:qpro/pages/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qpro/pages/routepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qpro/bloc/authentication/login/login_state.dart';
import 'package:qpro/bloc/authentication/login/login_bloc.dart';
import 'package:qpro/bloc/authentication/login/login_event.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthBloc authBloc;

  Future<String> checkToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    // Delay the execution of the FutureBuilder for 2000 milliseconds.
    Future.delayed(Duration(milliseconds: 1000),(){
      redirect();
    });
  }

  Future<void> redirect() async {
    String hasToken = await checkToken();
    if (hasToken != "") {
      authBloc.add(GetRefreshToken());
    } else {
      authBloc.add(GetLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is RefreshTokenSuccess){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => RoutePage()),
                    (Route<dynamic> route) => false
            );
          } else if (state is RefreshTokenFail || state is LoginInitState){
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/logo.json', // Replace with your file name
                width: 500,
                height: 500,
              ),
              SizedBox(height: 10.0),
              Text(
                'First in line, first in time',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 5.0),
              CircularProgressIndicator(color: Colors.lightBlue[100]),
            ],
          ),
        ),
      ),
    );
  }
}