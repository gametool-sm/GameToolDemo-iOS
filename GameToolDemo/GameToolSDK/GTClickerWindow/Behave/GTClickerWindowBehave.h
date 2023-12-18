//
//  GTClickerWindowBehave.h
//  GTSDK
//
//  Created by shangmi on 2023/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowBehave : NSObject

/**
 判断连点器悬浮窗的合理移动区域
 */
+ (CGPoint)clickerWindowMoveArea:(CGPoint)movePoint;

/**
 判断连点器触点的合理移动区域
 */
+ (CGPoint)clickerPointMoveArea:(CGPoint)movePoint;

@end

NS_ASSUME_NONNULL_END
