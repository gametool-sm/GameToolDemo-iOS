//
//  GTClickerWindowStartView.h
//  GTSDK
//
//  Created by shangminet on 2023/9/23.
//

#import "GTBaseView.h"

typedef void(^StartViewPauseClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SchemeActionPageType) {
    SchemeActionPageTypeRecord,
    SchemeActionPageTypeRecording,
    SchemeActionPageTypeRecordPlaying,
    SchemeActionPageTypeClickerPlaying,
};

@interface GTClickerWindowStartView : GTBaseView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *pauseSchemeButton;
@property (nonatomic, strong) UIImageView *pauseView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign) SchemeActionPageType schemeActionPageType;

@property (nonatomic, copy) StartViewPauseClickBlock startViewPauseClickBlock;

- (void)updateDataWithType:(SchemeActionPageType)type;

@end

NS_ASSUME_NONNULL_END
