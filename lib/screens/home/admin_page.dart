import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/screens/home/all_orders.dart';
import 'package:order_project/screens/home/order_tile.dart';
import 'package:order_project/services/auth.dart';
import 'package:order_project/services/database.dart';
import 'package:order_project/shared/loading.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AuthServices auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("All Orders"),
        backgroundColor: Colors.brown[500],
        elevation: 0,
        actions: [
          FlatButton.icon(
            onPressed: () async {
              await auth.signOut();
            },
            icon: Icon(Icons.person, color: Colors.white),
            label: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder<List<Brew>>(
          stream: DatabaseService().allBrews ?? [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Brew> brews = snapshot.data ?? [];
              return ListView.builder(
                itemCount: brews.length,
                itemBuilder: (context, index) {
                  if(brews[index].ready == false) {
                    return AllOrders(brew: brews[index]);
                  } else return Container(width: 0, height: 0);
                },
              );
            }
            return Loading();
          }),
    );
  }

}
