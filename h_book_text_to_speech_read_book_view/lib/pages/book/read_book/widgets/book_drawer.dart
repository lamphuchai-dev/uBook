import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h_book/app/extensions/extensions.dart';

class BookDrawer extends StatefulWidget {
  const BookDrawer({super.key});

  @override
  State<BookDrawer> createState() => _BookDrawerState();
}

class _BookDrawerState extends State<BookDrawer> {
  final backgroundColor = Colors.grey;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: backgroundColor,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.width * 0.85,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(child: Column(children: [_headerDrawer()])),
    );
  }

  Widget _headerDrawer() {
    return Container(
      height: 50,
      color: Colors.red,
    );
  }
}
