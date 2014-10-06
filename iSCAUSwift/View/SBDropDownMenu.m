//
//  SBDropDownMenu.m
//  SocialBase
//
//  Created by Alvin on 6/8/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "SBDropDownMenu.h"
#import "iSCAUSwift-Swift.h"

// Params
#define MenuToggleDuration 0.3
#define DefalutAnimationDuration 0.3
#define ThemeColor [UIColor colorFromHexRGB:@"3b4354" alpha:1]
#define CustomersTableViewCellSelectedBackgroundColor [UIColor colorWithR:0 g:0 b:0 a:0.2]
#define MenuViewWidth 50
#define CustomersTableViewCellWidth 156.f
#define CustomersTableViewCellHeight 44.f
#define TitleViewFont [UIFont boldSystemFontOfSize:19]
#define TitleViewMaxWidth 120
#define TitleViewMaxHeight 44

@interface SBDropDownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *userSelectionTapGesture;
@property (nonatomic, strong) NSMutableArray *items;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoreOnTitleView;
@property (weak, nonatomic) IBOutlet UILabel *labTitleOnTitleView;

@property (strong, nonatomic) IBOutlet UIControl *popupViewBackground;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIView *titleViewOnPopupView;
@property (weak, nonatomic) IBOutlet UILabel *labTitleOnPopupView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoreOnPopupView;
@property (weak, nonatomic) IBOutlet UITableView *tableCustomers;

@end

@implementation SBDropDownMenu

- (instancetype)init
{
    self = [super init];
    
    [[NSBundle mainBundle] loadNibNamed:@"SBDropDownMenu" owner:self options:nil];
    self.frame = self.titleView.bounds;
    [self addSubview:self.titleView];
    [self setup];
    
    return self;
}

- (void)setup
{
    self.items = [NSMutableArray array];
    
    // Title view
    self.titleView.backgroundColor = APP_DELEGATE.tintColor;
    self.userSelectionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomersSelection:)];
    [self.titleView addGestureRecognizer:self.userSelectionTapGesture];
    
    // Popup View
    self.popupViewBackground.frame = [UIScreen mainScreen].bounds;
    self.popupViewBackground.hidden = YES;
    self.popupViewBackground.alpha = 0;
    [APP_DELEGATE.window addSubview:self.popupViewBackground];
    
    self.popupView.backgroundColor = WhiteColor;
    self.popupView.frame = (CGRect){
        (SCREEN_WIDTH - self.popupView.width) / 2,
        20,
        self.popupView.size
    };
    self.popupView.layer.cornerRadius = 2.f;
    self.popupView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.popupView.layer.shadowOpacity = 0.5;
    self.popupView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    
    self.titleViewOnPopupView.backgroundColor = APP_DELEGATE.tintColor;
    self.tableCustomers.backgroundColor = APP_DELEGATE.tintColor;
    
    [self layoutTitleView];
}

#pragma mark - Datasource

- (void)setTitleWithWeek:(NSInteger)week
{
    if (week == [Utils currentWeekNum]) {
        self.labTitleOnPopupView.text = [NSString stringWithFormat:@"第"SINT"周(本周)", week];
        self.labTitleOnTitleView.text = [NSString stringWithFormat:@"第"SINT"周(本周)", week];
    } else {
        self.labTitleOnPopupView.text = [NSString stringWithFormat:@"第"SINT"周", week];
        self.labTitleOnTitleView.text = [NSString stringWithFormat:@"第"SINT"周", week];
    }
    [self layoutTitleView];
}

- (void)resetDatasource:(NSArray *)data
{
    if (data.count > 0) {
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:data];
        [self.tableCustomers reloadData];
        
        [self setTitleWithWeek:[Utils currentWeekNum]];
    }
}

#pragma mark - Action

- (IBAction)toggleCustomersSelection:(id)sender
{
    if (!self.isPopUpShown) {
        self.isPopUpShown = YES;
        self.popupViewBackground.hidden = NO;
        [self.titleViewOnPopupView addGestureRecognizer:self.userSelectionTapGesture];
        [UIView animateWithDuration:DefalutAnimationDuration
                         animations:^{
                             self.popupViewBackground.alpha = 1;
                             self.imgMoreOnPopupView.transform = CGAffineTransformRotate(self.imgMoreOnPopupView.transform, M_PI);
                             self.imgMoreOnTitleView.transform = CGAffineTransformRotate(self.imgMoreOnTitleView.transform, M_PI);
                         }];
    } else {
        self.isPopUpShown = NO;
        [self addGestureRecognizer:self.userSelectionTapGesture];
        [UIView animateWithDuration:DefalutAnimationDuration
                         animations:^{
                             self.popupViewBackground.alpha = 0;
                             self.imgMoreOnPopupView.transform = CGAffineTransformRotate(self.imgMoreOnPopupView.transform, -M_PI);
                             self.imgMoreOnTitleView.transform = CGAffineTransformRotate(self.imgMoreOnTitleView.transform, -M_PI);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 self.popupViewBackground.hidden = YES;
                             }
                         }];
    }
}

#pragma mark - UI

// 调整标题大小
- (void)layoutTitleView
{
    CGSize titleSize = [self.labTitleOnPopupView.text sizeWithAttributes:@{ NSFontAttributeName: self.labTitleOnPopupView.font }];
    titleSize.width = MIN(titleSize.width, TitleViewMaxWidth);
    titleSize.height = TitleViewMaxHeight;
    
    if (self.items.count <= 1) {
        self.imgMoreOnTitleView.hidden = YES;
        self.labTitleOnTitleView.frame = (CGRect) {
            CGPointZero,
            titleSize
        };
        self.labTitleOnTitleView.center = self.titleView.center;
        [self.titleView removeGestureRecognizer:self.userSelectionTapGesture];
    } else {
        self.imgMoreOnTitleView.hidden = NO;
        [self.titleView addGestureRecognizer:self.userSelectionTapGesture];
        
        CGFloat orifinX = (CustomersTableViewCellWidth - titleSize.width - self.imgMoreOnPopupView.width / 2) / 2;
        
        self.labTitleOnPopupView.frame = (CGRect){
            orifinX,
            0,
            titleSize
        };
        self.labTitleOnTitleView.frame = self.labTitleOnPopupView.frame;
        
        self.imgMoreOnPopupView.frame = (CGRect){
            self.labTitleOnPopupView.right - 10,
            0,
            self.imgMoreOnPopupView.size
        };
        self.imgMoreOnTitleView.frame = self.imgMoreOnPopupView.frame;
    }
}

// 重设标题
- (void)resetTitleView
{
    [self.items removeAllObjects];
    [self.tableCustomers reloadData];
    [self layoutTitleView];
}

#pragma mark - TableView datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CustomersTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SBCustomerCellIdentifier = @"SBCustomerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SBCustomerCellIdentifier];
    NSInteger TagLabCustomerName = 1000;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SBCustomerCellIdentifier];
        cell.frame = (CGRect){
            CGPointZero,
            CustomersTableViewCellWidth,
            CustomersTableViewCellHeight
        };
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        CGFloat marginX = 20.f;
        UILabel *labCustomerName = [[UILabel alloc] initWithFrame:(CGRect){
            marginX,
            0,
            cell.width - marginX * 2,
            cell.contentView.height
        }];
        labCustomerName.backgroundColor = [UIColor clearColor];
        labCustomerName.textColor = [UIColor whiteColor];
        labCustomerName.font = TitleViewFont;
        labCustomerName.textAlignment = NSTextAlignmentLeft;
        labCustomerName.tag = TagLabCustomerName;
        labCustomerName.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:labCustomerName];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = CustomersTableViewCellSelectedBackgroundColor;
    }
    UILabel *labCustomerName = (UILabel *)[cell.contentView subviewWithTag:TagLabCustomerName];
    if (labCustomerName) {
        if ([self.items[indexPath.row] integerValue] == [Utils currentWeekNum]) {
            labCustomerName.text = [NSString stringWithFormat:@"第%@周(本周)", self.items[indexPath.row]];
        } else {
            labCustomerName.text = [NSString stringWithFormat:@"第%@周", self.items[indexPath.row]];
        }
    }

    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row < self.items.count) {
        [self toggleCustomersSelection:nil];
        NSNumber *week = self.items[row];
        if ([week integerValue] == [Utils currentWeekNum]) {
            self.labTitleOnPopupView.text = [NSString stringWithFormat:@"第%@周(本周)", week];
            self.labTitleOnTitleView.text = [NSString stringWithFormat:@"第%@周(本周)", week];
        } else {
            self.labTitleOnPopupView.text = [NSString stringWithFormat:@"第%@周", week];
            self.labTitleOnTitleView.text = [NSString stringWithFormat:@"第%@周", week];
        }
        [self layoutTitleView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
            [self.delegate didSelectedItem:self.items[row]];
        }
    }
}

@end
