//
//  UIFont+Custom.h
//  GTBaseComponent
//
//  Created by shangmi on 2023/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Custom)

/// 粗体字体
/// - Parameter size: 字体大小
+ (UIFont *)boldFontOfSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
