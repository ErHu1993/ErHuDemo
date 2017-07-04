//
//  ERSegmentController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERPageViewController.h"

@class ERSegmentController;

@protocol ERSegmentControllerDelegte <NSObject>

@optional

/**
 导航按钮点击事件回调

 @param segmentController self
 @param indexPath indexPath
 */
- (void)segmentController:(ERSegmentController *)segmentController didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 导航按钮双击事件回调
 
 @param segmentController self
 @param indexPath indexPath
 */
- (void)segmentController:(ERSegmentController *)segmentController itemDoubleClickAtIndexPath:(NSIndexPath *)indexPath;

/**
 页面切换滚动完成回调

 @param pageController superClass
 @param fromIndex fromIndex
 @param toIndex toIndex
 */
- (void)pageControllerDidScroll:(ERPageViewController *)pageController fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface ERSegmentController : ERPageViewController

@property (nonatomic, weak) id<ERSegmentControllerDelegte>delegate;

/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editMenuButton;
/** 底部横线高度 */
@property (nonatomic, assign) CGFloat progressHeight;
/** 底部横线宽度 */
@property (nonatomic, assign) CGFloat progressWidth;
/** 未选中状态下的字号 */
@property (nonatomic, strong) UIFont *normalTextFont;
/** 选中状态下的字号 */
@property (nonatomic, strong) UIFont *selectedTextFont;
/** 未选中状态下的字体颜色 */
@property (nonatomic, strong) UIColor *normalTextColor;
/** 选中状态下的字体颜色 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/** item直接的行间距 */
@property (nonatomic, assign) NSInteger itemMinimumSpace;
@end
