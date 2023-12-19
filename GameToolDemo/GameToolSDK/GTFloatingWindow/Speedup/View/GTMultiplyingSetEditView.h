//
//  GTMultiplyingSetEditView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//增加bloock
typedef void(^InsertButtonBlock)(void);

@interface GTMultiplyingSetEditView : UIView

@property (nonatomic, copy) InsertButtonBlock insertButtonBlock;

@end

NS_ASSUME_NONNULL_END
