//
//  EduSysWeekClassTableView.h
//  iSCAU
//
//  Created by Alvin on 13-10-6.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduSysWeekClassTableView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *headerWeekDay;
@property (nonatomic, strong) UIScrollView *headerClassTime;
@property (nonatomic, strong) UIScrollView *classTable;

@property (nonatomic, strong) NSArray *weekdayArray;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, strong) NSMutableArray    *classesArray;

- (id)initWithFrame:(CGRect)frame classes:(NSArray *)classes;
- (void)updateViewWithWeek:(NSInteger)theWeek;
- (void)updateClasses:(NSArray *)classes;

@end
