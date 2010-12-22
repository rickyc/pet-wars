//
//  TicTacToe.h
//  TicTacToe
//
//  Created by Andrew Saladino on 5/1/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"

@interface TicTacToeViewController : UIViewController  {
	IBOutlet UIButton *topLeft;
	IBOutlet UIButton *topMiddle;
	IBOutlet UIButton *topRight;
	IBOutlet UIButton *midLeft;
	IBOutlet UIButton *midMiddle;
	IBOutlet UIButton *midRight;
	IBOutlet UIButton *botLeft;
	IBOutlet UIButton *botMiddle;
	IBOutlet UIButton *botRight;
	IBOutlet UIButton *andrewFailsToMakeABackBTN;
	
	NSMutableArray *usedSpots;
	NSMutableArray *playersMoves;
	NSMutableArray *computersMoves;
	
	IBOutlet UILabel *theTurn;
	IBOutlet UILabel *gameResult;
	IBOutlet UIImageView *manto;
	
	int turn;
	BOOL isGameOver;
	
	Manto *pet;
}

- (IBAction) spaceChosen:(id)sender;

- (IBAction) backPressed:(id) sender;

- (BOOL) isEmptySpace:(int)space;

- (BOOL) checkPlayerWin;

- (BOOL) checkComputerWin;

- (void) computerMove;

- (void) gameOver;

- (int) getComputersNextMove;

- (int) getRandomMove;

@property (nonatomic, retain) UIButton *topLeft;
@property (nonatomic, retain) UIButton *topMiddle;
@property (nonatomic, retain) UIButton *topRight;
@property (nonatomic, retain) UIButton *midLeft;
@property (nonatomic, retain) UIButton *midMiddle;
@property (nonatomic, retain) UIButton *midRight;
@property (nonatomic, retain) UIButton *botLeft;
@property (nonatomic, retain) UIButton *botMiddle;
@property (nonatomic, retain) UIButton *botRight;
@property (nonatomic, retain) UIButton *andrewFailsToMakeABackBTN;

@property (nonatomic, retain) NSMutableArray *usedSpots;
@property (nonatomic, retain) NSMutableArray *playersMoves;
@property (nonatomic, retain) NSMutableArray *computersMoves;

@property (nonatomic, retain) UILabel *theTurn;
@property (nonatomic, retain) UILabel *gameResult;
@property (nonatomic, retain) UIImageView *manto;

@property (nonatomic, retain) Manto *pet;

@end

