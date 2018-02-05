//
//  ZegoQuizParser.h
//  LiveQuiz
//
//  Created by summeryxia on 25/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZegoQuizParser : NSObject

+ (NSString *)assembleRelayData:(NSString *)activityID
                     questionID:(NSString *)questionID
                         answer:(NSString *)answer
                         revive:(int)revive
                       userData:(NSString *)userData;

@end
