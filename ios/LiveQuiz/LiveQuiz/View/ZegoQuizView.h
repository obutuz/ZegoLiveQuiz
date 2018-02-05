//
//  ZegoQuizView.h
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoQuizInfo.h"

@protocol ZegoQuizViewDelegate <NSObject>

- (void)onOptionAClicked:(id)sender;
- (void)onOptionBClicked:(id)sender;
- (void)onOptionCClicked:(id)sender;

@end

@interface ZegoQuizView : UIView

@property (nonatomic, strong) ZegoQuizInfo *quizInfo;   // 题目信息
@property (nonatomic, assign) NSInteger countdown;      // 答题倒计时

@property (nonatomic, weak) id<ZegoQuizViewDelegate> delegate;

@end
