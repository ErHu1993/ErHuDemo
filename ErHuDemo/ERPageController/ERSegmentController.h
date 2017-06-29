//
//  ERSegmentController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERPageViewController.h"

@interface ERSegmentController : ERPageViewController

@property (nonatomic, weak) id<ERPageViewControllerDelegte>delegate;

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

@end
