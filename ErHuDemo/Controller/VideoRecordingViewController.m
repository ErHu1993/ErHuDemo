//
//  VideoRecordingViewController.m
//  Zing
//
//  Created by 胡广宇 on 2017/3/29.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "VideoRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CircleProgressView.h"
#import "VideoRecordManager.h"
@interface VideoRecordingViewController ()<VideoRecordManagerDelegate>
/** 背景视图 */
@property (nonatomic, strong) UIView *backView;
/** 录制/暂停按钮 */
@property (nonatomic, strong) UIButton *inputButton;
/**  左侧 返回/重录 按钮, */
@property (nonatomic, strong) UIButton *leftButton;
/** 右侧 切换/确认 按钮 */
@property (nonatomic, strong) UIButton *rightButton;
/** 录制管理类 */
@property (nonatomic, strong) VideoRecordManager *manager;
/** 录视频进度条 */
@property (nonatomic, strong) CircleProgressView *recordProgressView;
/** 记录录制时间定时器 */
@property (nonatomic, strong) NSTimer* timer;
/** 记录录制时间 */
@property (nonatomic, assign) CGFloat recordingTime;

@end

@implementation VideoRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.manager openVideo];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.manager closeVideo];
}

/**
 初始化界面
 */
- (void)initSubView{

     self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
     self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    
     self.manager = [[VideoRecordManager alloc] initWithSuperView:self.backView];
    
     self.manager.delegate = self;
    
     self.inputButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2, ScreenHeight - 60 - 30, 60, 60)];
    [self.inputButton setBackgroundImage:[UIImage imageNamed:@"release_video_shooting"] forState:UIControlStateNormal];
    [self.inputButton setBackgroundImage:[UIImage imageNamed:@"release_video_process"] forState:UIControlStateSelected];
    [self.inputButton setBackgroundImage:[UIImage imageNamed:@"release_video_process"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.inputButton setBackgroundImage:[UIImage imageNamed:@"release_video_process"] forState:UIControlStateHighlighted];
    [self.inputButton addTarget:self action:@selector(inputButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.inputButton];
    
     self.recordProgressView = [[CircleProgressView alloc] initWithCenter:self.inputButton.center radius:24 lineColor:[UIColor redColor] lineWidth:6];
    [self.backView addSubview:self.recordProgressView];
    
     self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.inputButton.left - 36 - 44, self.inputButton.top + (self.inputButton.height - 36) / 2 , 36, 36)];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"release_video_down"] forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"release_video_return"] forState:UIControlStateSelected];
    [self.leftButton setShowsTouchWhenHighlighted:false];
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.leftButton];
    
     self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.inputButton.right + 44, self.leftButton.top, 36, 36)];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"release_video_switch"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"release_video_determine"] forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setShowsTouchWhenHighlighted:false];
    [self.backView addSubview:self.rightButton];
}


/**
 录制进度条监听
 */
- (void)progressChange{
    
    self.recordingTime += TimeInterval;
    
    if (self.recordingTime >= VideoRecordMaxTime) {
        self.inputButton.selected = !self.inputButton.selected;
        [self stopVideoRecord];
    }
    self.recordProgressView.progress = self.recordingTime / VideoRecordMaxTime;
}


/**
 开启监听计时器
 */
- (void)startTimer{
    self.recordingTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
}


/**
 停止监听计时器
 */
- (void)timerStop{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 按钮点击 Action

/**
 录制/暂停按钮点击事件

 @param btn btn
 */
- (void)inputButtonClick:(UIButton *)btn{
    if (!btn.selected) {
        [self startVideoRecord];
    }else{
        [self stopVideoRecord];
    }
    
    btn.selected = !btn.selected;
}

/**
 左侧 返回/重录 按钮点击事件
 
 @param btn btn
 */
- (void)leftButtonClick:(UIButton *)btn{
    if (!btn.selected) {
        //返回方法
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //移除重录方法
        [self deleteVideoRecord];
    }
}

/**
 右侧 切换/确认 按钮点击事件
 
 @param btn btn
 */
- (void)rightButtonClick:(UIButton *)btn{
    
    if (!btn.selected) {
        //切换摄像头
        [self.manager exchangeCamera];
    }else{
        //确定按钮  视频或者图片获取失败路径为nil
        [self.manager getVideoAndThumbnailPathWithBlock:^(NSString *videoPath, NSString *thumbnailPath) {
            NSLog(@"视频路径: %@ \n 截图路径:%@",videoPath,thumbnailPath);
        }];
    }
}

#pragma mark - 处理事件


/**
 移除当前视频
 */
- (void)deleteVideoRecord{
     self.inputButton.hidden = false;
     self.recordProgressView.hidden = false; 
     self.recordProgressView.progress = 0;
     self.leftButton.selected = false;
     self.rightButton.selected = false;
    [self.manager deleteVideoRecord];
}


/**
 开始录音
 */
- (void)startVideoRecord{
    [self startTimer];
     self.leftButton.hidden = true;
     self.rightButton.hidden = true;
    [self.manager startVideoRecord];
}


/**
 停止录音
 */
- (void)stopVideoRecord{
    [self timerStop];
     self.inputButton.hidden = true;
     self.recordProgressView.hidden = true;
     self.leftButton.hidden = false;
     self.rightButton.hidden = false;
     self.leftButton.selected = true;
     self.rightButton.selected = true;
     self.recordProgressView.progress = 0;
     [self.manager stopVideoRecordWithSecond:self.recordingTime];
}

#pragma mark - VideoRecordManagerDelegate
- (void)recordTimerTooShort:(VideoRecordManager *)manager{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间不能低于3秒哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [self deleteVideoRecord];
    });
}

- (void)systemVideoEquipmentNotReady{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
         self.recordingTime = 4; //取消提示时间低于3秒
        [self stopVideoRecord];
        [self deleteVideoRecord];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备启动失败~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
