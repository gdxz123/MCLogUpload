//
//  MCFileLogUploadManager.m
//  HGUploadCocoaLumberjack
//
//  Created by gdxz on 2018/3/23.
//  Copyright © 2018年 onething. All rights reserved.
//

#import "MCFileLogUploadManager.h"
#import "MCLogUploadManager.h"
#import "MCLogUploadFormatter.h"
const int ddLogLevel = DDLogFlagVerbose;

@interface MCFileLogUploadManager ()<MCLogUploadManagerDelegate>

@property (nonatomic, strong) MCLogUploadManager *fileLogManager;
@property (nonatomic, strong) DDFileLogger *fileLogger;

@end

@implementation MCFileLogUploadManager

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSString *requestString = @"www.xxxx.com/upload";
    
    self.fileLogManager = [[MCLogUploadManager alloc] initWithUploadRequestString:requestString delegate:self];
    self.fileLogManager.maximumNumberOfLogFiles = 3;
    self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:self.fileLogManager];
    
    self.fileLogger.rollingFrequency = 1;
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    self.fileLogger.maximumFileSize = 5*1024*1024;
    self.fileLogger.logFormatter = [[MCLogUploadFormatter alloc] init];
    [DDLog addLogger:self.fileLogger];
}

- (void)testLog {
    DDLogVerbose(@"输出详细信息");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
    DDLogVerbose(@"123456");
    DDLogVerbose(@"56412");
    DDLogVerbose(@"6321");
}

- (void)startUpload {
    [self.fileLogManager uploadArchivedFilesWithComplete:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"upload success");
        }
    }];
}
@end



















