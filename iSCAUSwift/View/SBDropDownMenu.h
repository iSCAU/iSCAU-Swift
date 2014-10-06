//
//  SBDropDownMenu.h
//  SocialBase
//
//  Created by Alvin on 6/8/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SBDropDownMenuDelegate <NSObject>
- (void)didSelectedItem:(id)item;
@end

@interface SBDropDownMenu : UIView

@property (nonatomic) BOOL isPopUpShown;
@property (nonatomic, weak) id<SBDropDownMenuDelegate> delegate;

- (void)resetTitleView;
- (void)resetDatasource:(NSArray *)data;
- (IBAction)toggleCustomersSelection:(id)sender;
- (void)setTitleWithWeek:(NSInteger)week;

@end
