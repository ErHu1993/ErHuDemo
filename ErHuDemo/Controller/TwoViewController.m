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

@interface TwoViewController ()<ERPageViewControllerDataSource,ERSegmentControllerDelegte,ERSegmentMenuControllerDataSource>

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *displayArray;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *unDisplayArray;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    NSArray *displayTitlesArry  = @[@"Two",@"Two",@"Two",@"Two",@"Four",@"Four",@"Four",@"Four",@"Three",@"Three",@"Three"];
    
    self.displayArray = [NSMutableArray arrayWithCapacity:displayTitlesArry.count];
    
    for (int i = 0; i < displayTitlesArry.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:displayTitlesArry[i] forKey:@"name"];
        [dic setValue:@(i) forKey:@"tag"];
        [dic setValue:[[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",displayTitlesArry[i]]) alloc] init] forKey:@"viewController"];
        [self.displayArray addObject:dic];
    }
    
    NSArray *undisplayTitlesArry  = @[@"One",@"One",@"One",@"One"];
    
    self.unDisplayArray = [NSMutableArray arrayWithCapacity:undisplayTitlesArry.count];
    
    for (int i = 0; i < undisplayTitlesArry.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:undisplayTitlesArry[i] forKey:@"name"];
        [dic setValue:@(i + displayTitlesArry.count + 1) forKey:@"tag"];
        [dic setValue:[[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",undisplayTitlesArry[i]]) alloc] init] forKey:@"viewController"];
        [self.unDisplayArray addObject:dic];
    }

    ERSegmentController *pageVC = [[ERSegmentController alloc] init];
    pageVC.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
    pageVC.segmentHeight = 25;
    pageVC.progressWidth = 15;
    pageVC.progressHeight = 1;
    pageVC.itemMinimumSpace = 10;
    pageVC.editMenuIconIgV.image = [UIImage imageNamed:@"editButtonImage"];
    pageVC.normalTextFont = [UIFont systemFontOfSize:12];
    pageVC.selectedTextFont = [UIFont systemFontOfSize:16];
    pageVC.normalTextColor = [UIColor blackColor];
    pageVC.selectedTextColor = [UIColor redColor];
    pageVC.dataSource = self;
    pageVC.menuDataSource = self;
    pageVC.delegate = self;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
}

#pragma mark - ERSegmentMenuControllerDataSource

- (NSMutableArray <NSDictionary *> *)selectedChannelLisInSegmentMenuController:(ERSegmentMenuController *)segmentMenuController{
    
    return self.displayArray;
}

- (NSMutableArray <NSDictionary *> *)unSelectChannelListInSegmentMenuController:(ERSegmentMenuController *)segmentMenuController{
    return self.unDisplayArray;
}

#pragma mark - ERPageViewControllerDataSource

- (NSInteger)numberOfControllersInPageViewController:(ERPageViewController *)pageViewController{
    return self.displayArray.count;
}

- (UIViewController *)pageViewController:(ERPageViewController *)pageViewController childControllerAtIndex:(NSInteger)index{
    return [self.displayArray[index] valueForKey:@"viewController"];
}

- (NSString *)pageViewController:(ERPageViewController *)pageViewController titleForChildControllerAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%@", [self.displayArray[index] valueForKey:@"name"]];
}

#pragma mark - ERSegmentControllerDelegte

- (void)segmentController:(ERSegmentController *)segmentController didSelectEditMenuButton:(UIButton *)editMenuButton{
        
    CGFloat angle = editMenuButton.selected ? M_PI * 0.25 : - M_PI * 0.25;
    //旋转动画
    [UIView animateWithDuration:0.25 animations:^{
        segmentController.editMenuIconIgV.transform = CGAffineTransformRotate(segmentController.editMenuIconIgV.transform, angle);
    }];
}

- (void)segmentController:(ERSegmentController *)segmentController didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *currentVC = [self.displayArray[indexPath.item] valueForKey:@"viewController"];
    NSLog(@"currentVC: %@ , index : %ld",currentVC,indexPath.item);
}

- (void)segmentController:(ERSegmentController *)segmentController itemDoubleClickAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *currentVC = [self.displayArray[indexPath.item] valueForKey:@"viewController"];
    NSLog(@"双击了,可刷新 currentVC: %@ , index : %ld",currentVC,indexPath.item);
}

- (void)pageControllerDidScroll:(ERPageViewController *)pageController fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    UIViewController *currentVC = [self.displayArray[toIndex] valueForKey:@"viewController"];
    NSLog(@"滚动切换 完成 currentVC: %@ , fromIndex : %ld  toindex : %ld",currentVC,fromIndex,toIndex);
}

#pragma mark - getter/setter

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
