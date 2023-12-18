//
//  GTDialogViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/7/4.
//

#import "GTDialogViewController.h"
#import "GTAnimationDialogView.h"

@interface GTDialogViewController ()

@property (nonatomic, strong) GTAnimationDialogView *dialogView;

@end

@implementation GTDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

@end
