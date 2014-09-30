//
//  UIColor+Addition.h
//  LifeTime
//
//  Created by Alvin on 13-8-28.
//  Copyright (c) 2013年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BlackColor [UIColor blackColor]
#define DarkGrayColor [UIColor darkGrayColor]
#define LightGrayColor [UIColor lightGrayColor]
#define WhiteColor [UIColor whiteColor]
#define GrayColor [UIColor grayColor]
#define RedColor [UIColor redColor]
#define GreenColor [UIColor greenColor]
#define BlueColor [UIColor blueColor]
#define CyanColor [UIColor cyanColor]
#define YellowColor [UIColor yellowColor]
#define MagentaColor [UIColor magentaColor]
#define OrangeColor [UIColor orangeColor]
#define PurpleColor [UIColor purpleColor]
#define BrownColor [UIColor brownColor]
#define ClearColor [UIColor clearColor]

@interface UIColor (Addition)

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
+ (UIColor *)colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha;

@end
