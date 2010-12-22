//
//  CleanlinessViewController.h
//  firstScreens
//
//  Created by Andrew Saladino on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CleanlinessViewController : UIViewController 
{	
	IBOutlet UIImageView *choiceSelectedA; // to circle choice A
	IBOutlet UIImageView *choiceSelectedB; // to circle choice B
	IBOutlet UIImageView *choiceSelectedC; // to circle choice C
	
	NSString *cleanlinessChosen; // the answer the person entered to the question
	NSMutableDictionary *data;
}

@property (nonatomic, retain) UIImageView *choiceSelectedA; // outlet so i can make the selection hidden
@property (nonatomic, retain) UIImageView *choiceSelectedB; // outlet so i can make the selection hidden
@property (nonatomic, retain) UIImageView *choiceSelectedC; // outlet so i can make the selection hidden

@property (nonatomic, retain) NSString *cleanlinessChosen; // the answer to the question the user put in
@property (nonatomic, retain) NSMutableDictionary *data;

- (IBAction)choicePressed:(id)sender; // person selected an answer

- (IBAction)nextPressed:(id)sender; // person wants to go to the next screen

- (IBAction)backPressed:(id)sender; // person wants to go to the last screen

- (void) makeChoicesSelectedHidden; // helps me manage if things are seen or not

@end
