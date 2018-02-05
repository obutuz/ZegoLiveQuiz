//
//  ZegoQuizView.m
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoQuizView.h"
#import "UIView+TapAction.h"

#define UnChosenBackgroundColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]
#define ChosenBackgroundColor [UIColor colorWithRed:96.0/255 green:44.0/255 blue:183.0/255 alpha:1.0]

#define UnChosenFontColor [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]
#define ChosenFontColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]
#define disableFontColor [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0]

#define UnChosenBorderColor [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0].CGColor
#define ChosenBorderColor [UIColor colorWithRed:96.0/255 green:44.0/255 blue:183.0/255 alpha:1.0].CGColor

#define RightAnswerBorderColor [UIColor colorWithRed:108.0/255 green:217.0/255 blue:131.0/255 alpha:1.0].CGColor
#define WrongAnswerBorderColor [UIColor colorWithRed:252.0/255 green:49.0/255 blue:108.0/255 alpha:1.0].CGColor

#define RightAnswerBackgroundColor [UIColor colorWithRed:108.0/255 green:217.0/255 blue:131.0/255 alpha:1.0]
#define WrongAnswerBackgroundColor [UIColor colorWithRed:252.0/255 green:49.0/255 blue:108.0/255 alpha:1.0]
#define OtherAnswerBackgroundColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]

#define CountdownBackgroundColor [UIColor colorWithRed:252.0/255 green:49.0/255 blue:108.0/255 alpha:1.0]

@interface ZegoQuizView()

@property (weak, nonatomic) IBOutlet UIView *countdownView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@property (weak, nonatomic) IBOutlet UILabel *quizDescription;

@property (weak, nonatomic) IBOutlet UIView *quizView;

@property (weak, nonatomic) IBOutlet UIView *optionAView;
@property (weak, nonatomic) IBOutlet UILabel *optionALabel;
@property (weak, nonatomic) IBOutlet UILabel *optionACountLabel;

@property (weak, nonatomic) IBOutlet UIView *optionBView;
@property (weak, nonatomic) IBOutlet UILabel *optionBLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionBCountLabel;

@property (weak, nonatomic) IBOutlet UIView *optionCView;
@property (weak, nonatomic) IBOutlet UILabel *optionCLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionCCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@end

@implementation ZegoQuizView

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s awakeFromNib", __func__);
    
    self.countdownView.layer.cornerRadius = self.countdownView.layer.bounds.size.width / 2.0;
    self.countdownLabel.layer.cornerRadius = self.countdownLabel.layer.bounds.size.width / 2.0;
    self.quizView.layer.cornerRadius = 20.0;
    self.optionAView.layer.borderWidth = 2.0;
    self.optionAView.layer.cornerRadius = self.optionAView.layer.bounds.size.height / 2.0;
    self.optionBView.layer.borderWidth = 2.0;
    self.optionBView.layer.cornerRadius = self.optionBView.layer.bounds.size.height / 2.0;
    self.optionCView.layer.borderWidth = 2.0;
    self.optionCView.layer.cornerRadius = self.optionCView.layer.bounds.size.height / 2.0;
    self.countdownLabel.layer.cornerRadius = self.countdownLabel.layer.bounds.size.height / 2.0;
    self.countdownLabel.layer.masksToBounds = YES;

    self.optionAView.backgroundColor = OtherAnswerBackgroundColor;
    self.optionBView.backgroundColor = OtherAnswerBackgroundColor;
    self.optionCView.backgroundColor = OtherAnswerBackgroundColor;
    self.optionAView.layer.borderColor = UnChosenBorderColor;
    self.optionBView.layer.borderColor = UnChosenBorderColor;
    self.optionCView.layer.borderColor = UnChosenBorderColor;
    
    [self.optionAView addTarget:self action:@selector(onOptionAChosen:)];
    [self.optionBView addTarget:self action:@selector(onOptionBChosen:)];
    [self.optionCView addTarget:self action:@selector(onOptionCChosen:)];
}

#pragma mark - Setter

- (void)setCountdown:(NSInteger)countdown {
    _countdownLabel.text = [NSString stringWithFormat:@"%ld", (long)countdown];
    
    if (countdown <= 3) {
        _countdownLabel.backgroundColor = CountdownBackgroundColor;
        
        if (countdown == 0) {
            _countdownLabel.text = @"时间到";
            _countdownLabel.font = [UIFont systemFontOfSize:14];
        }
    } else {
        _countdownLabel.font = [UIFont systemFontOfSize:35];
    }

    [self layoutIfNeeded];
}

- (void)setQuizInfo:(ZegoQuizInfo *)quizInfo {
    [self showAnswerResult:quizInfo];
    [self configOptionLabelText:quizInfo];
    [self configOptionColor:quizInfo];
    
    if ([quizInfo.type isEqualToString:@"answer"]) {
        [self disableAllOptions];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - Event response

- (void)onOptionAChosen:(id)sender {
    [self chooseOptionA:YES];
    [self chooseOptionB:NO];
    [self chooseOptionC:NO];
    if ([self.delegate respondsToSelector:@selector(onOptionAClicked:)]) {
        [self.delegate onOptionAClicked:sender];
    }
}

- (void)onOptionBChosen:(id)sender {
    [self chooseOptionA:NO];
    [self chooseOptionB:YES];
    [self chooseOptionC:NO];
    if ([self.delegate respondsToSelector:@selector(onOptionBClicked:)]) {
        [self.delegate onOptionBClicked:sender];
    }
}

- (void)onOptionCChosen:(id)sender {
    [self chooseOptionA:NO];
    [self chooseOptionB:NO];
    [self chooseOptionC:YES];
    if ([self.delegate respondsToSelector:@selector(onOptionCClicked:)]) {
        [self.delegate onOptionCClicked:sender];
    }
}

- (void)chooseOptionA:(BOOL)bChoose {
    if (bChoose) {
        self.optionAView.backgroundColor = ChosenBackgroundColor;
        self.optionAView.layer.borderColor = ChosenBorderColor;
        self.optionALabel.textColor = ChosenFontColor;
        [self disableAllOptions];
    } else {
        self.optionALabel.textColor = UnChosenFontColor;
    }
}

- (void)chooseOptionB:(BOOL)bChoose {
    if (bChoose) {
        self.optionBView.backgroundColor = ChosenBackgroundColor;
        self.optionBView.layer.borderColor = ChosenBorderColor;
        self.optionBLabel.textColor = ChosenFontColor;
        [self disableAllOptions];
    } else {
        self.optionCLabel.textColor = UnChosenFontColor;
    }
}

- (void)chooseOptionC:(BOOL)bChoose {
    if (bChoose) {
        self.optionCView.backgroundColor = ChosenBackgroundColor;
        self.optionCView.layer.borderColor = ChosenBorderColor;
        self.optionCLabel.textColor = ChosenFontColor;
        [self disableAllOptions];
    } else {
        self.optionCLabel.textColor = UnChosenFontColor;
    }
}

#pragma mark - Private

- (void)showAnswerResult:(ZegoQuizInfo *)quizInfo {
    if ([quizInfo.type isEqualToString:@"answer"]) {
        UIImage *image;
        
        if (![quizInfo.correctAnswer isKindOfClass:[NSString class]]) {
            NSLog(@"correct answer is not string, abandon");
            return;
        }
        
        if ([quizInfo.correctAnswer isEqualToString:quizInfo.userAnswer]) {
            image = [UIImage imageNamed:@"right"];
            _countdownLabel.backgroundColor = RightAnswerBackgroundColor;
        } else {
            image = [UIImage imageNamed:@"wrong"];
            _countdownLabel.backgroundColor = WrongAnswerBackgroundColor;
        }
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = image;
        NSAttributedString *aStr = [NSAttributedString attributedStringWithAttachment:attach];
        _countdownLabel.attributedText = aStr;
    }
}

- (void)configOptionLabelText:(ZegoQuizInfo *)quizInfo {
    _quizDescription.text = quizInfo.title;
    
    _optionALabel.text = quizInfo.options[0].optionDesc;
    _optionACountLabel.text = [NSString stringWithFormat:@"%ld", (long)quizInfo.options[0].optionCount];
    _optionACountLabel.hidden = quizInfo.options[0].optionCount > 0 ? NO : YES;
    
    _optionBLabel.text = quizInfo.options[1].optionDesc;
    _optionBCountLabel.text = [NSString stringWithFormat:@"%ld", (long)quizInfo.options[1].optionCount];
    _optionBCountLabel.hidden = quizInfo.options[1].optionCount > 0 ? NO : YES;
    
    _optionCLabel.text = quizInfo.options[2].optionDesc;
    _optionCCountLabel.text = [NSString stringWithFormat:@"%ld", (long)quizInfo.options[2].optionCount];
    _optionCCountLabel.hidden = quizInfo.options[2].optionCount > 0 ? NO : YES;
}

- (void)configOptionColor:(ZegoQuizInfo *)quizInfo {
    if ([quizInfo.userAnswer isEqualToString:@"A"]) {
        _optionAView.backgroundColor = WrongAnswerBackgroundColor;
        _optionAView.layer.borderColor = WrongAnswerBorderColor;
    } else if ([quizInfo.userAnswer isEqualToString:@"B"]) {
        _optionBView.backgroundColor = WrongAnswerBackgroundColor;
        _optionBView.layer.borderColor = WrongAnswerBorderColor;
    } else if ([quizInfo.userAnswer isEqualToString:@"C"]) {
        _optionCView.backgroundColor = WrongAnswerBackgroundColor;
        _optionCView.layer.borderColor = WrongAnswerBorderColor;
    }
    
    
    if (![quizInfo.correctAnswer isKindOfClass:[NSString class]]) {
        NSLog(@"correct answer is not string, abandon");
        return;
    }
    
    if ([quizInfo.correctAnswer isEqualToString:@"A"]) {
        _optionAView.backgroundColor = RightAnswerBackgroundColor;
        _optionAView.layer.borderColor = RightAnswerBorderColor;
    } else if ([quizInfo.correctAnswer isEqualToString:@"B"]) {
        _optionBView.backgroundColor = RightAnswerBackgroundColor;
        _optionBView.layer.borderColor = RightAnswerBorderColor;
    } else if ([quizInfo.correctAnswer isEqualToString:@"C"]){
        _optionCView.backgroundColor = RightAnswerBackgroundColor;
        _optionCView.layer.borderColor = RightAnswerBorderColor;
    }
}


- (void)disableAllOptions {
    self.optionAView.userInteractionEnabled = NO;
    self.optionBView.userInteractionEnabled = NO;
    self.optionCView.userInteractionEnabled = NO;
}

@end
