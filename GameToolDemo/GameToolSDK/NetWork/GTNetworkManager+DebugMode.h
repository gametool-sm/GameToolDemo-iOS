//
//  GTNetworkManager+DebugMode.h
//  GTSDK
//
//  Created by shangmi on 2023/7/17.
//

#import "GTNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNetworkManager (DebugMode)

/// 获取保存的debug_token
- (void)configData;

/// 是否是接口调试模式
- (BOOL)checkIsExpire;

@end

NS_ASSUME_NONNULL_END
