//
//  GObject.m
//  Pet Wars
//
//	Generic Gravity Object
//	
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "GObject.h"

@implementation GObject
@synthesize velocity, oldPosition, currentPosition, name, objectImage, floatingInClouds, wasDragged, kLeftPadding, kRightPadding, 
kBottomPadding, currentColor, defaultImage, scale, key;

- (id)init {
	floatingInClouds = NO;
	wasDragged = NO;
	
	return self;
}

- (void)setLeftPadding:(int)lPad andRightPadding:(int)rPad andBottomPadding:(int)bPad {
	self.kLeftPadding = lPad;
	self.kRightPadding = rPad;
	self.kBottomPadding = bPad;
}

- (BOOL)objectBeingDragged:(CGPoint)newPosition {
	objectImage.center = CGPointMake(newPosition.x,newPosition.y);
	
	float radius_w = objectImage.frame.size.width/2;
	float radius_h = objectImage.frame.size.height/2;
	
	if(objectImage.center.x < radius_w+kLeftPadding)
		objectImage.center = CGPointMake(radius_w+kLeftPadding,objectImage.center.y);
	else if(objectImage.center.x > kStageWidth-radius_w+kRightPadding)
		objectImage.center = CGPointMake(kStageWidth-radius_w+kRightPadding,objectImage.center.y);
	
	if(objectImage.center.y > kStageHeight-kMenuBar-radius_h+kBottomPadding)
		objectImage.center = CGPointMake(objectImage.center.x,kStageHeight-kMenuBar-radius_h+kBottomPadding);		
	
	// drag the object
	oldPosition = currentPosition;
	currentPosition = newPosition;
	
	velocity = CGPointMake((currentPosition.x-oldPosition.x)/2,(currentPosition.y-oldPosition.y));
	
	return NO;
}

- (BOOL)updateGravityAnimation {
	velocity = CGPointMake(velocity.x,velocity.y+kGravity);
	currentPosition = CGPointMake(currentPosition.x+velocity.x,currentPosition.y+velocity.y);
	
	float radius_w = objectImage.frame.size.width/2;
	float radius_h = objectImage.frame.size.height/2;
	
	if(currentPosition.y + radius_h > kStageHeight-kMenuBar+kBottomPadding) {
		currentPosition.y = kStageHeight-kMenuBar-radius_h+kBottomPadding;
		velocity = CGPointMake(kFriction*velocity.x,kRestitution*-1*velocity.y);
	}
//	NSLog(@"hello? %f",currentPosition.x+radius_w);
	if(currentPosition.x + radius_w > kStageWidth) {
		currentPosition = CGPointMake(kStageWidth-radius_w+kRightPadding,currentPosition.y);
		velocity = CGPointMake(kRestitution*-1*velocity.x,velocity.y);
	}
	if(currentPosition.x < radius_w) {
		currentPosition = CGPointMake(radius_w+kLeftPadding,currentPosition.y);
		velocity = CGPointMake(kRestitution*-1*velocity.x,velocity.y);
	}
	
	objectImage.center = currentPosition;
	
	// vibration feature only occurs when manto is thrown above the clouds & off the screen
	if(currentPosition.y + radius_h < 0)
		floatingInClouds = YES;
	
	// no velocity and back on the ground, manto stopped bouncing
	if((int)velocity.x == 0 && (int)velocity.y == 0 && objectImage.center.y == 305-radius_w) {
		wasDragged = NO;
	}
	
	return NO;
}

- (NSDictionary*)keyValueParser:(NSString*)str {
	NSMutableDictionary *statsDict = [[NSMutableDictionary new] autorelease];
	NSArray *ary = [str componentsSeparatedByString:@","];
	for(int i=0;i<ary.count;i++) {
		NSArray *keyval = [[ary objectAtIndex:i] componentsSeparatedByString:@":"];
		[statsDict setObject:[keyval objectAtIndex:1] forKey:[keyval objectAtIndex:0]];
	}
	return statsDict;
}

-(void)setImage:(NSString*)imageName withScale:(float)scaleFactor {
	UIImage *img = [UIImage imageNamed:imageName];
	objectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width*scaleFactor, img.size.height*scaleFactor)];
	objectImage.userInteractionEnabled = YES;
	objectImage.image = img;
	defaultImage = img;
	scale = scaleFactor;
	[self setColor];
}

-(void)changeImage:(NSString*)imageName {
	if([UIImage imageNamed:imageName] != objectImage.image) {
		objectImage.image = [UIImage imageNamed:imageName];
		[self setColor];
	}
}

-(void)setColor {
	NSDictionary *colorStats = [self keyValueParser:currentColor];
	
	int type = [[colorStats objectForKey:@"t"] intValue];
	float r = [[colorStats objectForKey:@"r"] floatValue];
	float g = [[colorStats objectForKey:@"g"] floatValue];
	float b = [[colorStats objectForKey:@"b"] floatValue];
	float a = [[colorStats objectForKey:@"a"] floatValue];

	//			NSLog(@"rgba, %f, %f, %f, %f",r,g,b,a);
	if(type != 0)
		objectImage.image = [self colorizeImage:objectImage.image color:[UIColor colorWithRed:r green:g blue:b alpha:a] blendMode:[self getBlend:type]];
}

- (void)changePaintSets:(NSDictionary*)colorStats {
	int type = [[colorStats objectForKey:@"t"] intValue];
	
	// type 28 is random color
	if(type == 28) {
		float r = (arc4random()%1000000)*.000001;
		float g = (arc4random()%1000000)*.000001;
		float b = (arc4random()%1000000)*.000001;
		float a = (arc4random()%700000)*.000001+.3;
		int type = (int)arc4random()%27+1; // 1 - 27 only
		self.currentColor = [NSString stringWithFormat:@"r:%f,g:%f,b:%f,a:%f,t:%i",r,g,b,a,type];
		NSLog(@"asdf - %@",currentColor);
		objectImage.image = [self colorizeImage:self.defaultImage color:[UIColor colorWithRed:r green:g blue:b alpha:a] blendMode:[self getBlend:type]];
	} else {
		float r = [[colorStats objectForKey:@"r"] floatValue];
		float g = [[colorStats objectForKey:@"g"] floatValue];
		float b = [[colorStats objectForKey:@"b"] floatValue];
		float a = [[colorStats objectForKey:@"a"] floatValue];
		
		objectImage.image = [self colorizeImage:self.defaultImage color:[UIColor colorWithRed:r green:g blue:b alpha:a] blendMode:[self getBlend:type]];
	}
}

- (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor blendMode:(CGBlendMode)blend {
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, blend);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(CGBlendMode)getBlend:(int)row {
	CGBlendMode blend;
	
	switch(row) {
		case 0:		blend = kCGBlendModeNormal;			break;
		case 1: 	blend = kCGBlendModeMultiply;		break;
		case 2: 	blend = kCGBlendModeScreen;			break;
		case 3: 	blend = kCGBlendModeOverlay;		break;
		case 4: 	blend = kCGBlendModeDarken;			break;
		case 5: 	blend = kCGBlendModeLighten;		break;
		case 6: 	blend = kCGBlendModeColorDodge;		break;
		case 7: 	blend = kCGBlendModeColorBurn;		break;
		case 8: 	blend = kCGBlendModeSoftLight;		break;
		case 9: 	blend = kCGBlendModeHardLight;		break;
		case 10: 	blend = kCGBlendModeDifference;		break;
		case 11: 	blend = kCGBlendModeExclusion;		break;
		case 12: 	blend = kCGBlendModeHue;			break;
		case 13: 	blend = kCGBlendModeSaturation;		break;
		case 14: 	blend = kCGBlendModeColor;			break;
		case 15: 	blend = kCGBlendModeLuminosity;		break;
		case 16: 	blend = kCGBlendModeClear;			break;
		case 17: 	blend = kCGBlendModeCopy;			break;
		case 18: 	blend = kCGBlendModeSourceIn;		break;
		case 19: 	blend = kCGBlendModeSourceOut;		break;
		case 20: 	blend = kCGBlendModeSourceAtop;		break;
		case 21: 	blend = kCGBlendModeDestinationOver;break;
		case 22: 	blend = kCGBlendModeDestinationIn;	break;
		case 23: 	blend = kCGBlendModeDestinationOut;	break;
		case 24: 	blend = kCGBlendModeDestinationAtop;break;
		case 25: 	blend = kCGBlendModeXOR;			break;
		case 26: 	blend = kCGBlendModePlusDarker;		break;
		case 27: 	blend = kCGBlendModePlusLighter;	break;
	}
	return blend;
}

@end