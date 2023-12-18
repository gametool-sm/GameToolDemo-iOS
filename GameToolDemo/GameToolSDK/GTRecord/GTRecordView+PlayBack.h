//
//  GTRecordView+PlayBack.h
//  GTSDK
//
//  Created by smwl on 2023/11/3.
//

#import "GTRecordView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordView (PlayBack)

/// 回放
-(void)playbackWithSchemeModel:(GTClickerSchemeModel *)schemeModel;

/// 暂停方案
-(void)pauseScheme;


/// 继续方案
-(void)continueScheme;

/// 获取回放第一条线需要等待的时间
+(NSTimeInterval)timeIntervalBeforeFirstLineSchemeJsonStr:(NSString *)schemeJsonStr;

@end

NS_ASSUME_NONNULL_END
