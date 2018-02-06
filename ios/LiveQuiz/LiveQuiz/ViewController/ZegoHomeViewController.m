//
//  ZegoHomeViewController.m
//  LiveQuiz
//
//  Created by summeryxia on 17/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoHomeViewController.h"
#import "ZegoSetting.h"
#import "ZegoPlayViewController.h"
#import "UILabel+ChangeTextSpace.h"
#import "ZegoLabel.h"

static NSString *const zegoDomain      = @"zego.im";
static NSString *const alphaBaseUrl    = @"https://alpha-liveroom-api.zego.im";
static NSString *const testBaseUrl     = @"https://test2-liveroom-api.zego.im";
static NSString *const quizRoomPrefix  = @"ZegoQuiz-Windows-";
static NSString *const enterPlayingIdentifier = @"EnterPlayingIdentifier";

@interface ZegoHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startHintLabel;       // “节目正在进行”
@property (weak, nonatomic) IBOutlet UIButton *startButton;         // 点击观看

@property (weak, nonatomic) IBOutlet UILabel *startTimeHintLabel;   // “时间”
@property (weak, nonatomic) IBOutlet ZegoLabel *startTimeLabel;       // 20:00

@property (weak, nonatomic) IBOutlet UILabel *bonusHintLabel;       // “奖金”
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;           // 200
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;            // 万

@property (weak, nonatomic) IBOutlet UILabel *myBonusLabel;         // ”我的奖金“
@property (weak, nonatomic) IBOutlet UILabel *myRankLabel;          // ”本周排名“
@property (weak, nonatomic) IBOutlet UILabel *lifeTimesLabel;       // 复活卡数量
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *inviteView;

@property (weak, nonatomic) IBOutlet UIButton *rulesButton;         // 规则说明
@property (weak, nonatomic) IBOutlet UIButton *rankButton;          // 排行榜

@property (nonatomic, strong) NSMutableArray<ZegoRoomInfo *> *roomList;
@property (nonatomic, strong) ZegoRoomInfo *quizRoom;

@end

@implementation ZegoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"background"];
    self.view.layer.contents = (id)image.CGImage;
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.userInfoView.layer.cornerRadius = 24.0;
    self.inviteView.layer.cornerRadius = 24.0;
    self.startButton.layer.cornerRadius = self.startButton.bounds.size.height / 2.0;
    self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.height / 2.0;
    self.rulesButton.layer.cornerRadius = self.rulesButton.bounds.size.height / 2.0;
    self.rankButton.layer.cornerRadius = self.rankButton.bounds.size.height / 2.0;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupViewState:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"ZegoHomeViewController did Receive Memory Warning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"ZegoHomeViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:enterPlayingIdentifier]) {
        ZegoPlayViewController *viewController = (ZegoPlayViewController *)segue.destinationViewController;
        viewController.roomInfo = sender;
    }
}

#pragma mark - Event response

- (IBAction)onEnterPlaying:(id)sender {
    [self performSegueWithIdentifier:enterPlayingIdentifier sender:self.quizRoom];
}

- (void)applicationBecomeActive {
    [self fetchLiveRoom];
}

- (IBAction)onInviteFriend:(id)sender {
    [self showAlert:@"该功能由业务方自行实现 [1.0]" title:@"提示"];
}

- (IBAction)onShowInstruction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"进入指定房间" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入房间ID，不可为空";
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *roomID =  [[alertController textFields] objectAtIndex:0].text;
        NSLog(@"entering specified room, roomID: %@", roomID);
        
        if (roomID.length == 0) {
            NSLog(@"entering specified room, but roomID is nil");
            return;
        }
        
        ZegoRoomInfo *quizRoom = [[ZegoRoomInfo alloc] init];
        quizRoom.roomID = roomID;
        [self performSegueWithIdentifier:enterPlayingIdentifier sender:quizRoom];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:confirm];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onShowRank:(id)sender {
    [self showAlert:[NSString stringWithFormat:@"该功能由业务方自行实现\n[%@]\n[%@]", [ZegoLiveRoomApi version], [ZegoLiveRoomApi version2]] title:@"提示"];
}

- (void)showAlert:(NSString *)message title:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"好的", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                      
                                                    }];
    
    [alertController addAction:confirm];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Private

- (void)setupViewState:(BOOL)isStarted {
    // 先隐藏各种信息
    self.startTimeHintLabel.hidden = isStarted;
    self.startTimeLabel.hidden = isStarted;
    
    self.bonusHintLabel.hidden = isStarted;
    self.bonusLabel.hidden = isStarted;
    self.unitLabel.hidden = isStarted;
    
    self.startButton.hidden = !isStarted;
    self.startHintLabel.hidden = NO;
    
    if (isStarted) {
        self.startHintLabel.text = @"节目正在进行";
        self.stateLabel.text = @"";
    } else {
        self.stateLabel.text = @"检查节目中";
        [self fetchLiveRoom];
    }
}

- (void)fetchLiveRoom {
    NSString *baseUrl = nil;
    if ([ZegoSetting sharedInstance].useAlphaEnv) {
        baseUrl = @"https://alpha-liveroom-api.zego.im";
    } else if ([ZegoSetting sharedInstance].useTestEnv) {
        baseUrl = @"https://test2-liveroom-api.zego.im";
    } else {
        baseUrl = [NSString stringWithFormat:@"https://liveroom%u-api.%@", [ZegoSetting sharedInstance].appID, zegoDomain];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/demo/roomlist?appid=%u", baseUrl, [ZegoSetting sharedInstance].appID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"[fetchLiveRoom] url: %@", url.absoluteString);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.roomList removeAllObjects];
            
            if (error) {
                self.stateLabel.text = @"获取节目失败";
                self.startHintLabel.text = @"";
                NSLog(@"[fetchLiveRoom] error: %@", error);
                return;
            }
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (jsonError) {
                    NSLog(@"[fetchLiveRoom] parsing json error");
                    return;
                } else {
                    NSLog(@"[fetchLiveRoom] response: %@", jsonResponse);
                    NSUInteger code = [jsonResponse[@"code"] integerValue];
                    if (code != 0) {
                        return;
                    }
                    
                    NSArray *roomList = jsonResponse[@"data"][@"room_list"];
                    for (int idx = 0; idx < roomList.count; idx++) {
                        ZegoRoomInfo *info = [[ZegoRoomInfo alloc] init];
                        NSDictionary *infoDict = roomList[idx];
                        info.roomID = infoDict[@"room_id"];
                        
                        // 过滤掉 room_id 为空的房间
                        if (info.roomID.length == 0) {
                            continue;
                        }
                        
                        // 过滤掉 stream_info 为空的房间
                        if ([infoDict objectForKey:@"stream_info"]) {
                            NSArray *streamList = infoDict[@"stream_info"];
                            if (streamList.count == 0) {
                                continue;
                            }
                        }
                        
                        info.anchorID = infoDict[@"anchor_id_name"];
                        info.anchorName = infoDict[@"anchor_nick_name"];
                        info.roomName = infoDict[@"room_name"];
                        info.streamInfo = [[NSMutableArray alloc] initWithCapacity:1];
                        
                        for (NSDictionary *dict in infoDict[@"stream_info"]) {
                            ZegoStream *stream = [[ZegoStream alloc] init];
                            stream.streamID = dict[@"stream_id"];
                            [info.streamInfo addObject:stream];
                        }
                        
                        [self.roomList addObject:info];
                    }
                }
            }
            
            if (self.roomList.count == 0) {
                self.stateLabel.text = @"节目还没开始";
                self.startHintLabel.text = @"";
                NSLog(@"room list is empty");
                return;
            }
            
            // 取出 roomList 中有指定前缀的房间
            for (ZegoRoomInfo *info in self.roomList) {
                if ([info.roomID hasPrefix: quizRoomPrefix]) {
                    self.quizRoom = info;
                    break;
                }
            }
            
            if (self.quizRoom) {
                [self setupViewState:YES];
            } else {
                self.stateLabel.text = @"节目还没开始";
                self.startHintLabel.text = @"";
                NSLog(@"no specified prefix room");
                return;
            }
        });
    }];
    
    [task resume];
}

#pragma mark - Access

- (NSMutableArray *)roomList {
    if (!_roomList) {
        _roomList = [NSMutableArray array];
    }
    return _roomList;
}


@end
