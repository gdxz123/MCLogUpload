//
//  MCLogUploadFormatter.m
//  CocoaLumberjack
//
//  Created by gdxz on 2018/3/23.
//

#import "MCLogUploadFormatter.h"

@implementation MCLogUploadFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = nil;
    switch (logMessage.flag)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARNING]";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VERBOSE]";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@%@:%lu->%@",
                           logLevel, logMessage.function,
                           (unsigned long)logMessage.line, logMessage.message];
    return formatStr;
}

@end
