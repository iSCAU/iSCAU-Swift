//
//  EduSysWeekClassTableView.m
//  iSCAU
//
//  Created by Alvin on 13-10-6.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import "EduSysWeekClassTableView.h"
#import "AZTools.h"
#import "iSCAUSwift-Swift.h"

CGFloat HORIZONTAL_HEADER_ITEM_HEIGHT = 20.0f;
CGFloat HORIZONTAL_HEADER_ITEM_WIDTH = 60.0f;

CGFloat VERTICAL_HEADER_ITEM_HEIGHT = 60.0f;
CGFloat VERTICAL_HEADER_ITEM_WIDTH = 20.0f;

NSInteger kClassLabelBaseTag = 1000;

NSInteger kClassesPerDay = 13;

@implementation EduSysWeekClassTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.weekdayArray = @[@"Mon", @"Tus", @"Wed", @"Thus", @"Fri", @"Sat", @"Sun",];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame classes:(NSArray *)classes {
    self = [super initWithFrame:frame];
    if (self) {
        self.classesArray = [NSMutableArray array];
        [classes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                Lession *lession = [Lession converFromDict:obj];
                [self.classesArray addObject:lession];
            }
        }];
        self.weekdayArray = @[@"Mon", @"Tus", @"Wed", @"Thus", @"Fri", @"Sat", @"Sun",];
        self.backgroundColors = @[
                                  [UIColor colorWithR:250 g:120 b:134 a:1],
                                  [UIColor colorWithR:152 g:169 b:245 a:1],
                                  [UIColor colorWithR:175 g:146 b:215 a:1],
                                  [UIColor colorWithR:255 g:213 b:65 a:1],
                                  [UIColor colorWithR:168 g:210 b:65 a:1],
                                  ];
        [self setup];
    }
    return self;
}

- (void)setup
{
    // TODO: autolayout
    self.height = SCREEN_HEIGHT - 64.0 - 49.0;
    self.classTable.height = self.height;
    
    // 星期
    self.headerWeekDay = [[UIScrollView alloc] initWithFrame:CGRectMake(VERTICAL_HEADER_ITEM_WIDTH, 0, self.width - VERTICAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.headerWeekDay.contentSize = CGSizeMake(self.weekdayArray.count * HORIZONTAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT);
    self.headerWeekDay.delegate = self;
    self.headerWeekDay.bounces = NO;
    self.headerWeekDay.showsHorizontalScrollIndicator = NO;
    self.headerWeekDay.showsVerticalScrollIndicator = NO;
    self.headerWeekDay.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self addSubview:self.headerWeekDay];
    
    for (NSInteger i = 0; i < self.weekdayArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * HORIZONTAL_HEADER_ITEM_WIDTH, 0, HORIZONTAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT)];
        label.text = self.weekdayArray[i];
        label.font = Font(14);
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = LightGrayColor;
        [self.headerWeekDay addSubview:label];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 0.0f, 1.0f, label.height);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:0.3].CGColor;
        [label.layer addSublayer:bottomBorder];
    }
    
    // 课时
    self.headerClassTime = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HORIZONTAL_HEADER_ITEM_HEIGHT, VERTICAL_HEADER_ITEM_WIDTH, self.height - HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.headerClassTime.contentSize = CGSizeMake(VERTICAL_HEADER_ITEM_WIDTH, kClassesPerDay * VERTICAL_HEADER_ITEM_HEIGHT);
    self.headerClassTime.delegate = self;
    self.headerClassTime.bounces = NO;
    self.headerClassTime.showsHorizontalScrollIndicator = NO;
    self.headerClassTime.showsVerticalScrollIndicator = NO;
    [self addSubview:self.headerClassTime];
    
    for (NSInteger i = 1; i <= kClassesPerDay; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (i - 1) * VERTICAL_HEADER_ITEM_HEIGHT, VERTICAL_HEADER_ITEM_WIDTH, VERTICAL_HEADER_ITEM_HEIGHT)];
        label.text = [NSString stringWithFormat:@""SINT"", i];
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = LightGrayColor;
        label.font = Font(13);
        [self.headerClassTime addSubview:label];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, label.height, label.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:0.3].CGColor;
        [label.layer addSublayer:bottomBorder];
    }
    
    // 课程
    self.classTable = [[UIScrollView alloc] initWithFrame:CGRectMake(VERTICAL_HEADER_ITEM_WIDTH, HORIZONTAL_HEADER_ITEM_HEIGHT, self.width - VERTICAL_HEADER_ITEM_WIDTH, self.height - HORIZONTAL_HEADER_ITEM_HEIGHT)];
    self.classTable.contentSize = CGSizeMake(self.weekdayArray.count * HORIZONTAL_HEADER_ITEM_WIDTH, kClassesPerDay * VERTICAL_HEADER_ITEM_HEIGHT);
    self.classTable.delegate = self;
    self.classTable.bounces = NO;
    self.classTable.directionalLockEnabled = YES;
    self.classTable.showsHorizontalScrollIndicator = NO;
    self.classTable.showsVerticalScrollIndicator = NO;
    [self addSubview:self.classTable];
    
    for (NSInteger i = 1; i < 7; i++) {
        CALayer *verticalBorder = [CALayer layer];
        verticalBorder.frame = CGRectMake(i * HORIZONTAL_HEADER_ITEM_WIDTH, 0.0f, 1, self.classTable.contentSize.height);
        verticalBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                           alpha:0.15].CGColor;
        [self.classTable.layer addSublayer:verticalBorder];
    }
    
    for (NSInteger i = 1; i < kClassesPerDay; i++) {
        CALayer *horizontalBorder = [CALayer layer];
        horizontalBorder.frame = CGRectMake(0, i * VERTICAL_HEADER_ITEM_HEIGHT, self.classTable.contentSize.width, 1);
        horizontalBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                             alpha:0.15].CGColor;
        [self.classTable.layer addSublayer:horizontalBorder];
    }
}

- (void)updateClasses:(NSArray *)classes
{
    [self.classesArray removeAllObjects];
    [classes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            Lession *lession = [Lession converFromDict:obj];
            if (lession) {
                [self.classesArray addObject:lession];
            }
        }
    }];
    [self updateViewWithWeek:[Utils currentWeekNum]];
}

- (void)updateViewWithWeek:(NSInteger)theWeek
{
    [self.classTable.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *lab = obj;
            if (lab.tag >= kClassLabelBaseTag) {
                [lab removeFromSuperview];
            }
        }
    }];
    
    for (NSInteger i = 0; i < self.classesArray.count; i++) {
        Lession *lession = self.classesArray[i];
        NSInteger str = 0;
        NSInteger end = 0;
        NSString *node = lession.node;
        NSArray *temp = [node componentsSeparatedByString:@","];
        if (temp && temp.count > 0) {
            str = [temp[0] integerValue];
        }
        if (temp && temp.count > 0) {
            end = [[temp lastObject] integerValue];
        }
        
        if ([lession.strWeek integerValue] <= theWeek
            && [lession.endWeek integerValue] >= theWeek) {
            CGFloat left = [self classLabelLeftOffsetWithDay:lession.day];
            CGFloat top = (str - 1) * VERTICAL_HEADER_ITEM_HEIGHT;
            CGFloat height = (end - str  + 1) * VERTICAL_HEADER_ITEM_HEIGHT;
            if ((left >= 0 && left <= 6 * HORIZONTAL_HEADER_ITEM_WIDTH) &&
                (top >= 0 && top <= 11 * VERTICAL_HEADER_ITEM_HEIGHT) &&
                height >= 0) {
                UILabel *labClass = [[UILabel alloc] initWithFrame:(CGRect){
                    left,
                    top,
                    HORIZONTAL_HEADER_ITEM_WIDTH,
                    height
                }];
                labClass.textAlignment = NSTextAlignmentCenter;
                labClass.font = Font(14);
                labClass.minimumScaleFactor = 0.2;
                labClass.numberOfLines = 0;
                labClass.backgroundColor = self.backgroundColors[(str + (NSInteger)(left / HORIZONTAL_HEADER_ITEM_WIDTH)) % self.backgroundColors.count];
                labClass.text = [self classInfo:lession];
                labClass.textColor = WhiteColor;
                labClass.adjustsFontSizeToFitWidth = YES;
                labClass.tag = kClassLabelBaseTag + i;
                [self.classTable addSubview:labClass];
            }
        }
    }
}

- (NSString *)classInfo:(Lession *)lession
{
    NSMutableString *info = [NSMutableString string];
    if (lession.classname.length > 0) {
        [info appendString:lession.classname];
    }
    if (lession.location.length > 0) {
        [info appendFormat:@"\n%@", lession.location];
    }
    if (lession.teacher.length > 0) {
        [info appendFormat:@"\n%@", lession.teacher];
    }
    if (lession.dsz.length > 0) {
        [info appendFormat:@"\n%@周", lession.location];
    }
    return [info copy];
}

- (CGFloat)classLabelLeftOffsetWithDay:(NSString *)day
{
    NSArray *days = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    return [days indexOfObject:day] * HORIZONTAL_HEADER_ITEM_WIDTH;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (scrollView == self.headerWeekDay) {
        [self.classTable setContentOffset:CGPointMake(offset.x, self.classTable.contentOffset.y)];
    } else if (scrollView == self.headerClassTime) {
        [self.classTable setContentOffset:CGPointMake(self.classTable.contentOffset.x, offset.y)];
    } else {
        [self.headerWeekDay setContentOffset:CGPointMake(offset.x, 0)];
        [self.headerClassTime setContentOffset:CGPointMake(0, offset.y)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
