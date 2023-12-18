//
//  GTFloatingBallManager.h
//  GTSDK
//
//  Created by shangmi on 2023/7/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTFloatingBallConfig.h"
#import "GTFloatingBallWindow.h"
#import "GTFloatingBallViewController.h"
#import "GTFloatingBallBehaveProtocol.h"
#import "GTFloatingBallOperationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallManager : NSObject <GTFloatingBallOperationProtocol>

//倍率悬浮球的宽和高
@property (nonatomic, assign) CGFloat floatingBall_control_width;
@property (nonatomic, assign) CGFloat floatingBall_control_height;

//悬浮球window
@property (nonatomic, strong, nullable) GTFloatingBallWindow * ballWindow;
@property (nonatomic, strong, nullable) GTFloatingBallViewController * ballVC;

//悬浮球各种行为和样式
@property (nonatomic, assign) FloatingBallStyle floatingBallStyle;
@property (nonatomic, assign) FloatingBallState floatingBallState;
@property (nonatomic, assign) FloatingBallLuminance floatingBallLuminance;

//是否开了极简
@property (nonatomic, assign) BOOL isMinimalist;
//是否开了贴边（小白兔默认贴边，这个开关是控制两种极简模式的）
@property (nonatomic, assign) BOOL isAutoHide;
//是否开了倍率（极简模式下的倍率模式）
@property (nonatomic, assign) BOOL isMul;

/*
 因为手机翻转的监听会执行多次，所以需要限定时间内不执行翻转显示/隐藏悬浮球的操作
 */
@property (nonatomic, assign) BOOL floatBallStatusCanChange;

/// 初始化
+ (GTFloatingBallManager *)shareInstance;

@end

NS_ASSUME_NONNULL_END
