//
//  GTRecordWindowViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTBaseViewController.h"

#import "GTRecordWindowBeginRecordView.h"
#import "GTRecordWindowRecordTimeView.h"
#import "GTRecordWindowInfiniteView.h"
#import "GTRecordWindowFiniteView.h"
#import "GTRecordWindowCountdownView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordWindowViewController : GTBaseViewController

/**
 录制悬浮球
 */
@property (nonatomic, strong, nullable) GTRecordWindowBeginRecordView *beginRecordView;
@property (nonatomic, strong, nullable) GTRecordWindowRecordTimeView *recordTimeView;
@property (nonatomic, strong, nullable) GTRecordWindowInfiniteView *infiniteView;
@property (nonatomic, strong, nullable) GTRecordWindowFiniteView *finiteView;
@property (nonatomic, strong, nullable) GTRecordWindowCountdownView *counntdownView;

@end

NS_ASSUME_NONNULL_END
