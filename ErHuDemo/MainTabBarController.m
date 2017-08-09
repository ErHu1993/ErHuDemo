//
//  MainTabBarController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "MainTabBarController.h"
#import "ViewController.h"
#import "TwoViewController.h"
#import <ERModuleDemo/CTMediator+GetServiceViewController.h>

static NSString *rotationAnimationKey = @"TabBarButtonTransformRotationAnimationKey";

@interface MainTabBarController ()<UITabBarControllerDelegate>

/**
 上一次点击时间(用于判断双击刷新)
 */
@property (nonatomic, strong) NSDate *lastDate;

/**
 旋转动画
 */
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    [self setupControllers];
    
//    self.selectedIndex = 1;
}

- (void)setupControllers
{
    [self setupController:[[ViewController alloc]init] image:@"me_normal" selectedImage:@"me_selected" title:@"List"];
    
    [self setupController:[[TwoViewController alloc]init] image:@"me_normal" selectedImage:@"me_selected" title:@"双击我"];
    
    [self setupController:[[CTMediator sharedInstance] GetServiceViewController_TabBarViewController] image:@"me_normal" selectedImage:@"me_selected" title:@"第三方组件"];
}

//设置控制器
-(void)setupController:(UIViewController *)childVc
                 image:(NSString *)image
         selectedImage:(NSString *)selectedImage
                 title:(NSString *)title {
    
    UIViewController *viewVc = childVc;
    if (image.length) viewVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (selectedImage.length) viewVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.title = title;
    [viewVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    [viewVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewVc];
    [self addChildViewController:navi];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSDate *nowDate = [[NSDate alloc] init];
    
    UIViewController *nowVc = viewController.childViewControllers.firstObject;
    
    if ([nowVc isKindOfClass:[TwoViewController class]]) {
        
        if (nowDate.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.2f) {
            // 通过时间判断双击事件
            UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:viewController];
            
            if (tabBarSwappableImageView) {
                
                if (![[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey])  {
                    
                    //选中和未选中的image都需要更改为刷新中的图，不然会出现正在刷新时切换TabBar导致未选中的图片在旋转
                    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    viewController.tabBarItem.image = [[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    [self addTabBarButtonRotationAnimationWithCurrentViewController:viewController];
                    
                    if ([nowVc isKindOfClass:[TwoViewController class]]) {
                        //页面数据刷新
                        NSLog(@"刷新该页面");
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeTabBarButtonRotationAnimationWithCurrentViewController:nowVc];
                        });
                    }
                    
                }
                
            }
            
        }
        
        self.lastDate = nowDate;
    }
    return YES;
}

/**
 旋转动画
 
 @return CABasicAnimation 动画
 */
- (CABasicAnimation *)rotationAnimation{
    if (!_rotationAnimation) {
        //指定动画属性
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //单次动画时间
        _rotationAnimation.duration = 0.7;
        //重复次数
        _rotationAnimation.repeatCount= 99;
        //开始角度
        _rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        //结束角度
        _rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        // 是否在动画结束后移除动画
        _rotationAnimation.removedOnCompletion = NO;
    }
    return _rotationAnimation;
}


/**
 获取当前TabBarItem中的ImageView
 
 @param currentViewController 当前ViewController
 @return TabBarItem中的ImageView
 */
- (UIImageView *)getTabBarButtonImageViewWithCurrentVc:(UIViewController *)currentViewController{
    
    UIControl *tabBarButton = [currentViewController.tabBarItem valueForKey:@"view"];
    if (tabBarButton) {
        UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
        if (tabBarSwappableImageView) {
            return tabBarSwappableImageView;
        }
    }
    return nil;
}

/**
 添加旋转动画
 
 @param currentViewController 当前ViewController
 */
- (void)addTabBarButtonRotationAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        [[tabBarSwappableImageView layer] addAnimation:self.rotationAnimation forKey:rotationAnimationKey];
    }
}

/**
 移除旋转动画
 
 @param currentViewController 当前ViewController
 */
- (void)removeTabBarButtonRotationAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        
        if ([[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey]) {
            
            [[tabBarSwappableImageView layer] removeAnimationForKey:rotationAnimationKey];
            
        }
    }
    
    //移除后重新更换选中和未选中的图片
    if ([currentViewController isKindOfClass:[TwoViewController class]]) {
        currentViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        currentViewController.tabBarItem.image = [[UIImage imageNamed:@"me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
