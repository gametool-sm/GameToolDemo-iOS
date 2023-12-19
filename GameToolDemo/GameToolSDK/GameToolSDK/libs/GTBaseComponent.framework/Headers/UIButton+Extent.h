//
//  UIButton+Extent.h
//  GTBaseComponent
//
//  Created by smwl_dxl on 2023/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extent)

/*
 扩大按钮的点击范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
