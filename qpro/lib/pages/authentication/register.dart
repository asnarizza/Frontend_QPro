import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qpro/bloc/authentication/register/register_bloc.dart';
import 'package:qpro/bloc/authentication/register/register_event.dart';
import 'package:qpro/bloc/authentication/register/register_state.dart';
import '../../bloc/authentication/login/login_event.dart';
import '../homepage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {

  late RegisterBloc registerBloc;

  // controller for input
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final msg = BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state is RegisterFailState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.message,
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else if (state is RegisterLoadingState) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator(color: Colors.grey)),
          );
        } else {
          return Container();
        }
      },
    );

    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          }
        },
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
                  _emailField(),
                  const SizedBox(height: 10.0),
                  _passwordField(),
                  msg,
                  const SizedBox(height: 30.0),
                  _registerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('QPro', style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.black),
        hintText: 'Username',
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Colors.black),
        hintText: 'Email',
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        hintText: 'Password',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () {
            if (usernameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
              registerBloc.add(
                RegisterButtonPressed(
                  name: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            } else {
              registerBloc.add(EmptyField() as RegisterEvent);
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('REGISTER', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

