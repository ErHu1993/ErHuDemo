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
    pageVC.dataSource = self;
    pageVC.delegate = self;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
    
    
//    [btn addTapGestureBlock:^{
//        switch (random() % 5) {
//            case 1:
//            {
//                [self.childVCArray addObject:[[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",@"Three"]) alloc] init]];
//            }
//                break;
//                
//            case 3:
//            {
//                [self.childVCArray removeObjectAtIndex:0];
//            }
//                break;
//            default:
//            {
//                [self.childVCArray exchangeObjectAtIndex:self.childVCArray.count - 1 withObjectAtIndex:0];
//            }
//                break;
//        }
//        [pageVC reloadData];
//    }];
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
    return [NSString stringWithFormat:@"%@", self.titleArray[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
