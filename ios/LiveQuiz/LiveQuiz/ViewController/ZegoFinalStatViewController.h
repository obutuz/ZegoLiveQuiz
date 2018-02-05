//
//  ZegoFinalStatViewController.h
//  LiveQuiz
//
//  Created by xia on 31/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoSDKManager.h"

@protocol ZegoFinalStatViewControllerDelegate <NSObject>

- (void)onCloseButtonClicked:(id)sender;

@end

@interface ZegoFinalStatViewController : UIViewController

@property (nonatomic, copy) NSArray<ZegoUser *> *winnerList;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, weak) id<ZegoFinalStatViewControllerDelegate> delegate;

@end
