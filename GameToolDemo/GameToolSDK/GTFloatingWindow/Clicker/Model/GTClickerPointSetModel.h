//
//  GTClickerPointSetModel.h
//  GTSDK
//
//  Created by shangmi on 2023/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//触点显示
typedef NS_ENUM(NSUInteger, ClickerWindowPointShowType) {
    ClickerWindowPointShowNo,                         //所有触点不显示
    ClickerWindowPointShowExecute,                    //运行显示
    ClickerWindowPointShowAll,                        //所有触点显示
};

//触点大小
typedef NS_ENUM(NSUInteger, ClickerWindowPointSize) {
    ClickerWindowPointSizeOfSmall,                  //小
    ClickerWindowPointSizeOfMedium,                 //中
    ClickerWindowPointSizeOfLarge,                  //大
};

@interface GTClickerPointSetModel : NSObject

//触点显示
@property (nonatomic, assign) ClickerWindowPointShowType pointShowType;
//触点大小
@property (nonatomic, assign) ClickerWindowPointSize pointSize;
//是否开启防脚本检测
@property (nonatomic, assign) BOOL isOpenAutiScript;

@end

NS_ASSUME_NONNULL_END
