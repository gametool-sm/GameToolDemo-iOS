//
//  GTMotionManager.h
//  GTSDK
//
//  Created by shangmi on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTMotionManager : NSObject

+ (GTMotionManager *)shareManager;

- (void)startMonitorMotionWithCompletion:(void(^ __nullable)(void))completion;

//停止监测，这版本暂时用不上
//- (void)endMonitorMotion;

@end

NS_ASSUME_NONNULL_END
