//
//  ZegoMessageViewController.h
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoSDKManager.h"

@interface ZegoMessageViewController : UIViewController

@property (nonatomic, strong) NSArray<ZegoBigRoomMessage *> *messageList;

//- (void)updateLayout:(NSArray<ZegoRoomMessage *> *)messageList;

@end
