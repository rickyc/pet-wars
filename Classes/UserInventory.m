//
//  UserInventory.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/16/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "UserInventory.h"
#import "StoreItem.h"
#import "iDrewStuffAppDelegate.h"

@implementation UserInventory
@synthesize consumableInventory;

- (void)clearInventoryView {
	for(int i=0;i<consumableInventory.count;i++) {
		StoreItem *sItem = [consumableInventory objectAtIndex:i];
		[sItem.imageView removeFromSuperview];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.consumableInventory = [NSMutableArray new];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {	
	UITouch *touch = [touches anyObject];
	//CGPoint currentPosition = [touch locationInView:self];
	NSLog(@"touched - %@",[touch view]);
	
	int tapCount = [[touches anyObject] tapCount];
	
	for(int i=0;i<consumableInventory.count;i++) {
		StoreItem *sItem = [consumableInventory objectAtIndex:i];
		if([touch view] == sItem.imageView && tapCount == 2) {
			iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
			RootViewController *rootViewController = [appDelegate viewController];
			GameViewController *gameViewController = rootViewController.gameViewController;
			
			// double tap and use the item
			[gameViewController.petRock useItem:sItem atIndex:i];
			[HelperMethods playSound:@"pop"];
		}
	}
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	//UITouch *touch = [touches anyObject];
//	CGPoint currentPosition = [touch locationInView:self];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {	

}

- (void)drawInventory {
	[self clearInventoryView];
	
	int counter = 0;
	for(int i=0;i<consumableInventory.count;i++) {
		StoreItem *item = [consumableInventory objectAtIndex:i];
		if(item.showInInventory) {
			int imgPosition = 23 * counter + 5 * counter;
			
			// adds the item to the inventory, this should be done in manto
			UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgPosition, 0, 23, 23)];
			img.image = [UIImage imageNamed:item.imageName];
			img.userInteractionEnabled = YES;
			img.multipleTouchEnabled = YES;
			
			item.imageView = img;
			[self addSubview:img];
			counter++;
		}
	}
	
	self.contentSize = CGSizeMake(counter*28,32);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[consumableInventory release];
    [super dealloc];
}

@end
