//
//  CircleProgressView.h
//  Test
//
//  Created by 胡广宇 on 16/7/14.
//  Copyright © 2016年 Witgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

/**
 *  @brief 创建环形进度视图
 *
 *  @param center    中心点
 *  @param radius    环形半径
 *  @param linColor  线条颜色
 *  @param lineWidth 线条宽度
 *
 *  @return 环形进度视图
 */
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius lineColor:(UIColor *)linColor lineWidth:(CGFloat)lineWidth;

/** 进度（0~1） */
@property (nonatomic, assign) CGFloat progress;

@end
