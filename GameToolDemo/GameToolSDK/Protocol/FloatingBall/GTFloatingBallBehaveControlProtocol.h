//
//  GTFloatingBallBehaveControlProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 极简模式下，弹出和点亮不是一个整体，他们有可能单独出发，所以分开来写
 */

@protocol GTFloatingBallBehaveControlProtocol <NSObject>

//极简模式悬浮球贴边(相对默认模式的隐藏一半)
+ (void)floatingBallControlModeClingWithView:(UIView *)view;

//极简模式悬浮球弹出
+ (void)floatingBallControlModePopUpWithView:(UIView *)view;

//极简模式悬浮球熄灭
+ (void)floatingBallControlModeExtinguishWithView:(UIView *)view completion:(void(^ __nullable)(void))completion;

//极简模式悬浮球点亮
+ (void)floatingBallControlModeLightedWithView:(UIView *)view;

////极简模式悬浮球隐藏
//+(void)simpleFloatingBallHideWithView:(UIView *)view andFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTHideFloatBallView *)hideFloatBallView cancelHide:(void (^)(void))cancelHide hideFloatBall:(void (^)(void))hideFloatBall closeSimpleStyle:(void (^)(void))closeSimpleStyle;

+(void)reopenSimpleStyleDialogWithView:(UIView *)view andFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTHideFloatBallView *)hideFloatBallView cancelHide:(void(^)(void))cancelHide;
//关闭极简模式
+ (void)closeSimpleStyle;

@end

NS_ASSUME_NONNULL_END
