//
//  AZLoginView.h
//  Q.fm
//
//  Created by Alvin on 7/6/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZLoginView : UIView

@property (nonatomic, copy) dispatch_block_t loginBlock;
@property (nonatomic, copy) dispatch_block_t cancleBlock;
@property (nonatomic, copy) dispatch_block_t closeBlock;

- (void)show;
- (void)dismiss;

@end
