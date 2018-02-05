//
//  ZegoLabel.m
//  LiveQuiz
//
//  Created by summeryxia on 22/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoLabel.h"

@implementation ZegoLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, -8, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

//- (CGSize)intrinsicContentSize
//{
//    CGSize size = [super intrinsicContentSize];
//    size.width  += self.edgeInsets.left + self.edgeInsets.right;
//    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
//    return size;
//}

@end
