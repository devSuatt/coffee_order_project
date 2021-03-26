import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/screens/home/settings_form.dart';
import 'package:order_project/services/database.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {
  final Brew brew;
  OrderTile({this.brew});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        color: brew.ready == true ? Colors.red[100] : Colors.green[100],
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          onTap: () {
            showSettingsPanel(false, brew, context);
          },
          onLongPress: () {
            showDialogDelete(context, brew.brewId, user);
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown[brew.strength * 100],
          ),
          title: Text(brew.name),
          subtitle: Text("Takes ${brew.sugars} sugar(s)"),
        ),
      ),
    );
  }

  void showSettingsPanel(bool newControl, Brew brew, BuildContext context) {
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

  void showDialogDelete(BuildContext context, String id, Users user) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Delete Order",
            style: TextStyle(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              child: Text("Are you sure?"),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    DatabaseService(uid: user.uid).deleteUserData(id);
                    Navigator.pop(context);
                  },
                  child: Text("YES", style: TextStyle(color: Colors.white)),
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("NO", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
