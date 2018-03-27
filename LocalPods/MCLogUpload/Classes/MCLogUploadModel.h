//
//  MCLogUploadModel.h
//  AFNetworking
//
//  Created by gdxz on 2018/3/26.
//

#import <Foundation/Foundation.h>

@interface MCLogUploadModel : NSObject
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) long long fileSize;
@end
