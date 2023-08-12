import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rough_app/src/constants/text_strings.dart';

class DatabaseMethods {
  //************************Login and SignUP methods*************************
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

  //************************Notification methods*************************
  addTokenDataToUserInfo(String token, String userID) async {
    final data = {"token": token};
    FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .set(data, SetOptions(merge: true));
  }

  Future removeTokenDataFromUserInfo(String userID)async{
    try{
      DocumentReference docRef = FirebaseFirestore.instance.collection("users").doc(userID);
      DocumentSnapshot ds = await docRef.get();
      if(ds.exists){
        docRef.set({"token": ""},SetOptions(merge: true));
      }else{
        return false;
      }
    }
        catch (e){
          print("Error removing token data from user Info: $e");
          return false;
        }
  }

  //************************chatRoom methods*************************
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

  //************************GroupChatRoom methods*************************

  Future<String> createNewGroupAndGetId(
      Map<String, dynamic> groupInfoDetails) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("groups")
          .add(groupInfoDetails);
      String documentId = docRef.id;
      groupInfoDetails["groupID"] = documentId;
      await docRef.set(groupInfoDetails);
      return documentId;
    } catch (e) {
      print("Error creating new group: $e");
      return '';
    }
  }



  Future<bool> addGroupDataToUserInfo(
      String userID, Map<String, String> groupInfoMap) async {
    final DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userID).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final Map<String, dynamic> newMap;
      if (data.containsKey("groups")) {
        List<dynamic> newList = data["groups"];
        newList.add(groupInfoMap);
        newMap = {"groups": newList};
      } else {
        newMap = {
          "groups": [groupInfoMap]
        };
      }
      FirebaseFirestore.instance
          .collection("users")
          .doc(userID)
          .set(newMap, SetOptions(merge: true));
      return true;
    } else {
      return false;
    }
  }

  Future<Stream<QuerySnapshot>> getMyGroups(String userID) async {
    return FirebaseFirestore.instance
        .collection("groups")
        .orderBy("lastMessageTimeStamp", descending: true)
        .where("members", arrayContains: gAccountUserName)
        .snapshots();
  }

  Future<DocumentSnapshot?> getSingleUserByUserName(String userName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: userName)
          .limit(1) // Limit the query to return only one document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null; // If no document is found, return null
      }
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print("Error getting user details: $e");
      return null;
    }
  }

  Future<void> addMessageToGroupChatRoom(String groupChatRoomID,
      String messageID, Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupChatRoomID)
        .collection("messages")
        .doc(messageID)
        .set(messageInfoMap);
  }

  Future getGroupMembers(String groupChatRoomID)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("groups").doc(groupChatRoomID);
    DocumentSnapshot ds = await documentReference.get();

    return ds["members"];
  }

  Future getGroupActiveMembers(String groupChatRoomID)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("groups").doc(groupChatRoomID);
    DocumentSnapshot ds = await documentReference.get();
    return ds["activeMembers"];
  }

  Future<Stream<QuerySnapshot>> getGroupChatRoomMessages(
      String groupChatRoomID) async {
    return FirebaseFirestore.instance
        .collection("groups")
        .doc(groupChatRoomID)
        .collection("messages")
        .orderBy("message_timestamp", descending: true)
        .snapshots();
  }



  Future<void> updateLastMessageInfoInGroup(
      String groupChatRoomID, Map<String, dynamic> lastMessageInfoMap) async {
    try {
      return await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupChatRoomID)
          .set(lastMessageInfoMap, SetOptions(merge: true));
    } catch (e) {
      print("Error updating last message information: $e");
      return null;
    }
  }

  Future deleteGroupChatRoomMessages(String groupID) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupID)
          .get();

      if (snapShot.exists) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("groups")
            .doc(groupID)
            .collection("messages")
            .get();

        for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
          // Delete each document in the collection
          await docSnapshot.reference.delete();
        }

        // return await FirebaseFirestore.instance
        //     .collection("chatRooms")
        //     .doc(chatRoomID)
        //     .delete();
      } else {
        return false;
      }
    } catch (e) {
      print("Error deleting group chat room messages: $e");
      return null;
    }
  }

  Future leaveGroup(String groupID, String userName, String userID) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection("groups").doc(groupID);

      DocumentSnapshot snapShot = await docRef.get();

      if (snapShot.exists) {
        List memberList = snapShot["members"];
        memberList.remove(userName);
        await docRef.set({"members": memberList}, SetOptions(merge: true));
        // now removing from users collection;

        DocumentReference dr =
            await FirebaseFirestore.instance.collection("users").doc(userID);
        DocumentSnapshot ds = await dr.get();

        if (ds.exists) {
          List listOfGroups = ds["groups"];
          listOfGroups.removeWhere((map) => map["groupID"] == groupID);
          await dr.set({"groups": listOfGroups}, SetOptions(merge: true));

          print('Group left successfully');
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Error leaving group: $e");
      return null;
    }
  }

  Future deleteGroup(String groupID, List groupMembers,
      Map<String, dynamic> groupMemberInfo) async {
    try {
      for (String userName in groupMembers) {
        if (userName == gAccountUserName) {
          await leaveGroup(groupID, gAccountUserName, gAccountID);
        } else {
          await leaveGroup(
              groupID, userName, groupMemberInfo[userName]["userID"]);
        }
      }
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("groups").doc(groupID);
      // Delete the document using the delete method
      await documentReference.delete();
      print('Group deleted successfully');
    } catch (e) {
      print("Error deleting group: $e");
      return null;
    }
  }

  Future addMyselfToExistingGroup(String groupID) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("groups").doc(groupID);
      DocumentSnapshot ds = await docRef.get();

      if (ds.exists) {
        List listOfMembers = ds["members"];
        if (listOfMembers.contains(gAccountUserName)) {
          return true;
        } else {
          listOfMembers.add(gAccountUserName);
        }
        await docRef.set({"members": listOfMembers}, SetOptions(merge: true));
      } else {
        return false;
      }
    } catch (e) {
      print("Error adding self to group: $e");
      return null;
    }
  }

  Future addToActiveMembers(String groupID, String userName) async {
    try {
      DocumentReference docRef =
      FirebaseFirestore.instance.collection("groups").doc(groupID);
      DocumentSnapshot ds = await docRef.get();

      if (ds.exists) {
        List listOfMembers = ds["activeMembers"];
        if (listOfMembers.contains(userName)) {
          return true;
        } else {
          listOfMembers.add(userName);
        }
        await docRef.set({"activeMembers": listOfMembers}, SetOptions(merge: true));
      } else {
        return false;
      }
    } catch (e) {
      print("Error adding self to active members: $e");
      return null;
    }
  }

  Future removeFromActiveMembers(String groupID, String userName) async {
    try {
      DocumentReference docRef =
      FirebaseFirestore.instance.collection("groups").doc(groupID);
      DocumentSnapshot ds = await docRef.get();

      if (ds.exists) {
        List listOfMembers = ds["activeMembers"];
        if (listOfMembers.contains(userName)) {
          listOfMembers.remove(userName);
        } else {
          return true;
        }
        await docRef.set({"activeMembers": listOfMembers}, SetOptions(merge: true));
      } else {
        return false;
      }
    } catch (e) {
      print("Error removing self from active members: $e");
      return null;
    }
  }

}
//
// addTokenDataToUserInfo(String token, String userID) async {
//   final data = {"token": token};
//   FirebaseFirestore.instance
//       .collection("users")
//       .doc(userID)
//       .set(data, SetOptions(merge: true));
// }
