//
//  HandPaintingImageView.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/2.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandPaintingImageView : UIImageView
// 在设置了Image之后，只能调用一次，初始化绘图图层, widthInMM标注的宽度，单位毫米
- (void)hp_initWidthInMM:(double)widthInMM;
// 进入绘图页面时选中某种颜色
- (void)hp_chooseWithColor:(UIColor *)color abstractScale:(CGFloat)abstractScale;
// 传入绝对的缩放比
- (void)hp_setAbsoluteScale:(CGFloat)scale;
// 离开绘图页面时取消选中某种颜色
- (void)hp_unchoose;
// 撤销绘图
- (void)hp_undo;
// 是否进行过标注
- (BOOL)hp_hasStocks;
// 标注过的图片需要通过此方法将标注与原图混合
- (void)hp_drawOnImage;
@end
