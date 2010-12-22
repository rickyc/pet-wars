#import "CompleteInHimFont.h"

@implementation CompleteInHimFont

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		fontName = @"CompleteinHim";
		fontExtension = @"ttf";
		glyphOffset = -29;        // adjust this offset per font until it prints the proper characters
    }
    return self;
}

- (void)createLabel:(NSString*)text {
	[self initTextWithSize:26.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[self updateText:text];
}

- (void)createLabel:(NSString*)text withTextSize:(float)tSize {
	[self initTextWithSize:tSize color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[self updateText:text];
}

- (void)dealloc {
    [super dealloc];
}

@end