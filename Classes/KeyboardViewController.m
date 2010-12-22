//
//  firstScreensViewController.m
//  firstScreens
//
//  Created by Andrew Saladino on 4/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "KeyboardViewController.h"
#import "CompleteInHimFont.h"

@implementation KeyboardViewController
@synthesize nameString; // String of Data The User Enters
@synthesize nameStringView; // pointer to the name on the string
@synthesize genderViewController; // GenderViewController Object
@synthesize delAndBack; // to change the button from back or del depending on input


// User Pressed A Letter
- (IBAction)letterPressed:(id)sender {
	
	[delAndBack setImage: [UIImage imageNamed:@"keyboard_del.png"] forState:UIControlStateNormal];
	[delAndBack setImage: [UIImage imageNamed:@"keyboard_delDOWN.png"] forState:UIControlStateHighlighted];

	if (nameString.length < 12) // If there is less than 12 letters
	{
		[nameStringView removeFromSuperview]; // remove the old View
		int letter = [sender tag]; // Int letter is the tag of the Key Pressed
		
	  	
		CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(97, 78, 400, 0)] autorelease]; // Make a Label of the Custom Font
  		
		[myLabel initTextWithSize:48 color:[UIColor blackColor] bgColor:[UIColor clearColor]]; // Set Properties	
		
		[nameString appendString: [NSString stringWithFormat:@"%c", letter]]; // Add the pressed key to nameString which is the name the user enters.
		
		nameStringView = myLabel; // Pointer to the last label added so it can be removed.
		
		[myLabel updateText:nameString]; // Label View's text gets set to the proper string.
		[self.view addSubview:myLabel]; // Add Label's View to the Current View
	}
}

// Backspace Pressed.
- (IBAction)backspacePressed:(id)sender {
	
	if (nameString.length > 0) // If there are any characters entered
	{
		NSRange range = NSMakeRange(nameString.length-1,1); // Get the last character
		
		[nameString deleteCharactersInRange:range]; // Delete the last character		
		[nameStringView removeFromSuperview]; // Delete the old Label View
		
		CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(97, 78, 400, 0)] autorelease]; // Make a New Label View to Be Displayed
		[myLabel initTextWithSize:48 color:[UIColor blackColor] bgColor:[UIColor clearColor]]; // Set the Properties
		
		nameStringView = myLabel; // Pointer to the last label so it can be removed
		
		[myLabel updateText:nameString]; // Change the Label's text to the proper string(with deleted character)
		[self.view addSubview:myLabel]; // Add it to current view.

		if (nameString.length == 0)
		{
			[delAndBack setImage: [UIImage imageNamed:@"keyboard_back.png"] forState:UIControlStateNormal];
			[delAndBack setImage: [UIImage imageNamed:@"keyboard_backDOWN.png"] forState:UIControlStateHighlighted];
		}
	}
	else
	{
		[self.view removeFromSuperview];
		NSLog(@"Go Back a view");
	}
}

// Next Screen Pressed
- (IBAction)nextPressed:(id)sender{
	
	if (nameString.length > 0)
	{
		// Set the genderViewController to a new GenderViewController with a xib of Gender
		genderViewController = [[GenderViewController alloc] initWithNibName:@"GenderView" bundle:[NSBundle mainBundle]];
		
		// Make a dictinoary that will be passed through all of the views
		NSMutableDictionary *test = [NSMutableDictionary new];
		
		// Add the nameString for the key 'Name' to this dictionary
		[test setObject:nameString forKey:@"name"];
		
		// Set the instance variable data (which is also a NSMutableDictionary) to the local dictionary that was just created
		genderViewController.data = test;
		
		// Release the local dictionary
		[test release];

		// Display the new view
		[self.view addSubview:genderViewController.view];
	}
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

- (void)viewDidLoad	
{		
	self.nameString = [[NSMutableString new] autorelease];
	
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(35, 15, 480, 0)] autorelease];
	[myLabel initTextWithSize:50 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"What is your pet's name?"];
	[self.view addSubview:myLabel];
}


- (void)dealloc {
	[genderViewController release];
	[nameString release];
//	[nameStringView release];
    [super dealloc];
}

@end
