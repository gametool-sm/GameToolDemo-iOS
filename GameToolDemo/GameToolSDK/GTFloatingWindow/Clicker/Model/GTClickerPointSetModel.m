//
//  GTClickerPointSetModel.m
//  GTSDK
//
//  Created by shangmi on 2023/8/28.
//

#import "GTClickerPointSetModel.h"

@implementation GTClickerPointSetModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pointShowType":@"point_show_type",
             @"pointSize":@"point_size",
             @"isOpenAutiScript":@"is_open_autiScript"
    };
}

@end
