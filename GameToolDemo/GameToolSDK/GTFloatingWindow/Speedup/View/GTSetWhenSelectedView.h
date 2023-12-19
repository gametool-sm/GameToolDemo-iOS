//
//  GTSetWhenSelectedView.h
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import "GTBaseView.h"
#import "GTSwitch.h"

NS_ASSUME_NONNULL_BEGIN

//点击问号
typedef void(^ClickTipBlock)(NSString *str);
//点击自动贴边切换
typedef void(^ClickAutoHideSwitchBlock)(BOOL isOn);
//点击倍率快捷切换
typedef void(^ClickMultiplyingSwitchBlock)(BOOL isOn);
//进入当前配置
typedef void(^ClickCurrentConfigBlock)(NSArray *dataArray);

@interface GTSetWhenSelectedView : GTBaseView

@property (nonatomic, strong) GTSwitch *autoHideSwitch;

@property (nonatomic, copy) ClickTipBlock clickTipBlock;
@property (nonatomic, copy) ClickAutoHideSwitchBlock clickAutoHideSwitchBlock;
@property (nonatomic, copy) ClickMultiplyingSwitchBlock clickMultiplyingSwitchBlock;
@property (nonatomic, copy) ClickCurrentConfigBlock clickCurrentConfigBlock;

@end

NS_ASSUME_NONNULL_END
