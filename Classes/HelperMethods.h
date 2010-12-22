//
//  HelperMethods.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CompleteInHimFont.h"

@interface HelperMethods : NSObject {

}

+ (UIImageView*)createImageWithX:(int)x andY:(int)y andImage:(NSString*)nImage;
+ (UIButton*)createButtonWithX:(int)x andY:(int)y andUpImage:(NSString*)upImage andDownImage:(NSString*)downImage andTarget:(id)target andSelector:(SEL)selector;
+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text;
+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text andTextSize:(float)tSize;
+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text andSize:(float)tSize andFontColor:(UIColor*)fColor;
+ (BOOL)isNetworkAvailable;
+ (void)playSound:(NSString*)musicName;
+ (NSString*)getDatabasePath;
+ (void)alertWithTitle:(NSString*)title andMessage:(NSString*)msg andTarget:(UIViewController*)vc;

@end
