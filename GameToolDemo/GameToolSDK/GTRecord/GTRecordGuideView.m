//
//  GTRecordGuideView.m
//  GTSDK
//
//  Created by smwl on 2023/10/26.
//

#import "GTRecordGuideView.h"
#import "NSData+Custom.h"
#import "GTDialogWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTRecordWindowManager.h"

@interface GTRecordGuideView()

@property(nonatomic,copy)GuideCloseCallBack closeCallBack;

@end

static GTRecordGuideView *_guideView = nil;

@implementation GTRecordGuideView

+(instancetype)showGuideViewWithCloseCallBack:(GuideCloseCallBack)closeCallBack{
    BOOL isNotFirstTimeRecord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstTimeRecord"];
    if(isNotFirstTimeRecord){
        if(closeCallBack){
            closeCallBack();
        }
        return nil;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstTimeRecord"];
    GTRecordGuideView *guideView = [GTRecordGuideView new];
    guideView.closeCallBack = closeCallBack;
    guideView.backgroundColor = [UIColor colorWithRed:0.0/225 green:0.0/225 blue:0.0 alpha:0.5];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    [[GTDialogWindowManager shareInstance].dialogWindow addSubview:guideView];
//    [GTDialogWindowManager shareInstance].dialogWindow.windowLevel = 2899;
    [window addSubview:guideView];
//    [[GTDialogWindowManager  shareInstance] dialogWindowShow];
    [guideView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo([GTDialogWindowManager shareInstance].dialogWindow);
        make.edges.equalTo(window);
    }];
    _guideView = guideView;

    return guideView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self setUI];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeGuide)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}
-(UIImageView *)imageViewWithImageName:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[[GTThemeManager share] imageWithName:imageName]];
    [self addSubview:imageView];
    return imageView;
}
-(UILabel *)labelWithTitle:(NSString *)title fontOfSize:(CGFloat)fontOfSize{
    UILabel *label = [UILabel new];
    [label setText:title];
    [label setFont:[UIFont systemFontOfSize:fontOfSize weight:400]];
    [label setTextColor:[UIColor whiteColor]];
    [self addSubview:label];
    return label;
}
-(void)setUI{
    UIImageView *recordStartIcon = [self imageViewWithImageName:@"record_start_icon"];
//    [recordStartIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).mas_offset(10.0);
//        make.top.mas_equalTo(self.mas_top).mas_offset(257.0);
//        make.size.mas_equalTo(CGSizeMake(48.0, 48.0));
//    }];
    recordStartIcon.frame = [GTRecordWindowManager shareInstance].recordWinWindow.frame;
    recordStartIcon.hidden = YES;
    
    
    
    UIImageView *recordGuideIndicate = [self imageViewWithImageName:@"record_guide_indicate"];
    [recordGuideIndicate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(recordStartIcon.mas_right);
        make.centerY.mas_equalTo(recordStartIcon.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(41.0, 14.0));
    }];

    
    UILabel *recordStartLabel = [self labelWithTitle:localString(@"点击开始录制") fontOfSize:9 * WIDTH_RATIO];
    [recordStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(recordGuideIndicate.mas_right).mas_offset(4.0 * WIDTH_RATIO);
        make.centerY.mas_equalTo(recordGuideIndicate.mas_centerY);
    }];
    
    UIImageView *recordGuideCloseBg = nil;
    if([GTSDKUtils isPortrait]){
        recordGuideCloseBg = [self imageViewWithImageName:@"record_guide_close_bg"];
        [recordGuideCloseBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(self);
            make.height.mas_equalTo(160.0);
        }];
    }else{
        recordGuideCloseBg = [self imageViewWithImageName:@"record_guide_close_bg_ld"];
        [recordGuideCloseBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.centerX);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[[GTThemeManager share] imageWithName:@"clicker_mask_delete"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeGuide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    UILabel *recordCloseLabel = [self labelWithTitle:localString(@"拖拽至此可关闭") fontOfSize:13.0];
    [recordCloseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-26.0);
    }];
 
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.size.mas_equalTo(CGSizeMake(50.0, 50.0));
        make.bottom.mas_equalTo(recordCloseLabel.mas_top).mas_offset(-15.0);
    }];
    
    
    UIImageView *recordGuideDragDown = [self imageViewWithImageName:@"record_guide_drag_down"];
    [recordGuideDragDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.bottom.mas_equalTo(recordGuideCloseBg.mas_top).mas_offset(-8.0);
        make.size.mas_equalTo(CGSizeMake(24.0, 49.0));
    }];
    
}
+(void)closeGuideNow{
    [_guideView removeFromSuperview];
    _guideView = nil;
//    [GTDialogWindowManager shareInstance].dialogWindow.windowLevel = 30100;
//    [[GTDialogWindowManager shareInstance] dialogWindowHide];
}
+(void)closeGuide{
    [_guideView closeGuide];
}
-(void)closeGuideWithCloseCallBack:(GuideCloseCallBack)closeCallBack{
    [self closeGuide];
    if(closeCallBack){
        closeCallBack();
    }
}
/// 关闭引导蒙层
-(void)closeGuide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(self.closeCallBack){
            self.closeCallBack();
        }
        [self removeFromSuperview];
        _guideView = nil;
//        [GTDialogWindowManager shareInstance].dialogWindow.windowLevel = 30100;
//        [[GTDialogWindowManager shareInstance] dialogWindowHide];
    }];
    
}
@end
