//
//  GTTimerManager.h
//  GTSDK
//
//  Created by 童威 on 2023/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ExtinguishTimerTimeOutCompleteBlock)(void);
typedef void (^HideHalfTimerTimeOutCompleteBlock)(void);
typedef void (^LightedTimerTimeOutCompleteBlock)(void);

@interface GTTimerManager : NSObject
//悬浮球熄灭计时器
@property (nonatomic, strong) dispatch_source_t extinguishTimer;
//悬浮球隐藏一半计时器
@property (nonatomic, strong) dispatch_source_t hideHalfTimer;

@property (nonatomic, copy) ExtinguishTimerTimeOutCompleteBlock extinguishTimerTimeOutCompleteBlock;

@property (nonatomic, copy) HideHalfTimerTimeOutCompleteBlock hideHalfTimerTimeOutCompleteBlock;

@property (nonatomic, copy) LightedTimerTimeOutCompleteBlock lightedTimerTimeOutCompleteBlock;

@property (nonatomic, copy) dispatch_block_t extinguishBlock;

@property (nonatomic, copy) dispatch_block_t hidehalfBlock;

//instanc
+ (GTTimerManager *)shareManager;

//开始计时器
- (void)initiate:(dispatch_source_t)timer;

//暂停计时器
- (void)pause:(dispatch_source_t)timer;

//重置计时器
- (void)reset:(dispatch_source_t)timer;

//移除计时器
- (void)remove:(dispatch_source_t)timer;

@end

NS_ASSUME_NONNULL_END
