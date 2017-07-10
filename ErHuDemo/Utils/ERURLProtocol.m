//
//  ERURLProtocol.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/6.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERURLProtocol.h"

@interface ERURLProtocol ()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *data;

@end

static NSString* const URLProtocolHandledKey = @"handelKey";

@implementation ERURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

/**
 这里可以修改request，比如添加header，修改host等，并返回一个新的request

 @param request request
 @return request
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

/**
 主要判断两个request是否相同，如果相同的话可以使用缓存数据

 @param a a
 @param b b
 @return bool
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}


- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    NSLog(@"startLoading : %@",mutableReqeust.URL.absoluteString);
    
    NSLog(@"请求方式: %@ %@",[mutableReqeust.URL scheme],mutableReqeust.HTTPMethod);
    
    if ([mutableReqeust.HTTPMethod isEqualToString:@"POST"]) {
        NSLog(@"body : %@",mutableReqeust.HTTPBody);
    }
    
    NSLog(@"header : %@",mutableReqeust.allHTTPHeaderFields);
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
    if([httpresponse respondsToSelector:@selector(allHeaderFields)]){
        NSLog(@"didReceiveResponse: header %@",[httpresponse allHeaderFields]);
    }
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    self.data = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.data appendData:data];
    
    [self.client URLProtocol:self didLoadData:data];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *jsonStr = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonStr);
    
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
