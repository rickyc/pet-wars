//
//  SettingsViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
	IBOutlet UIButton *backButton;
}

@property(nonatomic, retain) UIButton *backButton;

- (IBAction)exitSettings:(id)sender;

@end
