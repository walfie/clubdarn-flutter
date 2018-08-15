import "package:flutter/material.dart";

import "../models.dart";
import "../searcher.dart";

class SettingsTab extends StatefulWidget {
  SettingsTab({
    @required this.searcher,
    this.onChanged,
  });

  final Searcher searcher;
  final ValueChanged<String> onChanged;

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Widget _radioOption(String title, String value) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: widget.searcher.serialNo,
      onChanged: (String value) {
        if (value != widget.searcher.serialNo) {
          setState(() {
            widget.searcher.serialNo = value;
            widget.onChanged?.call(value);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Machine", style: const TextStyle(fontSize: 20.0)),
        _radioOption("LiveDAM", null),
        _radioOption("PremierDAM", "AB316238"),
      ],
    );
  }
}
