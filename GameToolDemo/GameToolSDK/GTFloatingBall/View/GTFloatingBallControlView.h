//
//  GTFloatingBallControlView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTFloatingBallBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallControlView : GTFloatingBallBaseView

@property (nonatomic, strong) UIButton *floatingBallBtn;

- (void)clickShadowView:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
