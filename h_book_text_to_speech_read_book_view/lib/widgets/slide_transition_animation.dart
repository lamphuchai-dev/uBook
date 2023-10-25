import 'package:flutter/material.dart';
import 'package:h_book/services/system_chrome_service.dart';

enum AnimationType { topToBottom, bottomToTop, leftToRight, rightToLeft }

class SlideTransitionAnimation extends StatefulWidget {
  const SlideTransitionAnimation(
      {Key? key,
      required this.child,
      required this.runAnimation,
      required this.type,
      this.onCloseSuccess,
      this.changeNavigationBarColor = true})
      : super(key: key);
  final Widget child;

  final AnimationType type;

  final bool changeNavigationBarColor;

  final bool runAnimation;
  final VoidCallback? onCloseSuccess;

  @override
  State<SlideTransitionAnimation> createState() =>
      _SlideTransitionAnimationState();
}

class _SlideTransitionAnimationState extends State<SlideTransitionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _setupAnimation();
    super.initState();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<Offset>(begin: _getOffset(widget.type), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutQuad));
    if (widget.runAnimation) {
      _animationController.forward();
    }

    _animationController.addStatusListener((status) {
      if (widget.changeNavigationBarColor) {}
      switch (status) {
        case AnimationStatus.forward:
          if (widget.changeNavigationBarColor) {
            SystemChromeService.setSystemUIOverlayStyle(
                const Color(0xffDDDDDD));
          }
          break;

        case AnimationStatus.dismissed:
          widget.onCloseSuccess?.call();
          if (widget.changeNavigationBarColor) {
            SystemChromeService.setSystemUIOverlayStyle(
              Colors.white,
            );
          }

          break;
        default:
          break;
      }
    });
  }

  Offset _getOffset(AnimationType type) {
    switch (type) {
      case AnimationType.leftToRight:
        return const Offset(-1, 0);
      case AnimationType.rightToLeft:
        return const Offset(1, 0);
      case AnimationType.topToBottom:
        return const Offset(0, -1);
      case AnimationType.bottomToTop:
        return const Offset(0, 1);
      default:
        break;
    }
    return Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => SlideTransition(
        position: _animation,
        child: child,
      ),
      child: widget.child,
    );
  }

  tmp() async {
    if (widget.runAnimation) {
      print("tmp");
      final tmp = _animationController.forward();
      await tmp.whenComplete(() {
        print("whenComplete");
      });
      tmp.whenCompleteOrCancel(() {
        print("object");
      });
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant SlideTransitionAnimation old) {
    if (widget.child != old.child || widget.runAnimation != old.runAnimation) {
      tmp();
      // if (widget.runAnimation) {
      //   final tmp = _animationController.forward();
      //   tmp.whenComplete(() {
      //     print("whenComplete");
      //   });
      //   tmp.whenCompleteOrCancel(() {});
      // } else {
      //   _animationController.reverse();
      // }
    }
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
