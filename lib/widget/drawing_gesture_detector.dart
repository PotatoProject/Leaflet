import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DrawingGestureDetector extends StatelessWidget {
  final Widget child;
  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;

  DrawingGestureDetector({
    this.child,
    this.onUpdate,
    this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        MonoDragGestureDetector:
            GestureRecognizerFactoryWithHandlers<MonoDragGestureDetector>(
          () => MonoDragGestureDetector(),
          (MonoDragGestureDetector instance) {
            instance.onStart = (Offset position) {
              return MonoDrag(
                events: instance.events,
                onUpdate: onUpdate,
                onEnd: onEnd,
              );
            };
          },
        ),
      },
      child: child,
    );
  }
}

class MonoDrag extends Drag {
  final List<PointerDownEvent> events;

  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;

  MonoDrag({
    this.events,
    this.onUpdate,
    this.onEnd,
  });

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    final delta = details.delta;
    if (events.length == 1) {
      onUpdate?.call(DragUpdateDetails(
        sourceTimeStamp: details.sourceTimeStamp,
        delta: Offset(delta.dx, delta.dy),
        primaryDelta: details.primaryDelta,
        globalPosition: details.globalPosition,
        localPosition: details.localPosition,
      ));
    }
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
    onEnd?.call(details);
  }
}

class MonoDragGestureDetector
    extends MultiDragGestureRecognizer<_MonoDragPointerState> {
  final List<PointerDownEvent> events = [];

  MonoDragGestureDetector() : super(debugOwner: false);

  @override
  createNewPointerState(PointerDownEvent event) {
    events.add(event);
    return _MonoDragPointerState(event.position, event.kind,
        onDisposeState: () {
      events.remove(event);
    });
  }

  @override
  String get debugDescription => 'custom vertical multidrag';
}

typedef OnDisposeState();

class _MonoDragPointerState extends MultiDragPointerState {
  final OnDisposeState onDisposeState;

  _MonoDragPointerState(Offset initialPosition, PointerDeviceKind kind,
      {this.onDisposeState})
      : super(initialPosition, kind);

  @override
  void checkForResolutionAfterMove() {
    if (pendingDelta.dy.abs() > kTouchSlop &&
        pendingDelta.dx.abs() > kTouchSlop) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    starter(initialPosition);
  }

  @override
  void dispose() {
    onDisposeState?.call();
    super.dispose();
  }
}
