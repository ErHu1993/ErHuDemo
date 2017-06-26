//
//  PhotoLibraryService.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "PhotoLibraryService.h"
#import <Photos/Photos.h>

@interface PhotoLibraryService ()

@property (nonatomic, assign) NSInteger poolCount;

@end

@implementation PhotoLibraryService

/**
 单利
 
 @return self
 */
+ (instancetype)defaultService {
    static PhotoLibraryService *_defaultService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultService = [[PhotoLibraryService alloc] init];
    });
    return _defaultService;
}

- (instancetype)init {
    if (self = [super init]) {
        self.poolCount = 10;
        self.cachImageSize = CGSizeMake(90 * ScreenScale, 90 * ScreenScale);
        self.imageManager = [[PHCachingImageManager alloc] init];
        self.cachImageContentMode = PHImageContentModeAspectFill;
    }
    return self;
}


/**
 检查权限
 */
- (void)afterAccessAuthorized:(void (^)(void))closure{
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            closure();
            break;
        default:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    closure();
                }
            }];
        }
            break;
    }
}


/**
 更新池
 */
- (void)updatePool{
    __weak typeof(self)weakSelf = self;
    [self afterAccessAuthorized:^{
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        [fetchOptions setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]]];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:fetchOptions];
        [assets enumerateObjectsUsingBlock:^(PHAsset *asset ,NSUInteger index, BOOL * _Nonnull stop) {
            switch (asset.mediaType) {
                case PHAssetMediaTypeImage:
                {
                    if (weakSelf.photoPool.count < weakSelf.poolCount) {
                        [weakSelf.photoPool addObject:asset];
                    }
                    if (weakSelf.pool.count < weakSelf.poolCount) {
                        [weakSelf.pool addObject:asset];
                    }
                }
                    break;
                case PHAssetMediaTypeVideo:
                {
                    if (weakSelf.videoPool.count < weakSelf.poolCount) {
                        [weakSelf.videoPool addObject:asset];
                    }
                    if (weakSelf.pool.count < weakSelf.poolCount) {
                        [weakSelf.pool addObject:asset];
                    }
                }
                    break;
                    
                default:
                {
                    //continue
                    *stop = false;
                }
                    break;
            }
        }];
        [weakSelf.imageManager stopCachingImagesForAllAssets];
        [weakSelf.imageManager startCachingImagesForAssets:weakSelf.photoPool targetSize:weakSelf.cachImageSize contentMode:self.cachImageContentMode options:nil];
    }];
}


/**
 获得图片完整的列表

 @param closure 回调
 */
- (void)getPhotos:(void (^)(NSArray <PHAsset *> *assets))closure{
    __weak typeof(self)weakSelf = self;
    [self afterAccessAuthorized:^{
        NSMutableArray *result = [[NSMutableArray alloc] init];
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        [fetchOptions setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]]];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:fetchOptions];
        [assets enumerateObjectsUsingBlock:^(PHAsset *asset ,NSUInteger index, BOOL * _Nonnull stop) {
            switch (asset.mediaType) {
                case PHAssetMediaTypeImage:
                {
                    [result addObject:asset];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [weakSelf.photoPool removeAllObjects];
        [weakSelf.photoPool addObjectsFromArray:result];
        closure(result);
    }];
}

/**
 获得视频完整的列表
 
 @param closure 回调
 */
- (void)getVideos:(void (^)(NSArray <PHAsset *> *assets))closure{
    __weak typeof(self)weakSelf = self;
    [self afterAccessAuthorized:^{
        NSMutableArray *result = [[NSMutableArray alloc] init];
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        [fetchOptions setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]]];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:fetchOptions];
        [assets enumerateObjectsUsingBlock:^(PHAsset *asset ,NSUInteger index, BOOL * _Nonnull stop) {
            switch (asset.mediaType) {
                case PHAssetMediaTypeVideo:
                {
                    [result addObject:asset];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [weakSelf.videoPool removeAllObjects];
        [weakSelf.videoPool addObjectsFromArray:result];
        closure(result);
    }];
}

/**
 获得综合完整的列表
 
 @param closure 回调
 */
- (void)getAll:(void (^)(NSArray <PHAsset *> *assets))closure{
    __weak typeof(self)weakSelf = self;
    [self afterAccessAuthorized:^{
        NSMutableArray *result = [[NSMutableArray alloc] init];
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        [fetchOptions setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]]];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:fetchOptions];
        [assets enumerateObjectsUsingBlock:^(PHAsset *asset ,NSUInteger index, BOOL * _Nonnull stop) {
            [result addObject:asset];
        }];
        [weakSelf.pool removeAllObjects];
        [weakSelf.pool addObjectsFromArray:result];
        closure(result);
    }];
}

#pragma mark - getter/setter

- (NSMutableArray <PHAsset *>*)pool{
    if (!_pool) {
        _pool = [[NSMutableArray alloc] init];
    }
    return _pool;
}

- (NSMutableArray <PHAsset *>*)photoPool{
    if (!_photoPool) {
        _photoPool = [[NSMutableArray alloc] init];
    }
    return _photoPool;
}

- (NSMutableArray <PHAsset *>*)videoPool{
    if (!_videoPool) {
        _videoPool = [[NSMutableArray alloc] init];
    }
    return _videoPool;
}
@end
