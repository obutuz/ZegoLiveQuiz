//
//  ZegoActivityInfo.h
//  LiveQuiz
//
//  Created by xia on 01/02/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZegoActivityState) {
    ZegoActivityStateNotStart,  // 未开始
    ZegoActivityStatePlaying,   // 已开始，正在进行中
    ZegoActivityStateEnded,     // 已结束
};

typedef NS_ENUM(NSUInteger, ZegoActivityResult) {
    ZegoActivityResultWin,      // 胜利
    ZegoActivityResultLose,     // 失败
};

@interface ZegoActivityInfo : NSObject

@property (nonatomic, copy) NSString *activityID;
@property (nonatomic, assign) ZegoActivityState activityState;
@property (nonatomic, assign) ZegoActivityResult activityResult;

// 暂时没有用上
@property (nonatomic, strong) NSDate *beginTime;    // 开始时间
@property (nonatomic, assign) NSInteger prizeValue; // 奖金数目

@end
