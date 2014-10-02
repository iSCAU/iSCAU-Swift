//
//  LibSearchBooksDetailViewController.m
//  iSCAU
//
//  Created by Alvin on 2/17/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "LibSearchBooksDetailViewController.h"
#import "LibSearchBooksDetailCell.h"
#import "Constant.h"
#import "AZTools.h"
#import "iSCAUSwift-Swift.h"
#import <CoreText/CoreText.h>

#define CELL_HEIGHT 105

@interface LibSearchBooksDetailViewController ()

@end

@implementation LibSearchBooksDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SET_DEFAULT_BACKGROUND_COLOR(self.tableView);

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize titleLabelMaxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:13] };
    CGFloat height = [self.bookName boundingRectWithSize:titleLabelMaxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil].size.height;
    return height + 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat fontSize = 13;

    CGSize titleLabelMaxSize = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:13] };
    CGFloat labHeight = [self.bookName boundingRectWithSize:titleLabelMaxSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil].size.height + 3;

    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, labHeight)];
    headerSectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    UILabel *labAverageCredits = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 290, labHeight)];
    labAverageCredits.backgroundColor = [UIColor clearColor];
    labAverageCredits.font = [UIFont systemFontOfSize:fontSize];
    labAverageCredits.text = self.bookName;
    labAverageCredits.numberOfLines = 0;
    labAverageCredits.lineBreakMode = NSLineBreakByWordWrapping;
    labAverageCredits.textColor = APP_DELEGATE.tintColor;
    [headerSectionView addSubview:labAverageCredits];
    
    return headerSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LibSearchBooksDetailCellIndentifier = @"LibSearchBooksDetailCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LibSearchBooksDetailCellIndentifier];
    if (cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"LibSearchBooksDetailCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (![self.detailInfos[indexPath.row] isKindOfClass:[NSNull class]]) {
        [(LibSearchBooksDetailCell *)cell configurateInfo:self.detailInfos[indexPath.row]];
    }
    
    return cell;
}

@end
