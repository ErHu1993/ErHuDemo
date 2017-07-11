//
//  UIColor+ERCategory.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/11.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ERCategory)


/**
 *  @brief  根据十六进制配色数值返回颜色对象
 *
 *  @param hex 十六进制配色数值
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

/**
 *  @brief  根据十六进制配色字符串返回颜色对象
 *
 *  @param stringToConvert 十六进制配色字符串
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  @brief RGBA返回颜色对象（R、G、B在0~255）
 *
 *  @param red   0~255
 *  @param green 0~255
 *  @param blue  0~255
 *  @param alpha 透明度（0~1）
 *
 *  @return UIColor对象
 */

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

@end
