//
//  EduSysPickClassInfoViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysPickClassInfoViewController.h"
#import "EduSysPickClassInfoCell.h"
#import "UIImage+Tint.h"
#import "AZTools.h"
#import "iSCAUSwift-Swift.h"

#define CELL_HEIGHT 157

@interface EduSysPickClassInfoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BOOL isReloading;
@property (weak, nonatomic) IBOutlet UITableView *pickClassInfoTable;
@property (nonatomic, strong) NSMutableArray *pickClassInfos;
@end

@implementation EduSysPickClassInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title= @"选课情况";
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 55, 44);
    btnClose.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btnClose setImage:[[UIImage imageNamed:@"refresh.png"] imageWithTintColor:APP_DELEGATE.tintColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.rightBarButtonItem = closeBarBtn;
    
    self.pickClassInfos = [NSMutableArray array];

    SET_DEFAULT_BACKGROUND_COLOR(self.pickClassInfoTable);

    [self reloadData];
}

- (void)reloadData {
    if (self.isReloading) {
        return;
    }

    if ([Utils stuNum].length < 1 || [Utils stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }

    SHOW_WATING_HUD;
    self.isReloading = YES;
    [EduHttpManager requestPickClassInfoWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        if (response.statusCode == kStatusCodeSuccess) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            self.pickClassInfos = [dict objectForKey:@"pickclassinfos"];
            [self.pickClassInfoTable reloadData];
            
            if (dict.count == 0) {
                SHOW_NOTICE_HUD(@"当前没有已选课程");
            }
        }
        self.isReloading = NO;
        HIDE_ALL_HUD;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pickClassInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *EduSysExamInfoCellIndentifier = @"EduSysPickClassInfoCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EduSysExamInfoCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"EduSysPickClassInfoCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    [(EduSysPickClassInfoCell *)cell configurateInfo:self.pickClassInfos[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end