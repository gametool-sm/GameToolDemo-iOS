//
//  GTClickerMainTableViewCell.h
//  GTSDK
//
//  Created by shangmi on 2023/8/14.
//

#import <UIKit/UIKit.h>
#import "GTClickerSchemeModel.h"
#import "GTClickerMainTableViewCell.h"
#import "GTBaseView.h"
#import "GTDialogView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol GTClickerMainTableViewCellDelegate <NSObject>
- (void)enableButtonClickedForRow:(NSInteger)row;

//编辑完成后的数据更新
- (void)cellDidFinishEditingWithModel:(GTClickerSchemeModel *)data indexPath:(NSIndexPath *)indexPath;
//删除行
- (void)deleteButtonClickedInCell:(UITableViewCell *)cell;

//
- (void)moreButtonClickedForRow:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell;
@end


@interface GTClickerMainTableViewCell : UITableViewCell
@property (nonatomic, weak) id<GTClickerMainTableViewCellDelegate> celldelegate;
@property (nonatomic, strong) id<UITableViewDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger finalPath;
@property (nonatomic, assign) NSInteger firstPath;

- (void)updateWithData:(GTClickerSchemeModel *)model;
@end

NS_ASSUME_NONNULL_END
