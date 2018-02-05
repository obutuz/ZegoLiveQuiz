//
//  ZegoCommentView.h
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZegoCommentViewDelegate <NSObject>

- (void)onShareButtonClicked:(id)sender;

@end

@interface ZegoCommentView : UIView

@property (weak, nonatomic) IBOutlet UITextField *commentInput;
@property (weak, nonatomic) IBOutlet UILabel *reviveLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) id<ZegoCommentViewDelegate> delegate;

@end
