//
//  WhichDoYouPreferViewController.h
//  firstScreens
//
//  Created by Andrew Saladino on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CleanlinessViewController.h" // to go forward


@interface WhichDoYouPreferViewController : UIViewController 
{
	IBOutlet UIImageView *choiceSelectedA; // to circle choice A
	IBOutlet UIImageView *choiceSelectedB; // to circle choice B
	IBOutlet UIImageView *choiceSelectedC; // to circle choice C
	
	NSString *preferChosen; // the answer the person entered to the question
	NSMutableDictionary *data; // data that is passed through views

	CleanlinessViewController *cleanlinessViewController; // to go to the next view controller
	

}

@property (nonatomic, retain) UIImageView *choiceSelectedA; // outlet so i can make the selection hidden
@property (nonatomic, retain) UIImageView *choiceSelectedB; // outlet so i can make the selection hidden
@property (nonatomic, retain) UIImageView *choiceSelectedC; // outlet so i can make the selection hidden

@property (nonatomic, retain) NSString *preferChosen; // the answer to the question the user put in
@property (nonatomic, retain) NSMutableDictionary *data;

@property (nonatomic, retain) CleanlinessViewController *cleanlinessViewController; // my forward view controller


- (IBAction)choicePressed:(id)sender; // person selected an answer

- (IBAction)nextPressed:(id)sender; // person wants to go to the next screen

- (IBAction)backPressed:(id)sender; // person wants to go to the last screen

- (void) makeChoicesSelectedHidden; // helps me manage if things are seen or not

@end
