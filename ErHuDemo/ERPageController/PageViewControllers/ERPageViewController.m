//
//  ERPageViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERPageViewController.h"

@interface ERPageViewController ()

@property (nonatomic, assign) NSMutableArray *visiblecontrollers;

@end

@implementation ERPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentHeight = 30;
}

/**
 添加子视图控制器
 */
- (void)initializeSubViews{
    
    [self.visiblecontrollers removeAllObjects];
    self.countOfControllers = [self.dataSource numberOfControllersInPageViewController:self];
    for (int i = 0; i < self.countOfControllers; i++) {
        [self addViewController:[self.dataSource pageViewController:self childControllerAtIndex:i] atIndex:i];
    }
    self.contentScrollerView.contentSize = CGSizeMake(self.countOfControllers * CGRectGetWidth(self.contentScrollerView.frame), 0);
    self.contentScrollerView.contentOffset = CGPointMake(self.currentIndex * CGRectGetWidth(self.contentScrollerView.frame), 0);
}

/**
 刷新子视图
 */
- (void)reloadPageData{
    [self initializeSubViews];
}

/**
 移动到某一页面
 
 @param index index
 */
- (void)movePageControllerToIndex:(NSInteger)index{
    if (index < 0 && index > self.countOfControllers) return;
    [self.contentScrollerView setContentOffset:CGPointMake(index * CGRectGetWidth(self.contentScrollerView .frame),0)];
}

#pragma mark - 控制器的增删操作

- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    if (!viewController.parentViewController) {
        [self addChildViewController:viewController];
        viewController.view.frame = [self getControllerFrameWithIndex:index];
        [self.contentScrollerView addSubview:viewController.view];
        [self.visiblecontrollers addObject:viewController];
    }else {
        viewController.view.frame = [self getControllerFrameWithIndex:index];
    }
}

- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    if (viewController.parentViewController) {
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        [self.visiblecontrollers removeObjectAtIndex:index];
    }
}

- (CGRect)getControllerFrameWithIndex:(NSInteger)index{
    return CGRectMake(index * CGRectGetWidth(self.contentScrollerView.frame), 0, CGRectGetWidth(self.contentScrollerView.frame), CGRectGetHeight(self.contentScrollerView.frame));
}

- (void)viewWillLayoutSubviews{
    if (!CGRectEqualToRect(self.contentScrollerView.bounds, self.view.bounds)) {
        self.contentScrollerView.frame = CGRectMake(0, self.segmentHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - self.segmentHeight);
        [self initializeSubViews];
    }
}


#pragma mark - getter/setter

- (UIScrollView *)contentScrollerView{
    if (!_contentScrollerView) {
        _contentScrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentScrollerView.showsHorizontalScrollIndicator = NO;
        _contentScrollerView.showsVerticalScrollIndicator = NO;
        _contentScrollerView.pagingEnabled = YES;
        [self.view addSubview:_contentScrollerView];
    }
    return _contentScrollerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
