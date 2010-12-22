//
//  GObject.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGravity 2.2		// how fast it falls back down
#define kRestitution 0.3	// elasticity, 0.1 - 0.9
#define kFriction 0.9		// 0.1 - 0.9

#define kStageWidth 480
#define kStageHeight 320
#define kMenuBar 30

@interface GObject : NSObject {
	int key;
	
	int kLeftPadding;
	int kRightPadding;
	int kBottomPadding;
	float scale;
	
	CGPoint velocity;
	CGPoint oldPosition;
	CGPoint currentPosition;

	BOOL floatingInClouds;
	BOOL wasDragged;
	
	NSString *name;
	UIImageView *objectImage;
	UIImage *defaultImage;
	
	NSString *currentColor;
}

@property(nonatomic, assign) int key;
@property(nonatomic, assign) float scale;
@property(nonatomic, assign) int kLeftPadding;
@property(nonatomic, assign) int kRightPadding;
@property(nonatomic, assign) int kBottomPadding;

@property(nonatomic, assign) CGPoint velocity;
@property(nonatomic, assign) CGPoint oldPosition;
@property(nonatomic, assign) CGPoint currentPosition;

@property(nonatomic, assign) BOOL floatingInClouds;
@property(nonatomic, assign) BOOL wasDragged;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) UIImageView *objectImage;
@property(nonatomic, retain) NSString *currentColor;
@property(nonatomic, retain) UIImage *defaultImage;

- (void)setLeftPadding:(int)lPad andRightPadding:(int)rPad andBottomPadding:(int)bPad;
- (BOOL)objectBeingDragged:(CGPoint)newPosition;
- (BOOL)updateGravityAnimation;
- (void)setImage:(NSString*)imageName withScale:(float)scaleFactor;
- (void)setColor;
- (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor blendMode:(CGBlendMode)blend;
- (void)changeImage:(NSString*)imageName;
- (NSDictionary*)keyValueParser:(NSString*)str;
- (CGBlendMode)getBlend:(int)row;
- (void)changePaintSets:(NSDictionary*)colorStats;

@end
