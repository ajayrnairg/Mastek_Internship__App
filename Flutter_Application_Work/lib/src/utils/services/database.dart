import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods {
  Future addGoogleUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    FirebaseFirestore.instance
        .collection("GoogleUsers")
        .doc(userId)
        .set(userInfoMap);
    // FirebaseFirestore.instance.collection("GoogleUsers").add(data);
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final docRef =
    FirebaseFirestore.instance.collection("GoogleUsers").doc(userId);
    Map<String,dynamic>? userinfo;
    await docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      // print("printing data");
      // print(data);
      userinfo = data;

    },
        onError: (e)=> print("Error getting document: $e"));
    return userinfo;
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("GoogleUsers")
        .where("username", isEqualTo: username)
        .snapshots();
  }



}
