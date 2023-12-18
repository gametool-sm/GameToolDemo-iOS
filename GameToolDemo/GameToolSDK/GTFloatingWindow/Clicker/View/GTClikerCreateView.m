//
//  GTClikerCreateView.m
//  GTSDK
//
//  Created by shangminet on 2023/8/15.
//

#import "GTClikerCreateView.h"

@implementation GTClikerCreateView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [GTThemeManager share].colorModel.clicker_create_createView_color;
    }
    return self;
}

@end
