import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/screens/home/order_tile.dart';
import 'package:order_project/screens/home/settings_form.dart';
import 'package:order_project/services/auth.dart';
import 'package:order_project/services/database.dart';
import 'package:order_project/shared/loading.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final UserData userData;
  const UserPage({this.userData});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthServices auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showSettingsPanel(true, context, user);
        },
      ),
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("My Orders"),
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
          stream: DatabaseService(uid: widget.userData.uid).orders ?? [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Brew> orders = snapshot.data ?? [];
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderTile(brew: orders[index]);
                },
              );
            }
            return Loading();
          }),
    );
  }

  void showSettingsPanel(bool newControl, BuildContext context, Users user) {
    
    Brew brew = Brew(brewId: "", name: "", sugars: "", strength: 1, role: "user", ready: false, date: DateTime.now().toIso8601String(), customerName: "", userId: "");
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(newControl: newControl, brew: brew),
        );
      },
    );
  }
}
