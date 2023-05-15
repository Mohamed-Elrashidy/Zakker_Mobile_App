import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteDataSource{

  Future<List<Map<String, dynamic>>>getData(String path)
  async {

    CollectionReference collectionReference = FirebaseFirestore.instance.collection(path);

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot document) {
      //print("recieved data is =>"+document.data().toString());
      dataList.add(document.data() as Map<String,dynamic> );
    });

    return dataList;

  /*  List<Map<String, dynamic>> data=[];
    await FirebaseFirestore.instance
        .collection(path).get().then(
        (QuerySnapshot<Map<String, dynamic>> snapshot)
            {
              snapshot.docs.map((DocumentSnapshot documentSnapshot){
               data .add( documentSnapshot.data()! as Map<String, dynamic>);
              });
            }

    );
  return data;*/

  }




  Future<void> addData(String path,int id,dynamic data) {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(path);

    return collectionReference
        .doc(id.toString())
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  Future<void> updateData(String path,int id,dynamic updatedData) {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(path);

    return collectionReference
        .doc(id.toString())
        .update(updatedData)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteData(String path,int id) {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(path);

    return collectionReference
        .doc(id.toString())
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }




}