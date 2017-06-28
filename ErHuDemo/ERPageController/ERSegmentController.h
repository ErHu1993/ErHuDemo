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

@property (nonatomic, assign) CGFloat itemMinimumSpacing; // cell space
@property (nonatomic, assign) CGFloat progressWidth;

// text font
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *selectedTextFont;

// text color
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end
