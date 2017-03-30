---
layout: post
title: "Flipping two views"
---

![]({{ site.url }}/assets/flip_two_views.gif)

This is a two phase animation:

```objc
- (void)flip {

    _fromView.layer.transform = CATransform3DIdentity;
    _fromView.hidden = NO;
    _toView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    _toView.hidden = YES;

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = @M_PI_2;
    rotationAnimation.duration = kAnimationDuration;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_fromView.layer addAnimation:rotationAnimation forKey:@"first"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_toView.hidden) {
        // ^注1
        _toView.hidden = NO;
        _fromView.hidden = YES;

        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.toValue = @0.0f;
        rotationAnimation.duration = kAnimationDuration;
        rotationAnimation.delegate = self;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_toView.layer addAnimation:rotationAnimation forKey:@"second"];
    } else {
        // ^注2
        _toView.layer.transform = CATransform3DIdentity;
    }
}
```
这是个两阶段的动画，animationDidStop:finished: 会 callback 两次，分别在注释 1 和注释 2 的位置。

[完整 demo](https://github.com/shyang/FlipAnimation/blob/master/FlipAnimation/ViewController.m)
