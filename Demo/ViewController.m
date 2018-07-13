//
//  ViewController.m
//  Demo
//
//  Created by 许亚光 on 2018/7/11.
//  Copyright © 2018年 KevinXu. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"


@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIView *clockView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self dashboardView];

    NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self touchesBegan:nil withEvent:nil];
    }];

    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGFloat progress = (arc4random_uniform(40)+60)/100.0;

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 动画快慢
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.duration = 1.0f*progress;
    animation.fromValue = @(-0.2*M_PI);
    animation.toValue = @(1.4*M_PI*progress - 0.2*M_PI);
    [_clockView.layer addAnimation:animation forKey:@"dsgsdg"];
    
    
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.fillMode = kCAFillModeForwards;
    checkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 动画快慢
    checkAnimation.removedOnCompletion = NO;
    checkAnimation.duration = 1.0f*progress;
    checkAnimation.repeatCount = 1;
    checkAnimation.autoreverses = YES;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f*progress);
    [_progressLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
    
}


- (void)dashboardView {
    // 主背景色
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 渐变背景
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = CGRectMake((kWidth - 300)/2, (kHeight - 300)/2, 300, 300);
    
    // 渐变图层
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = CGRectMake(0, 0, 300, 300);
    gradientLayer3.colors = @[(__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
    gradientLayer3.locations = @[@(0),@(0.8)];
    gradientLayer3.startPoint = CGPointMake(0, 0.5);
    gradientLayer3.endPoint = CGPointMake(1, 0.5);
    [gradientLayer addSublayer:gradientLayer3];
    
    [self.view.layer addSublayer:gradientLayer];
    
    
    // 开始和结束角度
    CGFloat startA = -M_PI - 0.2 * M_PI;
    CGFloat ednA = 0.2 * M_PI;
    
    // 最外圈圆弧
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, kHeight/2) radius:150 startAngle:startA endAngle:ednA clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
    
    // 内圈圆弧
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, kHeight/2) radius:80 startAngle:startA endAngle:ednA clockwise:YES];

    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.lineCap = kCALineCapSquare;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.lineWidth = 4;
    layer2.strokeColor = [UIColor whiteColor].CGColor;
    layer2.path = path2.CGPath;

    [self.view.layer addSublayer:layer2];
    
    // 中间圆弧
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, kHeight/2) radius:10 startAngle:startA endAngle:ednA clockwise:YES];
    
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.lineCap = kCALineCapSquare;
    layer3.fillColor = [UIColor clearColor].CGColor;
    layer3.lineWidth = 6;
    layer3.strokeColor = [UIColor whiteColor].CGColor;
    layer3.path = path3.CGPath;
    
    [self.view.layer addSublayer:layer3];
    
    // 进度圆弧
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:115 - 2 startAngle:startA endAngle:ednA clockwise:YES];
    
    CAShapeLayer *layer4 = [CAShapeLayer layer];
    layer4.lineCap = kCALineCapButt;
    layer4.fillColor = [UIColor clearColor].CGColor;
    layer4.strokeColor = [UIColor whiteColor].CGColor;
    layer4.lineWidth = 70;
    layer4.path = path4.CGPath;
    layer4.strokeEnd = 0;
    gradientLayer.mask = layer4;
    
    _progressLayer = layer4;
    
    // 指针
    UIView *clockView = [[UIView alloc] initWithFrame:CGRectMake((kWidth-140)/2, (kHeight-2)/2, 140, 2)];
    clockView.backgroundColor = [UIColor whiteColor];
    clockView.layer.anchorPoint = CGPointMake(1.08, 0.5);
    [self.view addSubview:clockView];
    _clockView = clockView;
    clockView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -0.2*M_PI);
    
    // 刻度
    CGFloat perAngle = 1.4 * M_PI / 70;
    
    for (NSInteger i = 0; i < 71; i++) {
        CGFloat startAngel = (startA + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;
        
        CGFloat middleAngle = (startAngel - endAngel);
        
    
        UIBezierPath *tickPath = nil;
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = [UIColor whiteColor].CGColor;
        if (i % 5 == 0) {
            tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, kHeight/2) radius:(150-7.5 + 2) startAngle:(startAngel + middleAngle/2) endAngle:(endAngel + middleAngle/2) clockwise:YES];
            perLayer.lineWidth   = 15.f;
            
            CGPoint point      = [self calculateTextPositonWithArcCenter:CGPointMake(kWidth/2, kHeight/2) Angle:-(startAngel + endAngel)/2];
            NSString *tickText = [NSString stringWithFormat:@"%ld",i * 2];
            
            UILabel *text      = [[UILabel alloc] init];
            text.text          = tickText;
            text.font          = [UIFont systemFontOfSize:10];
            text.textColor     = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            CGFloat w = [text sizeThatFits:CGSizeZero].width;
            CGFloat h = [text sizeThatFits:CGSizeZero].height;
            text.frame = CGRectMake(point.x - w/2, point.y - h/2, w, h);
            [self.view addSubview:text];
            
        } else {
            tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWidth/2, kHeight/2) radius:(150-5 + 2) startAngle:(startAngel + middleAngle/2) endAngle:(endAngel + middleAngle/2) clockwise:YES];
            perLayer.lineWidth   = 5;
            
        }
        
        perLayer.path = tickPath.CGPath;
        [self.view.layer addSublayer:perLayer];
    }
    
    
}


// 计算位置,默认半径125
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel {
    CGFloat x = 125 * cosf(angel);
    CGFloat y = 125 * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}


#pragma mark 渐变图层
- (void)gradientColorLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor] CGColor], (__bridge id)[[UIColor redColor] CGColor]];
    gradientLayer.locations = @[@(0), @(1)];
    gradientLayer.startPoint = CGPointMake(.5, 0);
    gradientLayer.endPoint = CGPointMake(.5, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:gradientLayer];
}

#pragma mark
- (void)copyAnimation {
        UIView *animationView = [UIView new];
        animationView.bounds = CGRectMake(0, 0, kWidth, 300);
        animationView.center = self.view.center;
        animationView.backgroundColor = [UIColor grayColor];
        animationView.clipsToBounds = YES;
        [self.view addSubview:animationView];
    
        CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
        animationLayer.backgroundColor = [UIColor redColor].CGColor;
        animationLayer.bounds = CGRectMake(0, 0, 20, 20);
        animationLayer.cornerRadius = 10;
        animationLayer.masksToBounds = YES;
        animationLayer.position = CGPointMake(self.view.bounds.size.width/2, 50);
        animationLayer.borderColor = [UIColor whiteColor].CGColor;
        animationLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1);
    
        CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnim.duration = 1.0;
        transformAnim.repeatCount = HUGE;
        transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1)];
    
        [animationLayer addAnimation:transformAnim forKey:@"keee"];
    
        CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
        replicatorLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
        [replicatorLayer addSublayer:animationLayer];
        replicatorLayer.instanceCount = 20;
        replicatorLayer.instanceDelay = 0.05;
        CGFloat angle = (2.0*M_PI) / (20.0);
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
    
        [animationView.layer addSublayer:replicatorLayer];
}

#pragma mark
- (void)scaleAnimation {
    UIView *animationView = [UIView new];
    animationView.bounds = CGRectMake(0, 0, kWidth, 200);
    animationView.center = self.view.center;
    animationView.backgroundColor = [UIColor lightGrayColor];
    animationView.clipsToBounds = YES;
    [self.view addSubview:animationView];
    
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
    animationLayer.bounds = CGRectMake(0, 0, 20, 20);
    animationLayer.cornerRadius = 10;
    animationLayer.position = CGPointMake(kWidth/2, 100);
    
    // 放大的动画
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(10, 10, 1)];
    transformAnim.duration = 1;

    
    // 透明度动画(其实也可以直接设置CAReplicatorLayer的instanceAlphaOffset来实现)
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = @(1);
    alphaAnim.toValue = @(0);
    alphaAnim.duration = 1;

    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[transformAnim, alphaAnim];
    animGroup.duration = 1;
    animGroup.repeatCount = MAXFLOAT;
    [animationLayer addAnimation:animGroup forKey:@"rrr"];
    
    
    CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
    [replicatorLayer addSublayer:animationLayer];
    replicatorLayer.instanceCount = 3;  //三个复制图层
    replicatorLayer.instanceDelay = 0.2;  // 复制间隔0.3秒
    [animationView.layer addSublayer:replicatorLayer];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
