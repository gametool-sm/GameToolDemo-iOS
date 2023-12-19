//
//  UIColor+Util.m
//  GTSDK
//
//  Created by shangmi on 2023/6/27.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

+ (UIColor *)themeColor {
    return [UIColor hexColor:@"#3391FF"];
}

+ (UIColor *)themeColorWithAlpha:(CGFloat)alpha {
    return [UIColor hexColor:@"#3391FF" withAlpha:alpha];
}

+ (UIColor *)hexColor:(NSString *)hexColorString {
    return [UIColor hexColor:hexColorString withAlpha:1];
}

+ (UIColor *)hexColor:(NSString *)hexColorString withAlpha:(CGFloat)alpha {
    NSString *cString = [[hexColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
 
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
 
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
 
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
 
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
 
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
