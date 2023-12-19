//
//  GTClickerWindowFutureStartView.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTBaseView.h"
#import "GTClickerSchemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowFutureStartView : GTBaseView

//倒计时计时器
@property (nonatomic, strong, nullable) NSTimer *countDownTimer;

- (void)updateData:(GTClickerSchemeModel *)model;

//开始熄灭倒计时（只有启动方式为倒计时和立即的才有熄灭状态）
- (void)clickerWindowStartDark;
//移除会变成熄灭状态的计时器
- (void)clickerWindowRemoveDark;
- (void)removeTimer;
@end

NS_ASSUME_NONNULL_END
