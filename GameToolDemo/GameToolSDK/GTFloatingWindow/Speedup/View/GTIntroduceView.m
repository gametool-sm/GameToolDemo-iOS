//
//  GTIntroduceView.m
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import "GTIntroduceView.h"
@interface GTIntroduceView ()

//介绍文本
@property (nonatomic, copy)NSString *descText;
//介绍动画地址
@property (nonatomic, copy)NSString *bundleName;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) LOTAnimationView *descImg;

@end

@implementation GTIntroduceView

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    self.descLabel = nil;
    self.descImg = nil;
    [self setUp];
}

- (instancetype)initWithDescText:(nonnull NSString *)descText bundleName:(nonnull NSString *)bundleName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.descText = [descText copy];
        self.bundleName = [bundleName copy];
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.descLabel];
    [self.scrollView addSubview:self.descImg];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];

    [self.descImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(5 * WIDTH_RATIO);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(110 * WIDTH_RATIO);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-5 * WIDTH_RATIO);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.contentSize = CGSizeMake(0, MAXFLOAT);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.numberOfLines = 0;
        
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.descText];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        NSRange tempRange = NSMakeRange(0, attributedStr.length);
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:tempRange];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * WIDTH_RATIO] range:tempRange];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[GTThemeManager share].colorModel.textColor range:tempRange];
        _descLabel.attributedText = attributedStr;

    }
    return _descLabel;
}

- (LOTAnimationView *)descImg {
    if (!_descImg) {

        _descImg = [LOTAnimationView autoDirectoryAnimationNamed:self.bundleName inBundle:[[GTThemeManager share] getGTSDKBundle]];

        _descImg.loopAnimation = YES;
        [_descImg play];
    }
    return _descImg;
}


@end
