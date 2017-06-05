//
//  UIView+EHCategory.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/5.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "UIView+EHCategory.h"
#import <objc/runtime.h>

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint center = CGPointZero;
    center.x = CGRectGetMidX(rect);
    center.y = CGRectGetMidY(rect);
    return center;
}

CGRect CGRectMakeWithCenter(CGPoint center,CGFloat width,CGFloat height)
{
    CGRect rect = CGRectZero;
    rect.origin.x = center.x - width*0.5;
    rect.origin.y = center.y - height*0.5;
    rect.size = CGSizeMake(width, height);
    return rect;
}


@implementation UIView (EHCategory)

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil ]lastObject];
}

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

#pragma mark - 视图处理
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = centerX - newFrame.size.width/2 ;
    self.frame = newFrame;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = centerY - newFrame.size.height/2 ;
    self.frame = newFrame;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

#pragma mark - 图层处理
- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)cornerWithRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)borderWithColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setTapGestureBlock:(TapGestureBlock)tapGestureBlock
{
    if (self.tapGestureBlock != tapGestureBlock) {
        //存储新的值
        [self willChangeValueForKey:@"tapGestureBlock"];
        objc_setAssociatedObject(self, @selector(tapGestureBlock), tapGestureBlock, OBJC_ASSOCIATION_COPY);
        [self didChangeValueForKey:@"tapGestureBlock"];
    }
}

- (TapGestureBlock)tapGestureBlock
{
    return (TapGestureBlock)objc_getAssociatedObject(self, @selector(tapGestureBlock));
}

/** 添加手势 */
- (UITapGestureRecognizer *)addTapGestureBlock:(TapGestureBlock)tapGestureBlock
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer: tap];
    self.tapGestureBlock = tapGestureBlock;
    return tap;
}

- (void)tapAction
{
    if (self.tapGestureBlock) {
        self.tapGestureBlock();
    }
}

/** 返回一个带阴影的snapShotView */
- (UIView *)customSnapshotView {
    
    UIView *snapshot = [self snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-4.0, 0.0);
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/**
 给视图添加阴影
 
 @param radius 阴影半径
 @param offset 偏移量（size.width > 0 : 阴影向右偏 size.height > 0 : 阴影向下偏）
 @param opacity 不透明度
 @param color 颜色
 */
- (void)addShadowWithRadius:(CGFloat)radius offset:(CGSize)offset opacity:(CGFloat)opacity color:(UIColor *)color {
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

/**
 移除所有子视图
 */
- (void)removeAllSubViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

@end
