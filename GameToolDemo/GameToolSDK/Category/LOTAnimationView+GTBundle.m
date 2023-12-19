//
//  LOTComposition+GTBundle.m
//  GameToolSDK
//
//  Created by smwl on 2023/12/7.
//

#import "LOTAnimationView+GTBundle.h"
#import "GTOperationControl.h"
@implementation LOTAnimationView (GTBundle)
+ (nonnull instancetype)autoDirectoryAnimationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle{
    LOTComposition *comp = [LOTComposition autoDirectoryAnimationNamed:animationName inBundle:bundle];
    return [[self alloc] initWithModel:comp inBundle:bundle];
}
@end
