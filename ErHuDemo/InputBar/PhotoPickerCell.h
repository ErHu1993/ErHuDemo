//
//  PhotoPickerCell.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoLibraryService.h"
#import "PHAsset+EHCategory.h"
@interface PhotoPickerCell : UICollectionViewCell

/** 图片 */
@property (nonatomic, strong) PHAsset *asset;

@end
