//
//  GTEmptyDataView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/14.
//

#import "GTEmptyDataView.h"

@implementation GTEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    UIImageView *tipImg = [UIImageView new];
    tipImg.image = [[GTThemeManager share] imageWithName:@"clicker_main_placeholder_img"];
    [self addSubview:tipImg];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.textColor = [GTThemeManager share].colorModel.clicker_empty_text_color;
    tipLabel.text = localString(@"暂无可用方案，赶快去创建吧");
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:12 * WIDTH_RATIO];
    [self addSubview:tipLabel];
    
    [tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100 * WIDTH_RATIO);
        make.height.mas_equalTo(93 * WIDTH_RATIO);
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(20 * WIDTH_RATIO);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipImg.mas_bottom).offset(20 * WIDTH_RATIO);
    }];
}

@end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
