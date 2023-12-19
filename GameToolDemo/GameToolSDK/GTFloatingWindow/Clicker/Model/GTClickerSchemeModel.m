//
//  GTClickerSchemeModel.m
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import "GTClickerSchemeModel.h"
#import "NSData+Custom.h"

@implementation GTRecordLineModel
-(NSMutableArray<GTClickerActionModel *> *)touchPoints{
    if(!_touchPoints){
        _touchPoints = [NSMutableArray array];
    }
    return _touchPoints;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"touchPoints" : [GTClickerActionModel class]
        
    };
}
@end
@implementation GTClickerSchemeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cycleIndex":@"cycle_index",
             @"cycleInterval":@"cycle_interval",
             @"startMethod":@"start_method",
             @"startTime":@"start_time",
             @"actionArray":@"action_list",
             @"recordLines":@"record_lines"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"actionArray" : [GTClickerActionModel class],
        @"recordLines": [GTRecordLineModel class],
        
    };
}

+(instancetype)defaultSchemeModel:(int)type{
    GTClickerSchemeModel *schemeModel = [GTClickerSchemeModel new];
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *schemedict = [NSData getSchemeList];
    NSArray *scheme_list = [schemedict objectForKey:@"data"];
    schemeModel.index = (int)scheme_list.count+1;
    schemeModel.type = type;
    schemeModel.cycleIndex = 0;
    schemeModel.startMethod = 0;
//    schemeModel.name = [NSString stringWithFormat:@"默认%@方案%ld",type==0?@"录制":@"连点", scheme_list.count + 1];
    schemeModel.name = [NSString stringWithFormat:@"默认连点方案%ld",scheme_list.count + 1];
    schemeModel.startTime = @"00:00:00";
    schemeModel.actionArray = array;
//    chemeModel.recordLines = [NSMutableArray array];
    if(type==1){
        GTClickerActionModel *point2 = [GTClickerActionModel new];
        point2.tapCount = 1;
        point2.pressDuration = 80;
        point2.clickInterval = 1000;
        point2.centerX = SCREEN_WIDTH/2;
        point2.centerY = [GTSDKUtils isPortrait]?160 * WIDTH_RATIO : 80 * WIDTH_RATIO;
        point2.timestamp = 0;
        NSMutableArray *array2 = [NSMutableArray array];
        [array2 addObject:point2];
    }
    return schemeModel;
    
}

-(NSMutableArray<GTRecordLineModel *> *)recordLines{
    if(!_recordLines){
        _recordLines = [NSMutableArray array];
    }
    return _recordLines;
}
@end
