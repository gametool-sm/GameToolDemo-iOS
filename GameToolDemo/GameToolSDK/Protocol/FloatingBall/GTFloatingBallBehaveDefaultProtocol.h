//
//  GTFloatingBallBehaveDefaultProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/7/4.
//

#import <Foundation/Foundation.h>
#import "GTHideFloatBallView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 普通模式下，弹出和点亮是一个整体，所以写在一块
 */

@protocol GTFloatingBallBehaveDefaultProtocol <NSObject>

/// 悬浮球自动贴边
/// - Parameters:
///   - view: 悬浮球所在view
///   - speed: 速度
///   - completion: completion
+ (void)floatingBallWeltWithView:(UIView *)view speed:(double)speed completion:(void(^)(void))completion;

//悬浮球贴边隐藏一半悬浮球
+ (void)floatingBallDefaultModeHideHalfWithView:(UIView *)view;

//悬浮球熄灭
+ (void)floatingBallDefaultModeExtinguishWithView:(UIView *)view completion:(void(^ __nullable)(void))completion;

//悬浮球点亮
+ (void)floatingBallDefaultModeLightedWithView:(UIView *)view;

//普通模式悬浮球隐藏
+ (void)defaultFloatingBallHideWithView:(UIView *)view andFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTHideFloatBallView *)hideFloatBallView cancelHide:(void(^)(void))cancelHide;
//极简模式悬浮球隐藏
+(void)simpleFloatingBallHideWithView:(UIView *)view andFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTHideFloatBallView *)hideFloatBallView cancelHide:(void (^)(void))cancelHide hideFloatBall:(void (^)(void))hideFloatBall closeSimpleStyle:(void (^)(void))closeSimpleStyle;
@end

NS_ASSUME_NONNULL_END
