import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/screens/home/settings_form.dart';
import 'package:order_project/services/database.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class AllOrders extends StatelessWidget {
  final Brew brew;
  AllOrders({this.brew});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.brown[300], width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(brew.customerName, style: TextStyle(fontSize: 17),),
        subtitle: Text(
          formatDate(DateTime.parse(brew.date), [dd, '/', mm, '/', yyyy])+ " - " +
          DateTime.parse(brew.date).hour.toString()+" : " 
        + (DateTime.parse(brew.date).minute.toString().length == 1 
        ? "0"+DateTime.parse(brew.date).minute.toString() 
        : DateTime.parse(brew.date).minute.toString()),
        style: TextStyle(color: Colors.pink[800]),
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.brown[brew.strength * 100],
        ),
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(18, 10, 10, 2),
            alignment: Alignment.topLeft,
            child: Text("DETAILS", style: TextStyle(color: Colors.pink[800], fontSize: 16,)),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
            thickness: 1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18, 2, 10, 8),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: 'Order:  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[800])),
                  TextSpan(text: brew.name),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18, 5, 10, 8),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: 'Sugars:  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[800])),
                  TextSpan(text: brew.sugars),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(18, 5, 10, 10),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: 'Strength:  ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[800])),
                  TextSpan(text: brew.strength.toString()),
                ],
              ),
            ),
          ),
           Divider(
            indent: 16,
            endIndent: 16,
            thickness: 1,
          ),
          Container(
            width: 300,
            child: FlatButton(onPressed: () {
              showDialogIsOrderReady(context, brew);
            },
            child: Text("READY", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
            color: Colors.teal,
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  void showDialogIsOrderReady(BuildContext context, Brew brew) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Is this order ready?",
            style: TextStyle(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          children: [
            Divider(
              indent: 16,
              endIndent: 16,
              thickness: 1,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(12),
              child: Text("Please check this order", style: TextStyle(fontSize: 15, color: Colors.pink[800])),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(3),
              child: Text("Order: "+brew.name),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(3),
              child: Text("Sugar: "+brew.sugars),
              ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(3),
              child: Text("Strength: "+brew.strength.toString()),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 16,
                endIndent: 16,
                thickness: 1,
              ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      DatabaseService(uid: brew.userId).changeOrdersReadyState(brew);
                      Navigator.pop(context);
                    },
                    child: Text("YES", style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: 90,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text("NO", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
