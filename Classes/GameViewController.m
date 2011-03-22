//
//  GameViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//	Argh! Someone has to help out with this....
//  Copyright 2009 :D. All rights reserved.
//

#import "GameViewController.h"
#import "CGAffineTransformShear.h"
#import "iDrewStuffAppDelegate.h"
#import "AccelerometerSimulation.h"

@class DeviceData;

@implementation GameViewController
@synthesize grass, largeCloud, smallCloud, sunMoon, menuView, jukeboxButton, minigamesButton, shoppingButton, songList, musicPlayer,
dateTimeWeather, weatherChecker, storeViewController, openCloseMenuButton, petRock, ansalasLabel, petAnimationTimer, songTitleLabel,
healthView, happinessBarImageView, hygieneBarImageView, hungerBarImageView, happinessBar, hygieneBar, hungerBar, ansalasView,
miniGamesViewController, statsViewController, inventoryView, itemsOnStage, gestureStartPoint, userMusicOn;

// used to track the menu view, if its opened or closed
CGPoint oldPosition;

#pragma mark Touch Gestures
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {	
	UITouch *touch = [[event allTouches] anyObject];
	int tapCount = [[touches anyObject] tapCount];
	
	// temp var to test
	CGPoint currentPosition = [touch locationInView:self.view];
	NSLog(@"touched => %@, tap count => %i, position => %f,%f",[touch view], tapCount, currentPosition.x, currentPosition.y);
	
	// pet rock is the main character
	if([touch view] == petRock.objectImage) {
		touchBegan = YES;
	}
	
	// double tap to remove item from the stage
	for(int i=0;i<itemsOnStage.count;i++) {
		GObject *gObject = [itemsOnStage objectAtIndex:i];
		if([touch view] == gObject.objectImage && tapCount == 2) {
			if([gObject.name isEqualToString:@"poop"]) {
				petRock.numNuggets -= 1;
			} else {
				for(StoreItem *sItem in petRock.inventoryView.consumableInventory) {
					if(sItem.key == gObject.key) {
						sItem.showInInventory = YES;
						break;
					}
				}
				[self redraw];
			}
			[HelperMethods playSound:@"pop2"];
			[gObject.objectImage removeFromSuperview];
			[itemsOnStage removeObjectAtIndex:i];
			NSLog(@"number of items on stage: %i",[itemsOnStage count]);
		}
	}
	
	// if it is not currently animated, double tap on manto
	if(!petRock.currentlyAnimated && tapCount >= 2 && [touch view] == petRock.objectImage) {
		if(!petRock.asleep) {
			if(tapCount == 2) {
				[petRock changeImage:@"manto_puzzled.png"];
				[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
				petRock.currentlyAnimated = YES;
			} else if(tapCount == 10) {
				int ranAnimation = arc4random()%6;
				NSString *petImgStr;
				
				switch(ranAnimation) {
					case 0:	petImgStr = @"manto_impatient.png";	break;
					case 1:	petImgStr = @"manto_angry.png";		break;
					case 2:	petImgStr = @"manto_despise.png";	break;
					case 3:	petImgStr = @"manto_strive.png";	break;
					case 4:	petImgStr = @"manto_rage.png";		break;
					case 5:	petImgStr = @"manto_cry.png";		break;
				}
				
				[petRock changeHappiness:(ranAnimation+1)*-5];
				[petRock changeImage:petImgStr];
				[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
				petRock.currentlyAnimated = YES;
				[self redraw];
			}
		} else {
			// the pet is asleep and you wake it up
			if(tapCount == 10) {
				[petRock changeImage:@"manto_angry.png"];
				petRock.asleep = NO;
				[petRock changeHappiness:-100];
				[self redraw];
			}
		}
	} 
	
	// toggles stats menu
	if([touch view] == ansalasView && tapCount == 2) {
		[HelperMethods playSound:@"click"];
		statsViewController = [StatsViewController new];
		statsViewController.pet = petRock;
		[self.view addSubview:statsViewController.view];
	}
	
	if([touches count] == 2) {
		gestureStartPoint = [touch locationInView:self.view];
		NSLog(@"two fingers");
	}
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"touch ended");
	
	// touch physics for the pet
	UITouch *touch = [[event allTouches] anyObject];
	if([touch view] == petRock.objectImage) {
		petRock.wasDragged = YES;
	}
	
	// touch physics for items on stage
	for(int i=0;i<itemsOnStage.count;i++) {
		GObject *gObject = [itemsOnStage objectAtIndex:i];
		if([touch view] == gObject.objectImage) {
			gObject.wasDragged = YES;
		}
	}

	touchBegan = NO;
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self.view];
	
	// two finger swipe to change inventory view
	if([touches count] == 2) {
		CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
		CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
		
		if (deltaX >= kMinimumGestureLength && deltaY <= kMaximumVariance) {
			if(currentPosition.x > gestureStartPoint.x){
				//right swipe
				NSLog(@"right swipe");
			} else if(currentPosition.x < gestureStartPoint.x){
				//left swipe
				NSLog(@"left swipe");
			}
		}	
	}
	
	// drag the menu up & down
	if([touch view] == menuView) {
		NSLog(@"menu is touched, %f,%f",menuView.center.x,menuView.center.y);
		int distanceDifference = oldPosition.y - currentPosition.y;
		if(distanceDifference < 0) {
			//NSLog(@"moved down");
			if(menuView.center.y < kMenuYOpened) {
				menuView.center = CGPointMake(menuView.center.x,menuView.center.y+5);
			}
			else {
				menuView.center = CGPointMake(menuView.center.x,kMenuYOpened);
				[openCloseMenuButton setImage:[UIImage imageNamed:@"up_arrow.png"] forState:UIControlStateNormal]; 	
			}
		} else {
			//NSLog(@"moved up");
			if(menuView.center.y > kMenuYClosed)
				menuView.center = CGPointMake(menuView.center.x,menuView.center.y-5);
			else {
				menuView.center = CGPointMake(menuView.center.x,kMenuYClosed);
				[openCloseMenuButton setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal]; 	
			}
		}
	}
	
	// if manto is currently not doing any gravity calculations
	//if([touch view] == manto && !mantoBeingDragged) {
	for(int i=0;i<itemsOnStage.count;i++) {
		GObject *gObject = [itemsOnStage objectAtIndex:i];
		if([touch view] == gObject.objectImage) {
			gObject.wasDragged = NO;
			[gObject objectBeingDragged:currentPosition];
		}
	}
		
	if([touch view] == petRock.objectImage) {
		petRock.wasDragged = NO;
		[petRock objectBeingDragged:currentPosition];
	}
	
	// used for the menu view
	oldPosition = currentPosition;
}

- (void)defaultPetImage {
	if(petRock.asleep)
		[petRock changeImage:@"manto_asleep.png"];
	else if(petRock.health >= 3)
		[petRock changeImage:@"manto_default.png"];
	else if(petRock.health == 2)
		[petRock changeImage:@"manto_bother.png"];
	else if(petRock.health == 1)
		[petRock changeImage:@"manto_despise.png"];

	petRock.currentlyAnimated = NO;
}

#pragma mark Shake API
- (BOOL)canBecomeFirstResponder {
	return YES;
}

// FIX: NOT WORKING, problem w/ first responder
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if(motion ==  UIEventSubtypeMotionShake) {
		NSLog(@"shook");
	//	myView.center = CGPointMake(myView.center.x,myView.center.y-10);
	}
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	NSLog(@"trial 2");
}

// low hunger = bigger poop
- (void)poopCycle {
	float scaleFactor = (petRock.hunger/100)*.2;
	scaleFactor = scaleFactor < 0.2 ? 0.2 : scaleFactor;
	
	[self addGObjectToStageWithName:@"Poop" andImage:@"poop.png" andScale:scaleFactor andInFront:NO andPosition:-1 andKey:-1];
	petRock.numNuggets += 1;
	[HelperMethods playSound:@"fart"];
	NSLog(@"poop!!! %f",scaleFactor);
}

- (void)addGObjectToStageWithName:(NSString*)name andImage:(NSString*)image andScale:(float)scaleFactor andInFront:(BOOL)front andPosition:(double)position andKey:(int)key {
	GObject *gObject = [GObject new];
	gObject.key = key;
	gObject.name = name;
	[gObject setImage:image withScale:scaleFactor];

	if(position == -1) {
		gObject.objectImage.center = petRock.currentPosition;
		gObject.currentPosition = petRock.currentPosition;
		gObject.oldPosition = petRock.oldPosition;
	} else {
		gObject.objectImage.center = CGPointMake(position,petRock.currentPosition.y);
		gObject.currentPosition = CGPointMake(position,petRock.currentPosition.y);
		gObject.oldPosition = CGPointMake(position,petRock.currentPosition.y);
	}
	
	gObject.wasDragged = YES;
	
	[itemsOnStage addObject:gObject];
	
	if(front)
		[self.view insertSubview:gObject.objectImage aboveSubview:petRock.objectImage];
	else
		[self.view insertSubview:gObject.objectImage belowSubview:petRock.objectImage];
}

#pragma mark Accelerometer
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// if manto is not being touched, not being dragged
	if(!petRock.currentlyAnimated && !petRock.wasDragged && !touchBegan) {
	//	NSLog(@"Accel: x: %g\ty:%g\tz:%g",acceleration.x,acceleration.y,acceleration.z);
		
		// shake the pet
		if (fabsf(acceleration.x) > kAccelerometerThreshold || fabsf(acceleration.y) > kAccelerometerThreshold || fabsf(acceleration.z) > kAccelerometerThreshold) {
			[petRock changeHappiness:-1];
			[petRock changeHunger:-1];
			[petRock changeFitness:1];
			[self redraw];
			NSLog(@"shake");
		}
		
		// gives it a little buffer before manto starts moving
		if(fabsf(acceleration.y) > 0.15) {
			accelerometerActive = YES;
			NSLog(@"acce y: %f",acceleration.y);
			// + mantoImageView.frame.size.width/2
			int direction = (acceleration.y < 0) ? -1 : 1;
			double mantoXPosition = petRock.objectImage.center.x + (direction*petRock.objectImage.frame.size.width/2);
			
		 	NSLog(@"Current Position: %f",mantoXPosition);
			if(mantoXPosition > 0 && mantoXPosition < 480) {
				petRock.objectImage.center = CGPointMake(petRock.objectImage.center.x+(kAccelerometerSpeed*acceleration.y),petRock.objectImage.center.y);
				
				// tilting the phone right
				// algorithm needs FIxING here.... basically this does not work on the iphone when the color of the pet is not default...
				// too much processing power.... we can limit this by checking the direction....
				if(!petRock.asleep) {
					if(direction > 0)
						[petRock changeImage:@"manto_scared_right.png"];
					else
						[petRock changeImage:@"manto_scared_left.png"];
				}
			} 
			
			// manto hits the left wall
			if(mantoXPosition < 0) {
				petRock.objectImage.center = CGPointMake(0+petRock.objectImage.frame.size.width/2,petRock.objectImage.center.y);
			
				// FIX: YOU SHOULD NOT BE ABLE TO TAP OR DRAG WHEN DIZZY
				if(fabsf(acceleration.y) > .65) {
					[HelperMethods playSound:@"wall"];
					[petRock changeHappiness:-5];
					[self redraw];
					[petRock changeImage:@"manto_dizzy_left.png"];
					petRock.currentlyAnimated = YES;
					[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
				}
			} else if(mantoXPosition > 480) {
				// bug here...
				petRock.objectImage.center = CGPointMake(500-petRock.objectImage.frame.size.width/2,petRock.objectImage.center.y);
				if(fabsf(acceleration.y) > .65) {
					[HelperMethods playSound:@"wall"];
					[petRock changeHappiness:-5];
					[self redraw];
					[petRock changeImage:@"manto_dizzy_right.png"];
					petRock.currentlyAnimated = YES;
					[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
				}
			}
			
			// set's manto's current location after accelerometer ends, for manto's automovement
			petRock.currentPosition = petRock.objectImage.center;
		} else {
			// manto is not moving
			[self defaultPetImage];
			accelerometerActive = NO;
		}
	}
}

#pragma mark Game Loop
- (void)checkTimeAndWeather:(NSTimer*)timer {
//	NSLog(@"no zipcode");
	if([self.dateTimeWeather coreLocationLoaded]) {
		// update sun / moon environment
		[weatherChecker invalidate];
		
//		NSLog(@"zippie? %@",dateTimeWeather.zipCode);
		NSDictionary *weather = [self.dateTimeWeather getWeather];
		NSDictionary *time = [self.dateTimeWeather getTime];
//		NSLog(@"time: %@",time);
		int currentTimeInSeconds = ([[time objectForKey:@"hour"] intValue]*60*60)+([[time objectForKey:@"minute"] intValue]*60);
		
		// NSLog(@"huh weather? %@",weather);
		// if we were able to retrieve the weather
		if(weather != nil) {
			NSDictionary *wDict = [weather objectForKey:@"weather"];
			NSDictionary *aDict = [weather objectForKey:@"astronomy"];
			int sunRise = [dateTimeWeather dateToSeconds:[aDict objectForKey:@"sunrise"]];
			int sunSet = [dateTimeWeather dateToSeconds:[aDict objectForKey:@"sunset"]];
			
//			NSLog(@"ct: %i, sr: %i, ss: %i",currentTimeInSeconds,sunRise,sunSet);
			if(currentTimeInSeconds > sunRise && currentTimeInSeconds < sunSet)
				sunMoon.image = [UIImage imageNamed:@"sun.png"];
			else
				sunMoon.image = [UIImage imageNamed:@"moon.png"];

			// special weather animations
			int weatherCode = [[wDict objectForKey:@"code"] intValue];
			if(weatherCode == 11 || weatherCode == 12) {	// rain
				[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(rainDrops) userInfo:nil repeats:YES];
				sunMoon.alpha = 0.5;
			}
			
			// adds the temperature & weather condition to the game view
			NSString *tempConditionsString = [NSString stringWithFormat:@"%@F - %@",[wDict objectForKey:@"temp"],
											  [wDict objectForKey:@"text"]];
			float fontSize = 20.0f;
			float widthOfText = [tempConditionsString length]*fontSize*.35;
			CompleteInHimFont *weatherAndTempView = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(240-widthOfText/2, 298, 180, 20)] autorelease];
			[weatherAndTempView initTextWithSize:fontSize color:[UIColor darkGrayColor] bgColor:[UIColor clearColor]];
			[weatherAndTempView updateText:tempConditionsString];
			[self.view insertSubview:weatherAndTempView belowSubview:inventoryView];
			//[self.view addSubview:weatherAndTempView];
		} else {		
			// if there is no internet, then default the sun / moon display to these settings
			int hour = [[time objectForKey:@"hour"] intValue];
			
			// 6pm till 6am = night time
			if(hour < 7 || hour > 18)
				sunMoon.image = [UIImage imageNamed:@"moon.png"];
			else
				sunMoon.image = [UIImage imageNamed:@"sun.png"];
		}
	}
}

// Manto's animation sequence
- (void)mantoAnimation:(NSTimer*)timer {
	// FIX NASTY HACK - DID THIS SO MONEY UPDATES AFTER A WIN FROM GAME!*!**!*!*!*!**!*!*!*!*!
	ansalasLabel.text = [NSString stringWithFormat:@"%i",petRock.ansalas];
	
	if(!petRock.asleep) {
		// as long as manto is not being touched or dragged, let it do it's own thing
		if(!accelerometerActive && !petRock.currentlyAnimated && !petRock.wasDragged && !touchBegan) {
			// FIX: Refine algorithm
			// create a random x, y direction to move
			int direction = (int)arc4random()%2 == 1 ? -1 : 1;
			// manto's currently a right wall hugger.... FIX THIS PlZ THANKS!
			petRock.velocity = CGPointMake(direction*(rand()%5+5),petRock.velocity.y+rand()%20+25);
			NSLog(@"pet->%f",petRock.currentPosition.x);
			petRock.wasDragged = YES;	// starts the gravity + physics calculations
		}
	}
}

#pragma mark -
#pragma mark rain animation
- (void)rainDrops {
	int drops = arc4random()%5;
	
	for(int i=0;i<drops;i++) {
		UIImageView *rain;
		if((int)arc4random()%2 == 1) { // large cloud
			int randomX  = (largeCloud.center.x-largeCloud.image.size.width/2)+arc4random()%((int)largeCloud.image.size.width);
			rain = [HelperMethods createImageWithX:randomX andY:largeCloud.center.y+largeCloud.image.size.height/2+5 andImage:@"raindrop.png"];
		} else { 
			int randomX  = (smallCloud.center.x-smallCloud.image.size.width/2)+arc4random()%((int)smallCloud.image.size.width);
			rain = [HelperMethods createImageWithX:randomX andY:smallCloud.center.y+smallCloud.image.size.height/2+5 andImage:@"raindrop.png"];
		}
		rain.alpha = (arc4random()%3*.1)+0.2;
		
		NSNumber *velocity = [NSNumber numberWithInt:(int)arc4random()%15+20];
		[self.view insertSubview:rain belowSubview:petRock.objectImage];
		NSMutableDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:rain,velocity,nil] forKeys:[NSArray arrayWithObjects:@"image",@"velocity",nil]];
		
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateRain:) userInfo:dict repeats:YES];
	}
}

- (void)animateRain:(NSTimer*)timer {
	NSDictionary *dict = [timer userInfo];
	UIImageView *rain = [dict objectForKey:@"image"];
	rain.center = CGPointMake(rain.center.x,rain.center.y+[[dict objectForKey:@"velocity"] intValue]);
	if(rain.center.y > 280) {	// remove rain when it hits the grass
		[rain removeFromSuperview];
		[timer invalidate];
	}
}

#pragma mark -
#pragma mark Music Animation
- (void)createMusicNotes:(BOOL)fromEndOfStage {
	int noteNumber = arc4random()%6+1; // generates a number from 1 - 6
	int randomX = fromEndOfStage ? arc4random()%40+480 : arc4random()%480;
	int randomY = arc4random()%175+75;
	
	UIImageView *musicNote = [HelperMethods createImageWithX:randomX andY:randomY andImage:[NSString stringWithFormat:@"musicNote%i.png",noteNumber]];
	float ratio = musicNote.image.size.height/20;
	musicNote.frame = CGRectMake(randomX, randomY, musicNote.image.size.width/ratio, 20);
	musicNote.alpha = .5+(arc4random()%3)*.1;

	[self.view insertSubview:musicNote belowSubview:petRock.objectImage];
	NSNumber *xVelocity = [NSNumber numberWithInt:arc4random()%2+1];
	NSNumber *yVelocity = [NSNumber numberWithInt:arc4random()%10+15];
	NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:musicNote,xVelocity,yVelocity,nil] forKeys:
						  [NSArray arrayWithObjects:@"image",@"x_velocity",@"y_velocity",nil]];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateMusic:) userInfo:dict repeats:YES];	
}

- (void)animateMusic:(NSTimer*)timer {
	NSDictionary *dict = [timer userInfo];
	UIImageView *musicNote = [dict objectForKey:@"image"];
	
	// if music is still playing then animate, otherwise destroy everything from the stage
	if(userMusicOn) {
		int xVelocity = [[dict objectForKey:@"x_velocity"] intValue];
		int yVelocity = -1*[[dict objectForKey:@"y_velocity"] intValue];
		musicNote.center = CGPointMake(musicNote.center.x-xVelocity,musicNote.center.y+yVelocity*sin(.5*(musicNote.center.x-xVelocity)));
		if(musicNote.center.x < 0) {
			[self createMusicNotes:YES];
			[musicNote removeFromSuperview];
			[timer invalidate];
		}
	} else {
		[musicNote removeFromSuperview];
		[timer invalidate];
	}
}

#pragma mark -
- (void)animationLoop {
	// grass algorithm, shears too much
	grassShearCounter++;
	if(grassShearCounter > grassMaxShear) {
		grassShearDirection *= -1;
		grassShearCounter = 0;
		grassMaxShear = rand()%750;
	}
	grass.transform = CGAffineTransformTranslate(grass.transform, -1*grassShearDirection*.05, 0);
	grass.transform = CGAffineTransformXShear(grass.transform, grassShearDirection*0.001);
	
	// cloud animations go here
	largeCloud.center = CGPointMake(largeCloud.center.x-largeCloudSpeed,largeCloud.center.y);
	smallCloud.center = CGPointMake(smallCloud.center.x-smallCloudSpeed,smallCloud.center.y);
	
	if(largeCloud.center.x+largeCloud.frame.size.width < 0) {
		largeCloud.center = CGPointMake(480+largeCloud.frame.size.width/2,largeCloud.center.y);
		largeCloudSpeed = (random()%3)*.1+.1;
	}
	
	if(smallCloud.center.x+smallCloud.frame.size.width < 0) {
		smallCloud.center = CGPointMake(480+smallCloud.frame.size.width/2,smallCloud.center.y);
		smallCloudSpeed = (random()%3)*.1+.1;	
	}	
	
	// GObject Physics
	// items on stage physics
	for(int i=0;i<itemsOnStage.count;i++) {
		GObject *gObject = [itemsOnStage objectAtIndex:i];
		if(gObject.wasDragged)
			[gObject updateGravityAnimation];
	}

	// manto gravity physics algorithm
	if(petRock.wasDragged && !petRock.currentlyAnimated) {
		[petRock updateGravityAnimation];
		
		if(petRock.floatingInClouds && !petRock.wasDragged) {
			// 25% chance of pet pooping because it gets scared when it is tossed beyond the clouds
			int poopProbability = arc4random()%4;
			if(poopProbability == 1)
				[self poopCycle];
			petRock.floatingInClouds = NO;
			AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
			[petRock changeHappiness:-1*(arc4random()%5+6)];
			[petRock changeHunger:-1*(arc4random()%5+6)];
			[petRock changeHygiene:-1*(arc4random()%5+6)];
			[self redraw];
		}
//		NSLog(@"manto's velocity: %f,%f - manto's x,y: %f,%f",mantoVelocity.x,mantoVelocity.y,mantoCurrentPosition.x,mantoCurrentPosition.y);
	}
}

#pragma mark -
#pragma mark Menu View Methods
- (IBAction)openCloseMenu:(id)sender {
	NSLog(@"shoppers inventory's %@:",self.petRock.inventoryView.consumableInventory);
	
	[HelperMethods playSound:@"click"];
	if(openCloseMenuButton.currentImage == [UIImage imageNamed:@"up_arrow.png"]) {
		[openCloseMenuButton setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal]; 
		menuView.center = CGPointMake(menuView.center.x,kMenuYClosed);
	} else {
		menuView.center = CGPointMake(menuView.center.x,kMenuYOpened);
		[openCloseMenuButton setImage:[UIImage imageNamed:@"up_arrow.png"] forState:UIControlStateNormal]; 
	}
}

#pragma mark JukeBox Methods
- (IBAction)playJukeBox:(id)sender {
//	[[Beacon shared] startSubBeaconWithName:@"Juke Box" timeSession:NO];
	[HelperMethods playSound:@"click"];

	if([musicPlayer nowPlayingItem] != nil) {
		[songTitleLabel removeFromSuperview];
		userMusicOn = NO;
		[musicPlayer stop];
	} else {
		songList = [MPMediaQuery songsQuery];
		NSArray *items = [songList items];
		NSUInteger itemCount = [items count];
	
		if (itemCount) {
			MPMediaItem *pickedItem = [items objectAtIndex:(random() % itemCount)];
			NSLog(@"media picked item");
			musicPlayer = [MPMusicPlayerController applicationMusicPlayer];

			[musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[NSArray arrayWithObject:pickedItem]]];
			NSLog(@"playing");
			[musicPlayer play];
			userMusicOn = YES; // crap i think i could of done musicPlayer isPlaying or something
		}

		// music animation, creates five music notes
		for(int i=0;i<5;i++)
			[self createMusicNotes:NO];
		
		// if it is not the iPhone Simulator than display the song title at the bottom left corner
		DeviceData *device = (DeviceData*)[(iDrewStuffAppDelegate*)[[UIApplication sharedApplication] delegate] device];
		if(![device.model isEqualToString:@"iPhone%20Simulator"]) {
			songTitleLabel = [HelperMethods createLabelWithX:10 andY:275 andWidth:200 andHeight:20 
								andText:[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle] andTextSize:14];
			[self.view addSubview:songTitleLabel];
		}
	}
}

#pragma mark Mini Games Method
- (IBAction)playMiniGames:(id)sender {
//	[[Beacon shared] startSubBeaconWithName:@"Mini-Games" timeSession:NO];
	[HelperMethods playSound:@"click"];
	
	if(miniGamesViewController == nil) {
		miniGamesViewController = [[MiniGamesViewController alloc] initWithNibName:@"MiniGamesView" bundle:[NSBundle mainBundle]];
		miniGamesViewController.pet = self.petRock;	
	} else
		[self.miniGamesViewController loadGames];
	
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	[rootViewController.view addSubview:miniGamesViewController.view];
}

#pragma mark Store Method
- (IBAction)gotoStore:(id)sender {
//	[[Beacon shared] startSubBeaconWithName:@"Market" timeSession:NO];
	[HelperMethods playSound:@"click"];
	
	// FIX: LOAD IN SEPARATE THREAD
	if(storeViewController == nil) {
		storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreView" bundle:[NSBundle mainBundle]];
		storeViewController.shopper = self.petRock;
	}
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	
	NSLog(@"what is my gamevc: %@",rootViewController.gameViewController);
	NSLog(@"what is my titlevc: %@",rootViewController.titleScreenViewController);
	
	[rootViewController.view addSubview:storeViewController.view];
}

#pragma mark ViewController Methods
- (void)redraw {
	[petRock.inventoryView drawInventory];
	[self drawStatBars];
	[self drawHealth];
}

- (void)drawHealth {
	int currentHealth = 0;
	
	if(healthView == nil) {
		// inits health aka hearts
		healthView = [UIImageView new];
		[self.view addSubview:healthView];
	} else
		currentHealth = [[healthView subviews] count];
	
	if(petRock.health < currentHealth) {
		for(int i=0;i<currentHealth-petRock.health;i++)
			[[[healthView subviews] objectAtIndex:[[healthView subviews] count] -1] removeFromSuperview];
	} else if(petRock.health > currentHealth) {
		// animate
		if(petRock.health == 4) {
			[petRock changeImage:@"manto_shy.png"];
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
			petRock.currentlyAnimated = YES;
		} else if(petRock.health == 5) {
			[petRock changeImage:@"manto_amative.png"];
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(defaultPetImage) userInfo:nil repeats:NO];
			petRock.currentlyAnimated = YES;
		}
		
		UIImage *heart = [UIImage imageNamed:@"heart.png"];
		CGRect frame = CGRectMake(20, 35, heart.size.width*petRock.health, heart.size.height);
		healthView.frame = frame;
		for(int i=currentHealth;i<petRock.health;i++) {
			int spacing = 4*i;
			UIImageView *tHeart = [[UIImageView alloc] initWithFrame:CGRectMake(i*heart.size.width+spacing,0,heart.size.width,heart.size.height)];
			tHeart.image = heart;
			[healthView addSubview:tHeart];
			[tHeart release];
		}
	}
}

// inits bars (andrew's fav place during this project)
- (void)drawStatBars {	
	// ***** happiness bar stats *****
	UIImage *hpyBarImg = [UIImage imageNamed:@"bar_happiness.png"];
	if(happinessBar == nil) {
		happinessBar = [[UIImageView alloc] initWithFrame:CGRectMake(happinessBarImageView.frame.origin.x,happinessBarImageView.frame.origin.y
																 ,hpyBarImg.size.width,hpyBarImg.size.height)];
		happinessBar.image = hpyBarImg;
		[self.view insertSubview:happinessBar belowSubview:happinessBarImageView];
	}
	happinessBar.frame = CGRectMake(happinessBar.frame.origin.x, happinessBar.frame.origin.y, 
									hpyBarImg.size.width*petRock.happiness/kMaxBarStats, hpyBarImg.size.height);
	
	int barXOffset = 3; // bad photoshop skills
	
	// **** hunger bar stats *****
	UIImage *hunBarImg = [UIImage imageNamed:@"bar_hunger.png"];
	if(hungerBar == nil) {
		//	[hunBarImg stretchableImageWithLeftCapWidth:2.0 topCapHeight:0];
		hungerBar = [[UIImageView alloc] initWithFrame:CGRectMake(barXOffset+hungerBarImageView.frame.origin.x,hungerBarImageView.frame.origin.y
																  ,hunBarImg.size.width,hunBarImg.size.height)];
		hungerBar.image = hunBarImg;
		[self.view insertSubview:hungerBar belowSubview:hungerBarImageView];
	}
	hungerBar.frame = CGRectMake(barXOffset+hungerBarImageView.frame.origin.x,hungerBarImageView.frame.origin.y,
								 hunBarImg.size.width*petRock.hunger/kMaxBarStats,hunBarImg.size.height);
	
	// ***** hygiene bar stats *****
	UIImage *hygBarImg = [UIImage imageNamed:@"bar_hygiene.png"];
	if(hygieneBar == nil) {
		//	[hygBarImg stretchableImageWithLeftCapWidth:2.0 topCapHeight:0];
		hygieneBar = [[UIImageView alloc] initWithFrame:CGRectMake(barXOffset+hygieneBarImageView.frame.origin.x,hygieneBarImageView.frame.origin.y
																   ,hygBarImg.size.width,hygBarImg.size.height)];
		hygieneBar.image = hygBarImg;
		[self.view insertSubview:hygieneBar belowSubview:hygieneBarImageView];
	}
	hygieneBar.frame = CGRectMake(barXOffset+hygieneBarImageView.frame.origin.x,hygieneBarImageView.frame.origin.y,
								  hygBarImg.size.width*petRock.hygiene/kMaxBarStats,hygBarImg.size.height);
}

- (void)initInventoryScrollView {
	inventoryView = [[UserInventory alloc] initWithFrame:CGRectMake(340, 293, 140, 32)];
	inventoryView.userInteractionEnabled = YES;
	inventoryView.multipleTouchEnabled = YES;
	inventoryView.delaysContentTouches = YES;
	inventoryView.showsHorizontalScrollIndicator = NO;
	inventoryView.consumableInventory = petRock.tempConsumableInventory;
	
	// comment this out if we are not using a scrollable view
	inventoryView.contentSize = CGSizeMake(inventoryView.consumableInventory.count*28,32);

	petRock.inventoryView = inventoryView;
	
	[self.view addSubview:inventoryView];
}

- (void)initItemsPreviouslyOnStageWithDictionary:(NSDictionary*)items {
	NSLog(@"%@",items);
	NSMutableArray *poopAry = [items objectForKey:@"poop"];
	for(NSDictionary *poop in poopAry) {
		[self addGObjectToStageWithName:@"Poop" andImage:@"poop.png" andScale:[[poop objectForKey:@"scale"] doubleValue] 
			andInFront:NO andPosition:[[poop objectForKey:@"x_coord"] doubleValue] andKey:-1];
		petRock.numNuggets += 1;
	}
	
	NSMutableArray *itemAry = [items objectForKey:@"items"];
	for(NSDictionary *item in itemAry) {
		for(StoreItem *sItem in petRock.inventoryView.consumableInventory) {
			if(sItem.key == [[item objectForKey:@"item_id"] intValue]) {
				sItem.showInInventory = NO;
				[self addGObjectToStageWithName:sItem.itemName andImage:sItem.imageName andScale:1 andInFront:YES 
					andPosition:[[item objectForKey:@"x_coord"] doubleValue] andKey:sItem.key];				
			}
		}
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self becomeFirstResponder];
	
	// inits the inventory scroll view programatically, transition away from xibs
	[self initInventoryScrollView];
	
	itemsOnStage = [NSMutableArray new];
	
	DeviceData *device = (DeviceData*)[(iDrewStuffAppDelegate*)[[UIApplication sharedApplication] delegate] device];
	if(![device.model isEqualToString:@"iPhone%20Simulator"]) {
		// inits the sound library
		// testing
//		MPMediaQuery *genres = [MPMediaQuery genresQuery];
//		for(MPMediaItem *song in genres.items) {
//			NSLog(@"song=>%@, genre=>%@",[song valueForProperty:MPMediaItemPropertyTitle],[song valueForProperty:MPMediaItemPropertyGenre]);
//		}
	}
	
	NSLog(@"Pet Rock's Name: %@, Health: %i",petRock.petName, petRock.health);
	[petRock setLeftPadding:-5 andRightPadding:20 andBottomPadding:15];
	
	// past 10 pm pet goes to sleep
	NSLog(@"date time: %@",[dateTimeWeather getTime]);
	if([[[dateTimeWeather getTime] objectForKey:@"hour"] intValue] >= 22) {
		petRock.asleep = YES;
		[petRock setImage:@"manto_asleep.png" withScale:1.0];
	} else
		[petRock setImage:@"manto_default.png" withScale:1.0];	
	petRock.wasDragged = YES;
	[self.view insertSubview:petRock.objectImage belowSubview:grass];
	
	// init currency
	ansalasLabel.text = [NSString stringWithFormat:@"%i",petRock.ansalas];
	
	// simulates real time poop
	int numPoop = [petRock adjustRealTimePoopCycle];
	for(int i=0;i<numPoop;i++) {
		float scaleFactor = (petRock.hunger/100)*.2;
		[self addGObjectToStageWithName:@"Poop" andImage:@"poop.png" andScale:scaleFactor andInFront:NO andPosition:arc4random()*420+40 andKey:-1];
		petRock.numNuggets += 1;
	}
	
	// init the items onto the stage
	[self initItemsPreviouslyOnStageWithDictionary:[petRock getDictionaryOfItemsPreviouslyOnStage]];
	
	// simualte real time stats
	[petRock adjustRealTimeStats];
	[self redraw];
	
	// init pet name w/ custom font
	[self.view addSubview:[HelperMethods createLabelWithX:20 andY:12 andWidth:150 andHeight:20 andText:petRock.petName andTextSize:26.0f]];
	
	// default closed menu position
	menuView.center = CGPointMake(menuView.center.x,kMenuYClosed);
	
	// probably not necessary to make a NSTimer object
	weatherChecker = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(checkTimeAndWeather:) userInfo:nil repeats:YES];
	
	// sets manto animation
	petAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(mantoAnimation:) userInfo:nil repeats:YES];
	
	// grass animation
	grassShearCounter = 0;
	grassShearDirection = 1;
	grassMaxShear = arc4random()%750;
	
	accelerometerActive = NO;
	largeCloudSpeed = smallCloudSpeed = 0.1;

	// custom alert test!!! TESTTTT
//	[HelperMethods alertWithTitle:@"Custom Title" andMessage:@"Welcome to Pet Wars! Created by Ricky Cheng." andTarget:self];
	
	// set accelerometer
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = self;
	accelerometer.updateInterval = kUpdateInterval;

	[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationLoop) userInfo:nil repeats:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemotrryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[songTitleLabel release];
	[petAnimationTimer release];
	[inventoryView release];
	[statsViewController release];
	[miniGamesViewController release];
	[ansalasLabel release];
	[ansalasView release];
	[healthView release];
	[happinessBar release];
	[hygieneBar release];
	[hungerBar release];
	[happinessBarImageView release];
	[hygieneBarImageView release];
	[hungerBarImageView release];
	[petRock release];
	[storeViewController release];
	[openCloseMenuButton release];
	[weatherChecker release];
	[dateTimeWeather release];
	[musicPlayer release];
	[songList release];
	[shoppingButton release];
	[minigamesButton release];
	[jukeboxButton release];
	[menuView release];
	[sunMoon release];
	[largeCloud release];
	[smallCloud release];
	[grass release];
    [super dealloc];
}

@end