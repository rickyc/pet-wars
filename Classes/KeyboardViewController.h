//
//  firstScreensViewController.h
//  firstScreens
//
//  Created by Andrew Saladino on 4/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenderViewController.h"

@interface KeyboardViewController : UIViewController {
	
	NSMutableString *nameString;
	
	UIView *nameStringView; // allows me to point to the name on the screen currently
	
	GenderViewController *genderViewController;

	IBOutlet UIButton *delAndBack; // button for going back or delete depending on situation
	
}

@property (nonatomic, retain) NSMutableString *nameString;
@property (nonatomic, retain) UIView *nameStringView;
@property (nonatomic, retain) GenderViewController *genderViewController;
@property (nonatomic, retain) UIButton *delAndBack;


- (IBAction)letterPressed:(id)sender;

- (IBAction)backspacePressed:(id)sender;

- (IBAction)nextPressed:(id)sender;
@end

