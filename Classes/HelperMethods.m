//
//  HelperMethods.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+ (UIImageView*)createImageWithX:(int)x andY:(int)y andImage:(NSString*)nImage {
	UIImage *img = [UIImage imageNamed:nImage];
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(x, y, img.size.width, img.size.height)] autorelease];
 	imageView.image = img;
	return imageView;
}

+ (UIButton*)createButtonWithX:(int)x andY:(int)y andUpImage:(NSString*)upImage andDownImage:(NSString*)downImage andTarget:(id)target andSelector:(SEL)selector {
	UIImage *upImg = [UIImage imageNamed:upImage];
	UIButton *btn = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(x, y, upImg.size.width, upImg.size.height)];
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[btn setBackgroundImage:upImg forState:UIControlStateNormal];
	[btn setBackgroundImage:[UIImage imageNamed:downImage] forState:UIControlStateHighlighted];
	return btn;
}

+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text {
	CompleteInHimFont *label = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(x, y, w, h)] autorelease];
	[label createLabel:text];
	return label;
}

+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text andTextSize:(float)tSize {
	CompleteInHimFont *label = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(x, y, w, h)] autorelease];
	[label createLabel:text withTextSize:tSize];
	return label;
}

+ (CompleteInHimFont*)createLabelWithX:(int)x andY:(int)y andWidth:(int)w andHeight:(int)h andText:(NSString*)text andSize:(float)tSize andFontColor:(UIColor*)fColor{
	CompleteInHimFont *label = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(x, y, w, h)] autorelease];
	[label initTextWithSize:tSize color:fColor bgColor:[UIColor clearColor]];
	[label updateText:text];
	return label;
}

+ (BOOL)isNetworkAvailable {
	NSString *theURL = [NSString stringWithFormat:@"http://www.google.com/"];
	theURL = [theURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
	NSURLResponse *resp = nil;
	NSError *err = nil;
	NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
	// no errors means network available
	return (err == nil);
}

+ (void)playSound:(NSString*)musicName {
	NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:@"wav"];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
	AudioServicesPlaySystemSound(soundID);	
}

+ (NSString*)getDatabasePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
	return path;
}

+ (void)alertWithTitle:(NSString*)title andMessage:(NSString*)msg andTarget:(UIViewController*)vc {
	PWAlert *alert = [PWAlert new];
	[alert setTitle:title andMessage:msg];
	[vc.view addSubview:alert.view];
}

@end
