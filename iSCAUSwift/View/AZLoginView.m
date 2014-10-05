//
//  AZLoginView.m
//  Q.fm
//
//  Created by Alvin on 7/6/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "AZLoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "AZTools"
#import <pop/POP.h>

#define kTitleOffsetY 15.0
#define kCommonMarginX 10.0
#define kCommonPadding 20.0

#define kErrorStateWaitDuration 1.5

#define kLoginViewWidth (SCREEN_WIDTH - 20.0 * 2)

@interface AZLoginView ()

@property (nonatomic, strong) UITextField *txtUsername;
@property (nonatomic, strong) UITextField *txtPasswd;
@property (nonatomic, strong) UIButton *btnCancle;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIControl *background;
@property (nonatomic, strong) UIView    *backgroundTxtUsername;
@property (nonatomic, strong) UIView    *backgroundTxtPasswd;
@property (nonatomic, strong) UIImageView *horizontalBorder;
@property (nonatomic, strong) UIImageView *verticalBorder;
@property (nonatomic, strong) UILabel     *labNotice;
@property (nonatomic, strong) UILabel     *labAccountUsageNotice;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation AZLoginView

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect afterFrame = CGRectMake((SCREEN_WIDTH - kLoginViewWidth) * 0.5, (SCREEN_HEIGHT - self.btnLogin.bottom - keyboardRect.size.height) * 0.5, kLoginViewWidth, self.btnLogin.bottom);
    [UIView animateWithDuration:animationDuration
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                            self.transform = CGAffineTransformMakeRotation(0);
                            self.frame = afterFrame;
                            self.background.alpha = 0.8;
                        }];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    
    CGRect afterFrame = CGRectMake((SCREEN_WIDTH - kLoginViewWidth) * 0.5, (SCREEN_HEIGHT - self.btnLogin.bottom - keyboardRect.size.height) * 0.5, kLoginViewWidth, self.btnLogin.bottom);
    [UIView animateWithDuration:0.27
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.frame = afterFrame;
                         self.background.alpha = 0.8;
                     }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.cornerRadius = 5.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 5.0;
    self.backgroundColor = [UIColor colorWithR:236 g:240 b:241 a:1];
    
    CGFloat btnCloseWidth = 30.0;
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClose.frame = (CGRect){
        -btnCloseWidth / 2,
        -btnCloseWidth / 2,
        btnCloseWidth,
        btnCloseWidth
    };
    [self.btnClose setImage:[UIImage imageNamed:@"shop-popup-close"] forState:UIControlStateNormal];
    [self.btnClose setImage:[UIImage imageNamed:@"shop-popup-close-highlighted"] forState:UIControlStateHighlighted];
    [self.btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnClose];
    
    // Account notice
    if (![[AZPreference valueForKey:kHadShownAccountUsageNotice] isEqualToString:@"1"]) {
        self.labAccountUsageNotice = [[UILabel alloc] initWithFrame:(CGRect){
            kCommonMarginX,
            kCommonMarginX,
            CGSizeZero
        }];
        self.labAccountUsageNotice.text = @"Q.fm 绝不会将你的 LoveQ 账号信息用于其它用途";
        self.labAccountUsageNotice.font = [UIFont systemFontOfSize:11];
        self.labAccountUsageNotice.textColor = APP_DELEGATE.tintColor;
        self.labAccountUsageNotice.alpha = 0.6;
        [self.labAccountUsageNotice sizeToFit];
        self.labAccountUsageNotice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labAccountUsageNotice];
    }
    
    CGFloat backgroundCornerRadius = 3.0;
    self.backgroundTxtUsername = [[UIView alloc] initWithFrame:(CGRect){
        kCommonMarginX,
        kCommonMarginX + self.labAccountUsageNotice.bottom,
        kLoginViewWidth - kCommonMarginX * 2,
        40,
    }];
    self.backgroundTxtUsername.layer.cornerRadius = backgroundCornerRadius;
    self.backgroundTxtUsername.backgroundColor = [UIColor seperatorColor];
    [self addSubview:self.backgroundTxtUsername];
    
    self.txtUsername = [[UITextField alloc] initWithFrame:(CGRect) {
        self.backgroundTxtUsername.left + kCommonMarginX,
        self.backgroundTxtUsername.top + kCommonMarginX,
        self.backgroundTxtUsername.width - kCommonMarginX * 2,
        self.backgroundTxtUsername.height - kCommonMarginX * 2
    }];
    self.txtUsername.backgroundColor = [UIColor clearColor];
    self.txtUsername.placeholder = @"LoveQ 账号";
    self.txtUsername.text = [AZPreference username];
    [self addSubview:self.txtUsername];
    
    self.backgroundTxtPasswd = [[UIView alloc] initWithFrame:(CGRect){
        kCommonMarginX,
        self.backgroundTxtUsername.bottom + kCommonMarginX,
        kLoginViewWidth - kCommonMarginX * 2,
        40,
    }];
    self.backgroundTxtPasswd.layer.cornerRadius = backgroundCornerRadius;
    self.backgroundTxtPasswd.backgroundColor = [UIColor seperatorColor];
    [self addSubview:self.backgroundTxtPasswd];
    
    self.txtPasswd = [[UITextField alloc] initWithFrame:(CGRect) {
        self.backgroundTxtPasswd.left + kCommonMarginX,
        self.backgroundTxtPasswd.top + kCommonMarginX,
        self.backgroundTxtPasswd.width - kCommonMarginX * 2,
        self.backgroundTxtPasswd.height - kCommonMarginX * 2
    }];
    self.txtPasswd.backgroundColor = [UIColor clearColor];
    self.txtPasswd.placeholder = @"LoveQ 密码";
    self.txtPasswd.secureTextEntry = YES;
    [self addSubview:self.txtPasswd];
    
    CGFloat stroke = 1;
    self.horizontalBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep"]];
    self.horizontalBorder.frame = (CGRect){
        0,
        self.backgroundTxtPasswd.bottom + kCommonMarginX,
        kLoginViewWidth,
        stroke
    };
    [self addSubview:self.horizontalBorder];
    
    // Vertical border
    self.verticalBorder = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithR:198 g:202 b:202 a:0.5]]];
    self.verticalBorder.frame = (CGRect) {
        kLoginViewWidth / 2,
        self.backgroundTxtPasswd.bottom + kCommonMarginX,
        stroke,
        44
    };
    [self addSubview:self.verticalBorder];

    // Cancle button
    self.btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancle.frame = (CGRect){
        0,
        self.backgroundTxtPasswd.bottom + kCommonMarginX,
        kLoginViewWidth / 2,
        44
    };
    [self.btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnCancle setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    [self.btnCancle setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateHighlighted];
    [self.btnCancle addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnCancle];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.btnCancle.bounds
                                                   byRoundingCorners:(UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.btnCancle.layer.mask = maskLayer;
    
    // Login button
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLogin.frame = (CGRect){
        kLoginViewWidth / 2,
        self.backgroundTxtPasswd.bottom + kCommonMarginX,
        kLoginViewWidth / 2,
        44
    };
    [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:APP_DELEGATE.tintColor forState:UIControlStateNormal];
    [self.btnLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateHighlighted];
    [self.btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnLogin];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.btnLogin.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.btnLogin.layer.mask = maskLayer;
    
    self.frame = (CGRect) {
        0,
        -self.btnLogin.bottom,
        kLoginViewWidth,
        self.btnLogin.bottom
    };
}

- (void)cancle
{
    [self dismiss];
    [AZHttpClient cancleRequest];
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)close
{
    [self dismiss];
    [AZHttpClient cancleRequest];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)enterLoginState
{
    if (!self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(self.width / 2, self.height / 2);
        debugLog(@"frmae %@", NSStringFromCGRect(self.indicatorView.frame));
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
    } else {
        self.indicatorView.hidden = NO;
    }
    for (UIView *subview in self.subviews) {
        if ([subview isEqual:self.indicatorView] ||
            [subview isEqual:self.btnClose] ||
            [subview isEqual:self.labNotice]) {
            continue;
        } else {
            subview.hidden = YES;
        }
    }
    
    [self.txtUsername resignFirstResponder];
    [self.txtPasswd resignFirstResponder];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.center = [self rootViewController].view.center;
                     }];
}

- (void)enterNormalState
{
    for (UIView *subview in self.subviews) {
        if ([subview isEqual:self.indicatorView] ||
            [subview isEqual:self.labNotice]) {
            subview.hidden = YES;
        } else {
            subview.hidden = NO;
        }
    }
    
    [self.txtUsername becomeFirstResponder];
    
    UIViewController *topVC = [self rootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kLoginViewWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - self.btnLogin.bottom - 216) * 0.5, kLoginViewWidth, self.btnLogin.bottom);
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.center = [self rootViewController].view.center;
                         self.frame = afterFrame;
                     }];
}

- (void)login
{
    [self enterLoginState];
    if (self.txtPasswd.text.length == 0 || self.txtUsername.text.length == 0) {
        if (!self.labNotice) {
            self.labNotice = [[UILabel alloc] init];
            self.labNotice.textColor = [UIColor darkGrayColor];
            self.labNotice.font = [UIFont systemFontOfSize:15];
            [self addSubview:self.labNotice];
        } else {
            self.labNotice.hidden = NO;
        }
        NSString *msg = @"请填入账户名和密码";
        self.labNotice.text = msg;
        [self.labNotice sizeToFit];
        self.indicatorView.hidden = YES;
        self.labNotice.center = CGPointMake(self.width / 2, self.height / 2);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorStateWaitDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self enterNormalState];
        });
        
        return;
    }
    
    [AZHttpClient loginWithUsername:self.txtUsername.text
                           password:self.txtPasswd.text
                            success:^(NSData *data, int httpCode){
                                debugLog(@"dict %@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                
                                if (dict[@"error"] && [dict[@"error"] integerValue] == 0) {
                                    [AZPreference setPreferenceForKey:kHadShownAccountUsageNotice value:@"1"];
                                    APP_DELEGATE.loveQHadLogin = YES;
                                    [AZPreference setUsername:self.txtUsername.text];
                                    [AZPreference setPassword:self.txtPasswd.text];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:LOVEQ_DID_LOGIN object:nil];
                                    [self dismiss];
                                    if (self.loginBlock) {
                                        self.loginBlock();
                                    }
                                } else {
                                    if (!self.labNotice) {
                                        self.labNotice = [[UILabel alloc] init];
                                        self.labNotice.textColor = [UIColor darkGrayColor];
                                        self.labNotice.font = [UIFont systemFontOfSize:15];
                                        [self addSubview:self.labNotice];
                                    } else {
                                        self.labNotice.hidden = NO;
                                    }
                                    NSString *msg = @"登录错误，请重试";
                                    if (dict[@"message"] && [dict[@"message"] length] > 0) {
                                        msg = dict[@"message"];
                                    }
                                    self.labNotice.text = msg;
                                    [self.labNotice sizeToFit];
                                    self.indicatorView.hidden = YES;
                                    self.labNotice.center = CGPointMake(self.width / 2, self.height / 2);
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorStateWaitDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self enterNormalState];
                                    });
                                    
                                    APP_DELEGATE.loveQHadLogin = NO;
                                    debugLog(@"failed");
                                }
                            }
                            failure:^(NSData *data, int httpCode){
                                APP_DELEGATE.loveQHadLogin = NO;
                                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                
                                debugLog(@"f %@ %d", string, httpCode);
                                if (!self.labNotice) {
                                    self.labNotice = [[UILabel alloc] init];
                                    self.labNotice.textColor = [UIColor darkGrayColor];
                                    self.labNotice.font = [UIFont systemFontOfSize:15];
                                    [self addSubview:self.labNotice];
                                } else {
                                    self.labNotice.hidden = NO;
                                }
                                NSString *msg = @"登录错误，请重试";
                                self.labNotice.text = msg;
                                [self.labNotice sizeToFit];
                                self.indicatorView.hidden = YES;
                                self.labNotice.center = CGPointMake(self.width / 2, self.height / 2);
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorStateWaitDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self enterNormalState];
                                });
                                
                                APP_DELEGATE.loveQHadLogin = NO;
                            }];
}

- (void)show
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    UIViewController *topVC = [self rootViewController];
    
    if (!self.background) {
        self.background = [[UIControl alloc] initWithFrame:topVC.view.bounds];
        self.background.backgroundColor = [UIColor blackColor];
        self.background.alpha = 0;
        self.background.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.background addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    [topVC.view addSubview:self.background];
    
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    [self.txtUsername becomeFirstResponder];
    
    [topVC.view addSubview:self];
}

- (void)dismiss
{
    [self.txtUsername resignFirstResponder];
    [self.txtPasswd resignFirstResponder];
    
    CGRect afterFrame = CGRectMake((SCREEN_WIDTH - self.width) * 0.5, SCREEN_HEIGHT, self.width, self.height);
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.frame = afterFrame;
                         self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
                         self.background.alpha = 0;
                     } completion:^(BOOL finished) {
                         [super removeFromSuperview];
                         [self.background removeFromSuperview];
                         self.background = nil;
                     }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIViewController *)rootViewController
{
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


@end
