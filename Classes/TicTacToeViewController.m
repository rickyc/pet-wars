//
//  TicTacToe.m
//  TicTacToe
//
//  Created by Andrew Saladino on 5/1/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TicTacToeViewController.h"
#import "CompleteInHimFont.h"

@implementation TicTacToeViewController
@synthesize topLeft, topMiddle, topRight;
@synthesize midLeft, midMiddle, midRight;
@synthesize botLeft, botMiddle, botRight;
@synthesize andrewFailsToMakeABackBTN;

@synthesize computersMoves, playersMoves, usedSpots;

@synthesize theTurn;
@synthesize gameResult;
@synthesize manto;
@synthesize pet;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	turn = 0;
	
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(150, 15, 480, 0)] autorelease];
	[myLabel initTextWithSize:50 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"Tic Tac Toe"];
	[self.view addSubview:myLabel];
	
	// Set the Arrays that will be used for tracking the board to @"0"
	usedSpots = [[NSMutableArray alloc] initWithCapacity:9];
	for (int i = 0; i <= 8; i++)
	{
		[usedSpots insertObject:@"0" atIndex:i];
	}
	
	computersMoves = [[NSMutableArray alloc] initWithCapacity:9];
	for (int i = 0; i <= 8; i++)
	{
		[computersMoves insertObject:@"0" atIndex:i];
	}
	
	playersMoves = [[NSMutableArray alloc] initWithCapacity:9];
	for (int i = 0; i <= 8; i++)
	{
		[playersMoves insertObject:@"0" atIndex:i];
	}
	
	// Random to see who goes first
	srandom(time(NULL));
	int whoGoesFirst = (random() % 2);
	if (whoGoesFirst == 0)
	{
		theTurn.text = @"Computer";
		[self performSelector:@selector(computerMove) withObject:nil afterDelay:2.0];
	}
	else
		if (whoGoesFirst == 1)
		{
			theTurn.text = @"Player";
		}
	// end this random part
	
}

// This method is invoked when the player picks a space
// It first checks if it is the player's turn to prevent cheating
// Then it reads which space was chosen and checks if it was empty
// If it was empty it then marks the space and sets the
// game state arrays as necessary.
- (IBAction)spaceChosen:(id)sender
{
	NSString *whoseTurn = theTurn.text;
	if ([whoseTurn isEqualToString:@"Player"])
	{
		int taggedSpace = [sender tag]; // tag number of the selected color
		if ([self isEmptySpace:taggedSpace]) // Is this a valid move?
		{
			if (taggedSpace == 0)
			{
				[topLeft setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];
			}
			else if (taggedSpace == 1)
			{
				[topMiddle setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];
			}
			else if (taggedSpace == 2)
			{
				[topRight setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];	
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];
			}
			else if (taggedSpace == 3)
			{
				[midLeft setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];
			}
			else if (taggedSpace == 4)
			{
				[midMiddle setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];	
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];	
			}
			else if (taggedSpace == 5)
			{
				[midRight setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];	
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];
			}
			else if (taggedSpace == 6)
			{
				[botLeft setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];	
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];	
			}
			else if (taggedSpace == 7)
			{
				[botMiddle setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];	
			}
			else if (taggedSpace == 8)
			{
				[botRight setImage: [UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:taggedSpace withObject:@"1"];
				[playersMoves replaceObjectAtIndex:taggedSpace withObject:@"1"];	
			}
			if ([self checkPlayerWin])
			{
				[self gameOver];
				isGameOver = YES;
			}
			else
			{
				turn++;
				theTurn.text = @"Computer";
				[self performSelector:@selector(computerMove) withObject:nil afterDelay:2.0];
				srandom(time(NULL));
			}
		}
		else
		{
			NSLog(@"This was not a valid move.");
		}
	}
}

// This method works as follows:
// - Are all spots on the board taken? If yes, game was a draw, call method gameOver
// - No, there is available space for the computer's move, call the getComputersNextMove
// method which based on the state of the board makes a decision where to go
// - Mark the computer's move and set the state arrays as necessary.
// - Did this move create a draw? If not, it is the player's turn.
- (void) computerMove
{
	if (turn == 9)
	{
		gameResult.text = @"Draw.";
		[self gameOver];
		isGameOver = YES;
	}
	else
		if (turn < 9)
		{
			int nextSpace = [self getComputersNextMove];
			if (nextSpace == 0)
			{
				[topLeft setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];
			}
			else if (nextSpace == 1)
			{
				[topMiddle setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];
			}
			else if (nextSpace == 2)
			{
				[topRight setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];	
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];
			}
			else if (nextSpace == 3)
			{
				[midLeft setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];
			}
			else if (nextSpace == 4)
			{
				[midMiddle setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];	
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];	
			}
			else if (nextSpace == 5)
			{
				[midRight setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];	
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];
			}
			else if (nextSpace == 6)
			{
				[botLeft setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];	
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];	
			}
			else if (nextSpace == 7)
			{
				[botMiddle setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];	
			}
			else if (nextSpace == 8)
			{
				[botRight setImage: [UIImage imageNamed:@"O.png"] forState:UIControlStateNormal];		
				[usedSpots replaceObjectAtIndex:nextSpace withObject:@"1"];
				[computersMoves replaceObjectAtIndex:nextSpace withObject:@"1"];	
			}
			if ([self checkComputerWin])
			{
				[self gameOver];
				isGameOver = YES;
			}
			else
				if (turn == 8)
				{
					gameResult.text = @"Draw.";
					[self gameOver];
					isGameOver = YES;
				}
				else
				{
					theTurn.text = @"Player";
					turn++;
				}
		}
}

// Logic for this is as follows:
// - Check to see if computer can win in next turn
// - Check to see if opponent can win in next turn
// - Check for most common tic-tac-toe trap and block it
// - Choose a random space
- (int) getComputersNextMove
{
	// See if the computer can win on the next move
	if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[computersMoves objectAtIndex:2] isEqualToString:@"1"])
		return 0; // _ | O | O Top Row
	else
		if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:1] isEqualToString:@"0"] && [[computersMoves objectAtIndex:2] isEqualToString:@"1"])
			return 1; // O | _ | O Top Row
		else
			if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[usedSpots objectAtIndex:2] isEqualToString:@"0"])
				return 2; // O | O | _ Top Row
			else
				if ([[usedSpots objectAtIndex:3] isEqualToString:@"0"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"])
					return 3; // _ | O | O Middle Row
				else
					if ([[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"])
						return 4; // O | _ | O Middle Row
					else
						if ([[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:5] isEqualToString:@"0"])
							return 5; // O | O | _ Middle Row
						else
							if ([[usedSpots objectAtIndex:6] isEqualToString:@"0"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
								return 6; // _ | O | O Bottom Row
							else
								if ([[computersMoves objectAtIndex:6] isEqualToString:@"1"] && [[usedSpots objectAtIndex:7] isEqualToString:@"0"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
									return 7; // O | _ | O Bottom Row
								else
									if ([[computersMoves objectAtIndex:6] isEqualToString:@"1"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
										return 8; // O | O | _ Bottom Row
									else
										if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
											return 0; // Left Vertical Top Left Missing
										else
											if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:3] isEqualToString:@"0"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
												return 3; // Left Vertical Middle Missing
											else
												if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[usedSpots objectAtIndex:6] isEqualToString:@"0"])
													return 6; // Left Vertical Bot Left Missing
												else
													if ([[usedSpots objectAtIndex:1] isEqualToString:@"0"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"])
														return 1; // Middle Vertical Mid Top Missing
													else
														if ([[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"])
															return 4; // Middle Vertical Middle Missing
														else
															if ([[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:7] isEqualToString:@"0"])
																return 7; // Middle Vertical Mid Bot Missing
															else
																if ([[usedSpots objectAtIndex:2] isEqualToString:@"0"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
																	return 2; // Right Vertical Top Missing
																else
																	if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[usedSpots objectAtIndex:5] isEqualToString:@"0"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
																		return 5; // Right Vertical Middle Missing
																	else
																		if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
																			return 8; // Right Vertical Bot Missing
																		else
																			if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
																				return 0; // Diagonal Top Left Missing
																			else
																				if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
																					return 4; // Diagonal Middle Missing
																				else
																					if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
																						return 8; // Diagonal Bottom Right Missing
																					else
																						if ([[usedSpots objectAtIndex:2] isEqualToString:@"0"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
																							return 2; // Diagonal Top Right Missing
																						else
																							if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
																								return 4; // Diagonal Middle Missing
																							else
																								if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:6] isEqualToString:@"0"])
																									return 6; // Diagonal Bottom Left Missing	
	
	// check if the opponent can win on the next move
	if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[playersMoves objectAtIndex:2] isEqualToString:@"1"])
		return 0; // _ | O | O Top Row
	else
		if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:1] isEqualToString:@"0"] && [[playersMoves objectAtIndex:2] isEqualToString:@"1"])
			return 1; // O | _ | O Top Row
		else
			if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[usedSpots objectAtIndex:2] isEqualToString:@"0"])
				return 2; // O | O | _ Top Row
			else
				if ([[usedSpots objectAtIndex:3] isEqualToString:@"0"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"])
					return 3; // _ | O | O Middle Row
				else
					if ([[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"])
						return 4; // O | _ | O Middle Row
					else
						if ([[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:5] isEqualToString:@"0"])
							return 5; // O | O | _	Middle Row
						else
							if ([[usedSpots objectAtIndex:6] isEqualToString:@"0"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
								return 6; // _ | O | O Bottom Row
							else
								if ([[playersMoves objectAtIndex:6] isEqualToString:@"1"] && [[usedSpots objectAtIndex:7] isEqualToString:@"0"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
									return 7; // O | _ | O Bottom Row
								else
									if ([[playersMoves objectAtIndex:6] isEqualToString:@"1"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
										return 8; // O | O | _	Bottom Row
									else
										if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
											return 0; // Left Vertical Top Row
										else
											if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:3] isEqualToString:@"0"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
												return 3; // Left Vertical Middle Row
											else
												if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[usedSpots objectAtIndex:6] isEqualToString:@"0"])
													return 6; // Left Vertical Bottom Row
												else
													if ([[usedSpots objectAtIndex:1] isEqualToString:@"0"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"])
														return 1; // Middle Vertical Top Row
													else
														if ([[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"])
															return 4; // Middle Vertical Middle Row
														else
															if ([[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:7] isEqualToString:@"0"])
																return 7; // Middle Vertical Bottom Row
															else
																if ([[usedSpots objectAtIndex:2] isEqualToString:@"0"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
																	return 2; // Right Vertical Top Row
																else
																	if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[usedSpots objectAtIndex:5] isEqualToString:@"0"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
																		return 5; // Right Vertical Middle Row
																	else
																		if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
																			return 8; // Right Vertical Bottom Row	
																		else
																			if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
																				return 0; // Diagonal Top Left Missing
																			else
																				if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
																					return 4; // Diagonal Middle Missing
																				else
																					if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:8] isEqualToString:@"0"])
																						return 8; // Diagonal Bottom Right Missing
																					else
																						if ([[usedSpots objectAtIndex:2] isEqualToString:@"0"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
																							return 2; // Diagonal Top Right Missing
																						else
																							if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[usedSpots objectAtIndex:4] isEqualToString:@"0"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
																								return 4; // Diagonal Middle Missing
																							else
																								if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[usedSpots objectAtIndex:6] isEqualToString:@"0"])
																									return 6; // Diagonal Bottom Left Missing
	
	// some cases to help the computer win
																								else
																									if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"] && [[usedSpots objectAtIndex:5] isEqualToString:@"0"])
																										return 5;
																									else
																										if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"] && [[usedSpots objectAtIndex:3] isEqualToString:@"0"])
																											return 3;
																										else // doesn't fit a condition choose a random spot
																										{
																											int theNextMove = [self getRandomMove];
																											return theNextMove;
																										}
	/* These statements make the computer unbeatable.  I took them out so it's fun.
	 else
	 if ([[usedSpots objectAtIndex:4] isEqualToString:@"0"])
	 return 4;
	 else
	 if ([[usedSpots objectAtIndex:0] isEqualToString:@"0"])
	 return 0;
	 */
}

// Random space if neither opponent nor computer can win on next move
- (int) getRandomMove
{
	int randomSpace = (random() % 9);
	while([self isEmptySpace:randomSpace] == FALSE)
	{
		randomSpace = (random() % 9);
	}
	return randomSpace;
}

// Is this space empty? YES or NO
- (BOOL) isEmptySpace:(int)space
{
	if ([[usedSpots objectAtIndex:space] isEqualToString:@"0"])
		return true;
	else
		return false;
}

// Checks if the Player Wins -- Goes through all winning scenarios.
- (BOOL) checkPlayerWin
{
	if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[playersMoves objectAtIndex:2] isEqualToString:@"1"])
	{
		gameResult.text = @"Player Wins";
		return true;
	}
	else
		if ([[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"])
		{
			gameResult.text = @"Player Wins";
			return true;		
		}
		else
			if ([[playersMoves objectAtIndex:6] isEqualToString:@"1"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
			{
				gameResult.text = @"Player Wins";
				return true;		
			}
			else
				if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:3] isEqualToString:@"1"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
				{
					gameResult.text = @"Player Wins";
					return true;		
				}
				else
					if ([[playersMoves objectAtIndex:1] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:7] isEqualToString:@"1"])
					{
						gameResult.text = @"Player Wins";
						return true;		
					}
					else
						if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[playersMoves objectAtIndex:5] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
						{
							gameResult.text = @"Player Wins";
							return true;		
						}
						else
							if ([[playersMoves objectAtIndex:0] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:8] isEqualToString:@"1"])
							{
								gameResult.text = @"Player Wins";
								return true;		
							}
							else
								if ([[playersMoves objectAtIndex:2] isEqualToString:@"1"] && [[playersMoves objectAtIndex:4] isEqualToString:@"1"] && [[playersMoves objectAtIndex:6] isEqualToString:@"1"])
								{
									gameResult.text = @"Player Wins";
									return true;		
								}
	return false; // If you get to this statement the player did not win.
}

// Checks if the Computer Wins -- Goes through all winning scenarios.
- (BOOL) checkComputerWin
{
	if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[computersMoves objectAtIndex:2] isEqualToString:@"1"])
	{
		gameResult.text = @"Computer Wins";
		return true;
	}
	else
		if ([[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"])
		{
			gameResult.text = @"Computer Wins";
			return true;		
		}
		else
			if ([[computersMoves objectAtIndex:6] isEqualToString:@"1"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
			{
				gameResult.text = @"Computer Wins";
				return true;		
			}
			else
				if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:3] isEqualToString:@"1"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
				{
					gameResult.text = @"Computer Wins";
					return true;		
				}
				else
					if ([[computersMoves objectAtIndex:1] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:7] isEqualToString:@"1"])
					{
						gameResult.text = @"Computer Wins";
						return true;		
					}
					else
						if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[computersMoves objectAtIndex:5] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
						{
							gameResult.text = @"Computer Wins";
							return true;		
						}
						else
							if ([[computersMoves objectAtIndex:0] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:8] isEqualToString:@"1"])
							{
								gameResult.text = @"Computer Wins";
								return true;		
							}
							else
								if ([[computersMoves objectAtIndex:2] isEqualToString:@"1"] && [[computersMoves objectAtIndex:4] isEqualToString:@"1"] && [[computersMoves objectAtIndex:6] isEqualToString:@"1"])
								{
									gameResult.text = @"Computer Wins";
									return true;		
								}
	return false; // If you get to this statement the computer the computer did not win
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) gameOver
{
	NSLog(@"Its Over");
	NSString *theWinner = gameResult.text;
	if ([theWinner isEqualToString: @"Player Wins"])
	{
		pet.ansalas += 50;	// fix algorithm!!!
		manto.image = [UIImage imageNamed:@"manto_puzzled.png"];
	}
	else
		if ([theWinner isEqualToString: @"Computer Wins"])
		{
			manto.image = [UIImage imageNamed:@"manto_dizzy_right.png"];
		}
		else
			if ([theWinner isEqualToString: @"Draw."])
			{
				manto.image = [UIImage imageNamed:@"manto_scared_right.png"];
			}
	
//	[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(andrewFailsBackDoesNotWork) userInfo:nil repeats:NO];
	// The gameResult.text is set to Computer Wins, Player Wins, or Draw.
}

- (IBAction) backPressed:(id) sender {
	[self.view removeFromSuperview];
	NSLog(@"Pressed Back");
}

// exit game, cause iDrew fails to write a back button
- (void)andrewFailsBackDoesNotWork {
	[self.view removeFromSuperview];
}

- (void)dealloc {
	[topLeft release];
	[topMiddle release];
	[topRight release];
	[midLeft release];
	[midMiddle release];
	[midRight release];
	[botLeft release];
	[botMiddle release];
	[botRight release];
	[computersMoves release];
	[playersMoves release];
	[usedSpots release];
	[theTurn release];
	[gameResult release];
	[super dealloc];
}

@end
