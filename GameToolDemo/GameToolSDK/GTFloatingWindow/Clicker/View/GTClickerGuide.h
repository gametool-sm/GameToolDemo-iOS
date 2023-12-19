//
//  GTClickerGuide.h
//  GTSDK
//
//  Created by shangminet on 2023/8/18.
//
/**
 
        引导蒙层
        
 */
#import <UIKit/UIKit.h>
#import "GTBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GTClickerGuide : GTBaseView

@property (nonatomic, strong) UIImageView *mengbanImage;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIImageView *deleteImage;
@property (nonatomic, strong) UILabel *deleteLabel;
@property (nonatomic, strong) UIImageView *tipImage;
@property (nonatomic, strong) UILabel *tipLabel;

//移除蒙层
- (void)hideAll;

@end

NS_ASSUME_NONNULL_END
