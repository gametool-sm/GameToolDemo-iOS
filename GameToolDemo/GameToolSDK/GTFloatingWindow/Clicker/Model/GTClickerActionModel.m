//
//  GTClickerActionModel.m
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import "GTClickerActionModel.h"

@implementation GTClickerActionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tapCount":@"tap_count",
             @"pressDuration":@"press_duration",
             @"clickInterval":@"click_interval",
             @"centerX":@"center_x",
             @"centerY":@"center_y",
    };
}

@end
