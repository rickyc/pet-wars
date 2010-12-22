//
//  genderScreenViewController.h
//  firstScreens
//
//  Created by Andrew Saladino on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteColorViewController.h"

@interface GenderViewController : UIViewController {
	
	FavoriteColorViewController *favoriteColorViewController;
	
	IBOutlet UIButton *female;
	IBOutlet UIButton *male;
	
	NSString *genderChosen;
	NSMutableDictionary *data;
	
}

@property (nonatomic, retain) FavoriteColorViewController *favoriteColorViewController; // to next view
@property (nonatomic, retain) UIButton *female; // allows me to swap the picture of the female by having an object
@property (nonatomic, retain) UIButton *male; // allows me to swap the picture of the male by having an object
@property (nonatomic, retain) NSString *genderChosen; // String that holds male/female
@property(nonatomic,retain) NSMutableDictionary *data; // Object that is passed through the views

- (IBAction)nextPressed:(id)sender;

- (IBAction)backPressed:(id)sender;

- (IBAction)femalePressed:(id)sender; // clicked the female button

- (IBAction)malePressed:(id)sender; // clicked the male button


@end
