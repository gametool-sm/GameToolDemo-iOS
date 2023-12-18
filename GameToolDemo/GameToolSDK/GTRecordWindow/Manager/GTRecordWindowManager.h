//
//  GTRecordWindowManager.h
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import "GTRecordWindowConfig.h"
#import "GTRecordWindowWindow.h"
#import "GTRecordWindowOperationProtocol.h"
#import "GTRecordWindowViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordWindowManager : NSObject <GTRecordWindowOperationProtocol>

@property (nonatomic, strong, nullable) GTRecordWindowWindow * recordWinWindow;
@property (nonatomic, strong, nullable) GTRecordWindowViewController * recordWindowVC;

//录制悬浮窗的状态
@property (nonatomic, assign) RecordWindowState recordWindowState;

//方案model
@property (nonatomic, strong, nullable) GTClickerSchemeModel *schemeModel;
//触点设置model
@property (nonatomic, strong) GTClickerPointSetModel *pointSetModel;

//方案最开始创建或启用时赋值，与沙盒中json文件内容一致（启用时直接赋值，创建新方案时则为空，因为新方案此时并不在json文件中）
@property (nonatomic, strong) NSString *schemeJsonString;

//控制所有触点显示和隐藏的总开关
@property (nonatomic, assign) BOOL isAllPointShow;

//每次点击悬浮窗启动时都保存一次方案的json，用来与下次点击启动作对比
@property (nonatomic, strong) NSString *lastClickJsonString;

+ (GTRecordWindowManager *)shareInstance;

//设置页面数据对比数组
@property (nonatomic, strong) NSMutableArray <GTClickerActionModel *> *compareArray;

- (void)recordWindowHide;


@end

NS_ASSUME_NONNULL_END
