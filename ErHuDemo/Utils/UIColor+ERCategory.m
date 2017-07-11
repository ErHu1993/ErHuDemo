//
//  UIColor+ERCategory.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/11.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "UIColor+ERCategory.h"

@implementation UIColor (ERCategory)

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    NSInteger r = (hex >> 16) & 0xFF;
    NSInteger g = (hex >> 8) & 0xFF;
    NSInteger b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0X"]||[cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


@end
