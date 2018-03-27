
//
//  MCLogUpload.m
//  CocoaLumberjack
//
//  Created by gdxz on 2018/3/23.
//

#import "MCLogUploadManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MCLogUploadModel.h"
#ifdef DEBUG
    #define MCUploadLog(__FORMAT__, ...) NSLog(__FORMAT__, ##__VA_ARGS__)
#else
    #define MCUploadLog(__FORMAT__, ...)
#endif

@interface MCLogUploadManager ()
@property (nonatomic, strong) NSString *uploadRequestString;
@property (nonatomic, weak) id<MCLogUploadManagerDelegate> delegate;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation MCLogUploadManager
- (instancetype)initWithUploadRequestString:(NSString *)uploadRequestString {
    if (self = [super init]) {
        _uploadRequestString = uploadRequestString;
    }
    return self;
}

- (instancetype)initWithUploadRequestString:(NSString *)uploadRequestString delegate:(id<MCLogUploadManagerDelegate>)delegate {
    if (self = [super init]) {
        _uploadRequestString = uploadRequestString;
        _delegate = delegate;
    }
    return self;
}


#pragma mark - Notification from DDFileLogger
- (void)didArchiveLogFile:(NSString *)logFilePath {
    MCUploadLog(@"didArchiveLogFile: %@", logFilePath);
    if ([self.delegate respondsToSelector:@selector(didArchiveUploadFilePath:)]) {
        [self.delegate didArchiveUploadFilePath:logFilePath];
    }
}

- (void)didRollAndArchiveLogFile:(NSString *)logFilePath {
    MCUploadLog(@"didRollAndArchiveLogFile: %@", logFilePath);
    if ([self.delegate respondsToSelector:@selector(didRollAndArchiveUploadLogFile:)]) {
        [self.delegate didRollAndArchiveUploadLogFile:logFilePath];
    }
}

- (void)uploadArchivedFilesWithComplete:(MCLogUploadNetCompleteBlock)block {
    dispatch_async([DDLog loggingQueue], ^{
        NSArray *fileInfos = [self unsortedLogFileInfos];
        NSMutableArray<MCLogUploadModel *> *filesToUpload = [NSMutableArray arrayWithCapacity:[fileInfos count]];
        for (int i = 0; i < fileInfos.count; i++) {
            DDLogFileInfo *fileInfo = fileInfos[i];
            if (fileInfo.isArchived) {
                MCLogUploadModel *fileModel = [[MCLogUploadModel alloc] init];
                fileModel.filePath = fileInfo.filePath;
                fileModel.fileName = fileInfo.fileName;
                fileModel.fileSize = fileInfo.fileSize;
                [filesToUpload addObject:fileModel];
            }
        }
        for (int i = 0; i < filesToUpload.count; i++) {
            MCLogUploadModel *model = filesToUpload[i];
            if ([[NSFileManager defaultManager] isReadableFileAtPath:model.filePath]) {
                [self uploadLogFileModel:model completeBlock:block];
            } else {
//              NSAssert(NO, @"日志要可读");
                NSLog(@"日志不可读");
            }
        }
    });
}

- (void)uploadLogFileModel:(MCLogUploadModel *)logFileModel completeBlock:(MCLogUploadNetCompleteBlock)compeleteBlock{
    dispatch_async([DDLog loggingQueue], ^{
        if (self.uploadRequestString.length > 0 && logFileModel) {
            NSString *fileName = logFileModel.fileName?:@"";
            long long fileSize = logFileModel.fileSize;
            NSString *fileType = @"multipart/form-data";
            void(^constructDataBlock)(id<AFMultipartFormData> formData)  = ^(id<AFMultipartFormData> formData) {
                NSInputStream * inputStream = [NSInputStream inputStreamWithFileAtPath:logFileModel.filePath];
                [formData appendPartWithInputStream:inputStream name:fileName fileName:fileName length:fileSize mimeType:fileType];
            };
            void (^reqestConfigBlock)(NSMutableURLRequest *req) = ^(NSMutableURLRequest *req) {};
            void (^progressBlock)(NSProgress * _Nonnull) = ^(NSProgress * _Nonnull uploadProgress) {};
            void (^successBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async([DDLog loggingQueue], ^{
                    NSDictionary *resultJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    if (resultJson) {
                        NSLog(@"resultJson = %@", resultJson);
                        if (compeleteBlock) {
                            compeleteBlock(resultJson,nil);
                        }
                    } else {
                        NSString *resultString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"日志上报服务器返回结果 = %@", resultString);
                        NSError *error = [NSError errorWithDomain:@"MCLogUploadManager" code:-9999 userInfo:@{NSLocalizedDescriptionKey: @"参数不对"}];
                        if (compeleteBlock) {
                            compeleteBlock(resultJson,error);
                        }
                    }
                });
            };
            void (^failureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async([DDLog loggingQueue], ^{
                    if (compeleteBlock) {
                        compeleteBlock(@"",error);
                    }
                });
            };
            [self.sessionManager POST:self.uploadRequestString parameters:nil constructingBodyWithBlock:constructDataBlock progress:progressBlock success:successBlock failure:failureBlock];
            if ([self.delegate respondsToSelector:@selector(attemptingUploadForFilePath:)]) {
                [self.delegate attemptingUploadForFilePath:logFileModel.filePath];
            }
        }
    });
}

#pragma mark - getter && setter
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = 60*30;
        _sessionManager.requestSerializer = requestSerializer;
        AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"application/javascript",
                                                     @"application/xml",
                                                     @"text/xml",
                                                     @"application/html",
                                                     @"text/html",
                                                     @"text/plain",
                                                     @"application/plain", nil];
        
        _sessionManager.responseSerializer = responseSerializer;
    }
    return _sessionManager;
}
@end
















