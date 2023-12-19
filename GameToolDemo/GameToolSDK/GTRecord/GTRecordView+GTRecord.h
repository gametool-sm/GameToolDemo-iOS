//
//  GTRecordView+GTRecord.h
//  GTSDK
//
//  Created by smwl on 2023/11/3.
//

#import "GTRecordView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordView (GTRecord)

/// 开始录制
-(void)beginRecord;

/// 结束录制
-(GTClickerSchemeModel *)finishRecord;

@end

NS_ASSUME_NONNULL_END
