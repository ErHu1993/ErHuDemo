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

@interface TwoViewController ()<ERPageViewControllerDataSource,ERSegmentControllerDelegte>

@property (nonatomic, strong) NSMutableArray <UIViewController *>*childVCArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.titleArray = @[@"One",@"Two",@"Four",@"Three",@"One",@"One",@"Two",@"Four",@"Three",@"One",@"Three"];
    
    for (NSString *className in self.titleArray) {
        UIViewController *vc = [[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",className]) alloc] init];
        [self.childVCArray addObject:vc];
    }

    ERSegmentController *pageVC = [[ERSegmentController alloc] init];
    pageVC.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
    pageVC.segmentHeight = 25;
    pageVC.progressWidth = 15;
    pageVC.progressHeight = 1;
    pageVC.itemMinimumSpace = 10;
    pageVC.normalTextFont = [UIFont systemFontOfSize:12];
    pageVC.selectedTextFont = [UIFont systemFontOfSize:16];
    pageVC.normalTextColor = [UIColor blackColor];
    pageVC.selectedTextColor = [UIColor redColor];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
}

#pragma mark - ERPageViewControllerDataSource

- (NSInteger)numberOfControllersInPageViewController:(ERPageViewController *)pageViewController{
    return self.childVCArray.count;
}

- (UIViewController *)pageViewController:(ERPageViewController *)pageViewController childControllerAtIndex:(NSInteger)index{
    return self.childVCArray[index];
}

- (NSString *)pageViewController:(ERPageViewController *)pageViewController titleForChildControllerAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%@", self.titleArray[index]];
}

#pragma mark - ERSegmentControllerDelegte

- (void)segmentController:(ERSegmentController *)segmentController didSelectEditMenuButton:(UIButton *)editMenuButton{
    
    editMenuButton.selected = !editMenuButton.selected;
    
    CGFloat angle = editMenuButton.selected ? M_PI * 0.25 : - M_PI * 0.25;
    //旋转动画
    [UIView animateWithDuration:0.25 animations:^{
        segmentController.editMenuIconIgV.transform = CGAffineTransformRotate(segmentController.editMenuIconIgV.transform, angle);
    }];
}

- (void)segmentController:(ERSegmentController *)segmentController didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *currentVC = self.childVCArray[indexPath.item];
    NSLog(@"currentVC: %@ , index : %ld",currentVC,indexPath.item);
}

- (void)segmentController:(ERSegmentController *)segmentController itemDoubleClickAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *currentVC = self.childVCArray[indexPath.item];
    NSLog(@"双击了,可刷新 currentVC: %@ , index : %ld",currentVC,indexPath.item);
}

- (void)pageControllerDidScroll:(ERPageViewController *)pageController fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    UIViewController *currentVC = self.childVCArray[toIndex];
    NSLog(@"滚动切换 完成 currentVC: %@ , fromIndex : %ld  toindex : %ld",currentVC,fromIndex,toIndex);
}

#pragma mark - getter/setter

- (NSMutableArray <UIViewController *>*)childVCArray{
    if (!_childVCArray) {
        _childVCArray = [[NSMutableArray alloc] init];
    }
    return _childVCArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
