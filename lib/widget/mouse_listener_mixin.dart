import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

mixin MouseListenerMixin<T extends StatefulWidget> on State<T> {
  late bool isMouseConnected;

  @override
  void initState() {
    isMouseConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    RendererBinding.instance!.mouseTracker.addListener(_mouseListener);
    super.initState();
  }

  @override
  void dispose() {
    RendererBinding.instance!.mouseTracker.removeListener(_mouseListener);
    super.dispose();
  }

  void _mouseListener() {
    final bool _isMouseConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (_isMouseConnected != isMouseConnected) {
      setState(() {
        isMouseConnected = _isMouseConnected;
      });
    }
  }
}
