//
//  GTOperationControl.h
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTFloatingBallOperationProtocol.h"
#import "GTFloatingWindowOperationProtocol.h"
#import "GTDialogWindowOperationProtocol.h"
#import "GTFloatingBallWindow.h"
#import "GTFloatingWindowWindow.h"
#import "GTDialogWindow.h"

//悬浮球的位置状态
typedef NS_ENUM(NSUInteger, GTSDKStyle) {
    GTSDKStyleDefault,                          //默认悬浮球，默认悬浮弹窗
    GTSDKStyleCustomFloatingWindow,             //自定义悬浮球，默认悬浮弹窗
    GTSDKStyleCustomFloatingBall,               //默认悬浮球，自定义悬浮弹窗
    GTSDKStyleCustom,                           //自定义悬浮球，自定义悬浮弹窗
};

NS_ASSUME_NONNULL_BEGIN

@interface GTOperationControl : NSObject

@property (nonatomic, assign) GTSDKStyle gtSDKStyle;

@property (nonatomic, assign)   UIInterfaceOrientation orientation;
/*
 是否隐藏过一次悬浮球，默认是NO（隐藏过则在翻转手机的时候需要切换悬浮球的显示状态）
 */
@property (nonatomic, assign) BOOL AlreadyHideFloatBall;

+ (GTOperationControl *)shareInstance;

- (void)setUpWithInfo:(NSDictionary *)info;

//初始化各个模块
//悬浮球
- (void)initFloatingBall;
//悬浮弹窗
- (void)initFloatingWindow;
//连点器悬浮窗
- (void)initClickerWindow;
//录制悬浮窗
- (void)initRecordWindow;
//所有弹窗
- (void)initDialogWindow;

@end

NS_ASSUME_NONNULL_END
