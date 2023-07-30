import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_strings.dart';


class TranslateSplitScreenTopWidget extends StatefulWidget {
  const TranslateSplitScreenTopWidget({
    super.key,
    required this.dropdownValue1,
    required this.languageList,
    required this.dropDownFunction1,
    required this.micRecordingFunction,
    required this.recordStatus,
    required this.originalTextController
  });

  final String dropdownValue1;
  final List<String> languageList;
  final Function dropDownFunction1;
  final Function micRecordingFunction;
  final bool recordStatus;
  final TextEditingController originalTextController;

  @override
  State<TranslateSplitScreenTopWidget> createState() => _TranslateSplitScreenTopWidgetState();
}

class _TranslateSplitScreenTopWidgetState extends State<TranslateSplitScreenTopWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 283,
      padding:
      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 245,
                decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.0)),
                ),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: widget.dropdownValue1,
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
                  onChanged: (val) {
                    widget.dropDownFunction1(val);
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: gDarkPurple,
                  ),
                  decoration: const InputDecoration(
                      labelText: gChooseFirstLang,
                      prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                      border: OutlineInputBorder()),
                ),
              ),
              IconButton(
                color: gDarkPurple,
                iconSize: 50,
                onPressed: () async {
                  widget.micRecordingFunction();
                },
                icon: widget.recordStatus
                    ? const Icon(Icons.stop)
                    : const Icon(Icons.mic),
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
                  color: gTileColorLight,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 1.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
              ],
            ),
            child: TextField(
              controller: widget.originalTextController,
              maxLines: null,
              // Allows the TextField to expand to accommodate multiple lines of text.
              expands: true,
              style:
              const TextStyle(color: gDarkPurple, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
