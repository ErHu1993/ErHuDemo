//
//  VideoRecordManager.h
//  Zing
//
//  Created by 胡广宇 on 2017/3/29.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 开启摄像头
 */
- (void)openVideo;

/**
 关闭摄像头
 */
- (void)closeVideo;

/**
 切换摄像头
 */
- (void)exchangeCamera;

/**
 开始录像
 */
- (void)startVideoRecord;

/**
 停止录像
 */
- (void)stopVideoRecord;

/**
 删除录像
 */
- (void)deleteVideoRecord;

/**
 获取视频数据路径
 
 @param callback 回调
 */
- (void)getVideoAndThumbnailPathWithBlock:(void (^)(NSString *videoPath , NSString *thumbnailPath))callback;


/**
 获取视频时长
 
 @return 时长
 */
- (CGFloat)getRecordTime;

@end

@protocol VideoRecordManagerDelegate <NSObject>

@optional;

/**
 视频录制过短代理
 
 @param manager self
 */
- (void)recordTimerTooShort:(VideoRecordManager *)manager;

/**
 录制视频时间结束
 
 @param manager self
 */
- (void)recordTimerEnd:(VideoRecordManager *)manager;


/**
 录制进度改变
 
 @param progress progress(0 ~ 1)
 */
- (void)recordProgressChange:(CGFloat)progress;

@end
