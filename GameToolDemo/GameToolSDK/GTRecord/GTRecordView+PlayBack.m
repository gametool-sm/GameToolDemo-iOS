//
//  GTRecordView+PlayBack.m
//  GTSDK
//
//  Created by smwl on 2023/11/3.
//

#import "GTRecordView+PlayBack.h"

@implementation GTRecordView (PlayBack)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark - public Api

/// 开始回放
/// - Parameter schemeModel: 方案model
-(void)playbackWithSchemeModel:(GTClickerSchemeModel *)schemeModel{
    self.recordViewMode = RecordViewModePlayback;
    self.pointShowType = [self loadPointShowType];
    self.schemeModel = schemeModel;
    [self.lineDrawers makeObjectsPerformSelector:@selector(removeLine)];
    [self.lineDrawers removeAllObjects];
    [SMRecordSDK shareSDK].delegate = self;
    [[SMRecordSDK shareSDK] startRecordWithSchemeJsonStr:[schemeModel modelToJSONString]];
    
    
    for(int i=0;i<schemeModel.recordLines.count;i++){
        GTRecordLineModel *recordLineModel = [schemeModel.recordLines objectAtIndex:i];
        GTLineDrawer *lineDrawer = [[GTLineDrawer alloc] initWithRecorView:self];
        [lineDrawer setLineSource:recordLineModel.lineSource];
        [lineDrawer updateLineNum:i+1];
        [self.lineDrawers addObject:lineDrawer];
        
    }
}
/// 暂停回放
-(void)pauseScheme{
    if(self.recordViewMode == RecordViewModeNone){
        //处理没有playbackWithSchemeModel上来就直接pauseScheme
        //或者remove之后没有先playbackWithSchemeModel就pauseScheme的场景
        //否则将会创建一个RecordView并添加到window上
        [self remove];
        return;
    }
    [[SMRecordSDK shareSDK] pauseScheme];
}

/// 继续方案
-(void)continueScheme{
    if(self.recordViewMode == RecordViewModeNone){
        //处理没有playbackWithSchemeModel上来就直接continueScheme
        //或者remove之后没有先playbackWithSchemeModel就continueScheme的场景
        //否则将会创建一个RecordView并添加到window上
        [self remove];
        return;
    }
    if([SMRecordSDK shareSDK].recordSchemeSatus == RecordSchemeSatusPaused){
        [[SMRecordSDK shareSDK] continueScheme];
    }else{
        [self playbackWithSchemeModel:self.schemeModel];
    }
}
+(NSTimeInterval)timeIntervalBeforeFirstLineSchemeJsonStr:(NSString *)schemeJsonStr{
    NSTimeInterval interval = [SMRecordSDK timeIntervalBeforeFirstLineSchemeJsonStr:schemeJsonStr];
    LOGDebug(@"回放方案第一个触点运行前需要的等待时间:%fs",interval)
    return interval;
}
#pragma clang diagnostic pop

#pragma mark - Private Api
-(void)resetAllLines{
    if(self.schemeSatus==RecordSchemeSatusPaused){
        return;
    }
    for (GTLineDrawer *lineDrawer in self.lineDrawers) {
        [lineDrawer resetLine];
    }
}
-(void)addPoint:(NSInteger)pointIndex toLine:(NSInteger)lineIndex{
    if(lineIndex>=self.schemeModel.recordLines.count){//防止数组越界
        LOGError(@"线的索引超出方案线的总数:lineIndex=%ld,recordLines.count=%ld",lineIndex,self.schemeModel.recordLines.count)
        return;
    }
    
    GTRecordLineModel *recordLineModel = [self.schemeModel.recordLines objectAtIndex:lineIndex];
    NSArray *touchPoints = recordLineModel.touchPoints;
    if(pointIndex>=touchPoints.count){
        LOGError(@"点的索引超出当前线的触点总数:pointIndex=%d lineIndex=%ld,touchPoints.count=%ld",pointIndex,lineIndex,touchPoints.count)
        return;
    }
    
    PointType pointType = PointType_During;
    if(pointIndex==0){
        pointType = PointType_Start;
    }
    if(pointIndex == touchPoints.count-1){
        pointType = PointType_End;
    }
    GTClickerActionModel *pointModel = [touchPoints objectAtIndex:pointIndex];
    [self.currentLineDrawer addPoint:pointModel pointType:pointType];
    
}
#pragma mark--SMRecordSDKDelegate
-(void)recordSchemeCycleNumChanged:(NSInteger)cycleNum{

    if([self.delegate respondsToSelector:@selector(recordSchemeSatuschanged:)]){
        [self.delegate recordSchemeCycleNumChanged:cycleNum];
    }
}
-(void)recordSchemeSatuschanged:(RecordSchemeSatus)recordSchemeSatus{
    self.schemeSatus = recordSchemeSatus;
    if([self.delegate respondsToSelector:@selector(recordSchemeSatuschanged:)]){
        [self.delegate recordSchemeSatuschanged:recordSchemeSatus];
    }
}
-(void)willRecordLine:(NSInteger)lineIndex interval:(NSTimeInterval)interval{
    self.currentLineIndex = lineIndex;
    
    if([self.delegate respondsToSelector:@selector(willRecordLine:interval:)]){
        [self.delegate willRecordLine:lineIndex interval:interval];
    }
}
-(void)beginRecordLine:(NSInteger)lineIndex{
    [[self.lineDrawers objectAtIndex:lineIndex] resetLine];
    [[self.lineDrawers objectAtIndex:lineIndex] setLineType:LineType_Current_Running];
    if(self.beforelineDrawer){
        [self.beforelineDrawer setLineType:LineType_Current_UNRunning];
        self.beforelineDrawer = nil;
    }
    //回放
    if(self.pointShowType==ClickerWindowPointShowAll){
        if(lineIndex==0){
            [self resetAllLines];
        }
        
    }
    if(self.pointShowType==ClickerWindowPointShowExecute){
        [self resetAllLines];
    }
  
    
}
-(void)didRecordLine:(NSInteger)lineIndex isLastLine:(BOOL)isLastLine interval:(NSTimeInterval)nextLineInterval{
    if(self.pointShowType==ClickerWindowPointShowAll){
        GTLineDrawer *lineDrawer = [self.lineDrawers objectAtIndex:lineIndex];
        if(lineDrawer.lineModel.recordLine.lineSource!=GTLineSourceTap){
            [lineDrawer setLineType:LineType_Current_UNRunning];
            NSInteger last_line = lineIndex-1;
            NSInteger last_line_before = lineIndex-2;
            if(last_line>=0){
                [[self.lineDrawers objectAtIndex:last_line] setLineType:LineType_Before_STEP_One];
            }
            if(last_line_before>=0){
                [[self.lineDrawers objectAtIndex:last_line_before] setLineType:LineType_Before_STEP_Two];
            }

        }else{
            self.beforelineDrawer = lineDrawer;
        }

        if(isLastLine){//方案执行完一轮，即将开始下一轮
            @WeakObj(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nextLineInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak resetAllLines];
            });
            
        }
        
    }
    if(self.pointShowType==ClickerWindowPointShowExecute){
        @WeakObj(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [selfWeak resetAllLines];
        });
        
    }
}
-(void)didFakeTouchPoint:(NSInteger)pointIndex lineIndex:(NSInteger)lineIndex interval:(NSTimeInterval)nextInterval{
    if(self.pointShowType!=ClickerWindowPointShowNo){
        self.currentLineDrawer = [self.lineDrawers objectAtIndex:lineIndex];
        [self addPoint:pointIndex toLine:lineIndex];
    }

}

@end
