//
//  JPTabViewController.m
//  JPTabViewController
//
//  Created by Jean-Philippe DESCAMPS on 19/03/2014.
//  Copyright (c) 2014 Jean-Philippe. All rights reserved.
//

#import "JPTabViewController.h"

@interface JPTabViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;


@property (nonatomic, strong) NSMutableArray *tabs;

@property (nonatomic) float statusHeight;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation JPTabViewController

- (id)initWithControllers:(NSArray *)controllers
{
    if(self = [self init])
    {
        _controllers = controllers;
        selectedTab = NSIntegerMax;
        _delegate = nil;
        _indicatorView = [[UIView alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _controllers = nil;
    selectedTab = NSIntegerMax;
    _delegate = nil;
    _indicatorView = [[UIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setup
{
    //此处可以设置状态栏
    UIColor *blackGreenColor = [UIColor colorWithRed:55/255.0 green:147/255.0 blue:129/255.0 alpha:1];
    [super viewDidLoad];
    UIColor *darkGreenColor = [UIColor colorWithRed:31/255.0 green:193/255.0 blue:168/255.0 alpha:1];
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _indicatorView.backgroundColor= darkGreenColor;
    _statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    UIImageView *top = [[UIImageView alloc]init];
    top.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    top.backgroundColor = blackGreenColor;
    [self.view addSubview:top];
    
    
    UIImageView *mid = [[UIImageView alloc]init];
    mid.frame = CGRectMake(0, 20, self.view.bounds.size.width, 50);
    mid.backgroundColor = darkGreenColor;
    
    UIImageView *topimage =[[UIImageView alloc]init];
    topimage.frame = CGRectMake(self.view.bounds.size.width/9,15, 10, 10);
    [topimage setImage:[UIImage imageNamed:@"top.png"]];
    [mid addSubview:topimage];
    
    UILabel *lable =[[UILabel alloc]init];
    lable.frame = CGRectMake(self.view.bounds.size.width/6-5, 15, 80, 10);
    lable.textColor = [UIColor whiteColor];
    lable.text = @"校园活动";
    [mid addSubview:lable];
    
    [self.view addSubview:mid];
    
    if (_controllers != nil)
    {
        [self loadUI];
    }
}

-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _menuHeight + _statusHeight,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height-_menuHeight);
    
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
    }

    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_controllers count], self.view.frame.size.height - _menuHeight - _statusHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadUI
{
    _menuHeight = 40.0;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight + _statusHeight,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - _menuHeight -_statusHeight)];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    
    float tabWidth = self.view.frame.size.width / [_controllers count]+1;
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];

        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
        [_contentScrollView addSubview:[controller view]];
        
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, _statusHeight+43
                                                                   , tabWidth, _menuHeight)];
        [tab setTitle:controller.title forState:UIControlStateNormal];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tab];
        [_tabs addObject:tab];

        // Add separator
       
    }
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;
    _indicatorView.frame = CGRectMake(0.0, _menuHeight + _statusHeight +35.0, tabWidth, 3.0);
    [self.view addSubview:_indicatorView];
    
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight + _statusHeight +37.0, self.view.frame.size.width, 1.0)];
    bottomHeaderView.backgroundColor = _indicatorView.backgroundColor;
    [self.view addSubview:bottomHeaderView];
    
    [self.view addSubview:_contentScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    float tabWidth = _indicatorView.frame.size.width;
    _indicatorView.frame = CGRectMake(page * tabWidth, _menuHeight + _statusHeight +35.0, tabWidth, 3.0);
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
}

- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    
    if(_delegate && [_delegate respondsToSelector:@selector(currentTabHasChanged:)] )
    {
        [_delegate currentTabHasChanged:selectedTab];
    }
}

- (void)deselectAllTabs
{
    for (UIButton *tab in _tabs)
    {
        [tab setSelected:NO];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)selectTabNum:(NSInteger)index
{
    if(index<0 || index>=[_tabs count])
    {
        return;
    }
    UIButton *tab = [_tabs objectAtIndex:index];
    [self selectTab:tab];
}

- (NSInteger)selectedTab
{
    return selectedTab;
}

@end
