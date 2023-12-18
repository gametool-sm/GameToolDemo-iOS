//
//  GTRecordWindowFiniteView.h
//  GTSDK
//
//  Created by shangmi on 2023/10/23.
//

#import "GTBaseView.h"
#import "GTClickerSchemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordWindowFiniteView : GTBaseView

@property (nonatomic, assign) int loopNum;
@property (nonatomic, strong) UILabel *loopDetailLabel;

//距离下一次动作的时间
@property (nonatomic, assign) float waitTime;
@property (nonatomic, strong) UILabel *waitTimeDetailLabel;
//距离下一次动作的时间倒计时计时器
//@property (nonatomic, strong, nullable) NSTimer *waitTimer;
@property (nonatomic, strong, nullable) CADisplayLink *waitDisplayLink;

//持续计时的时间
@property (nonatomic, assign) int timeNumber;

//开始距离下一次动作的时间倒计时计时器
- (void)startWaitTimer;
//移除距离下一次动作的时间倒计时计时器
- (void)removeWaitTimer;

- (void)updateData:(GTClickerSchemeModel *)model;

- (void)updateSize;
- (void)startScheme;
- (void)finishScheme;

@end

NS_ASSUME_NONNULL_END
