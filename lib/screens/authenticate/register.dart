import 'package:flutter/material.dart';
import 'package:order_project/screens/authenticate/authenticate.dart';
import 'package:order_project/screens/authenticate/sign_in.dart';
import 'package:order_project/services/auth.dart';
import 'package:order_project/shared/functions.dart';
import 'package:order_project/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String name = "";
  String email = "";
  String password = "";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[500],
        title: Text("Sign Up", style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            icon: Icon(Icons.person, color: Colors.white),
            label: Text("Sign In", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() => name = value);
                },
                obscureText: false,
                validator: (val) => val.isEmpty ? "Enter a name" : null,
                decoration: textInputDecoration("your name", "Name", Icon(Icons.person)),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() => email = value);
                },
                obscureText: false,
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                decoration: textInputDecoration("your email address", "Email", Icon(Icons.mail)),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() => password = value);
                },
                validator: (val) => val.isEmpty ? "Enter a password" : null,
                obscureText: true,
                decoration: textInputDecoration("Şifreniz", "Şifre", Icon(Icons.lock)),
              ),
              SizedBox(height: 10),
              RaisedButton(
                color: Colors.pink.shade400,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await auth.registerWithEmailAndPassword(name, email, password);
                    if (result == null) {
                      setState(() {
                        errorText = "please suply a valid email";
                        loading = false;
                      });
                    } else {}
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
