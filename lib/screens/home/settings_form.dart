import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/services/database.dart';
import 'package:order_project/shared/functions.dart';
import 'package:order_project/shared/loading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsForm extends StatefulWidget {
  bool newControl;
  Brew brew;

  SettingsForm({this.newControl, this.brew});
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4', '5'];
  final List<String> products = ['Espresso', 'Americano', 'Mocha', 'Latte', 'Cappucino', 'Frappuccino', 
  'Macchiato', 'Caramel Macchiato', 'Turkish Coffee', 'White Mocha', 'Affogato', 'Gibraldar'];
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Text(
            widget.newControl ? "Add new order" : 'Update your order',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 2, 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonFormField(
              hint: Text(products[0]),
              value: widget.newControl ? _currentName : (_currentName ?? widget.brew.name),
              validator: (value) => value == null ? "Please choose a product" : null,
              onChanged: (val) => setState(() => _currentName = val),
              items: products.map((product) {
                return DropdownMenuItem(
                  child: Text("$product"),
                  value: product,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.0),
          // dropdown
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 2, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.teal),
            ),
            child: DropdownButtonFormField(
              hint: Text(sugars[0]),
              value: widget.newControl ? _currentSugars : (_currentSugars ?? widget.brew.sugars),
              validator: (value) => value == null ? "Please choose sugar" : null,
              onChanged: (val) => setState(() => _currentSugars = val),
              items: sugars.map((sugar) {
                return DropdownMenuItem(
                  child: Text("$sugar sugars"),
                  value: sugar,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.0),
          // slider
          Slider(
            activeColor: Colors.brown[(_currentStrength ?? widget.brew.strength) * 100],
            inactiveColor: Colors.brown[(_currentStrength ?? widget.brew.strength) * 100],
            value: ((_currentStrength ?? widget.brew.strength).toDouble()),
            min: 1,
            max: 9,
            divisions: 8,
            onChanged: (val) => setState(() => _currentStrength = val.round()),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.teal,
            child: Text(
              widget.newControl ? "Save" : "Update",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await DatabaseService(uid: user.uid).setOrder(
                  widget.brew.brewId, 
                  _currentSugars ?? widget.brew.sugars,
                  _currentName ?? widget.brew.name, 
                  widget.brew.customerName=="" ? user.name : widget.brew.customerName,
                  _currentStrength ?? widget.brew.strength, 
                  widget.brew.role, 
                  widget.brew.ready, 
                  widget.brew.date,
                  widget.brew.userId,
                  );
                Navigator.pop(context);
              }
            },
          ),
          widget.newControl ? Container() :
          RaisedButton(
            color: Colors.red,
            child: Text("Delete", style: TextStyle(color: Colors.white),),
            onPressed: () {
              showDialogDelete(context, widget.brew.brewId, user);
            },
          ),
        ],
      ),
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
