//
//  GTSpeedUpSliderView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTSpeedUpSliderView : UIView

//进度
@property(nonatomic,assign) CGFloat progress;
//判断是加速还是减速
@property(nonatomic,  assign) BOOL isUp;

//滑动时和停止后Block
- (void)changeValue:(void(^_Nullable)(CGFloat value))changeEvent endValue:(void(^_Nullable)(CGFloat value))endValue;

@end

NS_ASSUME_NONNULL_END
