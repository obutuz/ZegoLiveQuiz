//
//  ZegoRoomViewController.m
//  LiveQuiz
//
//  Created by xia on 05/02/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoRoomViewController.h"
#import "ZegoSetting.h"
#import "ZegoPlayViewController.h"
#import "ZegoLogTableViewController.h"

static NSString *const zegoDomain      = @"zego.im";
static NSString *const alphaBaseUrl    = @"https://alpha-liveroom-api.zego.im";
static NSString *const testBaseUrl     = @"https://test2-liveroom-api.zego.im";
static NSString *const enterPlayingIdentifier = @"EnterPlayingIdentifier";

@interface ZegoRoomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray<ZegoRoomInfo *> *roomList;
@property (nonatomic, strong) ZegoRoomInfo *quizRoom;

@property (nonatomic, strong) NSMutableArray *logArray;

@end

@implementation ZegoRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"background"];
    self.view.layer.contents = (id)image.CGImage;
    
    self.logArray = [[NSMutableArray alloc] init];
    
    self.roomTableView.layer.cornerRadius = 20.0;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.roomTableView insertSubview:self.refreshControl atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizerFive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapViewFive:)];
    tapGestureRecognizerFive.numberOfTapsRequired = 5;
    [self.view addGestureRecognizer:tapGestureRecognizerFive];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:date]; //dateString: 20160707160333
     
    NSString *appVersion = [NSString stringWithFormat:@"App Version: %@", dateString];
    NSString *sdkVersion = [NSString stringWithFormat:@"SDK Version: %@", [ZegoLiveRoomApi version]];
    NSString *veVersion = [NSString stringWithFormat:@"VE Version: %@", [ZegoLiveRoomApi version2]];
    [self addLogString: [NSString stringWithFormat:@"%@ \n%@ \n%@", appVersion, sdkVersion, veVersion]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:enterPlayingIdentifier]) {
        ZegoPlayViewController *viewController = (ZegoPlayViewController *)segue.destinationViewController;
        viewController.roomInfo = sender;
    }
}

- (void)applicationBecomeActive {
    [self handleRefresh:self.refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    [self.roomList removeAllObjects];
    [self fetchLiveRoom];
}

- (void)onTapViewFive:(UIGestureRecognizer *)gesture {
    [self onShowLog:gesture];
}

- (void)onShowLog:(id)sender {
    ZegoLogTableViewController *logViewController = [[ZegoLogTableViewController alloc] init];
    logViewController.logArray = self.logArray;
    
    ZegoLogNavigationController *navigationController = [[ZegoLogNavigationController alloc] initWithRootViewController:logViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private

- (void)fetchLiveRoom {
    [self.refreshControl beginRefreshing];
    
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
    
    [self addLogString:[NSString stringWithFormat:@"[fetchLiveRoom] url: %@", url.absoluteString]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            
            [self.roomList removeAllObjects];
            
            if (error) {
                NSLog(@"[fetchLiveRoom] error: %@", error);
                [self addLogString:[NSString stringWithFormat:@"[fetchLiveRoom] error: %@", error]];
                return;
            }
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (jsonError) {
                    NSLog(@"[fetchLiveRoom] parsing json error");
                    [self addLogString:[NSString stringWithFormat:@"[fetchLiveRoom] parsing json error"]];
                    return;
                } else {
                    NSUInteger code = [jsonResponse[@"code"] integerValue];
                    [self addLogString:[NSString stringWithFormat:@"[fetchLiveRoom] response code: %lu", (unsigned long)code]];
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
                        [self.roomTableView reloadData];
                    }
                }
            }
        });
    }];
    
    [task resume];
}

- (void)addLogString:(NSString *)logString
{
    if (logString.length != 0)
    {
        NSString *totalString = [NSString stringWithFormat:@"%@: %@", [self getCurrentTime], logString];
        [self.logArray insertObject:totalString atIndex:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logUpdateNotification" object:self userInfo:nil];
    }
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"[HH-mm-ss:SSS]";
    return [formatter stringFromDate:[NSDate date]];
}


#pragma mark - Access

- (NSMutableArray *)roomList {
    if (!_roomList) {
        _roomList = [NSMutableArray array];
    }
    return _roomList;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.roomList.count < indexPath.row) {
        return nil;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell" forIndexPath:indexPath];
    ZegoRoomInfo *info = self.roomList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"RoomID: %@", info.roomID];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"RoomName: %@", info.roomName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.quizRoom = self.roomList[indexPath.row];
    [self performSegueWithIdentifier:enterPlayingIdentifier sender:self.quizRoom];
}

@end
