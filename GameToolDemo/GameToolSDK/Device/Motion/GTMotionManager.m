//
//  GTMotionManager.m
//  GTSDK
//
//  Created by shangmi on 2023/7/11.
//

#import "GTMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface GTMotionManager ()

@property (nonatomic, assign) CGFloat lastGravityZ;

@property (nonatomic, strong) CMMotionManager *manager;

@end

@implementation GTMotionManager

+ (GTMotionManager *)shareManager {
    static GTMotionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTMotionManager alloc]init];
    });
    return manager;
}

//悬浮球隐藏后，开始监测
- (void)startMonitorMotionWithCompletion:(void(^ __nullable)(void))completion {
    if ([self.manager isAccelerometerAvailable] ) {
        [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if ([self isAchieveRotationRate:motion] && [self isFaceDown:motion]) {
                if(completion){
                    completion();
                }
            }
        }];
    }
}

- (CMMotionManager *)manager {
    if (!_manager) {
        _manager = [[CMMotionManager alloc]init];
//        _manager.accelerometerUpdateInterval = 0.1;
    }
    return _manager;
}

- (BOOL)isAchieveRotationRate:(CMDeviceMotion *)motion {
    if (motion.rotationRate.x > 3 || motion.rotationRate.x < -3) {
        return YES;
    }
    if (motion.rotationRate.y > 3 || motion.rotationRate.y < -3) {
        return YES;
    }
    return NO;
}

- (BOOL)isFaceDown:(CMDeviceMotion *)motion {
    if (motion.gravity.z > 0.85 && motion.gravity.z < self.lastGravityZ) {
        self.lastGravityZ = motion.gravity.z;
        return YES;
    }
    self.lastGravityZ = motion.gravity.z;
    return NO;
}

@end
