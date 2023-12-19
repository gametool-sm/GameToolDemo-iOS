//
//  GTRecordWindowRecordTimeView.h
//  GTSDK
//
//  Created by shangmi on 2023/10/17.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN
                                                                                                             
@interface GTRecordWindowRecordTimeView : GTBaseView

//计时计时器
@property (nonatomic, strong, nullable) NSTimer *timer;

//开始熄灭倒计时（只有启动方式为倒计时和立即的才有熄灭状态）
- (void)startDark;
//移除会变成熄灭状态的计时器
- (void)removeDark;

//开始计时计时器
- (void)startTimer;
- (void)removeTimer;

@end

NS_ASSUME_NONNULL_END
