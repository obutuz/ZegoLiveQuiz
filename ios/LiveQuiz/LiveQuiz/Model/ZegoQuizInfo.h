//
//  ZegoQuizInfo.h
//  LiveQuiz
//
//  Created by summeryxia on 25/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZegoOptionInfo : NSObject

@property (nonatomic, copy) NSString *optionDesc;       // 选项描述
@property (nonatomic, assign) NSInteger optionCount;    // 选择的数量

@end

@interface ZegoQuizInfo : NSObject

@property (nonatomic, copy) NSString *type;             // question, answer
@property (nonatomic, assign) NSInteger index;          // 序号
@property (nonatomic, copy) NSString *quizID;           // 题目 ID
@property (nonatomic, copy) NSString *title;            // 题目描述
@property (nonatomic, copy) NSArray<ZegoOptionInfo *> *options; // 选项列表

@property (nonatomic, copy) NSString *correctAnswer;    // 正确答案，后台下发
@property (nonatomic, copy) NSString *userAnswer;       // 用户答案


@end
