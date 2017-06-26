//
//  PHAsset+EHCategory.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (EHCategory)

@property (nonatomic, assign) BOOL z_selected;

- (BOOL)isGif;

- (BOOL)isVideo;

@end
