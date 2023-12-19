//
//  SMCommonUtils.h
//  SMEncryption
//
//  Created by smwl_dxl on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCommonUtils : NSObject
@property (nonatomic, strong) NSMutableDictionary * gameInfoDict;
+ (instancetype)instance;

/*
 设置是否是gtsdk
 项目启动的时候就要设置
 */
+(void)setIsGtsdk:(BOOL)isGtsdk;
/*
 获取是否是gtsdk，决定使用的加密串，除了gtsdk其他项目的加密串都是统一的
 */
+(BOOL)getIsGtsdk;
/*
 设置域名是正式、测试、开发
 项目启动的时候就要设置
 */
+(void)setDomain:(NSString *)domain;
/*
 获取域名
 */
+(NSString *)getDomain;


@end

NS_ASSUME_NONNULL_END
