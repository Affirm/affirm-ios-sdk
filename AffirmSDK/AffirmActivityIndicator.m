//
//  AffirmActivityIndicator.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 5/31/17.
//  Copyright © 2017 Sachin Kesiraju. All rights reserved.
//

#import "AffirmActivityIndicator.h"

@interface AffirmActivityIndicator ()

@property (strong, nonatomic) CAShapeLayer *indicatorShapeLayer;

@end

@implementation AffirmActivityIndicator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 80, 80);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupCircleIndicator {
    self.indicatorShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorShapeLayer.strokeColor = self.indicatorColor.CGColor;
    self.indicatorShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.indicatorShapeLayer.lineWidth = self.indicatorLineWidth;
    
    CGFloat length = self.frame.size.width/5;
    self.indicatorShapeLayer.frame = CGRectMake(length, length, length*3, length*3);
    [self.layer addSublayer:self.indicatorShapeLayer];
}

- (void)startAnimatingOnView:(UIView *)view {
    [self setupCircleIndicator];
    [view addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startCircleAnimation];
    });
}

- (void)startCircleAnimation {
    [self.indicatorShapeLayer removeAllAnimations];
    CAShapeLayer *circleShapeLayer = [[CAShapeLayer alloc] init];
    circleShapeLayer.strokeColor =  self.indicatorPathColor.CGColor;
    circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    circleShapeLayer.lineWidth = self.indicatorShapeLayer.lineWidth;
    circleShapeLayer.path = [self arcPathWithStartAngle:-M_PI span:2*M_PI];
    
    CGFloat length = self.frame.size.width/5;
    circleShapeLayer.frame = CGRectMake(length, length, length*3, length*3);
    [self.layer insertSublayer:circleShapeLayer below:self.indicatorShapeLayer];
    
    self.indicatorShapeLayer.path = [self arcPathWithStartAngle:-M_PI/2 span:3*M_PI/2];
    
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation.z";
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 1.05;
    animation.repeatCount = INFINITY;
    
    [self.indicatorShapeLayer addAnimation:animation forKey:nil];
}

- (void)stopAnimating {
    [UIView animateWithDuration:0.35 delay:0.1 options:kNilOptions  animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.indicatorShapeLayer removeFromSuperlayer];
        [self removeFromSuperview];
    }];
}

- (CGPathRef)arcPathWithStartAngle:(CGFloat)startAngle span:(CGFloat)span {
    CGFloat radius = self.frame.size.width  / 2 - self.frame.size.width / 5;
    CGFloat x = self.indicatorShapeLayer.frame.size.width / 2;
    CGFloat y = self.indicatorShapeLayer.frame.size.height / 2;
    
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:startAngle+span clockwise:YES];
    return arcPath.CGPath;
}

@end
