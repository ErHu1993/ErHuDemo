//
//  VideoFileManager.h
//  Zing
//
//  Created by 胡广宇 on 2017/3/29.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "VideoFileManager.h"
#import <Photos/Photos.h>
#define FILE_PROJECT_NAME @"recordVideos"

@interface VideoFileManager ()
/** 基本视频路径 */
@property (nonatomic, copy) NSString *baseVideoPath;

@end

@implementation VideoFileManager

/**
 初始化文件路径并创建文件夹

 @return self
 */
- (instancetype)init{
    if (self = [super init]) {
        self.baseVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:FILE_PROJECT_NAME];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.baseVideoPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.baseVideoPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"创建文件夹失败:%@",error);
            }
        }
    }
    return self;
}

/**
 创建一个新的视频路径
 */
- (void)createNewVideoPath{
    NSString *currentTime = [self getNowDateString];
    self.currentVideoPath =  [self.baseVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",currentTime]];
    self.currentThumbnailPath = [self.baseVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",currentTime]];
    NSLog(@"视频路径:%@\n视频缩略图路径%@",self.currentVideoPath,self.currentThumbnailPath);
}

/**
 获取当前时间
 
 @return 年月日时分秒
 */
- (NSString*)getNowDateString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy_MM_dd_HH_mm_ss";
    NSString* nowTimeStr = [formatter stringFromDate:[NSDate date]];
    return nowTimeStr;
}

/**
 删除当前的视频和截图
 */
- (void)deleteVideoFile{
    
    NSError *error = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:self.currentVideoPath error:&error];
    if (error) {
        NSLog(@"删除视频失败:%@",error);
    }else{
        NSLog(@"成功删除视频");
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:self.currentThumbnailPath error:&error];
    if (error) {
        NSLog(@"删除缩略图失败:%@",error);
    }else{
        NSLog(@"成功删除缩略图");
    }
}

/**
 保存视频缩略图
 
 @param orientation 拍摄时的方向
 */
- (void)saveVideoThumbnailToPhotoLibraryWithOrientation:(AVCaptureVideoOrientation)orientation{
    
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.currentVideoPath]];
    
    int totalSeconds = ceil([urlSet duration].value / [urlSet duration].timescale);
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    CMTime time = CMTimeMakeWithSeconds(totalSeconds / 2, 600);
    
    NSError *error = nil;
    
    CGImageRef cgimage = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
    
    NSLog(@"视频缩略图获取结果 :%d",!error);
    
    if (error) return;
    
    UIImageOrientation imageOrientation = UIImageOrientationUp;
    
    switch (orientation) {
        case AVCaptureVideoOrientationLandscapeLeft:
        {
            imageOrientation = UIImageOrientationRight;
        }
            break;
        case AVCaptureVideoOrientationLandscapeRight:
        {
            imageOrientation = UIImageOrientationRight;
        }
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
        {
            imageOrientation  = UIImageOrientationRight;
        }
            break;
        case AVCaptureVideoOrientationPortrait:
        {
            imageOrientation = UIImageOrientationRight;
        }
            break;
    }
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgimage scale:1 orientation:imageOrientation];
    
    NSLog(@"imageOrientation %ld",resultImage.imageOrientation);
    
    NSData *imgData = UIImageJPEGRepresentation(resultImage, 1.0);
    
    BOOL imageWriteResult = [imgData writeToFile:self.currentThumbnailPath atomically: YES];
    
    NSLog(@"缩略图写入结果:%d",imageWriteResult);
    
    CGImageRelease(cgimage);
}

/**
  保存当前的视频

 @param completeBlock 完成回调
 */
- (void)saveVideoToPhotoLibraryCompleteBock:(void (^)(BOOL videoWriteResult))completeBlock{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status== PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:self.currentVideoPath]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (!error && success) {
                    
                    NSLog(@"视频保存相册成功!");
                    
                    NSError *error = nil;
                    
                    NSDictionary *attri = [[NSFileManager defaultManager] attributesOfItemAtPath:self.currentVideoPath error:&error];
                    
                    if (error) {
                        NSLog(@"视频读取失败! error:%@",error);
                    }else{
                        NSLog(@"%@",[NSString stringWithFormat:@"视频总大小:%.2fM",attri.fileSize/(1024.0 * 1024.0)]);
                    }
                    
                }else{
                    NSLog(@"视频保存相册失败! :%@",error);
                }
                
                if (completeBlock) {
                    completeBlock(!error && success);
                }
                
            }];
        }
    }];
}

@end
