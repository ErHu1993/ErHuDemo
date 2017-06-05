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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
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
    }
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"手绘",@"视频录制"];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
