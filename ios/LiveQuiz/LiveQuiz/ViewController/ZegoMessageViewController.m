//
//  ZegoMessageViewController.m
//  LiveQuiz
//
//  Created by summeryxia on 18/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoMessageViewController.h"
#import "ZegoMessageCell.h"
#import "YYText.h"

NSString *const messageCellIdentifier = @"ZegoMessageCellIdentifier";

@interface ZegoMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray<YYTextLayout*> *messageLayoutList;

@end

@implementation ZegoMessageViewController

@synthesize messageList = _messageList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    [self.messageTableView registerNib:[UINib nibWithNibName:@"ZegoMessageCell" bundle:nil] forCellReuseIdentifier:messageCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Public

- (void)updateLayout:(NSArray<ZegoBigRoomMessage *> *)messageList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (ZegoBigRoomMessage *message in messageList) {
            if (message.category == ZEGO_CHAT) {
                [self caculateLayout:@"" userName:message.fromUserName content:message.content];
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageList = messageList;
                [self.messageTableView reloadData];
                [self scrollTableViewToBottom];
            });
        }
    });
}

#pragma mark - Private

- (void)caculateLayout:(NSString *)userInfo userName:(NSString *)userName content:(NSString *)content
{
    if (userName.length == 0 || content.length == 0)
        return;
    
    CGFloat totalWidth = CGRectGetWidth(self.messageTableView.frame) - 20;
    
    NSMutableAttributedString *totalText = [[NSMutableAttributedString alloc] init];
    if (userInfo)
    {
        NSMutableAttributedString *userInfoString = [[NSMutableAttributedString alloc] initWithString:userInfo];
        userInfoString.yy_font = [UIFont systemFontOfSize:12.0];
        userInfoString.yy_color = [UIColor whiteColor];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeColor = [UIColor redColor];
        border.fillColor = [UIColor redColor];
        border.cornerRadius = 1;
        border.lineJoin = kCGLineJoinBevel;
        border.insets = UIEdgeInsetsMake(0, 0, 2.5, 0);
        
        userInfoString.yy_textBackgroundBorder = border;
        [userInfoString addAttribute:NSBaselineOffsetAttributeName value:@(2) range:NSMakeRange(0, userInfo.length)];
        
        [totalText appendAttributedString:userInfoString];
    }
    
    NSMutableAttributedString *userNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@: ", userName]];
    
    userNameString.yy_font = [UIFont systemFontOfSize:16.0];
    userNameString.yy_color = [UIColor colorWithRed:253/255.0 green:181/255.0 blue:84/255.0 alpha:1.0];
    
    [totalText appendAttributedString:userNameString];
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
    contentString.yy_font = [UIFont systemFontOfSize:16.0];
    contentString.yy_color = [UIColor whiteColor];
    
    [totalText appendAttributedString:contentString];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(totalWidth, CGFLOAT_MAX)];
    container.insets = UIEdgeInsetsMake(2, 10, 2, 10);
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:totalText];
    
    [self.messageLayoutList addObject:textLayout];
}

- (void)scrollTableViewToBottom
{
    NSInteger lastItemIndex = [self.messageTableView numberOfRowsInSection:0] - 1;
    if (lastItemIndex < 0) {
        return;
    }
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastItemIndex inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:lastIndexPath
                                 atScrollPosition:UITableViewScrollPositionBottom
                                         animated:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.messageList.count) {
        return nil;
    }
    
    ZegoMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];
    ZegoBigRoomMessage *message = self.messageList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", message.fromUserName, message.content]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:246/255.0 green:179/255.0 blue:18/255.0 alpha:1.0] range:NSMakeRange(0, message.fromUserName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] range:NSMakeRange(message.fromUserName.length, message.content.length + 2)];
    cell.messageView.attributedText = attrStr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (indexPath.row >= self.messageLayoutList.count) {
//        return 0.0;
//    }
//    YYTextLayout *layout = self.messageLayoutList[indexPath.row];
//    return layout.textBoundingSize.height;
    return 30;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}
                   
#pragma mark - Access

- (NSArray *)messageList {
    if (!_messageList) {
        _messageList = [[NSArray alloc] init];
    }
    return _messageList;
}

- (void)setMessageList:(NSMutableArray<ZegoBigRoomMessage *> *)messageList {
    if (messageList.count == 0) {
        NSLog(@"消息列表无内容");
        return;
    }
    _messageList = messageList;

    [self.messageTableView reloadData];

    [self.messageTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(_messageList.count - 1) inSection:0]
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionBottom];
}

@end
