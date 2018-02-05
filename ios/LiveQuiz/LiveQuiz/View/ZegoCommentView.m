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
    
    // 创建一个富文本，并修改富文本中的不同文字的样式
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"222"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];

    // 添加图片并设置
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"resurrection_fff"];
    attach.bounds = CGRectMake(0, 0, 21, 25);
    NSAttributedString *aString = [NSAttributedString attributedStringWithAttachment:attach];
    
    // 创建带有图片的富文本
    [attrStr insertAttributedString:aString atIndex:0];
    
    // 文字垂直居中
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
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
