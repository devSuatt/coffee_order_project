import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  var uuid = Uuid();
  bool temp = false;

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");
  FirebaseFirestore db = FirebaseFirestore.instance;
  
  Future setUserData(Users user) async {
    return await brewCollection.doc(uid).set(user.toMap());
  }

  Future setOrder(String brewId, String sugars, String name, String customerName, int strength, String role, bool ready, String date, String userId) async {
    String userName;
    await brewCollection.doc(uid).get().then((doc) => userName = doc.data()['name']);
    if(brewId == "") {
      Brew newOrder = Brew(brewId: uuid.v1(), name: name, customerName: userName, 
      sugars: sugars, strength: strength, role: role, ready: false, date: DateTime.now().toIso8601String(), userId: uid);
      return await brewCollection.doc(uid).collection('orders').doc(newOrder.brewId).set(newOrder.toMap());
    } else {
      Brew updatedOrder = Brew(brewId: brewId, name: name, customerName: customerName,
      sugars: sugars, strength: strength, role: role, ready: ready, date: date, userId: userId);
      return await brewCollection.doc(uid).collection('orders').doc(updatedOrder.brewId).set(updatedOrder.toMap());
    }
  }

  Future<void> deleteUserData(String brewId) async{
    print("ID => "+ brewId);
    return await brewCollection.doc(uid).collection('orders').doc(brewId).delete();
  }

  Future<void> changeOrdersReadyState(Brew order) async{
    Brew updatedOrder = Brew(brewId: order.brewId, name: order.name, customerName: order.customerName, 
    sugars: order.sugars, strength: order.strength, role: order.role, ready: true, date: order.date, userId: uid);
    return await brewCollection.doc(uid).collection('orders').doc(updatedOrder.brewId).set(updatedOrder.toMap());
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          brewId: doc.data()['brewId'] ?? '',
          sugars: doc.data()['sugars'] ?? '0',
          name: doc.data()['name'] ?? '',
          customerName: doc.data()['customerName'] ?? '',
          strength: doc.data()['strength'] ?? 0,
          role: doc.data()['role'] ?? '',
          ready: doc.data()['ready'] ?? false,
          date: doc.data()['date'] ?? DateTime.now(),
          userId: doc.data()['userId'] ?? "",
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      brewId: snapshot.data()['brewId'],
      name: snapshot.data()['name'],
      customerName: snapshot.data()['customerName'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength'],
      role: snapshot.data()['role'],
      ready: snapshot.data()['ready'],
      date: snapshot.data()['date'],
    );
  }

  Stream<UserData> get userData {
    return brewCollection
    .doc(uid)
    .snapshots()
    .map(_userDataFromSnapshot);
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  Stream<List<Brew>> get allBrews {
    return FirebaseFirestore.instance.collectionGroup('orders').snapshots()
    .map(_brewListFromSnapshot);
  }

  Stream<List<Brew>> get orders {
    
    return FirebaseFirestore.instance.collection('brews').doc(uid).collection('orders').orderBy('date', descending: true).snapshots()
    .map(_brewListFromSnapshot);
  }

}
