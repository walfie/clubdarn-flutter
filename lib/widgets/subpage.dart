import "package:flutter/material.dart";

class Subpage extends StatelessWidget {
  const Subpage({
    Key key,
    this.title,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title == null ? Container() : Text(title, maxLines: 2),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16.0), child: child),
      ),
    );
  }
}
