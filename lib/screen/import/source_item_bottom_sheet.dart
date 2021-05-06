import 'package:flutter/material.dart';

class ImportBottomSheet extends StatelessWidget {
  const ImportBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 16),
      // color: Colors.grey[900],
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(),
    );
  }
}
