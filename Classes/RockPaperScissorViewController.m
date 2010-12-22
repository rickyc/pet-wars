//
//  RockPaperScissorViewController.m
//  RockPaperScissor
//
//  Created by Andrew Saladino on 5/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RockPaperScissorViewController.h"

@implementation RockPaperScissorViewController
@synthesize playerSign, computerSign;
@synthesize winOrLose;
@synthesize playerInput, computerInput;
@synthesize theWinner;
@synthesize winOrLoseView, playerScoreView, computerScoreView;
@synthesize pet;

// User clicked on a sign
- (IBAction) signChosen:(id) sender
{
	srandom((random() % 1000) + time(NULL));
	int taggedSign = [sender tag]; // tag number of the selected color
	if (taggedSign == 0)
	{
		[playerSign setImage: [UIImage imageNamed:@"rps_rock_left.png"]];
		playerInput = @"0";
	}
	else
		if (taggedSign == 1)
		{
			[playerSign setImage: [UIImage imageNamed:@"rps_paper_left.png"]];
			playerInput = @"1";
		}
		else
			if (taggedSign == 2)
			{
				[playerSign setImage: [UIImage imageNamed:@"rps_scissor_left.png"]];
				playerInput = @"2";
			}
}

// User pressed shoot
- (IBAction) shootPressed:(id)sender
{
	[HelperMethods playSound:@"click"];
	srandom((random() % 10000) + time(NULL)); // seed generator
	if ((![playerInput isEqualToString:@"-1"]) && (gameFinished == NO)) // Tests to see if player selected a sign
	{
		[self randomComputerSign];
		[self checkWhoWon];
		[self isGameOver];
	}
}

- (void) isGameOver
{
	if (playerScoreInt == 4)
	{
		[playerScoreView removeFromSuperview];
		[computerScoreView removeFromSuperview];
		
		CompleteInHimFont *theWinnerOfGame = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(248, 265, 300, 0)] autorelease];
		[theWinnerOfGame initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
		
		pet.ansalas += 50; // change algorithm
		[theWinnerOfGame updateText:@"You win the game!"];
		[self.view addSubview:theWinnerOfGame];
		gameFinished = YES;
	}
	else
		if (computerScoreInt == 4)
		{
			[playerScoreView removeFromSuperview];
			[computerScoreView removeFromSuperview];
			
			
			CompleteInHimFont *theWinnerOfGame = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(248, 265, 300, 0)] autorelease];
			[theWinnerOfGame initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
			
			[theWinnerOfGame updateText:@"You lose the game."];
			[self.view addSubview:theWinnerOfGame];
			gameFinished = YES;
		}
	
	// game over, no back button, thanks iDrew
	if(gameFinished) {
		//[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(andrewFailsBackDoesNotWork) userInfo:nil repeats:NO];
	}
}

// exit game, cause iDrew fails to write a back button
- (void)andrewFailsBackDoesNotWork {
	[self.view removeFromSuperview];
}

// Show the computer's random sign
- (void) randomComputerSign
{
	int randomSign = (random() % 3);
	if (randomSign == 0)
	{
		[computerSign setImage: [UIImage imageNamed:@"rps_rock_right.png"]];
		computerInput = @"0";
	}
	else
		if (randomSign == 1)
		{
			[computerSign setImage: [UIImage imageNamed:@"rps_paper_right.png"]];
			computerInput = @"1";
		}
		else
			if (randomSign == 2)
			{
				[computerSign setImage: [UIImage imageNamed:@"rps_scissor_right.png"]];	
				computerInput = @"2";
			}
}

// Checks normal rule cases of R P S for player win
// Checks for tie
// Else, computer won
- (void) checkWhoWon
{
	if ([playerInput isEqualToString:@"0"] && [computerInput isEqualToString:@"2"])
	{
		theWinner = @"Player";
		winOrLose.text = @"Win";
		playerScoreInt++;
	}
	else
		if ([playerInput isEqualToString:@"1"] && [computerInput isEqualToString:@"0"])
		{
			theWinner = @"Player";
			winOrLose.text = @"Win";
			playerScoreInt++;	
		}
		else
			if ([playerInput isEqualToString:@"2"] && [computerInput isEqualToString:@"1"])
			{
				theWinner = @"Player";
				winOrLose.text = @"Win";
				playerScoreInt++;	
			}
			else
				if ([playerInput isEqualToString:computerInput])
				{
					theWinner = @"Tie";
					winOrLose.text = @"Tie";
				}
				else
				{
					theWinner = @"Computer";
					winOrLose.text = @"Lose";
					computerScoreInt++;			
				}
	
	// Re-draw the player and computer scores
	// Start by removing old scores
	[playerScoreView removeFromSuperview];
	[computerScoreView removeFromSuperview];
	[winOrLoseView removeFromSuperview];
	
	// Draw the Player's Score
	CompleteInHimFont *myPlayerScore = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(218, 265, 100, 0)] autorelease];
	[myPlayerScore initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	playerScoreView = myPlayerScore;
	
	[myPlayerScore updateText:[NSString stringWithFormat:@"Player: %d",  playerScoreInt]];
	[self.view addSubview:myPlayerScore];
	// End Player's Score Draw
	
	// Draw the Computer's Score
	CompleteInHimFont *myComputerScore = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(328, 265, 150, 0)] autorelease];
	[myComputerScore initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	computerScoreView = myComputerScore;
	
	[myComputerScore updateText:[NSString stringWithFormat:@"Computer: %d",  computerScoreInt]];
	[self.view addSubview:myComputerScore];
	// End Computer's Score draw
	
	// Update win or lose text
	CompleteInHimFont *myWinOrLose = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(242, 185, 50, 0)] autorelease];
	[myWinOrLose initTextWithSize:26 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	winOrLoseView = myWinOrLose;
	
	[myWinOrLose updateText:winOrLose.text];
	[self.view addSubview:myWinOrLose];
	// End Update Win or Lose text
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	CompleteInHimFont *myTitle = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(90, 15, 400, 0)] autorelease];
	[myTitle initTextWithSize:50 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myTitle updateText:@"Rock Paper Scissors"];
	[self.view addSubview:myTitle];
	
	computerScoreInt = 0; // Init score to 0
	playerScoreInt = 0; // Init score to 0
	playerInput = @"-1"; // To check if the user picked a sign
	gameFinished == NO; // Game Finished = NO
	
	// Draw the Player's Score
	CompleteInHimFont *myPlayerScore = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(218, 265, 100, 0)] autorelease];
	[myPlayerScore initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	playerScoreView = myPlayerScore;
	
	[myPlayerScore updateText:@"Player: 0"];
	[self.view addSubview:myPlayerScore];
	// End Player's Score Draw
	
	// Draw the Computer's Score
	CompleteInHimFont *myComputerScore = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(328, 265, 150, 0)] autorelease];
	[myComputerScore initTextWithSize:32 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	computerScoreView = myComputerScore;
	
	[myComputerScore updateText:@"Computer: 0"];
	[self.view addSubview:myComputerScore];
	// End Computer's Score draw
}

-(void)viewWillAppear:(BOOL)animated
{
	
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

- (IBAction) backPressed:(id) sender {
	[self.view removeFromSuperview];
	NSLog(@"Pressed Back");
}

- (void)dealloc {
	[computerSign release];
	[playerSign release];
	[winOrLose release];
	[playerInput release];
	[computerInput release];
	[theWinner release];
	//	[playerScoreView release];
	//	[computerScoreView release];
	[winOrLoseView release];
	[super dealloc];
}

@end
