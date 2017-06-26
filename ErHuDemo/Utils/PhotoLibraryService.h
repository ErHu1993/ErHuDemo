//
//  PhotoLibraryService.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PhotosTypes.h>

@class PHAsset,PHCachingImageManager;

@interface PhotoLibraryService : NSObject
/** 图片池 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*photoPool;
/** 视频池 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*videoPool;
/** 综合池 */
@property (nonatomic, strong) NSMutableArray <PHAsset *>*pool;

@property (nonatomic, assign) CGSize cachImageSize;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, assign) PHImageContentMode cachImageContentMode;

/**
 单利
 
 @return self
 */
+ (instancetype)defaultService;

/**
 检查权限
 */
- (void)afterAccessAuthorized:(void (^)(void))closure;

/**
 更新池
 */
- (void)updatePool;

/**
 获得图片完整的列表
 
 @param closure 回调
 */
- (void)getPhotos:(void (^)(NSArray <PHAsset *> *assets))closure;

/**
 获得视频完整的列表
 
 @param closure 回调
 */
- (void)getVideos:(void (^)(NSArray <PHAsset *> *assets))closure;

/**
 获得综合完整的列表
 
 @param closure 回调
 */
- (void)getAll:(void (^)(NSArray <PHAsset *> *assets))closure;
@end
