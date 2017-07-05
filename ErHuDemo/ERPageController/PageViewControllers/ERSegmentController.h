//
//  ERSegmentController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERPageViewController.h"
#import "ERSegmentMenuController.h"

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
 导航菜单编辑按钮点击回调

 @param segmentController self
 @param editMenuButton editMenuButton
 */
- (void)segmentController:(ERSegmentController *)segmentController didSelectEditMenuButton:(UIButton *)editMenuButton;
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
/** 是否展示编辑菜单按钮 */
@property (nonatomic, weak) id<ERSegmentMenuControllerDataSource> menuDataSource;
/** 编辑菜单图片(这里在editMenuButton上又覆盖一层imageView是为了让阴影和旋转分开,用不同的视图表示) */
@property (nonatomic, strong) UIImageView *editMenuIconIgV;
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
