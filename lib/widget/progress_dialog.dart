import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/transactions/model/state.dart';

class ProgressDialog extends StatelessWidget {
  static const String ROUTE_NAME = "progress_dialog";

  final Stream<ProgressState> progressStream;

  ProgressDialog({Key key, this.progressStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: StreamBuilder<ProgressState>(
        initialData: ProgressState(0, "Getting ready ..."),
        stream: progressStream,
        builder: (builderContext, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isCompleted) {
              _dismiss(context);
            }
            return Row(
              children: [
                Stack(
                  children: [
                    CircularProgressIndicator(
                      value: snapshot.data.progress,
                    ),
                    Text(
                      "${(snapshot.data.progressPercent)}%",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                  alignment: AlignmentDirectional.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(snapshot.data.info, maxLines: 1),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            _dismiss(context);
          }
          return Row();
        },
      ),
    );
  }

  void _dismiss(BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.of(context, rootNavigator: true).pop(ROUTE_NAME);
    });
  }
}
