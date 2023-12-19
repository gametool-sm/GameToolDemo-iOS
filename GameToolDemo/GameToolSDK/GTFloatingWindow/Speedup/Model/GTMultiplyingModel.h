//
//  GTMultiplyingModel.h
//  GTSDK
//
//  Created by shangmi on 2023/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTMultiplyingModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) float number;     //具体数值
@property (nonatomic, assign) BOOL isSelected;  //是否选定
@property (nonatomic, assign) BOOL isUp;        //是否加速

@end

NS_ASSUME_NONNULL_END
