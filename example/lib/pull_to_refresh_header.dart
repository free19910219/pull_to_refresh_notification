import 'dart:async';

import 'package:example/push_to_refresh_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshHeader extends StatefulWidget {
  @override
  _PullToRefreshHeaderState createState() => _PullToRefreshHeaderState();
}

class _PullToRefreshHeaderState extends State<PullToRefreshHeader> {
  int listlength = 50;
  DateTime dateTimeNow = DateTime.now();
  final GlobalKey<PullToRefreshNotificationState> key =
      new GlobalKey<PullToRefreshNotificationState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: <Widget>[
        PullToRefreshNotification(
          color: Colors.blue,
          onRefresh: onRefresh,
          maxDragOffset: maxDragOffset,
          armedDragUpCancel: false,
          key: key,
          child: CustomScrollView(
            physics: AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                title: Text("PullToRefreshHeader"),
              ),
              PullToRefreshContainer(buildPulltoRefreshHeader),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "List item : ${listlength - index}",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 2.0,
                        )
                      ],
                    ));
              }, childCount: listlength)),
            ],
          ),
        ),
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              key.currentState.show(notificationDragOffset: maxDragOffset);
            },
          ),
        )
      ],
    ));
  }

  Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
    //print(info?.mode);
    //print(info?.dragOffset);
//    print("------------");
    var offset = info?.dragOffset ?? 0.0;
    var mode = info?.mode;

    Widget child;
    if (mode == RefreshIndicatorMode.error) {
      child = GestureDetector(
          onTap: () {
            // refreshNotification;
            info?.pullToRefreshNotificationState?.show();
          },
          child: Container(
            color: Colors.grey,
            alignment: Alignment.bottomCenter,
            height: offset,
            width: double.infinity,
            //padding: EdgeInsets.only(top: offset),
            child: Container(
              padding: EdgeInsets.only(left: 5.0),
              alignment: Alignment.center,
              child: Text(
                "error, click to retry",
                style: TextStyle(fontSize: 12.0, inherit: false),
              ),
            ),
          ));
    } else {
      child = PullToRefreshHeaderWidget(info, dateTimeNow);
//      child = Container(
//        color: Colors.grey,
//        alignment: Alignment.bottomCenter,
//        height: offset,
//        width: double.infinity,
//        //padding: EdgeInsets.only(top: offset),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            refreshWiget,
//            Container(
//              padding: EdgeInsets.only(left: 5.0),
//              alignment: Alignment.center,
//              child: Text(
//                mode?.toString() ?? "",
//                style: TextStyle(fontSize: 12.0, inherit: false),
//              ),
//            )
//          ],
//        ),
//      );
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }

  bool success = false;
  Future<bool> onRefresh() {
    final Completer<bool> completer = new Completer<bool>();
    new Timer(const Duration(seconds: 2), () {
      completer.complete(success);
      success = true;
    });
    return completer.future.then((bool success) {
      if (success) {
        setState(() {
          dateTimeNow = DateTime.now();
          listlength += 10;
        });
      }
      return success;
    });
  }
}
