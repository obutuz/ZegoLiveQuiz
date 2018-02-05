//
//  ZegoMessageCell.m
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoMessageCell.h"

@implementation ZegoMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.messageView.displaysAsynchronously = YES;
        self.messageView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.messageView.textAlignment = NSTextAlignmentLeft;
        self.messageView.fadeOnAsynchronouslyDisplay = NO;
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
