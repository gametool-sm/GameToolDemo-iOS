//
//  GTMultiplyingSetView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/1.
//

#import "GTBaseView.h"
@class GTMultiplyingSetView;

NS_ASSUME_NONNULL_BEGIN

//减号按钮block
typedef void(^SubtractButtonBlock)(GTMultiplyingModel *model);
//加号按钮bloock
typedef void(^AddButtonBlock)(GTMultiplyingModel *model);
//删除block
typedef void(^DeleteButtonBlock)(GTMultiplyingModel *model,GTMultiplyingSetView *view);

@interface GTMultiplyingSetView : GTBaseView

@property (nonatomic, copy) SubtractButtonBlock subtractButtonBlock;

@property (nonatomic, copy) AddButtonBlock addButtonBlock;

@property (nonatomic, copy) DeleteButtonBlock deleteButtonBlock;

- (void)updateStyleWithSpeedModel:(GTMultiplyingModel *)model index:(int)index isEdit:(BOOL)isEdit;

//进入编辑状态
- (void)startEdit;

//结束编辑状态
- (void)endEdit;

@end

NS_ASSUME_NONNULL_END
