//
//  GTClickercreateViewController.h
//  GTSDK
//
//  Created by shangminet on 2023/8/15.
//

#import <UIKit/UIKit.h>

#import "GTBaseViewController.h"
#import "GTClickerSchemeModel.h"
NS_ASSUME_NONNULL_BEGIN

/*
        实现创建方案的页面
 */



@interface GTClickercreateViewController : GTBaseViewController
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) GTClickerSchemeModel *model;
@end

NS_ASSUME_NONNULL_END
