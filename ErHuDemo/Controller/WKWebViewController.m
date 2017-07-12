//
//  WKWebViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/6.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "ERURLProtocol.h"
#import "NSURLProtocol+WebKitSupport.h"

/**
 * 请求状态
 */
typedef NS_ENUM(NSInteger, WebViewRequestStatus){
    /**
     *  开始请求
     */
    WebViewStartRequest           = 1,
    /**
     *  请求完成
     */
    WebViewCompleteRequest        = 2,
    /**
     *  请求失败
     */
    WebViewFailRequest            = 3,
    
};

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) NSDate *startRequestDate;

@property (nonatomic, assign) WebViewRequestStatus status;

@property (nonatomic, strong) UITextView *textview;

@end

@implementation WKWebViewController

- (void)dealloc{
    
    NSLog(@"dealloc");
    
    if (self.urlString.length && self.webView) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.progressView removeFromSuperview];
    }
    [self clearWebViewCookie];
    //注册protocol
    [NSURLProtocol wk_unregisterClass:[ERURLProtocol class]];
}

/**
 通过url链接初始化
 
 @param urlString url连接字符串
 @param title 标题
 @return 网页控制器
 */
- (instancetype)initWthUrlString:(NSString *)urlString title:(NSString *)title
{
    if (self = [super init]) {
        self.urlString = urlString;
        if (title.length) {
            self.title = title;
        }
        //注册protocol
        [NSURLProtocol wk_registerClass:[ERURLProtocol class]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.urlString.length) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [backBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [self textview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewChange:) name:@"textviewchange" object:nil];
}

- (void)backAction{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getter/setter

- (WKWebView *)webView{
    if (!_webView && self.urlString.length) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)textviewChange:(NSNotification *)notifcation{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textview.text = [NSString stringWithFormat:@"%@ \n %@",self.textview.text,notifcation.object];
    });
}

- (UITextView *)textview{
    if (!_textview) {
        _textview = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 150, ScreenWidth, 150)];
        _textview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_textview];
        [_textview setEditable:false];
    }
    return _textview;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.tintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark 进度条君监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
                if (self.status == WebViewCompleteRequest) {
                    [self captureImageToLibrary];
                }
            }];
        }
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.status = WebViewStartRequest;
}

#pragma mark - WKWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.status = WebViewCompleteRequest;
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError * _Nullable error) {
        if (title.length) {
            weakSelf.title = title;
        }
    }];
    
}


/**
 在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
 该方法执行在加载界面之前
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"navigationType : %ld",navigationAction.navigationType);
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"navigationType : %ld",navigationAction.navigationType);
    if (navigationAction.navigationType == WKNavigationTypeFormSubmitted || navigationAction.navigationType == WKNavigationTypeFormResubmitted) {
        NSLog(@"表单提交?");
    }
    return nil;
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.status = WebViewFailRequest;
}

#pragma mark 清除WebView cookies缓存
- (void)clearWebViewCookie{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - 加载完成截屏保存相册

-(void)captureImageToLibrary
{
    CGRect screenRect = [self.webView bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.webView.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image,self, @selector(resultImage:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)resultImage:(UIImage *)resultImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){
        NSLog(@"截屏! 图片保存相册失败");
    }else{
        NSLog(@"截屏! 图片已成功保存至相册");
    }
}


#pragma mark - layout

-(void)viewDidLayoutSubviews {
    self.webView.frame = self.view.bounds;
    [self.progressView setFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 2)];
}

- (void)setStatus:(WebViewRequestStatus)status{
    if (_status != status) {
        if (status == WebViewStartRequest) {
            NSLog(@"开始请求");
            self.startRequestDate = [NSDate date];
        }else if (status == WebViewCompleteRequest){
            NSTimeInterval requestTime = [[NSDate date] timeIntervalSinceDate:self.startRequestDate];
            NSLog(@"请求完成, 用时 %f",requestTime);
        }else if (status == WebViewFailRequest){
            NSTimeInterval requestTime = [[NSDate date] timeIntervalSinceDate:self.startRequestDate];
            NSLog(@"请求失败, 用时 %f",requestTime);
        }
        _status = status;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
