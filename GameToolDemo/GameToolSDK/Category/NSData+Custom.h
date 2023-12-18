//
//  NSData+Custom.h
//  GTSDK
//
//  Created by shangmi on 2023/6/30.
//

#import <Foundation/Foundation.h>
#import "GTClickerSchemeModel.h"
#import "GTClickerPointSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Custom)

+ (NSData *)sourceDataWithSourceName:(NSString *)sourceName type:(NSString *)type bundleName:(NSString *)bundleName;

//获取json文件
+ (NSDictionary *)readJsonWithJsonName:(NSString *)name;

//保存json文件
+ (void)saveJsonToDocument:(NSDictionary *)dict andJsonName:(NSString *)name;

//获取方案列表数据
+ (NSDictionary *)getSchemeList;
//保存方案列表数据
+ (void)saveSchemeList:(NSArray <GTClickerSchemeModel *> *)array;

//获取触点设置
+ (NSDictionary *)getPonitSet;
//保存触点设置
+ (void)savePointSet:(GTClickerPointSetModel *)pointSetModel;

@end

NS_ASSUME_NONNULL_END
