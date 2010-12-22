//
//  SplashViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleScreenViewController.h"

@interface SplashViewController : UIViewController {
	NSTimer *timer;
	UIImageView *splashImageView;
	
	TitleScreenViewController *titleScreenViewController;
}

@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) UIImageView *splashImageView;
@property(nonatomic,retain) TitleScreenViewController *titleScreenViewController;

@end
