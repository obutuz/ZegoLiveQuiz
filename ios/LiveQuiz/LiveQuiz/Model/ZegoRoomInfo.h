//
//  ZegoRoomInfo.h
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZegoSDKManager.h"

@interface ZegoRoomInfo : NSObject

@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *anchorID;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, strong) NSMutableArray<ZegoStream *> *streamInfo;   // ZegoStream 列表

@end

