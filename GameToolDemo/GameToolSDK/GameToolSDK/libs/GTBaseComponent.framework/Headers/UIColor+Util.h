//
//  UIColor+Util.h
//  GTBaseComponent
//
//  Created by shangmi on 2023/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Util)

//主题色
+ (UIColor *)themeColor;
//主题色和透明度
+ (UIColor *)themeColorWithAlpha:(CGFloat)alpha;

//十六进制颜色转换
+ (UIColor *)hexColor:(NSString *)hexColorString;
//十六进制颜色转换和透明度
+ (UIColor *)hexColor:(NSString *)hexColorString withAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
