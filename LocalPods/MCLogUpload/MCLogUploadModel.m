//
//  MCLogUploadModel.m
//  AFNetworking
//
//  Created by gdxz on 2018/3/26.
//

#import "MCLogUploadModel.h"

@implementation MCLogUploadModel

- (instancetype)init {
    if (self = [super init]) {
        self.fileName = @"";
        self.filePath = @"";
        self.fileSize = 0;
    }
    return self;
}
@end
