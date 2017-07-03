//
//  Target_ServiceViewController.m
//  Pods
//
//  Created by 胡广宇 on 2017/7/3.
//
//

#import "Target_ServiceViewController.h"
#import "BaseViewController.h"

@implementation Target_ServiceViewController

- (BaseViewController *)Action_GetBaseViewController:(NSDictionary *)param;{
    NSLog(@"get parameter : %@",param);
    return [[BaseViewController alloc] init];
}

@end
