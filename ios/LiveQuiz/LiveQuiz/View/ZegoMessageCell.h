//
//  ZegoMessageCell.h
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface ZegoMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYLabel *messageView;

@property (nonatomic, strong) YYTextLayout *layout;

@end
