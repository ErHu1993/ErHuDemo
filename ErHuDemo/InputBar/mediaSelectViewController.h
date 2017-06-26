//
//  mediaSelectViewController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/16.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputBarViewController.h"
@interface mediaSelectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bottomChooseView;

@property (weak, nonatomic) IBOutlet UIView *maskGrayView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

- (void)show;

- (void)dismissWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

- (void)showWithInputBar:(InputBarViewController *)inputBar;
@end
