//
//  WKWebViewController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/6.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKWebView;

@interface WKWebViewController : UIViewController
/** 网页视图 */
@property (nonatomic, strong) WKWebView *webView;

/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** urlString */
@property (nonatomic, copy) NSString *urlString;

/**
 通过url链接初始化
 
 @param urlString url连接字符串
 @param title 标题
 @return 网页控制器
 */
- (instancetype)initWthUrlString:(NSString *)urlString title:(NSString *)title;
@end
