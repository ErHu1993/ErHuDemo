//
//  CircleProgressView.m
//  Test
//
//  Created by 胡广宇 on 16/7/14.
//  Copyright © 2016年 Witgo. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView ()

/** 圆弧半径 */
@property (nonatomic, assign) CGFloat radius;
/** 圆弧线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 圆弧线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation CircleProgressView

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{
    CGFloat x = center.x - radius - lineWidth*0.5;
    CGFloat y = center.y - radius - lineWidth*0.5;
    CGFloat width = 2*radius + lineWidth;
    CGFloat height = width;
    
    CGRect frame = CGRectMake(x, y, width, height);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.radius = radius;
        self.lineColor = lineColor;
        self.lineWidth = lineWidth;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    //手动调用 drawRect
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.lineColor set];
    CGFloat endAngle = 2 * M_PI*self.progress - M_PI_2;
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    [path setLineWidth:self.lineWidth];
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
}


@end
