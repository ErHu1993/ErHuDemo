//
//  TwoViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "TwoViewController.h"
#import "ERSegmentController.h"
#import "NSString+ERCategory.h"

@interface TwoViewController ()<ERPageViewControllerDataSource,ERSegmentControllerDelegte, ERSegmentMenuControllerDataSource>

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *displayArray;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *unDisplayArray;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self prepareData];
    
    [self addSegmentController];
}

- (void)prepareData{
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
        [dic setValue:@(i + displayTitlesArry.count) forKey:@"tag"];
        [dic setValue:[[NSClassFromString([NSString stringWithFormat:@"Page%@ViewController",undisplayTitlesArry[i]]) alloc] init] forKey:@"viewController"];
        [self.unDisplayArray addObject:dic];
    }
}

- (void)addSegmentController{
    ERSegmentController *pageManager = [[ERSegmentController alloc] init];
    if (@available(iOS 11.0, *)) {
        pageManager.contentScrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (ScreenHeight == 812) {
            pageManager.view.frame = CGRectMake(0, 64 + 24, ScreenWidth, ScreenHeight - 64 - 24 - 49);
        }else{
            pageManager.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
        }
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
        pageManager.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49);
    }
    pageManager.segmentHeight = 35;//导航条高度
    pageManager.progressWidth = 15;//导航条底横线度宽度
    pageManager.progressHeight = 1;//导航条底横线高
    pageManager.itemMinimumSpace = 10;//导航条item直接的间距
    pageManager.normalTextFont = [UIFont systemFontOfSize:12];//未选中字体大小
    pageManager.selectedTextFont = [UIFont systemFontOfSize:16];//已选中字体大小
    pageManager.normalTextColor = [UIColor blackColor];//未选中字体颜色
    pageManager.selectedTextColor = [UIColor redColor];//已选中字体颜色
    pageManager.dataSource = self;//页面管理数据源
    pageManager.menuDataSource = self;//菜单管理数据源, 如果不设置改代理则没有菜单按钮
    pageManager.editMenuIconIgV.image = [UIImage imageNamed:@"editButtonImage"];//编辑菜单icon
    pageManager.delegate = self;//相关事件返回代理
    [self.view addSubview:pageManager.view];
    [self addChildViewController:pageManager];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
