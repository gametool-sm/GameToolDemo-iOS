//
//  GTLineDrawer.m
//  GTSDK
//
//  Created by smwl on 2023/10/19.
//


#import "GTLineDrawer.h"
#import <math.h>
#import <LinkerPlugin/LinkerSDKConfig.h>

@interface GTLineDrawer()

@property(nonatomic,strong)UIView *recorView;

@property (strong,nonatomic) UIBezierPath *bezierPath;

@property (strong,nonatomic) CAShapeLayer *shapeLayer;

@property (strong,nonatomic) CAShapeLayer *startPointLayer;
@property (strong,nonatomic) CAShapeLayer *endPointLayer;


@end

@implementation GTLineDrawer
-(instancetype)initWithLineType:(GTRecordLineType)lineType recorView:(UIView *)recorView{
    GTLineDrawer *lineDrawer = [[GTLineDrawer alloc] initWithLineType:lineType];
    lineDrawer.recorView = recorView;
    [recorView.layer addSublayer:lineDrawer.shapeLayer];
    return lineDrawer;
}
-(instancetype)initWithRecorView:(UIView *)recorView{
    GTLineDrawer *lineDrawer = [[GTLineDrawer alloc] initWithLineType:LineType_Current_Running];
    lineDrawer.recorView = recorView;
    lineDrawer.lineModel = [GTLineModel new];
    [recorView.layer addSublayer:lineDrawer.shapeLayer];
    return lineDrawer;
}
-(instancetype)initWithLineType:(GTRecordLineType)lineType{
    if(self=[super init]){
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.lineWidth = 16;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        self.shapeLayer = shapeLayer;
        self.lineType = lineType;
    }
    
    return self;
}
-(UIColor *)strokeColorWithLineType:(GTRecordLineType)lineType{
    UIColor *strokeColor = nil;
    switch (lineType) {
        case LineType_Current_UNRunning:
            strokeColor = kRGBA(255, 255, 255, 1);
            break;

        case LineType_Current_Running:
            strokeColor = kRGBA(51, 145, 255, 1);
            break;
            
        case LineType_Before_STEP_One:
            strokeColor = kRGBA(255, 255, 255, 0.8);
            break;
            
        case LineType_Before_STEP_Two:
            strokeColor = kRGBA(255, 255, 255, 0.6);
            break;
            
    }
    return strokeColor;
    
}
-(UIColor *)getMaskLayerFillColor:(GTRecordLineType)lineType{
    UIColor *fillColor = nil;
    switch (lineType) {
        case LineType_Current_UNRunning:
            fillColor = kRGBA(64, 75, 94, 1);
            break;

        case LineType_Current_Running:
            fillColor = kRGBA(51, 145, 255, 1);
            break;
            
        case LineType_Before_STEP_One:
            fillColor = kRGBA(75, 92, 106, 1);
            break;
            
        case LineType_Before_STEP_Two:
            fillColor = kRGBA(101, 123, 138, 1);
            break;
            
    }
    
    return fillColor;
}

/// 获取单个触点以及线的端点背景图片
-(NSString *)getPointBackGroundImageName{
    if(self.lineModel.recordLine.lineSource == GTLineSourceLongPress){
        return [self getLongPressPointBackGroundImageName];
    }
    return [self getNormalBackGroundImageName];
    
}

/// 获取单个触点以及线的端点背景图片
-(NSString *)getNormalBackGroundImageName{
    if(self.lineType == LineType_Current_Running){
        return @"record_run_point_normal";
    }
    if(self.lineType == LineType_Current_UNRunning){
        return @"record_unrun_point_normal_0";
    }
    if(self.lineType == LineType_Before_STEP_One){
        return @"record_unrun_point_normal_1";
    }
    if(self.lineType == LineType_Before_STEP_Two){
        return @"record_unrun_point_normal_2";
    }
    return @"";
    
}
/// 获取长按背景图片
-(NSString *)getLongPressPointBackGroundImageName{
    if(self.lineType == LineType_Current_Running){
        return @"record_run_point_press";
    }
    if(self.lineType == LineType_Current_UNRunning){
        return @"record_unrun_point_press_0";
    }
    if(self.lineType == LineType_Before_STEP_One){
        return @"record_unrun_point_press_1";
    }
    if(self.lineType == LineType_Before_STEP_Two){
        return @"record_unrun_point_press_2";
    }
    return @"";
}
-(CGFloat)getPointAlpha{
    switch (self.lineType) {
        case LineType_Before_STEP_One:
            return 0.8;
        case LineType_Before_STEP_Two:
            return 0.6;
        default:
            return 1.0;
    }
}
-(CGFloat)getPointWidth:(GTLineSource)lineSource{
    if(lineSource==GTLineSourceLongPress){
        return 34.0 * WIDTH_RATIO;
    }
    return 30.0 * WIDTH_RATIO;
}
-(void)drawLine{
    
    int touchPointCount = (int)self.lineModel.recordLine.touchPoints.count;
    for(int i=0;i<touchPointCount;i++){
        GTClickerActionModel *pointModel = [self.lineModel.recordLine.touchPoints objectAtIndex:i];
        PointType pointType = PointType_During;
        if(i==0) pointType = PointType_Start;//第一个点
        if(i==touchPointCount-1) pointType = PointType_End;//最后一个点
            
//        if(self.lineModel.recordLine.lineSource == GTLineSourceTap){//特殊处理tap
//            [self joinTapPoint:pointModel pointType:pointType];
//        }else{//longPress & pan
//            [self joinPoint:pointModel pointType:pointType];
//        }
        [self joinPoint:pointModel pointType:pointType];
        
    }
}
-(void)hideLine{
    self.shapeLayer.hidden = YES;
    self.lineModel.startPointButton.hidden = YES;
    self.lineModel.endPointButton.hidden = YES;
    self.lineModel.startBackGroudView.hidden = YES;
    [self.lineModel.startPointButton setHighlighted:NO];
    [self.lineModel.endPointButton setHighlighted:NO];
    
}
-(void)showLine{
    self.shapeLayer.hidden = NO;
    self.lineModel.startPointButton.hidden = NO;
    self.lineModel.endPointButton.hidden = NO;
    self.lineModel.startBackGroudView.hidden = NO;
}
-(void)removeLine{
    [self.shapeLayer removeFromSuperlayer];
    self.startPointLayer = nil;
    self.endPointLayer = nil;
    [self.lineModel.startPointButton removeFromSuperview];
    [self.lineModel.endPointButton removeFromSuperview];
    [self.lineModel.startBackGroudView removeFromSuperview];
}
-(void)resetLine{
    [self.bezierPath removeAllPoints];
    self.startPointLayer = nil;
    self.endPointLayer = nil;
    [self.lineModel.startPointButton removeFromSuperview];
    [self.lineModel.endPointButton removeFromSuperview];
    [self.lineModel.startBackGroudView removeFromSuperview];
    //移除端点遮罩
    [self.shapeLayer removeAllSublayers];
    self.shapeLayer.path = self.bezierPath.CGPath;
}
-(void)addPoint:(GTClickerActionModel *)pointModel pointType:(PointType)pointType{
    [self.lineModel.recordLine.touchPoints addObject:pointModel];
    if(self.lineModel.recordLine.lineSource == GTLineSourceTap){//特殊处理tap
        [self joinTapPoint:pointModel pointType:pointType];
    }else{//longPress & pan
        [self joinPoint:pointModel pointType:pointType];
    }
    
}
-(void)addPoint:(GTClickerActionModel *)pointModel{
    [self.lineModel.recordLine.touchPoints addObject:pointModel];   
}
-(void)updateLineNum:(NSInteger)lineNum{
    self.lineModel.lineNum = lineNum;
}
-(void)joinTapPoint:(GTClickerActionModel *)pointModel pointType:(PointType)pointType{
    NSString *backGroundImageName = [self getPointBackGroundImageName];
    CGFloat alpha = [self getPointAlpha];
    CGFloat width = [self getPointWidth:self.lineModel.recordLine.lineSource];
    [self.lineModel showTapPoint:pointType superView:self.recorView backGround:backGroundImageName alpha:alpha width:width];
}

-(void)joinPoint:(GTClickerActionModel *)pointModel pointType:(PointType)pointType{
    CGPoint touchPoint = CGPointMake(pointModel.centerX, pointModel.centerY);
    if(pointType==PointType_Start){
//        if(self.draweModel == LineDrawMode_SingleLine){
//            [self.bezierPath removeAllPoints];
//        }
//        [self.bezierPath moveToPoint:touchPoint];
        [self smoothToPoint:pointModel granularity:4];
    }else{
//        [self.bezierPath addLineToPoint:touchPoint];
        [self smoothToPoint:pointModel granularity:4];
        
    }
    CGFloat width = [self getPointWidth:self.lineModel.recordLine.lineSource];
    if(pointType==PointType_Start||pointType==PointType_End){
        
        NSString *backGroundImageName = [self getPointBackGroundImageName];
        CGFloat alpha = [self getPointAlpha];
       
        [self.lineModel showExtremePoint:pointType superView:self.recorView backGround:backGroundImageName alpha:alpha width:width];
        
        //长安动画
        if(pointType==PointType_Start&&self.lineModel.recordLine.lineSource == GTLineSourceLongPress){
            UIView *startBackGroudView = self.lineModel.startBackGroudView;
            if(![self.recorView.subviews containsObject:startBackGroudView]){
                [self.recorView addSubview:startBackGroudView];
                [startBackGroudView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, width));
                    make.left.mas_equalTo(pointModel.centerX-width/2);
                    make.top.mas_equalTo(pointModel.centerY-width/2);
                }];
            }
            [UIView animateWithDuration:0.5 animations:^{
                startBackGroudView.transform = CGAffineTransformMakeScale(2.0, 2.0);
                startBackGroudView.alpha = 0.0;
            } completion:^(BOOL finished) {
                startBackGroudView.alpha = 1.0;
                startBackGroudView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [startBackGroudView removeFromSuperview];
            }];
            
        }
//        [self updateExtremePointButtonState];
    }

  
    self.shapeLayer.path = [self.bezierPath CGPath];
}


-(void)updateExtremePointButtonState{

    NSString *backGroundImageName = [self getPointBackGroundImageName];
    CGFloat alpha = [self getPointAlpha];
    [self.lineModel updateExtremePointBackGround:backGroundImageName alpha:alpha];
    
    
}

///
-(NSMutableArray <NSValue*>*)touchPointValuesWithPointModel:(GTClickerActionModel *)pointModel{
    NSInteger index = [self.touchPoints indexOfObject:pointModel];
    NSArray *touchPoints = [self.touchPoints subarrayWithRange:NSMakeRange(0, index+1)];
    NSMutableArray *mArr = [NSMutableArray array];
    for (GTClickerActionModel *pointModel in touchPoints) {
        CGPoint point = CGPointMake(pointModel.centerX, pointModel.centerY);
        [mArr addObject:[NSValue valueWithCGPoint:point]];
    }
    return mArr;
}


#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

/// 直线平滑化
/// 基于:Centripetal Catmull–Rom spline
/// https://zhuanlan.zhihu.com/p/660097801
/// - Parameters:
///   - pointModel: <#pointModel description#>
///   - granularity: <#granularity description#>
-(void)smoothToPoint:(GTClickerActionModel *)pointModel granularity:(NSInteger)granularity{
    NSMutableArray *points = [self touchPointValuesWithPointModel:pointModel];
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [self.bezierPath removeAllPoints];
    [self.bezierPath moveToPoint:POINT(0)];
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);;
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [self.bezierPath addLineToPoint:pi];
        }
        
        // Now add p2
        [self.bezierPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [self.bezierPath addLineToPoint:POINT(points.count - 1)];
    
}
-(NSArray <GTClickerActionModel *>*)touchPoints{
    return [self.lineModel.recordLine.touchPoints copy];
}
-(CAShapeLayer *)maskLayerWithTouchPoint:(CGPoint)touchPoint{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:touchPoint radius:14.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    UIColor *fillColor = [self getMaskLayerFillColor:self.lineType];
//    maskLayer.strokeColor = fillColor.CGColor;;
    maskLayer.path = circlePath.CGPath;
//    maskLayer.fillColor = fillColor.CGColor;
    maskLayer.contents = CFBridgingRelease([[GTThemeManager share] imageWithName:@"floating_ball_left_icon"].CGImage);
    maskLayer.opaque = 0.9;
    return maskLayer;
    
}

-(UIBezierPath *)bezierPath{
    if(!_bezierPath){
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.flatness = 0.01;
        _bezierPath.lineCapStyle = kCGLineCapRound;
        _bezierPath.lineJoinStyle = kCGLineJoinRound;
        _bezierPath.miterLimit = -10;
    }
    return _bezierPath;
}
-(void)setLineType:(GTRecordLineType)lineType{
    LOGDebug(@"线类型改变 lineNum:%ld %@=>%@",(long)self.lineModel.lineNum,[self lineTypeDesc:_lineType],[self lineTypeDesc:lineType])
    _lineType = lineType;
    UIColor *strokeColor = [self strokeColorWithLineType:lineType];
    self.shapeLayer.strokeColor = strokeColor.CGColor;
    NSString *backGroundImageName = [self getPointBackGroundImageName];
    CGFloat alpha = [self getPointAlpha];
    [self.lineModel updateExtremePointBackGround:backGroundImageName alpha:alpha];
    [self.shapeLayer setNeedsDisplay];
    

    
}
-(NSString *)lineTypeDesc:(GTRecordLineType)lineType{
    switch(lineType){
        case LineType_Current_UNRunning:
            return @"LineType_Current_UNRunning";
        case LineType_Current_Running:
            return @"LineType_Current_Running";
        case LineType_Before_STEP_One:
            return @"LineType_Before_STEP_One";
        case LineType_Before_STEP_Two:
            return @"LineType_Before_STEP_Two";
        default:
            return @"";
            
    }
}
-(void)setLineSource:(GTLineSource)lineSource{
    self.lineModel.recordLine.lineSource = lineSource;
    
}

-(void)dealloc{
    LOGDealloc()
    
}
@end
