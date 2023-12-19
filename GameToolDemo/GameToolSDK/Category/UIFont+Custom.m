//
//  UIFont+Custom.m
//  GTSDK
//
//  Created by shangmi on 2023/6/27.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (UIFont *)boldFontOfSize:(CGFloat)size {
    return  [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (UIFont *)mediumFontOfSize:(CGFloat)size {
    return  [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}


@end
