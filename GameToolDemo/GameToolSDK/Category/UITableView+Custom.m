//
//  UITableView+Custom.m
//  GTSDK
//
//  Created by shangmi on 2023/8/14.
//

#import "UITableView+Custom.h"
#import "GTEmptyDataView.h"

@implementation UITableView (Custom)

- (void)showEmptyView {
    UIView *backgroundView = [[GTEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.backgroundView = backgroundView;
}

@end
