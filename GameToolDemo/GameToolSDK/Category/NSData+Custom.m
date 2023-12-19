//
//  NSData+Custom.m
//  GTSDK
//
//  Created by shangmi on 2023/6/30.
//

#import "NSData+Custom.h"
#import "GTClickerSchemeModel.h"

@implementation NSData (Custom)

//获取方案列表数据
+ (NSDictionary *)getSchemeList {
    return [NSData readJsonWithJsonName:@"scheme_list"];
}
//保存方案列表数据
+ (void)saveSchemeList:(NSArray <GTClickerSchemeModel *> *)array {
    NSMutableArray *schemeListArray = [NSMutableArray array];
    for (GTClickerSchemeModel *schemeModel in array) {
        NSMutableArray *actionListArray = [NSMutableArray array];
        for (GTClickerActionModel *actionModel in schemeModel.actionArray) {
            NSMutableDictionary *pointDict = [NSMutableDictionary dictionary];
            [pointDict setValue:[NSNumber numberWithInt:actionModel.tapCount] forKey:@"tap_count"];
            [pointDict setValue:[NSNumber numberWithInt:actionModel.pressDuration] forKey:@"press_duration"];
            [pointDict setValue:[NSNumber numberWithInt:actionModel.clickInterval] forKey:@"click_interval"];
            [pointDict setValue:[NSNumber numberWithFloat:actionModel.centerX] forKey:@"center_x"];
            [pointDict setValue:[NSNumber numberWithFloat:actionModel.centerY] forKey:@"center_y"];
            [pointDict setValue:[NSNumber numberWithLong:actionModel.timestamp] forKey:@"timestamp"];
            
            [actionListArray addObject:pointDict];
        }
        
        NSMutableArray *recordLineArray = [NSMutableArray array];
        for (GTRecordLineModel *recordLineModel in schemeModel.recordLines) {
            NSMutableArray *lineArray = [NSMutableArray array];
            
            for (GTClickerActionModel *actionModel in recordLineModel.touchPoints) {
                NSMutableDictionary *pointDict = [NSMutableDictionary dictionary];
                [pointDict setValue:[NSNumber numberWithInt:actionModel.tapCount] forKey:@"tap_count"];
                [pointDict setValue:[NSNumber numberWithInt:actionModel.pressDuration] forKey:@"press_duration"];
                [pointDict setValue:[NSNumber numberWithInt:actionModel.clickInterval] forKey:@"click_interval"];
                [pointDict setValue:[NSNumber numberWithFloat:actionModel.centerX] forKey:@"center_x"];
                [pointDict setValue:[NSNumber numberWithFloat:actionModel.centerY] forKey:@"center_y"];
//                [pointDict setValue:[NSNumber numberWithLong:actionModel.timestamp] forKey:@"timestamp"];
                [pointDict setValue:@(actionModel.timestamp) forKey:@"timestamp"];
                
                [lineArray addObject:pointDict];
            }
            
            [recordLineArray addObject:@{
                @"lineSource":@(recordLineModel.lineSource),
                @"touchPoints":lineArray
            }];
        }
        
        NSMutableDictionary *schemeDict = [NSMutableDictionary dictionary];
        [schemeDict setValue:[NSNumber numberWithInt:schemeModel.index] forKey:@"index"];
        [schemeDict setValue:[NSNumber numberWithInt:schemeModel.type] forKey:@"type"];
        [schemeDict setValue:[NSString stringWithFormat:@"%@", schemeModel.name] forKey:@"name"];
        [schemeDict setValue:[NSNumber numberWithInt:schemeModel.cycleIndex] forKey:@"cycle_index"];
        [schemeDict setValue:[NSNumber numberWithInt:schemeModel.cycleInterval] forKey:@"cycle_interval"];
        [schemeDict setValue:[NSNumber numberWithInt:(int)schemeModel.startMethod] forKey:@"start_method"];
        [schemeDict setValue:[NSString stringWithFormat:@"%@", schemeModel.startTime] forKey:@"start_time"];
        [schemeDict setValue:[actionListArray copy] forKey:@"action_list"];
        [schemeDict setValue:[recordLineArray copy] forKey:@"record_lines"];
        [schemeDict setValue:@(schemeModel.recordStartTime) forKey:@"recordStartTime"];
        [schemeDict setValue:@(schemeModel.recordEndTime) forKey:@"recordEndTime"];
        
        [schemeListArray addObject:schemeDict];
    }
    [NSData saveJsonToDocument:@{@"data" : [schemeListArray copy]} andJsonName:@"scheme_list"];
}

//获取触点设置
+ (NSDictionary *)getPonitSet {
    return [NSData readJsonWithJsonName:@"point_set"];
}
//保存触点数据
+ (void)savePointSet:(GTClickerPointSetModel *)pointSetModel {
    NSDictionary *pointSetDict = [NSDictionary dictionary];

    [pointSetDict setValue:[NSNumber numberWithInt:(int)pointSetModel.pointShowType] forKey:@"point_show_type"];
    [pointSetDict setValue:[NSNumber numberWithInt:(int)pointSetModel.pointSize] forKey:@"point_size"];
    [pointSetDict setValue:[NSNumber numberWithBool:pointSetModel.isOpenAutiScript] forKey:@"is_open_auti_script"];
    
    [NSData saveJsonToDocument:@{@"data" : pointSetDict} andJsonName:@"point_set"];
}

+ (NSData *)sourceDataWithSourceName:(NSString *)sourceName type:(NSString *)type bundleName:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *dataPath = [bundle pathForResource:sourceName ofType:type];
    return [NSData dataWithContentsOfFile:dataPath];
}

+ (NSDictionary *)readJsonWithJsonName:(NSString *)name {
    NSString *documentPath = [NSData getDocumentPathWithName:name];
    
    NSData *data = [NSData dataWithContentsOfFile:documentPath];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return dict;
    }else {
        return nil;
    }
}
                                                                                                                                                                 
+ (void)saveJsonToDocument:(NSDictionary *)dict andJsonName:(NSString *)name {
    NSString *documentPath = [NSData getDocumentPathWithName:name];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:documentPath atomically:YES];
}

//获取json文件路径
+ (NSString *)getDocumentPathWithName:(NSString *)name {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:name];
    NSLog(@"==============================%@==================", documentPath);
    return documentPath;
}

@end
