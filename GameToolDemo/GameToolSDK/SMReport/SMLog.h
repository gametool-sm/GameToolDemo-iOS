//
//  SMLog.h
//  GTSDK
//
//  Created by smwl on 2023/11/17.
//

#ifndef SMLog_h
#define SMLog_h


//#define LOG_LEVEL_ALL
//#define LOG_LEVEL_DEBUG
//#define LOG_LEVEL_INFO
//#define LOG_LEVEL_WARN
//#define LOG_LEVEL_ERROR
//#define LOG_LEVEL_DEALLOC

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


#endif /* SMLog_h */
