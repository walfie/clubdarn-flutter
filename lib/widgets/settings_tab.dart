import "package:flutter/material.dart";

import "../models.dart";
import "../searcher.dart";

class SettingsTab extends StatefulWidget {
  SettingsTab({
    @required this.searcher,
  });

  final Searcher searcher;

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
        setState(() {
          widget.searcher.serialNo = value;
        });
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
