//
//  ImageTableViewCell.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/8/9.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) CAShapeLayer *pathLayer;

@end

@implementation ImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backImageView];
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    
    [self.path removeAllPoints];
    
    [self.path addArcWithCenter:CGPointMake(60, 60) radius:radius startAngle:0.0 endAngle:180.0 clockwise:YES];
    
    self.pathLayer.path = self.path.CGPath;
    
    self.coverImageView.layer.mask = self.pathLayer;
}

- (UIBezierPath *)path{
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

- (CAShapeLayer *)pathLayer{
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
    }
    return _pathLayer;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        _backImageView.image = [UIImage imageNamed:@"backImage"];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _backImageView;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.backImageView.bounds];
        _coverImageView.image = [UIImage imageNamed:@"coverImage"];
    }
    return _coverImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
