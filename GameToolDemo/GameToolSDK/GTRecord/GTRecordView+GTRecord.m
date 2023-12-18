//
//  GTRecordView+GTRecord.m
//  GTSDK
//
//  Created by smwl on 2023/11/3.
//


#import "GTRecordView+GTRecord.h"
#import <LinkerPlugin/LinkerSDKConfig.h>

@implementation GTRecordView (GTRecord)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma mark - public Api
-(void)beginRecord{
    self.recordViewMode = RecordViewModeRecord;
    self.pointShowType = [self loadPointShowType];
    GTClickerSchemeModel *schemeModel =  [GTClickerSchemeModel defaultSchemeModel:0];
    schemeModel.recordStartTime = [[NSDate date] timeIntervalSince1970];  //开始录制时间
    self.schemeModel = schemeModel;
    
   
    
}
-(GTClickerSchemeModel *)finishRecord{
    if(self.recordViewMode == RecordViewModeNone){
        //处理没有beginRecord上来就直接finishRecord
        //或者remove之后没有先beginRecord就finishRecord的场景
        //否则将会创建一个RecordView并添加到window上
        [self remove];
        return nil;
    }
    self.schemeModel.recordEndTime = [[NSDate date] timeIntervalSince1970]; //结束录制时间
    for(GTLineDrawer *lineDrawer in self.lineDrawers){
        [self.schemeModel.recordLines addObject:lineDrawer.lineModel.recordLine];
    }
    if(self.schemeModel.recordLines.count==0){
        LOGWarn(@"本次录制没有添加触点和路径")
        return nil;
    }
    self.recordViewMode = RecordViewModePlayback;
    return self.schemeModel;
}
#pragma clang diagnostic pop

#pragma mark - Private Api

/// 为longPress和pan添加触点
/// - Parameters:
///   - gesture: <#gesture description#>
///   - pointType: <#pointType description#>
-(void)addTouchPoint:(UIGestureRecognizer *)gesture pointType:(PointType)pointType{
    GTClickerActionModel *pointModel = [self pointModelForGesture:gesture];
    [self addTouchPointWithPointModel:pointModel pointType:pointType];
}
-( GTClickerActionModel *)pointModelForGesture:(UIGestureRecognizer *)gesture{
    GTClickerActionModel *pointModel = [GTClickerActionModel new];
    CGPoint point = [gesture locationInView:self];
    pointModel.centerX = point.x;
    pointModel.centerY = point.y;
    pointModel.timestamp = [[NSDate date] timeIntervalSince1970];
    return pointModel;
}
-(void)addTouchPointForTap:(UIGestureRecognizer *)gesture{
    GTClickerActionModel *startPointModel = [self pointModelForGesture:gesture];
    [self addTouchPointWithPointModel:startPointModel pointType:PointType_Start];
    GTClickerActionModel *endPointModel = [GTClickerActionModel new];
    CGPoint point = CGPointMake(startPointModel.centerX, startPointModel.centerY);
    endPointModel.centerX = point.x;
    endPointModel.centerY = point.y;
    endPointModel.timestamp = startPointModel.timestamp+0.05;
    [self addTouchPointWithPointModel:endPointModel pointType:PointType_End];
    [self.lineDrawers addObject:self.currentLineDrawer];
    LOGDebug(@"=============>Tap End")
}

/// 更新当前录制线的编号
-(void)setCurrentLineLineNumber{
    int lineDrawerCount = (int)self.lineDrawers.count;
    [self.currentLineDrawer updateLineNum:lineDrawerCount+1];
}

/// 立即清空最后一条线
-(void)resetLineNow{
    GTLineDrawer *lineDrawer = [self.lineDrawers lastObject];
    [lineDrawer resetLine];
}

/// 0.5秒后清空最后一条线
-(void)resetLine5secs{
    @WeakObj(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [selfWeak resetLineNow];
    });
    
}

-(void)addTouchPointWithPointModel:(GTClickerActionModel *)pointModel pointType:(PointType)pointType{
    if(pointType == PointType_Start){
        [self setCurrentLineLineNumber];
    }
    if(self.pointShowType==ClickerWindowPointShowNo||self.pointShowType==ClickerWindowPointShowExecute){
        //        [self.currentLineDrawer addPoint:pointModel];
        [self.currentLineDrawer addPoint:pointModel pointType:pointType];
        if(pointType == PointType_Start){
            [self resetLineNow];
        }
        if(pointType == PointType_End){

            [self resetLine5secs];
        }
    }else if (self.pointShowType==ClickerWindowPointShowAll){
        [self.currentLineDrawer addPoint:pointModel pointType:pointType];
        if(pointType == PointType_Start){
            [self updateRecordLineNumAndLineTypeNowForShowAllType];
        }
        if(pointType == PointType_End){
            [self updateRecordLineNumAndLineTypeNowForShowAllType5Secs];
        }
        
        
    }else{
        
    }
}

/// 更新录制过程中"所有触点"模式下线的编号和类型
-(void)updateRecordLineNumAndLineTypeNowForShowAllType{
    int lineDrawerCount = (int)self.lineDrawers.count;
    for(int i=lineDrawerCount-1;i>=0;i--){
        GTLineDrawer *lineDrawer = [self.lineDrawers objectAtIndex:i];
        if(i==lineDrawerCount-1){//最近一条线
            lineDrawer.lineType = LineType_Current_UNRunning;
        }else if (i==lineDrawerCount-2){//倒数第一条
            lineDrawer.lineType = LineType_Before_STEP_One;;
        }else{//倒数第二条及第二条以前
            lineDrawer.lineType = LineType_Before_STEP_Two;
        }
        
        [lineDrawer updateLineNum:i+1];
//        [lineDrawer drawLine];
    }
}

-(void)updateRecordLineNumAndLineTypeNowForShowAllType5Secs{
    @WeakObj(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [selfWeak updateRecordLineNumAndLineTypeNowForShowAllType];
    });
}
#pragma mark 手势
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    UIGestureRecognizerState gestureState = tap.state;
    if(gestureState == UIGestureRecognizerStateBegan){
        NSLog(@"=============>tap Began");
        
    }else if(gestureState == UIGestureRecognizerStateChanged){
        NSLog(@"=============>tap Changed");
       
    }else if (gestureState == UIGestureRecognizerStateEnded){//只有UIGestureRecognizerStateEnded
        self.currentLineDrawer = [[GTLineDrawer alloc] initWithRecorView:self];
        [self.currentLineDrawer setLineSource:GTLineSourceTap];
        [self addTouchPointForTap:tap];
    }

}

-(void)longPressGesture:(UILongPressGestureRecognizer *)press{

    UIGestureRecognizerState gestureState = press.state;
    if(gestureState == UIGestureRecognizerStateBegan){
        self.currentLineDrawer = [[GTLineDrawer alloc] initWithRecorView:self];
        [self.currentLineDrawer setLineSource:GTLineSourceLongPress];
        [self addTouchPoint:press pointType:PointType_Start];
        LOGDebug(@"=============>press Began")
    }else if(gestureState == UIGestureRecognizerStateChanged){
        [self addTouchPoint:press pointType:PointType_During];
    }else if (gestureState == UIGestureRecognizerStateEnded){
        [self addTouchPoint:press pointType:PointType_End];
        [self.lineDrawers addObject:self.currentLineDrawer];
        LOGDebug(@"=============>press Ended")
//        [self showLinesBefore];
    }
    
}

-(void)panGesture:(UIPanGestureRecognizer *)pan{

    UIGestureRecognizerState gestureState = pan.state;
    if(gestureState == UIGestureRecognizerStateBegan){
        self.currentLineDrawer = [[GTLineDrawer alloc] initWithRecorView:self];
        [self.currentLineDrawer setLineSource:GTLineSourcePan];
        [self addTouchPoint:pan pointType:PointType_Start];
        LOGDebug(@"=============>Pan Began")
    }else if(gestureState == UIGestureRecognizerStateChanged){
        [self addTouchPoint:pan pointType:PointType_During];
    }else if (gestureState == UIGestureRecognizerStateEnded){
        [self addTouchPoint:pan pointType:PointType_End];
        [self.lineDrawers addObject:self.currentLineDrawer];
//        [self showLinesBefore];
        LOGDebug(@"=============>Pan Ended")
    }
}


@end
