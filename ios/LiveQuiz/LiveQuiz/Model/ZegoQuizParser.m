//
//  ZegoQuizParser.m
//  LiveQuiz
//
//  Created by summeryxia on 25/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoQuizParser.h"

@implementation ZegoQuizParser

+ (NSString *)assembleRelayData:(NSString *)activityID
                     questionID:(NSString *)questionID
                         answer:(NSString *)answer
                       userData:(NSString *)userData {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"activity_id"] = activityID;
    dict[@"question_id"] = questionID;
    dict[@"answer"] = answer;
    dict[@"user_data"] = userData;
    
    NSError *assembleError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&assembleError];
    
    if (assembleError.code != 0) {
        NSLog(@"assemble relay data error: %ld", (long)assembleError.code);
        return nil;
    }
    
    NSString *relayData =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%s, relayData string: %@", __func__, relayData);
    
    return relayData;
}

@end
