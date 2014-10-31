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
#import "SBDropDownMenu.h"
#import "iSCAUSwift-Swift.h"
#import <CNPPopupController/CNPPopupController.h>

@interface EduSysClassTableViewController () <PopoverViewDelegate, SBDropDownMenuDelegate, CNPPopupControllerDelegate>
@property (nonatomic) BOOL weekStyle;
@property (nonatomic, strong) SBDropDownMenu *dropDownMenu;
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
    
    // Data
    self.weekStyle = [Utils preferWeekStyleClassTable];
    [self setupRightButtonState];
    
    // Update notice
    {
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        if (![[Utils savedVersionString] isEqualToString:version]) {
            [Utils setSavedVersionString:version];
            NSMutableParagraphStyle *titleParagraphStyle = NSMutableParagraphStyle.new;
            titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            titleParagraphStyle.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"更新内容" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSParagraphStyleAttributeName : titleParagraphStyle}];
            
            NSString *update = @""
            "1. 全新 UI，更加清爽易用；\n"
            "2. “地图”和“校历”等数据更新；\n"
            "3. 新增“活动”和“外卖”（这个真没收钱！）模块；\n"
            "4. 课表除了添加“每周视图”外，还有 iOS8 通知中心小工具“Today”，更快的查看每日课程。\n\n"
            "设置方法：\n"
            "第一步：升级到 iOS8 系统，安装 3.0.0 以上版本 iSCAU；\n"
            "第二步：下拉通知中心，点击底部“编辑”按钮，再点击“+iSCAU”按钮即添加成功；\n"
            "第三步：调整 widget 到你想要的位置，随时下拉通知中心即可快速查阅课表。";
            
            NSMutableParagraphStyle *contentParagraphStyle = NSMutableParagraphStyle.new;
            contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            contentParagraphStyle.alignment = NSTextAlignmentLeft;
            NSAttributedString *content = [[NSAttributedString alloc] initWithString:update
                                                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : contentParagraphStyle}];
            
            NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"好的！" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : titleParagraphStyle}];
            CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
            
            CNPPopupController *popVC = [[CNPPopupController alloc] initWithTitle:title contents:@[content] buttonItems:@[buttonItem] destructiveButtonItem:nil];
            popVC.theme = [CNPPopupTheme defaultTheme];
            popVC.delegate = self;
            popVC.theme.popupStyle = CNPPopupStyleCentered;
            popVC.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
            [popVC presentPopupControllerAnimated:YES];
            
            buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
                [popVC dismissPopupControllerAnimated:YES];
            };
        } else {
            [self checkLogin];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupData) name:EDU_SYS_DID_UPDATE_CLASSTABLE_NOTIFICATION object:nil];
}

- (void)viewDidLayoutSubviews
{
    [self setupData];
    [self updateTitle];
}

- (void)checkLogin
{
    if ([Utils stuNum].length == 0 &&
        [Utils stuPwd].length == 0 &&
        [Utils libPwd].length == 0) {
        if (![Utils hadLogin]) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        [Utils setHadLogin:YES];
    }
}

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title
{
    [self checkLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - methods

- (void)showPopOverView
{
    UIButton *btnReloadData = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReloadData.frame = CGRectMake(5, 0, 90, 40);
    [btnReloadData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReloadData setTitle:@"更新" forState:UIControlStateNormal];
    btnReloadData.userInteractionEnabled = NO;

    if (self.weekStyle) {
        UIButton *btnFlipToWeek = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFlipToWeek.frame = CGRectMake(5, 44, 90, 40);
        [btnFlipToWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnFlipToWeek setTitle:@"每日视图" forState:UIControlStateNormal];
        btnFlipToWeek.userInteractionEnabled = NO;
        
        [PopoverView showPopoverAtPoint:CGPointMake(SCREEN_WIDTH - 20, 0) inView:self.view withViewArray:@[btnReloadData, btnFlipToWeek] delegate:self];
    } else {
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
        
        UIButton *btnFlipToWeek = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFlipToWeek.frame = CGRectMake(5, 132, 90, 40);
        [btnFlipToWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnFlipToWeek setTitle:@"全周视图" forState:UIControlStateNormal];
        btnFlipToWeek.userInteractionEnabled = NO;
        
        [PopoverView showPopoverAtPoint:CGPointMake(SCREEN_WIDTH - 20, 0) inView:self.view withViewArray:@[btnReloadData, btnChangeClassTableMode, btnEdit, btnFlipToWeek] delegate:self];
    }
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    if (self.weekStyle) {
        switch (index) {
            case 0:
                [self reloadData];
                break;
            case 1:
                [self flipClassTable];
        }
    } else {
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
            case 3:
                [self flipClassTable];
        }
    }
    
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
}

#pragma mark - Style

- (void)didSelectedItem:(id)item
{
    if (self.weekStyle) {
        [self.weekTableView updateViewWithWeek:[item integerValue]];
    }
}

- (void)flipClassTable
{
    if (!self.weekStyle) {
        [self setupWeekClasstable];
    } else {
        [self setupDayClasstable];
    }
    
    APP_DELEGATE.window.userInteractionEnabled = NO;
    [UIView transitionWithView:self.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        if (!self.weekStyle) {
                            [self.dayTableView removeFromSuperview];
                            self.dayTableView = nil;

                            [self.view addSubview:self.weekTableView];
                        } else {
                            [self.weekTableView removeFromSuperview];
                            self.weekTableView = nil;
                            
                            [self.view addSubview:self.dayTableView];
                        }
                        self.weekStyle = !self.weekStyle;
                        [Utils setPreferWeekStyleClassTable:self.weekStyle];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            APP_DELEGATE.window.userInteractionEnabled = YES;
                            [self updateTitle];
                        }
                    }];
}

- (void)updateTitle
{
    if (self.weekStyle) {
        if (!self.dropDownMenu) {
            // Dropdown menu
            self.dropDownMenu = [[SBDropDownMenu alloc] init];
            self.dropDownMenu.backgroundColor = [UIColor clearColor];
            self.dropDownMenu.delegate = self;
            NSMutableArray *weeks = [NSMutableArray array];
            for (NSInteger i = 1; i <= 23; i++) {
                [weeks addObject:@(i)];
            }
            [self.dropDownMenu resetDatasource:weeks];
        }
        [self.dropDownMenu setTitleWithWeek:[Utils currentWeekNum]];
        self.navigationItem.titleView = self.dropDownMenu;
    } else {
        self.navigationItem.titleView = nil;
        self.navigationItem.title = [NSString stringWithFormat:@"课程表 %@", [Utils currentWeek]];
    }
}

#pragma mark - Data

- (void)setupData
{
    NSDictionary *classDict = [Utils localClassesInfo];
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
    
    for (NSMutableDictionary *lession in classes) {
        for (NSString *key in [lession allKeys]) {
            if ([lession[key] isEqual:[NSNull null]]) {
                lession[key] = @"";
            }
        }
        
        NSString *day = [lession objectForKey:@"day"];
        
        if ([day isEqualToString:@"一"]) {
            [self.classesMon addObject:lession];
        } else if ([day isEqualToString:@"二"]) {
            [self.classesTue addObject:lession];
        } else if ([day isEqualToString:@"三"]) {
            [self.classesWed addObject:lession];
        } else if ([day isEqualToString:@"四"]) {
            [self.classesThus addObject:lession];
        } else if ([day isEqualToString:@"五"]) {
            [self.classesFri addObject:lession];
        } else if ([day isEqualToString:@"六"]) {
            [self.classesSat addObject:lession];
        } else if ([day isEqualToString:@"日"]) {
            [self.classesSun addObject:lession];
        }
    }
    
    [self setupTable];
}

- (void)setupTable
{
    if (self.weekStyle) {
        [self updateTitle];
        [self setupWeekClasstable];
        [self.view addSubview:self.weekTableView];
    } else {
        [self setupDayClasstable];
        [self.view addSubview:self.dayTableView];
    }
}

- (void)setupWeekClasstable
{
    NSMutableArray *classes = [NSMutableArray array];
    [classes addObjectsFromArray:self.classesMon];
    [classes addObjectsFromArray:self.classesTue];
    [classes addObjectsFromArray:self.classesWed];
    [classes addObjectsFromArray:self.classesThus];
    [classes addObjectsFromArray:self.classesFri];
    [classes addObjectsFromArray:self.classesSat];
    [classes addObjectsFromArray:self.classesSun];
    if (!self.weekTableView) {
        self.weekTableView = [[EduSysWeekClassTableView alloc] initWithFrame:self.view.bounds classes:classes];
    }
    [self.weekTableView updateClasses:classes];
}

- (void)setupDayClasstable
{
    if (!self.dayTableView) {
        self.dayTableView = [[EduSysDayClassTableView alloc] initWithFrame:(CGRect){
            CGPointZero,
            self.view.size
        }];
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

- (void)reloadData
{
    if ([Utils stuNum].length < 1 || [Utils stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    SHOW_WATING_HUD
    [EduHttpManager requestClassTableWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        if (response.statusCode == kStatusCodeSuccess) {
            NSDictionary *classesInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            if (classesInfo[@"termStartDate"]) {
                [Utils setSemesterStartDate:classesInfo[@"termStartDate"]];
            }
            [self parseClassesData:classesInfo];
            [self saveClassesDataToLocal:classesInfo];
        }
        HIDE_ALL_HUD
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
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消编辑" style:UIBarButtonItemStylePlain target:self action:@selector(endEditing)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    } else {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:Image(@"plus.png") style:UIBarButtonItemStylePlain target:self action:@selector(showPopOverView)];
        rightBarButtonItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
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

- (void)saveClassesDataToLocal:(NSDictionary *)classesDict
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.iSCAU"];
    [sharedDefaults setObject:classesDict forKey:@"kClassTableDictKey"];
    [sharedDefaults synchronize];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:classesDict];
    [data writeToFile:[Utils classTablePath] atomically:YES];
}

@end
