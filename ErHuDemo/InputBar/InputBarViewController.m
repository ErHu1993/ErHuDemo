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

@property (nonatomic, strong) UIVisualEffectView *blurBgView;

@property (nonatomic, strong) mediaSelectViewController *mediaSelectVC;

@property (nonatomic, assign) BOOL showMediaSelects;

@end

@implementation InputBarViewController

- (void)dealloc{
    NSLog(@"=== %@ dealloced! ===", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self setupSubViews];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubViews{
    __weak typeof(self)weakSelf = self;
    [self.containerView addTapGestureBlock:^{
        
        weakSelf.ContainerViewHeight.constant = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.view layoutIfNeeded];
            [weakSelf.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.ControlViewHeight.constant + self.ContainerViewHeight.constant);
            }];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - 更多媒体点击

- (IBAction)mediaButtonClick:(UIButton *)sender {    
    if (self.view.top != ScreenHeight - self.view.height) {
        self.showMediaSelects = true;
        [self.view endEditing:YES];
    }else{
        [self.mediaSelectVC show:self.blurBgView];
    }
}

- (IBAction)sendButtonClick:(id)sender {
    
    UIImageView *containnerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 150) / 2, 10, 150, 200)];
    containnerImageView.image = [UIImage imageNamed:@"Launch_640_960"];
    self.ContainerViewHeight.constant = containnerImageView.height + containnerImageView.top * 2;
    [self.containerView addSubview:containnerImageView];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.ControlViewHeight.constant + self.ContainerViewHeight.constant);
        }];
    }];
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
                [self.mediaSelectVC show:self.blurBgView];
            }
        }];
    }
}

#pragma mark - getter/setter

- (mediaSelectViewController *)mediaSelectVC{
    if (!_mediaSelectVC) {
        _mediaSelectVC = [[mediaSelectViewController alloc] initWithNibName:@"mediaSelectViewController" bundle:[NSBundle mainBundle]];
        _mediaSelectVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _mediaSelectVC;
}

- (UIVisualEffectView *)blurBgView {
    if (!_blurBgView) {
        UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurBgView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        _blurBgView.alpha = 0;
        _blurBgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _blurBgView;
}

- (void)viewDidLayoutSubviews{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
