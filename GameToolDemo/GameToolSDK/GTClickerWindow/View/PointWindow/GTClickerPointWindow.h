//
//  GTClickerPointWindow.h
//  GTSDK
//
//  Created by shangmi on 2023/8/28.
//

#import <UIKit/UIKit.h>
#import "GTClickerActionModel.h"

NS_ASSUME_NONNULL_BEGIN
//拖拽触点文字消失
typedef void(^dragTipDisappearBlock)(void);

@interface GTClickerPointWindow : UIWindow

@property (nonatomic, copy) dragTipDisappearBlock dragTipDisappearBlock;
@property (nonatomic, strong) UIImageView *bgImg;

//@property (nonatomic, strong) GTClickerActionModel *actionModel;

- (instancetype)initWithFrame:(CGRect)frame withIndex:(int)index actionModel:(GTClickerActionModel *)actionModel;

@end

NS_ASSUME_NONNULL_END
