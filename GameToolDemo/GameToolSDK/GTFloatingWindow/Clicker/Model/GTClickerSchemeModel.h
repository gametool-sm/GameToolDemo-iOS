//
//  GTClickerSchemeModel.h
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import <Foundation/Foundation.h>
#import "GTClickerActionModel.h"
#import "GTClickerWindowConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,GTLineSource){
    GTLineSourceTap,//这条线来自tap手势
    GTLineSourceLongPress,//这条线来自LongPress手势
    GTLineSourcePan//这条线来自Pan手势
    
};

@interface GTRecordLineModel : NSObject

@property(nonatomic,assign)GTLineSource lineSource;

@property(nonatomic,strong)NSMutableArray <GTClickerActionModel *>*touchPoints;


@end

@interface GTClickerSchemeModel : NSObject

//在方案列表中的索引
@property (nonatomic, assign) int index;
//0为录制，1为连点
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int cycleIndex;//0无限循环
@property (nonatomic, assign) int cycleInterval;
@property (nonatomic, assign) ClickerWindowStartMethod startMethod;
@property (nonatomic, copy) NSString *startTime;
//连点功能储存所有触点的model
@property (nonatomic, strong) NSMutableArray <GTClickerActionModel *> *actionArray;
//录制功能储存所有触点，数组中的每个元素为一个数组，即为一条轨迹
@property (nonatomic, strong) NSMutableArray <GTRecordLineModel *> *recordLines;

@property (nonatomic, assign) NSTimeInterval recordStartTime;//开始录制按钮点击时间(秒级)
@property (nonatomic, assign) NSTimeInterval recordEndTime;//结束录制按钮点击时间(秒级)

/// <#Description#>
/// - Parameter type: 方案类型 0:录制方案 1:连点方案
+(instancetype)defaultSchemeModel:(int)type;

@end

NS_ASSUME_NONNULL_END
