//
//  GTNetworkManager+DebugMode.m
//  GTSDK
//
//  Created by shangmi on 2023/7/17.
//

#import "GTNetworkManager+DebugMode.h"

@implementation GTNetworkManager (DebugMode)

- (void)configData {
    self.debugDict = [GTSDKUtils getDebugToken];
}

//是否是接口调试模式
- (BOOL)checkIsExpire {
    if (![self.debugDict allKeys].count) {
        return YES;
    }
    NSTimeInterval timeStamp = [self getCurrentTimestamp];
    return timeStamp > [self.debugDict[@"expireAt"] longValue] ? YES : NO;
}

- (void)configHeaderParam {
    
}

//删除，等待base库同步
- (NSTimeInterval)getCurrentTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}


@end
