//
//  EduSysClassTableViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-11.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysClassTableViewController.h"
#import "EduSysDayClassTableView.h"
#import "EduSysWeekClassTableView.h"
#import "EduSysClassTableEditedViewController.h"
#import "AZTools.h"
#import "iSCAUSwift-Swift.h"

@interface EduSysClassTableViewController () <PopoverViewDelegate>

@end

@implementation EduSysClassTableViewController

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

    self.classesMon = [NSMutableArray array];
    self.classesTue = [NSMutableArray array];
    self.classesWed = [NSMutableArray array];
    self.classesThus = [NSMutableArray array];
    self.classesFri = [NSMutableArray array];
    self.classesSat = [NSMutableArray array];
    self.classesSun = [NSMutableArray array];

    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dayTableView = [[EduSysDayClassTableView alloc] initWithFrame:(CGRect){
        0,
        64,
        self.view.size
    }];

    [self.view addSubview:self.dayTableView];
    [self setupRightButtonState];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupData];    
    [self setupNavTitle];
}

#pragma mark - methods

- (void)setupNavTitle
{
    NSString *title = [NSString stringWithFormat:@"课程表%@", [self getWeek]];
    self.title = title;
}

- (NSString *)getWeek
{
    NSString *semesterStartDate = @""; //[[Tool semesterStartDate] copy];
    if (semesterStartDate) {
        NSDate *date = [NSDate date];
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:local];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [formatter dateFromString:semesterStartDate];
        NSTimeInterval interval = [date timeIntervalSinceDate:startDate];
        int days = ((int) interval) / 86400;
        int week = floor(days / 7.0) + 1;
        
        if (week > 0 && week < 22) { 
            return [NSString stringWithFormat:@"(第%d周)", week];
        } else {
            return @"";
        }
    }
    return @"";
}

- (void)setupData
{
    NSDictionary *classDict = [self loadLocalClassesData];
    [self parseClassesData:classDict];
}

- (void)parseClassesData:(NSDictionary *)classesInfo
{
    if (classesInfo == nil) return;

    [self.classesMon removeAllObjects];
    [self.classesTue removeAllObjects];
    [self.classesWed removeAllObjects];
    [self.classesThus removeAllObjects];
    [self.classesFri removeAllObjects];
    [self.classesSat removeAllObjects];
    [self.classesSun removeAllObjects];
    
    NSArray *classes = [classesInfo objectForKey:@"classes"];
    
    for (NSDictionary *class in classes) {
        NSString *day = [class objectForKey:@"day"];
        
        if ([day isEqualToString:@"一"]) {
            [self.classesMon addObject:class];
        } else if ([day isEqualToString:@"二"]) {
            [self.classesTue addObject:class];
        } else if ([day isEqualToString:@"三"]) {
            [self.classesWed addObject:class];
        } else if ([day isEqualToString:@"四"]) {
            [self.classesThus addObject:class];
        } else if ([day isEqualToString:@"五"]) {
            [self.classesFri addObject:class];
        } else if ([day isEqualToString:@"六"]) {
            [self.classesSat addObject:class];
        } else if ([day isEqualToString:@"日"]) {
            [self.classesSun addObject:class];
        }
    }
    [self.dayTableView reloadClassTableWithClasses:@[self.classesMon,
                                                     self.classesTue,
                                                     self.classesWed,
                                                     self.classesThus,
                                                     self.classesFri,
                                                     self.classesSat,
                                                     self.classesSun]
     ];
}

- (void)showPopOverView
{
    UIButton *btnReloadData = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReloadData.frame = CGRectMake(5, 0, 90, 40);
    [btnReloadData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReloadData setTitle:@"更新" forState:UIControlStateNormal];
    btnReloadData.userInteractionEnabled = NO;
    
    UIButton *btnChangeClassTableMode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChangeClassTableMode.frame = CGRectMake(5, 44, 90, 40);
    [btnChangeClassTableMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnChangeClassTableMode setTitle:@"编辑" forState:UIControlStateNormal];
    btnChangeClassTableMode.userInteractionEnabled = NO;
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(5, 88, 90, 40);
    [btnEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnEdit setTitle:@"添加" forState:UIControlStateNormal];
    btnEdit.userInteractionEnabled = NO;
    
    [PopoverView showPopoverAtPoint:CGPointMake(SCREEN_WIDTH - 20, 64) inView:self.view withViewArray:@[btnReloadData, btnChangeClassTableMode, btnEdit] delegate:self];
}

- (void)reloadData
{
//    if ([Tool stuNum].length < 1 || [Tool stuPwd].length < 1) {
//        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
//        return;
//    }
//    SHOW_WATING_HUD;
//    [[EduSysHttpClient shareInstance] 
//     eduSysGetClassTableSuccess:^(NSData *responseData, NSInteger httpCode){
//         NSDictionary *classesInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
//         if (httpCode == 200) {
//             HIDE_ALL_HUD;
//             if (classesInfo[@"termStartDate"]) {
//                 [Tool setSemesterStartDate:classesInfo[@"termStartDate"]];
//                 [self setNavTitle];
//             }
//             [self parseClassesData:classesInfo];
//             [self saveClassesDataToLocal:classesInfo];
//         }
//     } 
//     failure:nil];
    [EduHttpManager requestClassTableWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        if (response.statusCode == kStatusCodeSuccess) {
            NSDictionary *classesInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            if (classesInfo[@"termStartDate"]) {
//                [Tool setSemesterStartDate:classesInfo[@"termStartDate"]];
                [self setupNavTitle];
            }
            [self parseClassesData:classesInfo];
            [self saveClassesDataToLocal:classesInfo];
        }
    }];
}

- (void)editClassTable
{
    [self.dayTableView enterEditingMode];
    [self setupRightButtonState];
}

- (void)setupRightButtonState
{
    if (self.dayTableView.isEditing) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(endEditing)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    } else {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopOverView)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)endEditing
{
    [self.dayTableView cancleEdit];
    [self setupRightButtonState];
}

- (void)editTable
{
    EduSysClassTableEditedViewController *editViewController = [[EduSysClassTableEditedViewController alloc] init];
    editViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self reloadData];
            break;
        case 1:
            [self editClassTable];
            break;
        case 2:
            [self editTable];
            break;
        default:
            break;
    }

    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
}

- (NSDictionary *)loadLocalClassesData
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Utils classTablePath]];
}

- (void)saveClassesDataToLocal:(NSDictionary *)classesDict
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:classesDict];
    [data writeToFile:[Utils classTablePath] atomically:YES];
}

@end
