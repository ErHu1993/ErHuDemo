//
//  VideoRecordManager.h
//  Zing
//
//  Created by 胡广宇 on 2017/3/29.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat VideoRecordMaxTime = 15; //视频最大时长 (单位/秒)
static CGFloat VideoRecordMinTime = 3;  //最短视频时长 (单位/秒)
static CGFloat TimeInterval = 0.05;  //定时器请求间隔

@protocol VideoRecordManagerDelegate;

@interface VideoRecordManager : NSObject
/**
 初始化
 
 @param superView 父视图
 @return self
 */
- (instancetype)initWithSuperView:(UIView *)superView;

/**
 录像管理类代理
 */
@property (nonatomic, weak) id<VideoRecordManagerDelegate>delegate;
    
/**
 开启摄像
 */
- (void)openVideo;

/**
 关闭摄
 */
- (void)closeVideo;

/**
 切换摄像头
 */
- (void)exchangeCamera;

/**
 停止录像

 @param second 当前定时器记录的时间
 */
- (void)stopVideoRecordWithSecond:(CGFloat)second;

/**
 开始录像
 */
- (void)startVideoRecord;

/**
 删除录像
 */
- (void)deleteVideoRecord;

/**
 获取视频数据路径
 
 @param callback 回调
 */
- (void)getVideoAndThumbnailPathWithBlock:(void (^)(NSString *videoPath , NSString *thumbnailPath))callback;

@end

@protocol VideoRecordManagerDelegate <NSObject>

@optional;

/**
 视频录制过短代理

 @param manager self
 */
- (void)recordTimerTooShort:(VideoRecordManager *)manager;


/**
 视频录制启动失败回调
 */
- (void)systemVideoEquipmentNotReady;

@end
