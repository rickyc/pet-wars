//
//  PeerToPeerViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/6/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PeerToPeerViewController : UIViewController {
	UITextView *txtView;
	NSTimer *updateChatTimer;
}

@property(nonatomic, retain) UITextView *txtView;
@property(nonatomic, retain) NSTimer *updateChatTimer;

- (void)goBack:(id)sender;

@end
