//
//  GTDataConfig.h
//  GTSDK
//
//  Created by smwl on 2023/11/13.
//

#import <Foundation/Foundation.h>
#import "GTSensorEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTDataConfig : NSObject

+(instancetype)sharedInstance;

/**
    神策数据初始化；
    在初始化SDK完成并且获取到deviceID后调用；
 
    @param appkey 游戏初始化时候传入的appkey;
 */

-(void)initConfigWithAppkey:(NSString *)appkey;

/**
    神策数据登入调用；
    在完成神策登入，并且获取到登入ID user_id以后再调用；
 
    @param userId 神策登入后的ID
 */

-(void)loginWithUserId:(NSString *)userId;


/// 神策数据登出
-(void)logout;


/// 上报数据
///
/// @discussion
/// propertyDict 是一个 Map。
/// 其中的 key 是 Property 的名称，必须是 NSString
/// value 则是 Property 的内容，只支持 NSString、NSNumber、NSSet、NSArray、NSDate 这些类型
/// 特别的，NSSet 或者 NSArray 类型的 value 中目前只支持其中的元素是 NSString
///
/// @param event 事件名称，kGTSensorEvent类型，一般为字符串
/// @param properties 事件携带的业务属性
/// @param shouldFlush 是否要立刻上报；根据具体业务而定；主动调用 flush 接口，则不论 flushInterval 和网络类型的限制条件是否满足，都尝试向服务器上传一次数据
-(void)uploadSensorDataWithEvent:(kGTSensorEvent)event
                   andProperties:(nullable NSDictionary *)properties
                     shouldFlush:(BOOL)shouldFlush;


@end

NS_ASSUME_NONNULL_END
