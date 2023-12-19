//
//  GTFloatingWindowConfig.m
//  GTSDK
//
//  Created by shangmi on 2023/6/30.
//

#import "GTFloatingWindowConfig.h"

//工具栏宽度(竖屏，横屏宽高相反)
CGFloat const toolbar_width = 196;
//工具栏高度(竖屏，横屏宽高相反)
CGFloat const toolbar_height = 52;
//悬浮弹窗宽度
CGFloat const floatingWindow_width = 310;
//悬浮弹窗高度
CGFloat const floatingWindow_height = 310;
//悬浮弹窗+切换工具栏的总高度
CGFloat const floatingWindowAndChange_height = 373;

@implementation GTFloatingWindowConfig

//返回展现的加速数字（分为整型和浮点型）
//范围区间
//0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9
//1 2 3 4 5 6 7 8 9 10
+ (GTMultiplyingModel *)didOperation:(BOOL)isAdd SpeedModel:(GTMultiplyingModel *)model {
    float number = model.number;
    if (isAdd) {
        if (number >= 1) {
            number += 1;
            if (number > 10) {
                model.number = number;
                model.isUp = YES;
                return model;
            }
            number = [[NSString stringWithFormat:@"%.0f", number] intValue];
            model.number = number;
            model.isUp = YES;
        }else {
            number += 0.1;
            if (number == 1) {
                number = [[NSString stringWithFormat:@"%.0f", number] intValue];
                model.number = number;
                model.isUp = YES;
            }else {
                number = [[NSString stringWithFormat:@"%.1f", number] floatValue];
                model.number = number;
                model.isUp = NO;
            }
        }
    }else {
        if (number > 1) {
            number -= 1;
            number = [[NSString stringWithFormat:@"%.0f", number] intValue];
            model.number = number;
            model.isUp = YES;
        }else {
            number -= 0.1;
            if (number < 0.1) {
                model.number = 0.1;
                model.isUp = NO;
                return model;
            }
            number = [[NSString stringWithFormat:@"%.1f", number] floatValue];
            model.number = number;
            model.isUp = NO;
        }
    }
    return model;
}

@end
