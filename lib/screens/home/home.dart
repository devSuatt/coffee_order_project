import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/screens/home/order_list.dart';
import 'package:order_project/screens/home/settings_form.dart';
import 'package:order_project/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:order_project/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthServices auth = AuthServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userData,
      child: OrderList(),
    );
  }

}
