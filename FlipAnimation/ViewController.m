//
//  ViewController.m
//  FlipAnimation
//
//  Created by shaohua on 30/03/2017.
//  Copyright © 2017 syang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate> {
    __weak UIView *_fromView, *_toView; // for animation only
}

@property (nonatomic) UILabel *frontView;
@property (nonatomic) UILabel *backView;
@property (nonatomic) UIButton *actionBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _frontView = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
    _frontView.text = @"Front";
    _frontView.textAlignment = NSTextAlignmentCenter;
    _frontView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_frontView];

    _backView = [[UILabel alloc] initWithFrame:_frontView.frame];
    _backView.text = @"Back";
    _backView.textAlignment = NSTextAlignmentCenter;
    _backView.backgroundColor = [UIColor greenColor];
    _backView.hidden = YES; // initially hidden
    [self.view addSubview:_backView];

    _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionBtn.frame = CGRectMake(110, 300, 100, 32);
    _actionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _actionBtn.layer.borderWidth = 1;
    [_actionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionBtn setTitle:@"Flip" forState:UIControlStateNormal];
    [_actionBtn addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_actionBtn];
}

#define kAnimationDuration .3
- (void)flip:(UIView *)fromView to:(UIView *)toView {
    _fromView = fromView;
    _toView = toView;

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
        _toView.layer.transform = CATransform3DIdentity;
    }
}

- (void)buttonTapped {
    if (_backView.hidden) {
        [self flip:_frontView to:_backView];
    } else {
        [self flip:_backView to:_frontView];
    }
}

@end
