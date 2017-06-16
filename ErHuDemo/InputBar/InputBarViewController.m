//
//  InputBarViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/15.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "InputBarViewController.h"

@interface InputBarViewController ()

@end

@implementation InputBarViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    if (self.view.superview) {
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat changeHeight = endFrame.origin.y - beginFrame.origin.y;
        changeHeight = changeHeight < 0 ?  -changeHeight : 0;
        
        self.view.sd_resetLayout.leftSpaceToView(self.view.superview, 0).rightSpaceToView(self.view.superview, 0).bottomSpaceToView(self.view.superview, changeHeight).heightIs(80);
        
        [UIView animateWithDuration:duration animations:^{
            [self.view.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
