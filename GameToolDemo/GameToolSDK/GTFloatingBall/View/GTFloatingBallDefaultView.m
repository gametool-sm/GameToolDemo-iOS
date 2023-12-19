//
//  GTFloatingBallDefaultView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTFloatingBallDefaultView.h"

@interface GTFloatingBallDefaultView ()

@end

@implementation GTFloatingBallDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [super setUp];
    
    [self addSubview:self.floatingBallImg];
    
    [self.floatingBallImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (UIImageView *)floatingBallImg {
    if (!_floatingBallImg) {
        _floatingBallImg = [UIImageView new];
        
        CGPoint centerPoint = [GTSDKUtils getFloatingBallLastPosition];
        if (centerPoint.x < SCREEN_WIDTH/2) {
            
            _floatingBallImg.image = [[GTThemeManager share] imageWithName:@"floating_ball_right_icon"];
        }else{
            _floatingBallImg.image = [[GTThemeManager share] imageWithName:@"floating_ball_left_icon"];
        }
        _floatingBallImg.userInteractionEnabled = YES;
    }
    return _floatingBallImg;
}

@end
