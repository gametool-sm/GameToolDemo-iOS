//
//  GTFloatingWindowManager.h
//  GTSDK
//
//  Created by shangmi on 2023/8/16.
//

#import <Foundation/Foundation.h>
#import "GTFloatingWindowOperationProtocol.h"
#import "GTFloatingWindowWindow.h"
#import "GTFloatingWindowViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingWindowManager : NSObject <GTFloatingWindowOperationProtocol>

//悬浮球window
@property (nonatomic, strong, nullable) GTFloatingWindowWindow * windowWindow;
@property (nonatomic, strong, nullable) GTFloatingWindowViewController * windowVC;

+ (GTFloatingWindowManager *)shareInstance;

@end

NS_ASSUME_NONNULL_END
