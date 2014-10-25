//
//  EduSysEmptyClassroomViewController.m
//  iSCAU
//
//  Created by Alvin on 13-9-10.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysEmptyClassroomViewController.h"
#import "EduSysEmptyClassroomSelectionViewController.h"
#import "UIButton+Bootstrap.h"
#import "EduSysEmptyClassroomDetailViewController.h"
#import "iSCAUSwift-Swift.h"
#import "Constant.h"

#define kXQ @"校区"
#define kJSLB @"教室类别"
#define kKSZ @"开始周"
#define kJSZ @"结束周"
#define kSJD @"时间段"
#define kWeekday @"星期几"
#define kDSZ @"单双周"

@interface EduSysEmptyClassroomViewController ()

@property (nonatomic) BOOL isReloading;
@property (nonatomic, strong) NSDictionary *selectionsDict;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnXQ;
@property (weak, nonatomic) IBOutlet UIButton *btnJSLB;
@property (weak, nonatomic) IBOutlet UIButton *btnKSZ;
@property (weak, nonatomic) IBOutlet UIButton *btnJSZ;
@property (weak, nonatomic) IBOutlet UIButton *btnSJT;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekday;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UILabel *labXQ;
@property (weak, nonatomic) IBOutlet UILabel *labJSLB;
@property (weak, nonatomic) IBOutlet UILabel *labSJD;
@property (weak, nonatomic) IBOutlet UILabel *labWeekday;
@property (weak, nonatomic) IBOutlet UILabel *labKSZ;
@property (weak, nonatomic) IBOutlet UILabel *labJSZ;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dszSegment;

@end

@implementation EduSysEmptyClassroomViewController

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
    
    self.navigationItem.title = @"空余课室";
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;        
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *btnShowParams = [[UIBarButtonItem alloc] initWithTitle:@"更新参数" style:UIBarButtonItemStylePlain target:self action:@selector(refreshParameters)];
    self.navigationItem.rightBarButtonItem = btnShowParams;
    
    CGSize contentSize = self.backgroundScrollView.frame.size;
    ++contentSize.height;
    self.backgroundScrollView.contentSize = contentSize;
    
    [self.btnSearch successStyle];
    
    if ([Utils emptyClassroomParams]) {
        self.selectionsDict = [NSDictionary dictionaryWithDictionary:[Utils emptyClassroomParams]];
        [self setupEmptyClassroomParams];
    } else {
        [self refreshParameters];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelection:) name:EDU_SYS_EMPTY_CLASSROOM_SELECTED_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)updateSelection:(NSNotification *)notification {
    NSDictionary *selection = notification.userInfo;
    if (selection[kXQ]) {
        self.labXQ.text = self.selectionsDict[kXQ][[selection[kXQ] integerValue]];
    } else if (selection[kJSLB]) {
        self.labJSLB.text = self.selectionsDict[kJSLB][[selection[kJSLB] integerValue]];
    } else if (selection[kKSZ]) {
        self.labKSZ.text = self.selectionsDict[kKSZ][[selection[kKSZ] integerValue]];
    } else if (selection[kJSZ]) {
        self.labJSZ.text = self.selectionsDict[kJSZ][[selection[kJSZ] integerValue]];
    } else if (selection[kSJD]) {
        self.labSJD.text = self.selectionsDict[kSJD][[selection[kSJD] integerValue]];
    } else if (selection[kWeekday]) {
        self.labWeekday.text = self.selectionsDict[kWeekday][[selection[kWeekday] integerValue]];
    }
}

- (void)refreshParameters {
    if ([Utils stuNum].length < 1 || [Utils stuPwd].length < 1) {
        SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
        return;
    }
    
    if (self.isReloading) {
        return;
    }
    
    self.isReloading = YES;
    SHOW_WATING_HUD
    [EduHttpManager requestEmptyClassroomParamsWithCompletionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
        self.isReloading = NO;
        if (response.statusCode == kStatusCodeSuccess) {
            NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:nil];
            [self parseParams:params];
            [self setupEmptyClassroomParams];
        }
        HIDE_ALL_HUD
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)setupEmptyClassroomParams {
    if (self.selectionsDict) {
        if ([self.selectionsDict[kXQ] count] > 0) {
            self.labXQ.text = self.selectionsDict[kXQ][0];
        }
        if ([self.selectionsDict[kJSLB] count] > 0) {
            self.labJSLB.text = self.selectionsDict[kJSLB][0];
        }
        if ([self.selectionsDict[kKSZ] count] > 0) {
            self.labKSZ.text = self.selectionsDict[kKSZ][0];
        }
        if ([self.selectionsDict[kJSZ] count] > 0) {
            self.labJSZ.text = self.selectionsDict[kJSZ][0];
        }
        if ([self.selectionsDict[kSJD] count] > 0) {
            self.labSJD.text = self.selectionsDict[kSJD][0];
        }
        if ([self.selectionsDict[kWeekday] count] > 0) {
            self.labWeekday.text = self.selectionsDict[kWeekday][0];
        }
    }
}

- (void)parseParams:(NSDictionary *)selectionParams {
    NSArray *paramsArray = selectionParams[@"params"];
    if (paramsArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSDictionary *d in paramsArray) {
            [dict setObject:d[@"value"] forKey:d[@"key"]];
        }
        if (dict.count > 0) {
            [Utils setEmptyClassroomParams:dict];
            self.selectionsDict = dict;
        }
    }
}

#pragma mark - selection

- (IBAction)xqSelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kXQ] count] > 0) {
        selectionViewController.selectionKey = kXQ;
        selectionViewController.selections = self.selectionsDict[kXQ];
    } else {
//        SHOW_NOTICE_HUD(@"请先更新参数");
    }
    [self.navigationController pushViewController:selectionViewController animated:YES];
}

- (IBAction)jslbSelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kJSLB] count] > 0) {
        selectionViewController.selectionKey = kJSLB;
        selectionViewController.selections = self.selectionsDict[kJSLB];
    } else {
        SHOW_NOTICE_HUD(@"请先更新参数");
    }

    [self.navigationController pushViewController:selectionViewController animated:YES];
}
- (IBAction)kszSelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kKSZ] count] > 0) {
        selectionViewController.selectionKey = kKSZ;
        selectionViewController.selections = self.selectionsDict[kKSZ];
    } else {
        SHOW_NOTICE_HUD(@"请先更新参数");
    }

    [self.navigationController pushViewController:selectionViewController animated:YES];
}
- (IBAction)jszSelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kJSZ] count] > 0) {
        selectionViewController.selectionKey = kJSZ;
        selectionViewController.selections = self.selectionsDict[kJSZ];
    } else {
        SHOW_NOTICE_HUD(@"请先更新参数");
    }

    [self.navigationController pushViewController:selectionViewController animated:YES];
}
- (IBAction)sjtSelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kSJD] count] > 0) {
        selectionViewController.selectionKey = kSJD;
        selectionViewController.selections = self.selectionsDict[kSJD];
    } else {
        SHOW_NOTICE_HUD(@"请先更新参数");
    }

    [self.navigationController pushViewController:selectionViewController animated:YES];
}
- (IBAction)weekdaySelection:(id)sender
{
    EduSysEmptyClassroomSelectionViewController *selectionViewController = [[EduSysEmptyClassroomSelectionViewController alloc] init];
    if ([self.selectionsDict[kWeekday] count] > 0) {
        selectionViewController.selectionKey = kWeekday;
        selectionViewController.selections = self.selectionsDict[kWeekday];
    }
    [self.navigationController pushViewController:selectionViewController animated:YES];
}

- (IBAction)searchEmptyClassroom:(id)sender
{
    if (self.labXQ.text.length > 0 &&
        self.labJSZ.text.length > 0 &&
        self.labSJD.text.length > 0 &&
        self.labWeekday.text.length > 0 &&
        self.labKSZ.text.length > 0 &&
        self.labJSZ.text.length > 0) {
        if ([self.labKSZ.text integerValue] > [self.labJSZ.text integerValue]) {
            SHOW_NOTICE_HUD(@"开始周不能大于结束周哦~");
            return;
        }
        
        if ([Utils stuNum].length < 1 || [Utils stuPwd].length < 1) {
            SHOW_NOTICE_HUD(@"请先填写对应账号密码哦");
            return;
        }
    
        SHOW_WATING_HUD;
        [EduHttpManager requestEmptyClassroomInfoWithXq:self.labXQ.text
                                                   jslb:self.labJSLB.text
                                                 ddlKsz:self.labKSZ.text
                                                 ddlJsz:self.labJSZ.text
                                                    xqj:self.labWeekday.text
                                                    dsz:self.selectionsDict[kDSZ][self.dszSegment.selectedSegmentIndex]
                                                    sjd:self.labSJD.text
                                      completionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id data, NSError *error) {
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          if (response.statusCode == kStatusCodeSuccess && dict) {
                                              NSArray *emptyClassrooms = dict[@"classRooms"];
                                              if (emptyClassrooms) {
                                                  EduSysEmptyClassroomDetailViewController *detailViewController = [[EduSysEmptyClassroomDetailViewController alloc] init];
                                                  detailViewController.emptyClassrooms = emptyClassrooms;
                                                  [self.navigationController pushViewController:detailViewController animated:YES];
                                              }
                                          }
                                          HIDE_ALL_HUD
                                      }];
    }
}

@end
