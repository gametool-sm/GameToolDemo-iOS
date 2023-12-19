//
//  GTFloatingBallBaseView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallBaseView : UIView

//蒙层
@property (nonatomic, strong) UIView *shadowView;

- (void)setUp;

- (void)changeTheme:(NSNotification *)noti;

@end

NS_ASSUME_NONNULL_END
