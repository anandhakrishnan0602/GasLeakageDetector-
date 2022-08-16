import 'package:flutter/material.dart';
import 'package:gas_leakage/screen/home.dart';
import 'package:gas_leakage/screen/register.dart';
import 'package:gas_leakage/services/auth.dart';
import 'package:gas_leakage/shared/decorations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (val) {
        emailController.text = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return ("please enter email");
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (val) {
        passwordController.text = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return ("Please enter a password");
        }
        if (val.length < 6) {
          return ("Password should have minimum 6 characters");
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final loginButton = ElevatedButton(
      onPressed: () async {
        final form = _formkey.currentState;
        if (form!.validate()) {
          dynamic result =
              await signIn(emailController.text, passwordController.text);
          if (result == null) {
            setState(() {
              error = "please enter a valid email and Password";
            });
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          }
        }
      },
      child: const Text("Sign in"),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        padding: const EdgeInsets.all(15),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 117, 250),
                Color.fromARGB(255, 145, 201, 251)
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Signin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                  ),
                  child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 40.0,
                          ),
                          emailField,
                          const SizedBox(
                            height: 20.0,
                          ),
                          passwordField,
                          const SizedBox(height: 20.0),
                          loginButton,
                          const SizedBox(
                            height: 20,
                          ),
                          Text(error,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage()));
                                  },
                                  child: const Text("Resgister")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
