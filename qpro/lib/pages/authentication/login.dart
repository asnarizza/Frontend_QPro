import 'package:qpro/pages/authentication/forgot_pass.dart';
import 'package:qpro/pages/authentication/register.dart';
import 'package:qpro/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qpro/bloc/authentication/login/login_bloc.dart';
import 'package:qpro/bloc/authentication/login/login_event.dart';
import 'package:qpro/bloc/authentication/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/admin_homepage.dart';
import '../staff/staff_homepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controller for input
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  // declare attribute
  late AuthBloc authBloc;

  @override
  void initState() {
    // initialize
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final msg = BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginErrorState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.message,
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else if (state is LoginLoadingState) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                )),
          );
        } else {
          return Container();
        }
      },
    );

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is UserLoginSuccessState) {
            int? roleId = await getRoleIdFromPreferences();
            int? userId = await getUserIdFromPreferences();
            print('Retrieved role ID: $roleId');
            print('Retrieved user ID: $userId');

            if (roleId == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHomePage()),
                      (Route<dynamic> route) => false
              );
            } else if (roleId == 2) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StaffHomePage(userId: userId!)),
                      (Route<dynamic> route) => false
              );
            } else if (roleId == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false
              );
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100, Colors.teal.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _logoText(),
                    const SizedBox(height: 30.0),
                    _usernameField(),
                    const SizedBox(height: 10.0),
                    _passwordField(),
                    _forgotPassword(),
                    msg,
                    const SizedBox(height: 30.0),
                    _loginButton(),
                    _signUpText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpText() {
    return Container(
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ));
        },
        child: Text(
          'Don\'t have an account? Sign up here',
          style: TextStyle(color: Colors.teal.shade900, fontSize: 12),
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen()));
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.teal.shade900, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _logoText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'QPro',
        style: TextStyle(
          color: Colors.teal.shade900,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.teal.shade900),
        prefixIcon: Icon(Icons.email, color: Colors.teal.shade900),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade900, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade900, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      controller: pwdController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.teal.shade900),
        prefixIcon: Icon(Icons.lock, color: Colors.teal.shade900),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade900, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade900, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: SizedBox(
        width: double.infinity,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () {
            if (usernameController.text.isNotEmpty &&
                pwdController.text.isNotEmpty) {
              authBloc.add(LoginButtonPressed(
                email: usernameController.text,
                password: pwdController.text,
              ));
            } else {
              authBloc.add(EmptyField());
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.teal.shade700,
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'LOG IN',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Change this to your desired color
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int?> getRoleIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('role_id'); // Retrieve the role ID
  }

  Future<int?> getUserIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // Retrieve the user ID
  }

}
