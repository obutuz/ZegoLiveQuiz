//
//  ZegoSDKManager.h
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZegoLiveRoom/ZegoLiveRoom.h>

@interface ZegoSDKManager : NSObject

// 获取 ZegoLiveRoomAPi 单例对象
+ (ZegoLiveRoomApi *)api;

// 释放 api 对象
+ (void)releaseApi;

@end
