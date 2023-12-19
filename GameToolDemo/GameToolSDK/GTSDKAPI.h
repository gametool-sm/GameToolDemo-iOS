//
//  GTSDKAPI.h
//  GTSDK
//
//  Created by smwl-dxl on 2023/10/19.
//

#ifndef GTSDKAPI_h
#define GTSDKAPI_h

#define PROD 1

#if PROD
#define GTSDKAPI_DOMMAIN        @"https://app.gametool.com"
#define GTSDKAPI_SENSOR_URL     @"https://report.gametool.com/sa" // 神策上报URL
#else
#define GTSDKAPI_DOMMAIN        @"https://app.40407.cn"
#define GTSDKAPI_SENSOR_URL     @"https://report.40407.cn/sa" // 神策上报URL
#endif

#define GTSDKAPI_SDKINIT        @"/v1/game-init"    // 初始化接口
#define GTSDKAPI_SDKLOGIN       @"/v1/game-login"   // 登录接口
#define GTSDKAPI_ToolStartup @"/v1/report-tool-startup"//工具启动上报
#define GTSDKAPI_DurationStart @"/v1/report-duration-start"//时长开始上报接口
#define GTSDKAPI_DurationUpdate @"/v1/report-duration-update"//时长更新上报接口
#endif /* GTSDKAPI_h */
