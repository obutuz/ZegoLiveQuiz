//
//  ZegoSDKManager.m
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoSDKManager.h"
#import "ZegoSetting.h"

@implementation ZegoSDKManager

static ZegoLiveRoomApi *_apiInstance = nil;

+ (ZegoLiveRoomApi *)api {
    if (_apiInstance == nil) {
        
        // 测试环境
        [ZegoLiveRoomApi setUseTestEnv:[ZegoSetting sharedInstance].useTestEnv];
        
        // 调试信息
#ifdef DEBUG
        [ZegoLiveRoomApi setVerbose:YES];
#endif
        
        // 初始化用户信息
        [ZegoLiveRoomApi setUserID:[ZegoSetting sharedInstance].userID userName:[ZegoSetting sharedInstance].userName];
        
        // 初始化 SDK 实例
        _apiInstance = [[ZegoLiveRoomApi alloc] initWithAppID:[ZegoSetting sharedInstance].appID appSignature:[ZegoSetting sharedInstance].appSign];
        
        // 初始化硬件编解码配置
#if TARGET_OS_SIMULATOR
        [ZegoSetting sharedInstance].useHardwareDecode = NO;
        [ZegoSetting sharedInstance].useHardwareEncode = NO;
#else
        [ZegoSetting sharedInstance].useHardwareDecode = YES;
        [ZegoSetting sharedInstance].useHardwareEncode = YES;
#endif
        
        [ZegoLiveRoomApi requireHardwareDecoder:[ZegoSetting sharedInstance].useHardwareDecode];
        [ZegoLiveRoomApi requireHardwareEncoder:[ZegoSetting sharedInstance].useHardwareEncode];
        
    }
    
    return _apiInstance;
}

+ (void)releaseApi {
    _apiInstance = nil;
}


@end

