//
//  ViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/1.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ViewController.h"
#import "HandPaintViewController.h"
#import "VideoRecordingViewController.h"
#import "InputMenuViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addConstraints];
}

- (void)addConstraints{
    self.tableView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArray[indexPath.row] isEqualToString:@"手绘"]) {
        HandPaintViewController *handPainting = [[HandPaintViewController alloc] init];
        [self presentViewController:handPainting animated:YES completion:nil];
    }else if ([self.dataArray[indexPath.row] isEqualToString:@"视频录制"]){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
                    [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                        if (granted) {
                            
                            NSError *AVAudioSessionCategoryError;
                            
                            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&AVAudioSessionCategoryError];
                            
                            NSError *AVAudioSessionActiveError;
                            
                            [[AVAudioSession sharedInstance] setActive:true error:&AVAudioSessionActiveError];
                            
                            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
                            
                            if (!AVAudioSessionCategoryError && !AVAudioSessionActiveError) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    VideoRecordingViewController *recordVC = [[VideoRecordingViewController alloc] init];
                                    [self presentViewController:recordVC animated:YES completion:nil];
                                });
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"错误~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [alertView show];
                                });
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没权限~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alertView show];
                            });
                        }
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没权限~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没权限~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }];
    }else if ([self.dataArray[indexPath.row] isEqualToString:@"菜单选项"]){
        InputMenuViewController *inputVC = [[InputMenuViewController alloc] init];
        UINavigationController *inputNav = [[UINavigationController alloc] initWithRootViewController:inputVC];
        [self presentViewController:inputNav animated:YES completion:nil];
    }else if ([self.dataArray[indexPath.row] isEqualToString:@"Web请求拦截(AJAX,表单)"]){
        
        NSString *URLString = @"http://m.baoxianduoduo.com/QybApp/Channel/QuoteFromChannel?c=977FVCD8&t=0&p=a&u=b2086c4b92124da98664926578adcc28&carNumber=%E7%9A%96A41266&carMasterName=%E5%AE%89%E5%BE%BD%E7%9A%96%E9%80%9A%E7%A7%91%E6%8A%80%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8&carIdentifiedCode=LL3BBADD0CA003251&engineNumber=FC5LAC00369&m=0e2d24619566ece2d02fc06257fe1197";
        
        NSString *b = @"http://m.baoxianduoduo.com/QybApp/Channel/QuoteFromChannel?c=977FVCD8&t=0&p=a&u=5299832dd9ab45959b5de72f8a219a46&carNumber=%E7%9A%96AUU410&carMasterName=%E6%B1%AA%E7%AB%B9%E5%8D%8E&carMasterIDNum=340822198901285514&carIdentifiedCode=LBEGCBFCXFX062053&engineNumber=FB343592&m=a479576b9cd627bacce0672c718c581c";
        NSString *baidu = @"https://www.baidu.com";
        WKWebViewController *webVC = [[WKWebViewController alloc] initWthUrlString:b title:@"我设置的标题"];
        UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webVC];
        [self presentViewController:webNav animated:YES completion:nil];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"手绘",@"视频录制",@"菜单选项",@"WKWebview监听Protocol请求拦截(AJAX,表单) ~还未完成"];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
