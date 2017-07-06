//
//  SectionHeader.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/6.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "SectionHeader.h"

@implementation SectionHeader

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews{
    [self.titleLabel setFrame:CGRectMake(10, (CGRectGetHeight(self.frame) - 15), CGRectGetWidth(self.frame), 15)];
}

@end
