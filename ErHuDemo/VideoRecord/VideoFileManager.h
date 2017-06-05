//
//  VideoFileManager.h
//  Zing
//
//  Created by 胡广宇 on 2017/3/29.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface VideoFileManager : NSObject
/** 视频路径 */
@property (nonatomic, copy) NSString *currentVideoPath;
/** 视频截图路径 */
@property (nonatomic, copy) NSString *currentThumbnailPath;

/**
 创建一个新的视频路径
 */
- (void)createNewVideoPath;

/**
 删除当前的视频和截图
 */
- (void)deleteVideoFile;

/**
 保存视频缩略图
 
 @param orientation 拍摄时的方向
 */
- (void)saveVideoThumbnailToPhotoLibraryWithOrientation:(AVCaptureVideoOrientation)orientation;

/**
 保存当前的视频
 
 @param completeBlock 完成回调
 */
- (void)saveVideoToPhotoLibraryCompleteBock:(void (^)(BOOL videoWriteResult))completeBlock;
@end
