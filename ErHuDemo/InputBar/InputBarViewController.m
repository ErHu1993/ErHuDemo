//
//  InputBarViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/15.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "InputBarViewController.h"
#import "mediaSelectViewController.h"
@interface InputBarViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *mediaButton;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) mediaSelectViewController *mediaSelectVC;

@property (nonatomic, assign) BOOL showMediaSelects;

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

#pragma mark - 更多媒体点击

- (IBAction)mediaButtonClick:(UIButton *)sender {
    if (self.view.top != ScreenHeight - self.view.height) {
        self.showMediaSelects = true;
        [self.view endEditing:YES];
    }else{
        [self.mediaSelectVC show];
    }
}

- (IBAction)sendButtonClick:(id)sender {
    
}

- (mediaSelectViewController *)mediaSelectVC{
    if (!_mediaSelectVC) {
        _mediaSelectVC = [[mediaSelectViewController alloc] initWithNibName:@"mediaSelectViewController" bundle:[NSBundle mainBundle]];
        _mediaSelectVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _mediaSelectVC;
}

#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    if (self.view.superview) {
        
        [self.view.superview bringSubviewToFront:self.view];
        
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat changeHeight = endFrame.origin.y - beginFrame.origin.y;
        changeHeight = changeHeight < 0 ?  changeHeight : 0;
        
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.superview).offset(changeHeight);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [self.view.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.showMediaSelects) {
                self.showMediaSelects = false;
                [self.mediaSelectVC show];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
