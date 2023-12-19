//
//  SMClickPointModel.h
//  GTAPP
//
//  Created by smwl on 2023/8/31.
//

#import <Foundation/Foundation.h>
//#import "NSObject+toDictionary.h"
NS_ASSUME_NONNULL_BEGIN

@interface SMClickPointModel : NSObject

/// 按钮点击次数
@property (nonatomic, assign) int tapCount;

/// 按压时间毫秒
@property (nonatomic, assign) int pressDuration;
@property (nonatomic, assign) int clickInterval;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/// PointModel在数组中的索引值
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSTimeInterval timestamp;//触点产生时的时间戳

@end

NS_ASSUME_NONNULL_END
