//
//  PeerToPeerViewController.m
//  Pet Wars
//
//  Created by Ricky Cheng on 5/6/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "PeerToPeerViewController.h"

@implementation PeerToPeerViewController
@synthesize txtView, updateChatTimer;

- (void)goBack:(id)sender {
	[updateChatTimer invalidate];
	[HelperMethods playSound:@"click"];
	[self.view removeFromSuperview];
}

- (void)toggleKeyboard:(id)sender {
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
	contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
	
	[self.view addSubview:[HelperMethods createImageWithX:0 andY:0 andImage:@"background.png"]];
	[self.view addSubview:[HelperMethods createButtonWithX:420 andY:295 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
												 andTarget:self andSelector:@selector(goBack:)]];
	
	[self.view addSubview:[HelperMethods createLabelWithX:150 andY:15 andWidth:400 andHeight:48 andText:@"Peer To Peer Chat" andTextSize:34]];
	
	// this should turn on the keyboard
//	[self.view addSubview:[HelperMethods createButtonWithX:20 andY:295 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
//												 andTarget:self andSelector:@selector(toggleKeyboard:)]];
	
	txtView = [[UITextView alloc] initWithFrame:CGRectMake(25,50,430,240)];
	txtView.scrollEnabled = YES;
	txtView.multipleTouchEnabled = NO;
	txtView.editable = NO;
	txtView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtView];
	
	updateChatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
	NSString *chatString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://rlcxxxxxxx.com/contents/isometrics/scripts/petwars_msg.php"]];
	NSLog(@"timer still going - url needs to be modified for this to work");
	
	// scroll to bottom does not work!!!
	CGPoint p = [txtView contentOffset];
	txtView.text = chatString;
	[txtView setContentOffset:p animated:NO];
	[txtView scrollRangeToVisible:NSMakeRange([txtView.text length], 0)];
}

- (void)dealloc {
	[txtView release];
	[super dealloc];
}

@end
