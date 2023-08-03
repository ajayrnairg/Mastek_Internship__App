import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final homeScreenController = Get.put(HomeScreenController());




  void _showToast() {
    Fluttertoast.showToast(
      msg: 'This is a Toast!',
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(gGroupChatScreenName),
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showToast();

          },
          child: Text('Show Toast'),

        ),
      ),
    );
  }
}
