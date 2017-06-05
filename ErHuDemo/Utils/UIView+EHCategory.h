//
//  UIView+EHCategory.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/5.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 获取当前区域的中心点
 *
 *  @param rect 当前区域
 *
 *  @return 中心点
 */
CGPoint CGRectGetCenter(CGRect rect);
/**
 *  @brief 通过中心点和宽高创建区域
 *
 *  @param center 中心点
 *  @param width  宽
 *  @param height 高
 *
 *  @return 区域
 */
CGRect CGRectMakeWithCenter(CGPoint center,CGFloat width,CGFloat height);

typedef void(^TapGestureBlock)();

@interface UIView (EHCategory)

/** tap手势的block回调 */
@property (nonatomic, copy) TapGestureBlock tapGestureBlock;

/** xib的裁剪半径 */
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;
/** xib的边缘线宽度 */
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
/** xib的边缘线颜色 */
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
/** 视图左下坐标 */
@property (readonly) CGPoint bottomLeft;
/** 视图右下坐标 */
@property (readonly) CGPoint bottomRight;
/** 视图右上坐标 */
@property (readonly) CGPoint topRight;
/** 视图左上坐标 */
@property CGPoint origin;
/** 视图大小 */
@property CGSize size;
/** 视图高 */
@property CGFloat height;
/** 视图宽 */
@property CGFloat width;
/** 视图顶部y坐标 */
@property CGFloat top;
/** 视图底部y坐标 */
@property CGFloat bottom;
/** 视图左边x坐标 */
@property CGFloat left;
/** 视图右边x坐标 */
@property CGFloat right;
/** 视图中心点x坐标 */
@property CGFloat centerX;
/** 视图中心点y坐标 */
@property CGFloat centerY;

/**
 *  @brief 从xib初始化view
 *
 *  @return view
 */
+ (instancetype)viewFromXib;

/**
 *  @brief  通过响应者链获取当前视图所在的控制器
 *
 *  @return UIViewController
 */
- (UIViewController *)viewController;

/**
 *  @brief  对视图进行裁剪
 *
 *  @param radius 裁剪半径
 */
- (void)cornerWithRadius:(CGFloat)radius;

/**
 *  @brief  给视图添加边框
 *
 *  @param borderColor 颜色
 *  @param borderWidth 边框线条宽度
 */
- (void)borderWithColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


/** 添加单击手势 */
- (UITapGestureRecognizer *)addTapGestureBlock:(TapGestureBlock)tapGestureBlock;

/** 返回一个带阴影的snapShotView */
- (UIView *)customSnapshotView;

/**
 给视图添加阴影
 
 @param radius 阴影半径
 @param offset 偏移量（size.width > 0 : 阴影向右偏 size.height > 0 : 阴影向下偏）
 @param opacity 不透明度
 @param color 颜色
 */
- (void)addShadowWithRadius:(CGFloat)radius offset:(CGSize)offset opacity:(CGFloat)opacity color:(UIColor *)color;

/**
 移除所有子视图
 */
- (void)removeAllSubViews;

@end
