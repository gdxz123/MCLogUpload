//
//  ViewController.m
//  HGUploadCocoaLumberjack
//
//  Created by gdxz on 2018/3/23.
//  Copyright © 2018年 onething. All rights reserved.
//

#import "ViewController.h"
#import "MCFileLogUploadManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MCFileLogUploadManager *fileLogUploadManager = [[MCFileLogUploadManager alloc] init];
    [fileLogUploadManager testLog];
}

@end
