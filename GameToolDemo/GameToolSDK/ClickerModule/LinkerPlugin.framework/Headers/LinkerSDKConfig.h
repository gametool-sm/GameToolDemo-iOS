//
//  LinkerSDKConfig.h
//  GTAPP
//
//  Created by smwl on 2023/8/31.
//

#ifndef LinkerSDKConfig_h
#define LinkerSDKConfig_h

#ifndef WeakSelf
#define WeakSelf __weak typeof(self) weakSelf = self;
#endif

#ifndef LINKER_DEBUGE

//#define LINKER_DEBUGE YES
#define LINKER_DEBUGE NO

#endif


#endif /* LinkerSDKConfig_h */

//#ifndef LOG_LEVEL_DEBUG
//#define LOG_LEVEL_DEBUG
//#endif
//
//#ifndef LOG_LEVEL_INFO
//#define LOG_LEVEL_INFO
//#endif
//
//#ifndef LOG_LEVEL_WARN
//#define LOG_LEVEL_WARN
//#endif
//
//#ifndef LOG_LEVEL_ERROR
//#define LOG_LEVEL_ERROR
//#endif
//
//#ifndef LOG_LEVEL_DEALLOC
//#define LOG_LEVEL_DEALLOC
//#endif

//
//#ifndef LOG_LEVEL_ALL
//#define LOG_LEVEL_ALL
//#endif

#ifdef LOG_LEVEL_ALL
#define LOG_LEVEL_DEBUG
#define LOG_LEVEL_ERROR
#define LOG_LEVEL_INFO
#define LOG_LEVEL_WARN
#define LOG_LEVEL_DEALLOC
#endif

#ifdef LOG_LEVEL_DEBUG
# define LOGDebug(fmt, ...) NSLog((@"%s" " %d\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LOGDebug(...);
#endif

#ifdef LOG_LEVEL_INFO
# define LOGInfo(fmt, ...) NSLog((@"✅ %s" " %d\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LOGInfo(...);
#endif

#ifdef LOG_LEVEL_WARN
# define LOGWarn(fmt, ...) NSLog((@"⚠️ %s" " %d\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LOGWarn(...);
#endif

#ifdef LOG_LEVEL_ERROR
# define LOGError(fmt, ...) NSLog((@"❌ %s" " %d\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LOGError(...);
#endif

#ifdef LOG_LEVEL_DEALLOC
# define LOGDealloc(fmt, ...) NSLog((@"♻️ %s" " %d\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LOGDealloc(...);

#endif

