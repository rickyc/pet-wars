//
//  PWAlert.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/24/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWAlert : UIViewController {
	UIButton *backButton;
}

- (void)setTitle:(NSString*)title andMessage:(NSString*)message;

@end
