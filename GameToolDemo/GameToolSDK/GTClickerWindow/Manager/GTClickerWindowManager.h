//
//  GTClickerWindowManager.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import <Foundation/Foundation.h>
#import "GTClickerWindowOperationProtocol.h"
#import "GTClickerWindowConfig.h"
#import "GTClickerWindowWindow.h"
#import "GTClickerWindowViewController.h"
#import "GTClickerSchemeModel.h"
#import "GTClickerPointSetModel.h"
#import "GTClickerPointWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowManager : NSObject <GTClickerWindowOperationProtocol>

@property (nonatomic, strong, nullable) GTClickerWindowWindow * clickerWinWindow;
@property (nonatomic, strong, nullable) GTClickerWindowViewController * clickerWindowVC;

//连点悬浮窗的状态
@property (nonatomic, assign) ClickerWindowState clickerWindowState;

//方案model
@property (nonatomic, strong, nullable) GTClickerSchemeModel *schemeModel;
//触点设置model
@property (nonatomic, strong) GTClickerPointSetModel *pointSetModel;

//方案最开始创建或启用时赋值，与沙盒中json文件内容一致（启用时直接赋值，创建新方案时则为空，因为新方案此时并不在json文件中）
@property (nonatomic, strong) NSString *schemeJsonString;
//储存触点window array
@property (nonatomic, strong) NSMutableArray<GTClickerPointWindow *> *pointWindowArray;
//设置页面数据对比数组
@property (nonatomic, strong) NSMutableArray <GTClickerActionModel *> *compareArray;
//控制所有触点显示和隐藏的总开关
@property (nonatomic, assign) BOOL isAllPointShow;

//每次点击悬浮窗启动时都保存一次方案的json，用来与下次点击启动作对比
@property (nonatomic, strong) NSString *lastClickJsonString;

//判断是启用方案还是新创建方案
//@property (nonatomic, assign) BOOL isFromNewScheme;

+ (GTClickerWindowManager *)shareInstance;

- (void)setUp;

@end

NS_ASSUME_NONNULL_END
