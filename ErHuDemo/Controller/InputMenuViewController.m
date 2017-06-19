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
@interface InputMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) InputBarViewController *inputBar;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InputMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [backBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.inputBar.view.mas_top).offset(0);
    }];
    
    [self.inputBar.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(50);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",random() % 100];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
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
        [self addChildViewController:self.inputBar];
        [self.view addSubview:_inputBar.view];
    }
    return _inputBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLayoutSubviews{
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.inputBar.view).offset(0);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
