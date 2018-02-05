//
//  ZegoFinalStatViewController.m
//  LiveQuiz
//
//  Created by xia on 31/01/2018.
//  Copyright © 2018 zego. All rights reserved.
//

#import "ZegoFinalStatViewController.h"
#import "ZegoUserCell.h"

NSString *const userCellIdentifier = @"ZegoUserCellIdentifier";

@interface ZegoFinalStatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UITableView *winnerTableView;

@end

@implementation ZegoFinalStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.winnerTableView.delegate = self;
    self.winnerTableView.dataSource = self;
    self.view.layer.cornerRadius = 20.0;
    self.winnerTableView.layer.cornerRadius = 20.0;
    self.winnerTableView.tableFooterView = [[UIView alloc] init];
    [self.winnerTableView registerNib:[UINib nibWithNibName:@"ZegoUserCell" bundle:nil] forCellReuseIdentifier:userCellIdentifier];
    
    self.statLabel.text = [NSString stringWithFormat:@"本场答题获胜总人数：%ld", (long)self.totalCount];
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

- (IBAction)onClose:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onCloseButtonClicked:)]) {
        [self.delegate onCloseButtonClicked:sender];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.winnerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.winnerList count] == 0 || indexPath.row > self.winnerList.count) {
        return nil;
    }
    
    ZegoUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    ZegoUser *user = self.winnerList[indexPath.row];
    cell.userNameLabel.text = user.userName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}


@end
