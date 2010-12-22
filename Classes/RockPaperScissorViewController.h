//
//  RockPaperScissorViewController.h
//  RockPaperScissor
//
//  Created by Andrew Saladino on 5/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"

@interface RockPaperScissorViewController : UIViewController 
{
	IBOutlet UIImageView *playerSign; // Picture of Player's Sign
	IBOutlet UIImageView *computerSign; // Picture of Computer's Sign
	
	IBOutlet UILabel *winOrLose; // Win, Lose, or Tie text
	
	NSString *playerInput; // The Player's input as a string
	NSString *computerInput; // The Computer's random input as a string
	
	NSString *theWinner; // Computer or Player depending on who won 4 games first
	
	int playerScoreInt; // Player score as an int
	int computerScoreInt; // Computer score as an int
	
	UIView *playerScoreView; // pointer to player score
	UIView *computerScoreView; // pointer to computer score
	UIView *winOrLoseView; // pointer to win or lose
	
	BOOL gameFinished;
	
	Manto *pet;
}

@property (nonatomic, retain) UIImageView *playerSign;
@property (nonatomic, retain) UIImageView *computerSign; 

@property (nonatomic, retain) UILabel *winOrLose;

@property (nonatomic, retain) NSString *playerInput;
@property (nonatomic, retain) NSString *computerInput;

@property (nonatomic, retain) NSString *theWinner;

@property (nonatomic, retain) UIView *playerScoreView;
@property (nonatomic, retain) UIView *computerScoreView;
@property (nonatomic, retain) UIView *winOrLoseView;
@property (nonatomic, retain) Manto *pet;

- (IBAction) signChosen:(id)sender;

- (IBAction) backPressed:(id)sender;

- (IBAction) shootPressed:(id)sender;

- (void) randomComputerSign;

- (void) checkWhoWon;

- (void) isGameOver;

@end

