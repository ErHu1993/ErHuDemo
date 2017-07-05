//
//  ERPageViewController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ERPageViewController;

@protocol ERPageViewControllerDataSource <NSObject>

@required

/**
 返回子控制器总数,类似TableViewDataSource

 @param pageViewController self
 @return 子控制器总数
 */
- (NSInteger)numberOfControllersInPageViewController:(ERPageViewController *)pageViewController;


/**
 返回对应index的ViewController

 @param pageViewController self
 @param index 当前index
 @return 需要展示的ViewController
 */
- (UIViewController *)pageViewController:(ERPageViewController *)pageViewController childControllerAtIndex:(NSInteger)index;

/**
 子控制器title

 @param pageViewController self
 @param index 当前index
 @return title
 */
- (NSString *)pageViewController:(ERPageViewController *)pageViewController titleForChildControllerAtIndex:(NSInteger)index;



@end


@interface ERPageViewController : UIViewController

/** 导航选择器高度 */
@property (nonatomic, assign) NSInteger segmentHeight;

@property (nonatomic, assign) NSInteger countOfControllers;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *contentScrollerView;

@property (nonatomic, weak) id<ERPageViewControllerDataSource> dataSource;

/**
 刷新子视图
 */
- (void)reloadPageData;


/**
 移动到某一页面
 
 @param index index
 */
- (void)movePageControllerToIndex:(NSInteger)index;
@end










