//
//  TwoViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "TwoViewController.h"
#import "ERPageViewController.h"
#import "ERSegmentController.h"
#import "ERSegmentCollectionViewCell.h"

@interface TwoViewController ()<ERPageViewControllerDataSource,ERPageViewControllerDelegte>

@property (nonatomic, strong) NSMutableArray <UIViewController *>*childVCArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.titleArray = @[@"One",@"Two",@"Four",@"Three",@"One",@"One",@"Two",@"Four",@"Three",@"One"];
    
    for (NSString *className in self.titleArray) {
        UIViewController *vc = [[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",className]) alloc] init];
        [self.childVCArray addObject:vc];
    }

    ERSegmentController *pageVC = [[ERSegmentController alloc] init];
    pageVC.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
    pageVC.progressWidth = 30;
    pageVC.normalTextFont = [UIFont systemFontOfSize:12];
    pageVC.selectedTextFont = [UIFont systemFontOfSize:15];
    pageVC.normalTextColor = [UIColor blueColor];
    pageVC.selectedTextColor = [UIColor orangeColor];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
}

- (NSMutableArray <UIViewController *>*)childVCArray{
    if (!_childVCArray) {
        _childVCArray = [[NSMutableArray alloc] init];
    }
    return _childVCArray;
}

- (NSInteger)numberOfControllersInPageViewController:(ERPageViewController *)pageViewController{
    return self.childVCArray.count;
}

- (UIViewController *)pageViewController:(ERPageViewController *)pageViewController childControllerAtIndex:(NSInteger)index{
    return self.childVCArray[index];
}

- (NSString *)pageViewController:(ERPageViewController *)pageViewController titleForChildControllerAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%@  d", self.titleArray[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
