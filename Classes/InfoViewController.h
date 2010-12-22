//
//  InfoViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
	IBOutlet UIButton *backButton;
}

@property(nonatomic, retain) UIButton *backButton;

-(IBAction)exitInfoView:(id)sender;

@end
