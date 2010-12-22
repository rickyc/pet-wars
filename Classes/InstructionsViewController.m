//
//  InstructionsViewController.m
//  instructions
//
//  Created by Jamin aka JDog on 4/22/09.
//  JDog commited a major fail. The accelerometer swipe was a nice touch though :D
//  Code taken from Apple's PageControl.zip & revised
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "InstructionsViewController.h"

#define kNumberOfPages 7

@interface InstructionsViewController(PrivateMethods)
	- (void)loadScrollViewWithPage:(int)page;
	- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation InstructionsViewController
@synthesize pageControl, imageViews, scrollView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
	self.imageViews = [[NSMutableArray alloc] init];
	
	// a page is the width of the scroll view
	self.scrollView.pagingEnabled = YES;
	self.scrollView.contentSize = CGSizeMake(480 * kNumberOfPages, scrollView.frame.size.height);
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;
	self.scrollView.delegate = self;
	
	pageControl.numberOfPages = kNumberOfPages;
	pageControl.currentPage = 0;
	
	// init image view
	for(int i=0;i<kNumberOfPages;i++)
		[self loadScrollViewWithPage:i];
}

- (void)loadScrollViewWithPage:(int)page {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"instructionsPage_%i.png",page+1]]];
	imageView.frame = CGRectMake(page*480, 0, 480, 320);
	imageView.multipleTouchEnabled = YES;
	imageView.userInteractionEnabled = YES;
	
	[self.imageViews addObject:imageView];
	[self.scrollView addSubview:imageView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	// We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
	// which a scroll event generated from the user hitting the page control triggers updates from
	// the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	if (pageControlUsed) {
		// do nothing - the scroll was initiated from the page control, not the user dragging
		return;
	}
	// Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
	
	// A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
	int page = pageControl.currentPage;

	// update the scroll view to the appropriate page
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:YES];
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
	pageControlUsed = YES;
}	

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(IBAction)closeInstructions:(id)sender {
	[HelperMethods playSound:@"click"];
	[self.imageViews release];		// does this crash the app?
	[self.view removeFromSuperview];
}

- (void)dealloc {
	[imageViews release];
	[scrollView release];
	[pageControl release];
    [super dealloc];
}

@end