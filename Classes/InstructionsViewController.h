//
//  InstructionsViewController.h
//  instructions
//
//  Created by Jamin aka JDog on 4/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface InstructionsViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *imageViews;
	BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *imageViews;

- (IBAction)changePage:(id)sender;
- (IBAction)closeInstructions:(id)sender;

@end
