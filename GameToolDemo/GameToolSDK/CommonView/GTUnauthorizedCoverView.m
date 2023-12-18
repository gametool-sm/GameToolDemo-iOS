//
//  GTUnauthorizedCoverView.m
//  GTSDK
//
//  Created by shangmi on 2023/9/21.
//

#import "GTUnauthorizedCoverView.h"

@implementation GTUnauthorizedCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor hexColor:@"0x234293" withAlpha:0.5];
}

@end
