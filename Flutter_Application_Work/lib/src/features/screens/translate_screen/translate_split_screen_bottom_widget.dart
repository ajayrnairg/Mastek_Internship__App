import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_strings.dart';


class TranslateSplitScreenBottomWidget extends StatefulWidget {
  const TranslateSplitScreenBottomWidget({
    super.key,
    required this.dropdownValue2,
    required this.languageList,
    required this.translatedTextController,
    required this.dropDownFunction2,
    required this.speakButtonFunction,
    required this.copyClipboardButtonFunction,

  });
  final String dropdownValue2;
  final List<String> languageList;
  final TextEditingController translatedTextController;
  final Function dropDownFunction2;
  final Function speakButtonFunction;
  final Function copyClipboardButtonFunction;

  @override
  State<TranslateSplitScreenBottomWidget> createState() => _TranslateSplitScreenBottomWidgetState();
}

class _TranslateSplitScreenBottomWidgetState extends State<TranslateSplitScreenBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: gPurpleGrey,
      height: 370,
      padding:
      const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 320,
                decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0)),
                ),
                child: DropdownButtonFormField(
                    isExpanded: true,
                    value: widget.dropdownValue2,
                    items: widget.languageList
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall,
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (val) async {
                      widget.dropDownFunction2(val);
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: gPurpleGrey,
                    ),
                    decoration: const InputDecoration(
                      labelText: gChooseSecondLang,
                      // floatingLabelStyle: TextStyle(color: gPurpleGrey),
                      prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                      border: OutlineInputBorder(),
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 320,
            height: 165,
            padding: const EdgeInsets.symmetric(
                vertical: 15, horizontal: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border(
                  top: BorderSide(color: gDarkPurple, width: 3.0),
                  bottom: BorderSide(color: gDarkPurple, width: 3.0),
                  left: BorderSide(color: gDarkPurple, width: 3.0),
                  right: BorderSide(color: gDarkPurple, width: 3.0)),
              boxShadow: [
                BoxShadow(
                  color: gTileColorDark,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 1.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
              ],
            ),
            child: TextField(
              controller: widget.translatedTextController,
              maxLines: null,
              // Allows the TextField to expand to accommodate multiple lines of text.
              expands: true,
              style:
              const TextStyle(color: gDarkPurple, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: gDarkPurple,
                iconSize: 50,
                onPressed: () {
                  widget.speakButtonFunction();
                },
                icon: const Icon(Icons.volume_up_sharp),
              ),
              IconButton(
                color: gDarkPurple,
                iconSize: 50,
                onPressed: () async {
                  widget.copyClipboardButtonFunction();
                },
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
