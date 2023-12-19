//
//  GTClickerActionModel.h
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerActionModel : NSObject

@property (nonatomic, assign) int tapCount;
@property (nonatomic, assign) int pressDuration;
@property (nonatomic, assign) int clickInterval;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) NSTimeInterval timestamp;//触点产生时的时间戳 CACurrentMediaTime

@end

NS_ASSUME_NONNULL_END
