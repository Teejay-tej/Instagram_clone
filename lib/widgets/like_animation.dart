import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LikeAnimation extends StatefulWidget {
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
     this.duration = const Duration(microseconds: 150),
    this.onEnd,
     this.smallLike = false,
  }) : super(key: key);
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(microseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

 startAnimation() async{
  if(widget.isAnimating || widget.smallLike){
    await animationController.forward();
    await animationController.reverse();
    await Future.delayed(const Duration(microseconds: 200));

    if(widget.onEnd != null){
      widget.onEnd!();
    }
  }
}
@override
  void dispose() {
   animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child,);
  }
}

