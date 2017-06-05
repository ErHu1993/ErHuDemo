//
//  AssetWriter.h
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/17.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShortVideoSessionDelegate;

@interface ShortVideoSession : NSObject

@property (nonatomic, readonly) BOOL videoInitialized;
@property (nonatomic, readonly) BOOL audioInitialized;

@property (nonatomic, weak) id<ShortVideoSessionDelegate> delegate;

- (instancetype)initWithTempFilePath:(NSString *)tempFilePath;

- (void)refreshNewFilePath:(NSString *)newFilePath;

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings;
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)prepareToRecord;
- (void)finishRecording;

@end


@protocol ShortVideoSessionDelegate <NSObject>

- (void)sessionDidFinishPreparing:(ShortVideoSession *)session;
- (void)session:(ShortVideoSession *)session didFailWithError:(NSError *)error;
- (void)sessionDidFinishRecording:(ShortVideoSession *)session;

@end

NS_ASSUME_NONNULL_END


