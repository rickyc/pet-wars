#import "CustomFontBase.h"

@implementation CustomFontBase

@synthesize curText;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// set defaults
		[self setBackgroundColor:[UIColor clearColor]];
		bgColor = [UIColor clearColor];
		[self setCurText: [NSMutableString stringWithString:@""] ];
		fontColor = [UIColor whiteColor];
		fontSize = 15;
		isGlowing = FALSE;
		[self setContentMode:UIViewContentModeTopLeft];  // make sure it doesn't scale/deform when setFrame is called 
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	// get context and flip for normal coordinates
	CGContextRef context =  UIGraphicsGetCurrentContext();
	CGContextTranslateCTM ( context, 0, self.bounds.size.height );
    CGContextScaleCTM ( context, 1.0, -1.0 );
	
	// Get the path to our custom font and create a data provider.
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:fontExtension];
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	// Create the font with the data provider, then release the data provider.
	CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
	CGDataProviderRelease(fontDataProvider); 
	// Set the customFont to be the font used to draw.
	CGContextSetFont(context, customFont);
	
	// prepare characters for printing
	NSString *theText = [NSString stringWithString: curText];
	int length = [theText length];
	unichar chars[length];
	CGGlyph glyphs[length];
	[theText getCharacters:chars range:NSMakeRange(0, length)];
	
	// draw bg
	if( bgColor != [UIColor clearColor] )
	{
		CGRect bgRect = CGRectMake (0, 0, self.bounds.size.width, self.bounds.size.height);
		CGContextSetFillColorWithColor( context, bgColor.CGColor );
		CGContextFillRect( context, bgRect );
	}
	
	// Set how the context draws the font, what color, how big.
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetFillColorWithColor(context, fontColor.CGColor );
	CGContextSetFontSize(context, fontSize);
	
	// set a glow?
	if( isGlowing ) {
		//CGContextSetShadow(context, CGSizeMake(0,0), 3 );
		CGContextSetShadowWithColor( context, CGSizeMake(0,0), 3, glowColor.CGColor );
	}
	
	// Loop through the entire length of the text.
	for (int i = 0; i < length; ++i) {
		// Store each letter in a Glyph and subtract the MagicNumber to get appropriate value.
		glyphs[i] = [theText characterAtIndex:i] + glyphOffset;
	}
	
	// draw the glyphs
	CGContextShowGlyphsAtPoint( context, 0, 0 + fontSize * .35, glyphs, length ); // hack the y-point to make sure it's not cut off below font baseline - this creates a perfect vertical fit
	
	// get width of text for autosizing the frame later (perhaps)
	CGPoint textEnd = CGContextGetTextPosition( context ); 
	autoSizeWidth = textEnd.x;
	
	// clean up the font
	CGFontRelease( customFont );
}


// call this after creating the LandscapeText object to set the styling
- (void)initTextWithSize:(float)size color:(UIColor*)color bgColor:(UIColor*)txtBgColor {
	// store font properties
	fontColor = color;
	fontSize = size;
	bgColor = txtBgColor;
	
	// autoscale height to font size
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, fontSize)];
}

// set new text to display
- (void)updateText:(NSString*)newText {
	[self setCurText: [NSString stringWithString:newText] ];
	[self setNeedsDisplay];
}

- (void)setGlow:(BOOL)glowing withColor:(UIColor*)color {
	glowColor = color;
	isGlowing = glowing;
}

- (void)autoSizeWidthNow {
	//printf( "autoSizeWidth = %f \n", autoSizeWidth );
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, autoSizeWidth, fontSize)];
}


- (void)dealloc {
	[curText release];
	[super dealloc];
}


@end