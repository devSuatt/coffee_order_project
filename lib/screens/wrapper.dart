import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/screens/authenticate/authenticate.dart';
import 'package:order_project/screens/home/home.dart';
import 'package:order_project/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    // return either Home or Authenticate Widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<List<Brew>>.value(
        value: DatabaseService().brews,
        child: HomePage(),
      );
    }
  }
}
