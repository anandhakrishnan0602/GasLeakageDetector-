import 'package:flutter/material.dart';
import 'package:gas_leakage/screen/home.dart';
import 'package:gas_leakage/services/auth.dart';
import 'package:gas_leakage/shared/decorations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
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
          prefixIcon: Icon(Icons.email),
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
          return ("Enter password");
        }
        if (val.length < 6) {
          return ("Minimum 6 characters");
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final cpasswordField = TextFormField(
      autofocus: false,
      controller: cpasswordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (val) {
        cpasswordController.text = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return ("Enter password");
        }
        if (val.length < 6) {
          return ("Minimum 6 characters");
        }
        if (passwordController.text != val) {
          return ("passwords doesn't match");
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final loginButton = ElevatedButton(
      onPressed: () async {
        final form = _formkey.currentState;
        if (form!.validate()) {
          dynamic result = await RegisterInWithEmail(
              emailController.text, passwordController.text);
          if (result == null) {
            setState(() {
              error = "please enter a valid email";
            });
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          }
        }
      },
      child: Text("Register"),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        padding: EdgeInsets.all(15),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: boxDecoration1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: boxDecoration2,
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
                          const SizedBox(height: 20.0,),
                          cpasswordField,
                          const SizedBox(height: 20.0),
                          loginButton,
                          const SizedBox(
                            height: 20,
                          ),
                          Text(error,
                          style: const TextStyle(color: Colors.red),),
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
