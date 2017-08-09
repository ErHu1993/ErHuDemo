//
//  ImageTableViewCell.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/8/9.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *coverImageView;

- (void)setRadius:(CGFloat)radius;
@end
