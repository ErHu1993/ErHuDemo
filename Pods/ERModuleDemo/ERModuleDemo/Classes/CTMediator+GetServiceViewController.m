//
//  CTMediator+GetServiceViewController.m
//  Pods
//
//  Created by 胡广宇 on 2017/7/3.
//
//

#import "CTMediator+GetServiceViewController.h"


@implementation CTMediator (GetServiceViewController)

- (UIViewController *)GetServiceViewController_TabBarViewController{
    UIViewController *viewController = [self performTarget:@"ServiceViewController"
                                                    action:@"GetBaseViewController"
                                                    params:@{@"key":@"value"}
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        UIViewController *errorVc = [[UIViewController alloc] init];
        errorVc.view.backgroundColor = [UIColor redColor];
        return errorVc;
    }
}

@end
