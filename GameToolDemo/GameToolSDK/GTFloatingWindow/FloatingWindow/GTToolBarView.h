//
//  GTToolBarView.h
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTBaseView.h"
#import "GTToolBarView.h"

NS_ASSUME_NONNULL_BEGIN
@class GTToolBarView;
@protocol ToolBarClickDelegate <NSObject>
//返回点击回调
- (void)toolBar:(GTToolBarView *)toolBar backClick:(UIButton *)sender;
//功能点击回调
- (void)toolBar:(GTToolBarView *)toolBar didSelected:(UIButton *)sender;

@end

@interface GTToolBarView : UIView

@property (nonatomic, weak) id<ToolBarClickDelegate> toolBarClickDelegate;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *speedUpButton;
@property (nonatomic, strong) UIButton *clickerButton;
@property (nonatomic, strong) UIButton *setButton;

@end

NS_ASSUME_NONNULL_END
