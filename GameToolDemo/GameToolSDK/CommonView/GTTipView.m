//
//  GTTipView.m
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import "GTTipView.h"
#import "GTFloatingBallConfig.h"

@interface GTTipView ()

//介绍动画地址
@property (nonatomic, copy)NSString *bundleName;
@property (nonatomic, copy)NSString *descText;

@property (nonatomic, strong) LOTAnimationView *descImg;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation GTTipView

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.descLabel.textColor = [GTThemeManager share].colorModel.textColor;
}

- (instancetype)initWithDescText:(NSString *)descText BundleName:(nonnull NSString *)bundleName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0];
        self.bundleName = [bundleName copy];
        self.descText = [descText copy];
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.descImg];
    [self.descImg addSubview:self.descLabel];
    self.descImg.alpha = 0;
    //获取动画json文件
    NSData *data = [NSData sourceDataWithSourceName:self.bundleName type:@"json" bundleName:@"GTSDK"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    [self.descImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo([dict[@"w"] intValue]/3 * WIDTH_RATIO);
        make.height.mas_equalTo([dict[@"h"] intValue]/3 * WIDTH_RATIO);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descImg.mas_bottom).offset(-65 * WIDTH_RATIO);
        make.bottom.equalTo(self.descImg.mas_bottom);
        make.left.equalTo(self.descImg.mas_left).offset(34 * WIDTH_RATIO);
        make.width.mas_equalTo(125 * WIDTH_RATIO);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.descImg.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (![NSStringFromClass([[[touches allObjects] firstObject].view class]) isEqualToString:@"LOTAnimationView"]) {
        [self removeFromSuperview];
    }
    
}

- (LOTAnimationView *)descImg {
    if (!_descImg) {
       
        _descImg = [LOTAnimationView autoDirectoryAnimationNamed:self.bundleName inBundle:[[GTThemeManager share] getGTSDKBundle]];
 
        _descImg.loopAnimation = YES;
        [_descImg play];
    }
    return _descImg;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.text = self.descText;
        _descLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _descLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

@end
