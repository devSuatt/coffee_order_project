import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/screens/home/admin_page.dart';
import 'package:order_project/screens/home/user_page.dart';
import 'package:order_project/services/auth.dart';
import 'package:order_project/shared/loading.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final AuthServices auth = AuthServices();
  String sugars = "";
  String name = "";
  int strength = 0;
  DocumentSnapshot snapshot;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData temp = new UserData(uid: "", name: "", sugars: "", strength: 1, role: "");
    //final brews = Provider.of<List<Brew>>(context) ?? [];
    UserData userData = Provider.of<UserData>(context) ?? temp;
    if(userData.role == 'admin') {
      return AdminPage();
    }
    else if(userData.role == 'user') {
      return UserPage(userData: userData);
    } 
    else {
      return Loading();
    }
  }

}
