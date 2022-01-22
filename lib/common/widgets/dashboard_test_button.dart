import 'dart:async';

import 'package:flutter/material.dart';

class DashboardTestButton extends StatefulWidget {
  const DashboardTestButton({
    Key? key,
    required this.buttonText,
    required this.backgroundColor,
    required this.onTapDown,
  }) : super(key: key);

  final Function onTapDown;
  final String buttonText;
  final Color backgroundColor;

  @override
  State<DashboardTestButton> createState() => _DashboardTestButtonState();
}

class _DashboardTestButtonState extends State<DashboardTestButton> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
          widget.onTapDown();
        });
      },
      onTapUp: (TapUpDetails details) {
        _timer!.cancel();
      },
      onTapCancel: () {
        _timer!.cancel();
      },
      child: Container(
        width: 100.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.buttonText,
            ),
          ],
        ),
      ),
    );
  }
}
