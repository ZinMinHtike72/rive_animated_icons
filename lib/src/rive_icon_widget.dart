import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/src/rive_assets.dart';

/// [RiveIconWidget] is the rive animated component for Rive Flutter 0.14.0+
class RiveIconWidget extends StatefulWidget {
  const RiveIconWidget({
    required this.height, required this.width, required this.icon, required this.color, super.key,
    this.strokeWidth = 2.0,
    this.loopAnimation = false,
    this.fit = Fit.contain,
  });

  final double height;
  final double width;
  final RiveAsset icon;
  final Color color;
  final double strokeWidth;
  final bool loopAnimation;
  final Fit fit;

  @override
  State<RiveIconWidget> createState() => _RiveIconWidgetState();
}

class _RiveIconWidgetState extends State<RiveIconWidget> {
  late final fileLoader = FileLoader.fromAsset(
    widget.icon.src,
    riveFactory: Factory.rive,
  );

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: RiveWidgetBuilder(
        fileLoader: fileLoader,
        builder: (context, state) => switch (state) {
          RiveLoading() => const Center(child: CircularProgressIndicator()),
          RiveFailed() => Center(child: Text('Failed to load: ${state.error}')),
          RiveLoaded() => _buildRive(state.controller),
        },
      ),
    );
  }

  Widget _buildRive(RiveWidgetController controller) {
    // Set up artboard, state machine, and inputs using new API
    final artboard = controller.artboard;
    final stateMachine = controller.stateMachine;

  // To update colors or strokes, use data binding or state machine inputs in your Rive file.
  // Example: Use stateMachine.boolean('myBool') or stateMachine.number('myNumber') to control properties.

    // Set state machine inputs using new API
    final trigger = stateMachine.trigger('active');
    final numberInput = stateMachine.number('strokeWidth');
    if (trigger != null) {
      if (widget.loopAnimation) {
        trigger.fire();
      }
    }
    if (numberInput != null) {
      numberInput.value = widget.strokeWidth - 1;
    }
  
    return RiveWidget(
      controller: controller,
      fit: widget.fit,
    );
  }
}
