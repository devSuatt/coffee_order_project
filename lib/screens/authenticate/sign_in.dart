import 'package:flutter/material.dart';
import 'package:order_project/screens/authenticate/authenticate.dart';
import 'package:order_project/screens/authenticate/register.dart';
import 'package:order_project/services/auth.dart';
import 'package:order_project/shared/functions.dart';
import 'package:order_project/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String password = "";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[500],
        title: Text("Sign In", style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            icon: Icon(Icons.person, color: Colors.white),
            label: Text("Register", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() => email = value);
                },
                obscureText: false,
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                decoration: textInputDecoration("Email adresiniz", "Email", Icon(Icons.mail)),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() => password = value);
                },
                obscureText: true,
                validator: (val) => val.isEmpty ? "Enter a password" : null,
                decoration: textInputDecoration("Şifreniz", "Şifre", Icon(Icons.lock)),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.pink.shade400,
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        errorText = "sign in error with those credentials";
                        loading = false;
                      });
                    } else {}
                    print("valid");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
