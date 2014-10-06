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

@interface EduSysClassTableViewController () <PopoverViewDelegate, SBDropDownMenuDelegate>
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
    [self setupData];
    [self updateTitle];
    [self setupRightButtonState];
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
    
    [self setupTable];
}

- (void)setupTable
{
    if (self.weekStyle) {
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
    } else {
        [self.weekTableView updateClasses:classes];
    }
    [self.weekTableView updateViewWithWeek:[Utils currentWeekNum]];
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
    SHOW_WATING_HUD;

    [EduHttpManager requestClassTableWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        if (response.statusCode == kStatusCodeSuccess) {
            HIDE_ALL_HUD;
            NSDictionary *classesInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            if (classesInfo[@"termStartDate"]) {
                [Utils setSemesterStartDate:classesInfo[@"termStartDate"]];
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
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消编辑" style:UIBarButtonItemStylePlain target:self action:@selector(endEditing)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    } else {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(showPopOverView)];
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
