//
//  ShortVideoWriter.m
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "ShortVideoRecorder.h"
#import "ShortVideoSession.h"
#import <CoreMotion/CoreMotion.h> 

typedef NS_ENUM( NSInteger, RecordingStatus ) {
    RecordingStatusIdle = 0,
    RecordingStatusStartingRecording,
    RecordingStatusRecording,
    RecordingStatusStoppingRecording,
}; 

@interface ShortVideoRecorder() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, ShortVideoSessionDelegate>

@property (nonatomic, copy) NSString *outputFilePath;

@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) dispatch_queue_t recorderQueue;

@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t audioDataOutputQueue;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;

@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;

@property (nonatomic, assign) RecordingStatus recordingStatus;

@property (nonatomic, retain) ShortVideoSession *assetSession;

@property (nonatomic, strong) CMMotionManager* montionManager;

@property (nonatomic, assign) BOOL shouldUpdateOrientation;

@property (nonatomic, assign) AVCaptureVideoOrientation currentOrientation;

@property (nonatomic, assign) AVCaptureDevicePosition currentPosition;

@end

@implementation ShortVideoRecorder

- (void)dealloc {
    [_assetSession finishRecording];
    [self endUpdateCurrentOrientation];
    [self stopRunning];
}


#pragma mark - Init

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize {
    self = [super init];
    if (self) {
        _outputFilePath = outputFilePath;
        _outputSize = outputSize;
        
        _recorderQueue = dispatch_queue_create("com.ShortVideoWriter.sessionQueue", DISPATCH_QUEUE_SERIAL );
        
        _audioDataOutputQueue = dispatch_queue_create("com.ShortVideoWriter.audioOutput", DISPATCH_QUEUE_SERIAL );

        _videoDataOutputQueue = dispatch_queue_create("com.ShortVideoWriter.videoOutput", DISPATCH_QUEUE_SERIAL );
        
        dispatch_set_target_queue(_videoDataOutputQueue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
        
        //监听当前屏幕方向
        self.montionManager = [[CMMotionManager alloc] init];

        [self addDataOutputsToCaptureSession:self.captureSession];
    }
    return self;
}

- (void)startUpdateCurrentOrientation{
    self.shouldUpdateOrientation = YES;
    if([self.montionManager isDeviceMotionAvailable]) {
        [self.montionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (self.shouldUpdateOrientation) {
                if (accelerometerData.acceleration.x < 0.75 && accelerometerData.acceleration.x > -0.75) {
                    if (accelerometerData.acceleration.y < 0) {
                        if (self.currentOrientation != AVCaptureVideoOrientationPortrait) {
                            self.currentOrientation = AVCaptureVideoOrientationPortrait;
                        }
                    }else if (accelerometerData.acceleration.y >= 0.75){
                        if (self.currentOrientation != AVCaptureVideoOrientationPortraitUpsideDown) {
                            self.currentOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                        }
                    }
                }else if (accelerometerData.acceleration.y < 0.75 && accelerometerData.acceleration.y > -0.75) {
                    if (accelerometerData.acceleration.x > 0.75) {
                        if (self.currentOrientation != AVCaptureVideoOrientationLandscapeLeft) {
                            self.currentOrientation = AVCaptureVideoOrientationLandscapeLeft;
                        }
                    }else if(accelerometerData.acceleration.x < -0.75){
                        if (self.currentOrientation != AVCaptureVideoOrientationLandscapeRight) {
                            self.currentOrientation = AVCaptureVideoOrientationLandscapeRight;
                        }
                    }
                }else {
                    return;
                }
            }
        }];
    }
}

- (void)endUpdateCurrentOrientation{
    NSLog(@"结束监听设备方向");
    [self.montionManager stopAccelerometerUpdates];
}

- (void)refreshNewFilePath:(NSString *)newFilePath{
    self.outputFilePath = newFilePath;
    [self.assetSession refreshNewFilePath:newFilePath];
}

- (AVCaptureVideoOrientation)getRecordingOrientation{
    return self.currentOrientation;
}

#pragma mark - Running Session

- (void)startRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self.captureSession startRunning];
        NSLog(@"开始监听设备方向");
        [self startUpdateCurrentOrientation];
    } );
}

- (void)stopRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self stopRecording];
        [self.captureSession stopRunning];
    } );
}



#pragma mark - Recording

- (void)startRecording {
    if (TARGET_IPHONE_SIMULATOR) {
        NSLog(@"录制视频不支持模拟器");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"录制视频不支持模拟器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    @synchronized(self) {
        if (self.recordingStatus != RecordingStatusIdle) {
            NSLog(@"已经在录制了");
            return;
        }   
        [self transitionToRecordingStatus:RecordingStatusStartingRecording error:nil];
    }
    
    self.shouldUpdateOrientation = false;
    self.assetSession = [[ShortVideoSession alloc] initWithTempFilePath:self.outputFilePath];
    self.assetSession.delegate = self;
    
    if([self.videoConnection isVideoOrientationSupported]) {
        
        switch (self.currentOrientation) {
            case AVCaptureVideoOrientationLandscapeLeft:
            {
                [self.videoConnection setVideoOrientation:self.currentPosition == AVCaptureDevicePositionFront ? AVCaptureVideoOrientationPortraitUpsideDown :AVCaptureVideoOrientationPortrait];
            }
                break;
            case AVCaptureVideoOrientationLandscapeRight:
            {
                [self.videoConnection setVideoOrientation:self.currentPosition == AVCaptureDevicePositionFront ? AVCaptureVideoOrientationPortrait :AVCaptureVideoOrientationPortraitUpsideDown];
            }
                break;
            case AVCaptureVideoOrientationPortraitUpsideDown:
            {
                [self.videoConnection setVideoOrientation:self.currentPosition == AVCaptureDevicePositionFront ? AVCaptureVideoOrientationLandscapeRight :AVCaptureVideoOrientationLandscapeLeft];
            }
                break;
            case AVCaptureVideoOrientationPortrait:
            {
                [self.videoConnection setVideoOrientation:self.currentPosition == AVCaptureDevicePositionFront ? AVCaptureVideoOrientationLandscapeLeft : AVCaptureVideoOrientationLandscapeRight];
            }
                break;
        }
    }
    
    [self endUpdateCurrentOrientation];
    
    [self setCompressionSettings];
    
    [self.assetSession addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription settings:self.videoCompressionSettings];
    [self.assetSession addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioCompressionSettings];
    
    [self.assetSession prepareToRecord];
    
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
}

- (void)stopRecording {
    @synchronized(self) {
        if (self.recordingStatus != RecordingStatusRecording){
            return;
        }
        [self transitionToRecordingStatus:RecordingStatusStoppingRecording error:nil];
    }
    [self.assetSession finishRecording];
}



#pragma mark - SwapCamera

- (void)swapFrontAndBackCameras {
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
                self.currentPosition = AVCaptureDevicePositionBack;
            } else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
                self.currentPosition = AVCaptureDevicePositionFront;
            }
            
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            //beginConfiguration 确保改变不会立刻应用
            [self.captureSession beginConfiguration];
            
//            [self.captureSession removeOutput:self.videoDataOutput];
//            [self.captureSession removeOutput:self.audioDataOutput];

            [self.captureSession removeInput:input];
            [self.captureSession addInput:newInput];
            
//            self.outputVideoFormatDescription = nil;
//            self.outputAudioFormatDescription = nil;
            //开始生效
            [self.captureSession commitConfiguration];
            //重新加载
//            [self addDataOutputsToCaptureSession:self.captureSession];
            break;
        }
    }
}



#pragma mark - Private methods

- (void)addDataOutputsToCaptureSession:(AVCaptureSession *)captureSession {
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    self.videoDataOutput.videoSettings = nil;
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    self.audioDataOutput = [AVCaptureAudioDataOutput new];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioDataOutputQueue];
    
    [self addOutput:self.videoDataOutput toCaptureSession:self.captureSession];
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    [self addOutput:self.audioDataOutput toCaptureSession:self.captureSession];
    self.audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
}

- (void)setCompressionSettings {
    
    NSInteger videoWidth = (self.currentOrientation == AVCaptureVideoOrientationLandscapeLeft || self.currentOrientation == AVCaptureVideoOrientationLandscapeRight) ?  720 : 1280;
    NSInteger videoHeight = (self.currentOrientation == AVCaptureVideoOrientationLandscapeLeft || self.currentOrientation == AVCaptureVideoOrientationLandscapeRight) ? 1280 : 720;
    
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];

    NSLog(@"videoOrientation : %ld , videoWidth : %ld  videoHeight :%ld",self.videoConnection.videoOrientation,videoWidth,videoHeight);
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{
                                            AVVideoAverageBitRateKey : @(2 * videoWidth * videoHeight),
//                                    AVVideoExpectedSourceFrameRateKey : @(60),
//                                        AVVideoMaxKeyFrameIntervalKey : @(60),
//                                    AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
                                            };
    
    self.videoCompressionSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    self.videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                 AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                       AVVideoWidthKey : @(videoWidth),
                                      AVVideoHeightKey : @(videoHeight),
                       AVVideoCompressionPropertiesKey : compressionProperties };
    
    // 音频设置
    self.audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(64000),
                                                       AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                               AVNumberOfChannelsKey : @(1),
                                                     AVSampleRateKey : @(44100)
                                       };
}

#pragma mark - SampleBufferDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.videoConnection){
        if (!self.outputVideoFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputVideoFormatDescription = formatDescription;
            }
        } else {
            @synchronized(self) {
                if (self.recordingStatus == RecordingStatusRecording){
                    [self.assetSession appendVideoSampleBuffer:sampleBuffer];
                }
            }
        }
    } else if (connection == self.audioConnection ){
        if (!self.outputAudioFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputAudioFormatDescription = formatDescription;
            }
        }
        @synchronized(self) {
            if (self.recordingStatus == RecordingStatusRecording){
                [self.assetSession appendAudioSampleBuffer:sampleBuffer];
            }
        }
    }
}

#pragma mark - AssetWriterDelegate methods

- (void)sessionDidFinishPreparing:(ShortVideoRecorder *)writer {
    @synchronized(self) {
        if (self.recordingStatus != RecordingStatusStartingRecording){
            return;
        }
        [self transitionToRecordingStatus:RecordingStatusRecording error:nil];
    }
}

- (void)session:(ShortVideoRecorder *)writer didFailWithError:(NSError *)error {
    @synchronized(self) {
        self.assetSession = nil;
        [self transitionToRecordingStatus:RecordingStatusIdle error:error];
    }
}

- (void)sessionDidFinishRecording:(ShortVideoRecorder *)writer {
    @synchronized(self) {
        if ( self.recordingStatus != RecordingStatusStoppingRecording ) {
            return;
        }
    }
    self.assetSession = nil;
    
    @synchronized(self) {
        [self transitionToRecordingStatus:RecordingStatusIdle error:nil];
    }
}


#pragma mark - Recording State Machine

- (void)transitionToRecordingStatus:(RecordingStatus)newStatus error:(NSError *)error {
    RecordingStatus oldStatus = self.recordingStatus;
    self.recordingStatus = newStatus;
    
    if (newStatus != oldStatus){
        if (error && (newStatus == RecordingStatusIdle)){
            dispatch_async( dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.outputFilePath error:error];
                }
            });
        } else {
            error = nil;
            if (oldStatus == RecordingStatusStartingRecording && newStatus == RecordingStatusRecording){
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        [self.delegate recorderDidBeginRecording:self];
                    }
                });
            } else if (oldStatus == RecordingStatusStoppingRecording && newStatus == RecordingStatusIdle) {
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        [self.delegate recorderDidEndRecording:self];
                        [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.outputFilePath error:nil];
                    }
                });
            }
        }
    }
}

#pragma mark - Capture Session Setup


- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [AVCaptureSession new];
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;//720 x 1280
        if (![self addDefaultCameraInputToCaptureSession:_captureSession]){
            NSLog(@"加载摄像头失败");
        }
        if (![self addDefaultMicInputToCaptureSession:_captureSession]){
            NSLog(@"加载麦克风失败");
        }
    }
    return _captureSession;
}

- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    if (error) {
        NSLog(@"配置摄像头输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];
        self.cameraDevice = cameraDeviceInput.device;
        return success;
    }
}

- (BOOL)addDefaultMicInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *micDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    if (error){
        NSLog(@"配置麦克风输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:micDeviceInput toCaptureSession:captureSession];
        return success;
    }
}

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddInput:input]){
        [captureSession addInput:input];
        return YES;
    } else {
        NSLog(@"不能添加输入: %@", [input description]);
    }
    return NO;
}


- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddOutput:output]){
        [captureSession addOutput:output];
        return YES;
    } else {
        NSLog(@"不能添加输出 %@", [output description]);
    }
    return NO;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            return device;
        }
    }
    return nil;
}


#pragma mark - Getter

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    return _previewLayer;
}


@end
