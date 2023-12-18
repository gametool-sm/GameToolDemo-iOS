//
//  GTLineModel.m
//  GTSDK
//
//  Created by smwl on 2023/10/19.
//

#import "GTLineModel.h"
#import "UIFont+Custom.h"
@interface GTLineModel()


@end
@implementation GTLineModel

-(void)addTouchPointModel:(GTClickerActionModel *)pointModel{
    [self.recordLine.touchPoints addObject:pointModel];
}
-(void)removeStartEndButton{
    [self.startPointButton removeFromSuperview];
    [self.endPointButton removeFromSuperview];
}
/// 展示线的端点：线的起点或终点按钮
/// - Parameters:
///   - pointType:起点或终点
///   - superView: 起点或终点的父view
///   - backGroundImage: 背景图片
///   - alpha: 透明度
-(void)showExtremePoint:(PointType)pointType superView:(UIView *)superView backGround:(NSString *)backGroundImage alpha:(CGFloat)alpha width:(CGFloat)width{
    
    if (pointType==PointType_During) return;
    UIButton *button = pointType==PointType_Start?self.startPointButton:self.endPointButton;

    GTClickerActionModel *pointModel = pointType==PointType_Start?self.recordLine.touchPoints.firstObject:self.recordLine.touchPoints.lastObject;
    [self showPointButton:superView pointModel:pointModel button:button width:width];
    [self updateExtremePointBackGround:backGroundImage alpha:alpha button:button];
}

/// 显示端点按钮
/// - Parameters:
///   - superView: <#superView description#>
///   - pointModel: <#pointModel description#>
///   - button: <#button description#>
-(void)showPointButton:(UIView *)superView pointModel:(GTClickerActionModel *)pointModel button:(UIButton *)button width:(CGFloat)width{
    if(![superView.subviews containsObject:button]){
        [superView addSubview:button];
    }
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.mas_equalTo(pointModel.centerX-width/2);
        make.top.mas_equalTo(pointModel.centerY-width/2);
    }];
    
    
}
/// 展示单个触点
/// - Parameters:
///   - pointType: <#pointType description#>
///   - superView: <#superView description#>
///   - backGroundImage: <#backGroundImage description#>
///   - alpha: <#alpha description#>
-(void)showTapPoint:(PointType)pointType superView:(UIView *)superView backGround:(NSString *)backGroundImage alpha:(CGFloat)alpha width:(CGFloat)width{
    
    if (pointType==PointType_During || pointType==PointType_End) return;
    UIButton *button = self.startPointButton;//单个触点只展示起点
    GTClickerActionModel *pointModel = self.recordLine.touchPoints.firstObject;
    [self showPointButton:superView pointModel:pointModel button:button width:width];
    [self updateExtremePointBackGround:backGroundImage alpha:alpha button:button];
    
}
-(void)updateExtremePointBackGround:(NSString *)backGroundImage alpha:(CGFloat)alpha button:(UIButton *)button{
//    NSString *backGroundImageNameNormal = [NSString stringWithFormat:@"%@_normal",backGroundImage];
//    NSString *backGroundImageNameHilight = [NSString stringWithFormat:@"%@_hilight",backGroundImage];
    [button setBackgroundImage:[[GTThemeManager share] imageWithName:backGroundImage] forState:UIControlStateNormal];
    button.titleLabel.alpha = alpha;
//    [button setBackgroundImage:[[GTThemeManager share] imageWithName:backGroundImage] forState:UIControlStateHighlighted];
    
//    button.alpha = alpha;
    
}
-(void)updateExtremePointBackGround:(NSString *)backGroundImage alpha:(CGFloat)alpha{
    [self updateExtremePointBackGround:backGroundImage alpha:alpha button:self.startPointButton];
    [self updateExtremePointBackGround:backGroundImage alpha:alpha button:self.endPointButton];
}
#pragma mark--getter/setter
-(void)setLineNum:(NSInteger)lineNum{
    _lineNum = lineNum;
    if(lineNum==0){
        [self.startPointButton setTitle:@"" forState:UIControlStateNormal];
        [self.endPointButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.startPointButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.lineNum] forState:UIControlStateNormal];
        [self.endPointButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.lineNum] forState:UIControlStateNormal];
    }
}
-(UIButton *)getPointButton{
    UIButton *button = [UIButton new];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.backgroundColor = [UIColor clearColor];
    [button.titleLabel setFont:[UIFont mediumFontOfSize:13.0]];
    button.userInteractionEnabled = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}
-(UIButton *)startPointButton{
    if(!_startPointButton){
        _startPointButton = [self getPointButton];
    }
    return _startPointButton;
}

-(UIButton *)endPointButton{
    if(!_endPointButton){
        _endPointButton =  [self getPointButton];
    }
    return _endPointButton;
}
-(UIView *)startBackGroudView{
    if(!_startBackGroudView){
        _startBackGroudView = [UIView new];
        _startBackGroudView.backgroundColor = [UIColor colorWithRed:51/255.0 green:145/255.0 blue:255/255.0 alpha:1.0];
        _startBackGroudView.layer.cornerRadius = 17.0 * WIDTH_RATIO;
        _startBackGroudView.clipsToBounds = YES;
//        _startBackGroudView.alpha = 0.3;
    }
    return _startBackGroudView;
}

-(GTRecordLineModel *)recordLine{
    if(!_recordLine){
        _recordLine = [GTRecordLineModel new];
    }
    return _recordLine;
}
@end
