//
//  mediaSelectViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/16.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "mediaSelectViewController.h"

@interface mediaSelectViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomChooseView;

@property (weak, nonatomic) IBOutlet UIView *maskGrayView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topChooseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomChooseViewHeigh;

@end

@implementation mediaSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskGrayView addGestureRecognizer:tap];
}

- (void)show{
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskGrayView.alpha = 0.2;
        self.buttonsViewHeight.constant = 80;
        self.topChooseHeight.constant = 100;
        self.bottomChooseViewHeigh.constant = 40;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.maskGrayView.alpha = 0;
        self.buttonsViewHeight.constant = 0;
        self.topChooseHeight.constant = 0;
        self.bottomChooseViewHeigh.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
