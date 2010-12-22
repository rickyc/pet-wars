//
//  FavoriteColorViewController.h
//  firstScreens
//
//  Created by Andrew Saladino on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhichDoYouPreferViewController.h"


@interface FavoriteColorViewController : UIViewController {
	WhichDoYouPreferViewController *whichDoYouPreferViewController;
	
	IBOutlet UIButton *orangeBox;
	IBOutlet UIButton *blackBox;
	IBOutlet UIButton *yellowBox;
	IBOutlet UIButton *blueBox;
	IBOutlet UIButton *redBox;
	IBOutlet UIButton *greenBox;
	IBOutlet UIButton *magentaBox;
	IBOutlet UIButton *purpleBox;
	
	NSString *colorChosen;
	NSMutableDictionary *data;


}

- (void) resetColorSelected; // resets all colors (used for mouseDOWN of a color)

- (IBAction)nextPressed:(id)sender;

- (IBAction)backPressed:(id)sender;

- (IBAction)colorPressed:(id)sender;

@property (nonatomic, retain) WhichDoYouPreferViewController *whichDoYouPreferViewController;

@property (nonatomic, retain) UIButton *orangeBox;
@property (nonatomic, retain) UIButton *blackBox;
@property (nonatomic, retain) UIButton *yellowBox;
@property (nonatomic, retain) UIButton *blueBox;
@property (nonatomic, retain) UIButton *redBox;
@property (nonatomic, retain) UIButton *greenBox;
@property (nonatomic, retain) UIButton *magentaBox;
@property (nonatomic, retain) UIButton *purpleBox;

@property (nonatomic, retain) NSString *colorChosen;
@property (nonatomic, retain) NSMutableDictionary *data;

@end
