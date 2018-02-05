//
//  UIView+TapAction.h
//  LiveQuiz
//
//  Created by summeryxia on 25/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchCallBackBlock)(void);


@interface UIView (TapAction)

@property (nonatomic, copy) TouchCallBackBlock touchCallBackBlock;

- (void)addActionWithblock:(TouchCallBackBlock)block;
- (void)addTarget:(id)target action:(SEL)action;

@end
