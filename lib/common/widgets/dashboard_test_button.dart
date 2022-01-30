import 'dart:async';

import 'package:flutter/material.dart';

class DashboardTestButton extends StatefulWidget {
  const DashboardTestButton({
    Key? key,
    required this.buttonText,
    required this.backgroundColor,
    required this.onTapDown,
    required this.enableContinuousTap,
  }) : super(key: key);

  final Function onTapDown;
  final String buttonText;
  final Color backgroundColor;
  final bool enableContinuousTap;

  @override
  State<DashboardTestButton> createState() => _DashboardTestButtonState();
}

class _DashboardTestButtonState extends State<DashboardTestButton> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (widget.enableContinuousTap) {
          _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
            widget.onTapDown();
          });
        } else {
          widget.onTapDown();
        }
      },
      onTapUp: (TapUpDetails details) {
        if (widget.enableContinuousTap) {
          _timer!.cancel();
        }
      },
      onTapCancel: () {
        if (widget.enableContinuousTap) {
          _timer!.cancel();
        }
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
