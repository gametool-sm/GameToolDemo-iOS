//
//  GTFloatingWindowViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "GTOperationControl.h"
#import "GTToolBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingWindowViewController : UIViewController

@property (nonatomic, strong) GTToolBarView *toolBar;
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, assign)   UIInterfaceOrientation orientation;

@end

NS_ASSUME_NONNULL_END
