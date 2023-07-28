import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addGoogleUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
    // FirebaseFirestore.instance.collection("users").add(data);
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(userId);
    Map<String, dynamic>? userinfo;
    await docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      // print("printing data");
      // print(data);
      userinfo = data;
    }, onError: (e) => print("Error getting document: $e"));
    return userinfo;
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future createChatRoom(
      String chatRoomID, Map<String, dynamic> roomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomID)
          .set(roomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("message_timestamp", descending: true)
        .snapshots();
  }

  Future deleteChatRoom(String chatRoomID) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .get();

    if (snapShot.exists) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomID)
          .collection("messages")
          .get();

      for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Delete each document in the collection
        await docSnapshot.reference.delete();
      }

      return await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomID)
          .delete();
    } else {
      return false;
    }
  }

  Future<void> addMessageToChatRoom(String chatRoomID, String messageID,
      Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID)
        .set(messageInfoMap);
  }
}
