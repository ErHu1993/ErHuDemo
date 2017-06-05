//
//  PKShortVideoWriter.h
//  DevelopWriterDemo
//
//  Created by huguangyu on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShortVideoRecorder;

@protocol ShortVideoRecorderDelegate <NSObject>

@required

- (void)recorderDidBeginRecording:(ShortVideoRecorder *)recorder;
- (void)recorderDidEndRecording:(ShortVideoRecorder *)recorder;
- (void)recorder:(ShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error;

@end



@class AVCaptureVideoPreviewLayer;

@interface ShortVideoRecorder : NSObject

@property (nonatomic, weak) id<ShortVideoRecorderDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize;

- (void)refreshNewFilePath:(NSString *)newFilePath;

- (AVCaptureVideoOrientation)getRecordingOrientation;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;

- (void)swapFrontAndBackCameras;

- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

NS_ASSUME_NONNULL_END


