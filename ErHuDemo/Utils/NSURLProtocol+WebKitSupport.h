//
//  NSURLProtocol+WebKitSupport.h
//  NSURLProtocol+WebKitSupport
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)

+ (BOOL)wk_registerClass:(Class)protocolClass;

+ (void)wk_unregisterClass:(Class)protocolClass;

@end
