//
//  GTFloatingBallConfig.h
//  GTSDK
//
//  Created by shangmi on 2023/6/16.
//

#import <Foundation/Foundation.h>
#import "GTFloatingBallBehaveProtocol.h"
#import "GTBottomHotSpotView.h"
#import "GTFloatingBallViewController.h"

//悬浮球的宽
extern CGFloat const floatingBall_width;
//悬浮球的高
extern CGFloat const floatingBall_height;
//未贴边悬浮球距离边框的边距
extern CGFloat const floatingBall_distance;

extern CGFloat const hideHotView_width;
extern CGFloat const hideHotView_height;

//定义有刘海屏的手机，刘海屏的宽度，或者灵动岛的宽度
extern CGFloat const safe_area_width;

//悬浮球的样式
typedef NS_ENUM(NSUInteger, FloatingBallStyle) {
    FloatingBallStyleDefault,           //默认样式
    FloatingBallStyleSimpleControl,     //简易控制样式
    FloatingBallStyleControl,           //正常控制样式
};

//悬浮球的位置状态
typedef NS_ENUM(NSUInteger, FloatingBallState) {
    FloatingBallStateWelt,      //自动靠边
    FloatingBallStateHideHalf,  //贴边隐藏一半
    FloatingBallStateHide,      //完全隐藏
};

//悬浮球的明暗状态
typedef NS_ENUM(NSUInteger, FloatingBallLuminance) {
    FloatingBallLuminanceLight,      //点亮
    FloatingBallLuminanceDark,        //熄灭
};

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallConfig : NSObject

+ (double)floatingBallWithView:(UIView *)view spendTimeAsSpeed:(double)speed;


//普通模式悬浮球隐藏
+ (void)defaultFloatingBallHideWithFloatBallImg:(nonnull UIView *)floatBallImg andHideFloatBallView:(nonnull GTBottomHotSpotView *)hideFloatBallView cancelHide:(nonnull void (^)(void))cancelHide confirm:(nonnull void (^)(void))confirm;

//极简模式悬浮球隐藏
+(void)simpleFloatingBallHideWithFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTBottomHotSpotView *)hideFloatBallView cancelHide:(void (^)(void))cancelHide hideFloatBall:(void (^)(void))hideFloatBall closeSimpleStyle:(void (^)(void))closeSimpleStyle;

+ (void)reopenSimpleStyleDialogWithFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTBottomHotSpotView *)hideFloatBallView cancelClose:(void (^)(void))cancelClose confirmClose:(nonnull void (^)(void))confirmClose;
//关闭极简模式
+(void)closeSimpleStyle;
@end

NS_ASSUME_NONNULL_END
