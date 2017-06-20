//
//  mediaSelectViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/16.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "mediaSelectViewController.h"

@interface mediaSelectViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topChooseHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomChooseViewHeigh;

@property (nonatomic, strong) UIView *backGroundBlurView;

@end

@implementation mediaSelectViewController

- (void)dealloc{
    NSLog(@"%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews{
    
    __weak typeof(self)weakSelf = self;
    [self.maskGrayView addTapGestureBlock:^{
        [weakSelf dismissWithAnimations:^{
            weakSelf.backGroundBlurView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.backGroundBlurView removeFromSuperview];
        }];
    }];

    [self.contentView addTapGestureBlock:^{
        [weakSelf dismissWithAnimations:^{
            weakSelf.backGroundBlurView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.backGroundBlurView removeFromSuperview];
        }];
    }];
    
    [self.buttonsView addTapGestureBlock:^{
        [weakSelf dismissWithAnimations:^{
            weakSelf.backGroundBlurView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.backGroundBlurView removeFromSuperview];
        }];
    }];
}

- (void)show:(UIView *)backGroundBlurView{
    
    self.backGroundBlurView = backGroundBlurView;
    
    if (!self.backGroundBlurView.superview) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.backGroundBlurView];
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backGroundBlurView.alpha = 0.2;
        self.buttonsViewHeight.constant = 80;
        self.topChooseHeight.constant = 100;
        self.bottomChooseViewHeigh.constant = 40;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:0.25 animations:^{
        if (animations) {
            animations();
        }
        self.buttonsViewHeight.constant = 0;
        self.topChooseHeight.constant = 0;
        self.bottomChooseViewHeigh.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
