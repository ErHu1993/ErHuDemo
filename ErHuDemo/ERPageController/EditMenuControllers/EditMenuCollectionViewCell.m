//
//  EditMenuCollectionViewCell.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/4.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "EditMenuCollectionViewCell.h"

#define angelToRandian(x)  ((x) / 180.0 * M_PI)

static NSString * const AnimationKey = @"shakeAnimation";

@interface EditMenuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) CAKeyframeAnimation *shakeAnimation;

@end

@implementation EditMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)deleteButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectDeleteItem:)]) {
        [self.delegate didSelectDeleteItem:self.indexPath];
    }
}

- (void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.deleteButton.hidden = !_canEdit;
        if (_canEdit) {
            [self.deleteButton.layer addAnimation:self.shakeAnimation forKey:AnimationKey];
            [self.channelButton.layer addAnimation:self.shakeAnimation forKey:AnimationKey];
        }else{
            if ([self.channelButton.layer animationForKey:AnimationKey]) {
                [self.channelButton.layer removeAnimationForKey:AnimationKey];
            }
            if ([self.deleteButton.layer animationForKey:AnimationKey]) {
                [self.deleteButton.layer removeAnimationForKey:AnimationKey];
            }
        }
    });
}

- (CAKeyframeAnimation *)shakeAnimation{
    if (!_shakeAnimation) {
        _shakeAnimation = [CAKeyframeAnimation animation];
        _shakeAnimation.keyPath = @"transform.rotation";
        _shakeAnimation.values = @[@(angelToRandian(-3)),@(angelToRandian(3)),@(angelToRandian(-3))];
        _shakeAnimation.repeatCount = MAXFLOAT;
        _shakeAnimation.duration = 0.2;
    }
    return _shakeAnimation;
}

@end
