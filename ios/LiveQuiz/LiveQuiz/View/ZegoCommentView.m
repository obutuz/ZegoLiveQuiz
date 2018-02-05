//
//  ZegoCommentView.m
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoCommentView.h"

@implementation ZegoCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shareButton.layer.cornerRadius = self.shareButton.bounds.size.height / 2.0;
    self.shareButton.layer.masksToBounds = YES;
    self.commentInput.layer.cornerRadius = self.commentInput.bounds.size.height / 2.0;
    [self.commentInput setValue:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.commentInput setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [self setupReviveLabel];
}

- (void)setupReviveLabel {
    self.reviveLabel.layer.cornerRadius = self.reviveLabel.bounds.size.height / 2.0;
    self.reviveLabel.layer.masksToBounds = YES;
    
    // 创建富文本文字
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"223"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];

    // 添加富文本图片
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"resurrection_fff"];
    textAttachment.bounds = CGRectMake(0, 0, 21, 25);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    // 图片与文本拼接
    [attrStr insertAttributedString:attachString atIndex:0];
    
    // 文字垂直居中
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(1, attrStr.length - 1)];
    
    self.reviveLabel.attributedText = attrStr;
    self.reviveLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

- (IBAction)onShareButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onShareButtonClicked:)]) {
        [self.delegate onShareButtonClicked:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
