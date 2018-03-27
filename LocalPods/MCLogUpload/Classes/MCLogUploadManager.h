//
//  MCLogUpload.h
//  CocoaLumberjack
//
//  Created by gdxz on 2018/3/23.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@protocol MCLogUploadManagerDelegate <NSObject>
@optional
- (void)didArchiveUploadFilePath:(NSString *)logFilePath;
- (void)didRollAndArchiveUploadLogFile:(NSString *)logFilePath;
- (void)attemptingUploadForFilePath:(NSString *)logFilePath;
- (void)uploadTaskForFilePath:(NSString *)logFilePath didCompleteWithError:(NSError *)error;
@end

typedef void (^MCLogUploadNetCompleteBlock)(id response,NSError *error);

@interface MCLogUploadManager : DDLogFileManagerDefault

//初始方法
- (instancetype)initWithUploadRequestString:(NSString *)uploadRequestString;
- (instancetype)initWithUploadRequestString:(NSString *)uploadRequestString delegate:(id<MCLogUploadManagerDelegate>)delegate;

//开始上传
- (void)uploadArchivedFilesWithComplete:(MCLogUploadNetCompleteBlock)block;

@end


























