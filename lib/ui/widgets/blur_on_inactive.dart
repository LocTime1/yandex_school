import 'dart:ui';
import 'package:flutter/material.dart';

class BlurOnInactive extends StatefulWidget {
  final Widget child;
  const BlurOnInactive({Key? key, required this.child}) : super(key: key);

  @override
  State<BlurOnInactive> createState() => _BlurOnInactiveState();
}

class _BlurOnInactiveState extends State<BlurOnInactive>
    with WidgetsBindingObserver {
  bool _blur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _blur =
          (state == AppLifecycleState.inactive ||
              state == AppLifecycleState.paused ||
              state == AppLifecycleState.detached);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_blur)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
      ],
    );
  }
}
