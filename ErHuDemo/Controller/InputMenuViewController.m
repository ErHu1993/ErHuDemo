//
//  InputMenuViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/15.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "InputMenuViewController.h"
#import "InputBarViewController.h"
#import "SDAutoLayout.h"
@interface InputMenuViewController ()

@property (nonatomic, strong) InputBarViewController *inputBar;

@end

@implementation InputMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self addConstraints];
}

- (void)setupSubViews{
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    [backBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)addConstraints{
    self.inputBar.view.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(80);
}


- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

#pragma mark - getter/setter

- (InputBarViewController *)inputBar{
    if (!_inputBar) {
        _inputBar = [[InputBarViewController alloc] initWithNibName:@"InputBarViewController" bundle:[NSBundle mainBundle]];
        [self addChildViewController:_inputBar];
        [self.view addSubview:_inputBar.view];
    }
    return _inputBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
