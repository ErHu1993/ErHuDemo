//
//  PhotoPickerCell.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/26.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "PhotoPickerCell.h"

@interface PhotoPickerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gifTag;

@property (weak, nonatomic) IBOutlet UIImageView *videoTag;

@property (weak, nonatomic) IBOutlet UIImageView *selectedTag;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setAsset:(PHAsset *)asset {
    
    _asset = asset;
    
    __weak typeof(self) weak_self = self;
    [[PhotoLibraryService defaultService].imageManager requestImageForAsset:asset targetSize:[PhotoLibraryService defaultService].cachImageSize contentMode:PhotoLibraryService.defaultService.cachImageContentMode options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weak_self.imageView.image = result;
    }];
    self.gifTag.hidden = !asset.isGif;
    self.videoTag.hidden = (asset.mediaType != PHAssetMediaTypeVideo);
    self.selectedTag.hidden = !asset.z_selected;
}

@end
