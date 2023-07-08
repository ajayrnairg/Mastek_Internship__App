import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../../controllers/home_screen_controller.dart';

class HomeListTileWidget extends StatelessWidget {
  const HomeListTileWidget({
    super.key,
    required this.tileLeading,
    required this.tileTitle,
    required this.controller,
  });

  final String tileLeading,tileTitle;
  final HomeScreenController controller;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10.0),
      tileColor: Colors.orange,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.0, color: Colors.red),
        borderRadius: BorderRadius.circular(gBorderRadius),
      ),
      leading: Image(
        image: AssetImage(tileLeading),
      ),
      title: Align(
          alignment: Alignment.centerLeft,
          child: Text(tileTitle, style: Theme.of(context).textTheme.titleLarge)),
      onTap: () {controller.goToPageFunc(key);},
    );
  }
}