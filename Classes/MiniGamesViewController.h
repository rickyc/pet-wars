//
//  MiniGamesViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicTacToeViewController.h"
#import "RockPaperScissorViewController.h"
#import "Manto.h"
#import "PeerToPeerViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface MiniGamesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UIButton *exitMiniGamesButton;
	IBOutlet UITableView *tableView;
	NSMutableArray *gamesAry;
	Manto *pet;
	
	PeerToPeerViewController *peerToPeerViewController;
	TicTacToeViewController *ticTacToeViewController;
	RockPaperScissorViewController *rockPaperScissorViewController;
}

@property(nonatomic, retain) Manto *pet;
@property(nonatomic, retain) UIButton *exitMiniGamesButton;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *gamesAry;
@property(nonatomic, retain) PeerToPeerViewController *peerToPeerViewController;
@property(nonatomic, retain) TicTacToeViewController *ticTacToeViewController;
@property(nonatomic, retain) RockPaperScissorViewController *rockPaperScissorViewController;

- (IBAction)exitMiniGames:(id)sender;
- (void)loadGames;

@end
