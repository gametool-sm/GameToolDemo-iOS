//
//  UIButton+Extent.h
//  GTSDK
//
//  Created by shangmi on 2023/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extent)

/*
 扩大按钮的点击范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

- (void)layoutButtonWithImageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
