//
//  PHAsset+EHCategory.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "PHAsset+EHCategory.h"
#import <objc/runtime.h>

@implementation PHAsset (EHCategory)

- (BOOL)z_selected {
    return [objc_getAssociatedObject(self, @selector(z_selected)) boolValue];
}

- (void)setZ_selected:(BOOL)z_selected {
    objc_setAssociatedObject(self, @selector(z_selected), @(z_selected), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isGif{
    NSString *uti = [self valueForKey:@"uniformTypeIdentifier"];
    if ([[self valueForKey:@"uniformTypeIdentifier"] isKindOfClass:[NSString class]]) {
        return [[uti lowercaseString] containsString:@"gif"];
    }else{
        return false;
    }
}

- (BOOL)isVideo {
    return (self.mediaType == PHAssetMediaTypeVideo);
}

@end
