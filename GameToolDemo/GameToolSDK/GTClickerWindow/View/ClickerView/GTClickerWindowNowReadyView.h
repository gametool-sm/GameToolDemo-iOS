//
//  GTClickerWindowNowReadyView.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//启动
typedef void(^StartBlock)(void);
//增加
typedef void(^AddBlock)(void);
//设置
typedef void(^SetBlock)(void);


@interface GTClickerWindowNowReadyView : GTBaseView

@property (nonatomic, copy) StartBlock startBlock;

@property (nonatomic, copy) AddBlock addBlock;

@property (nonatomic, copy) SetBlock setBlock;

//蒙层
@property (nonatomic, strong) UIImageView *shadowImg;

@end

NS_ASSUME_NONNULL_END
