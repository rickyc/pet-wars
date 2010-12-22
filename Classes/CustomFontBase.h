/*
 *
 */

@interface CustomFontBase : UIView {
	NSMutableString *curText;
	UIColor *fontColor;
	UIColor *bgColor;
	int fontSize;
	NSString *fontName;
	NSString *fontExtension;
	float autoSizeWidth;
	int glyphOffset;
	BOOL isGlowing;
	UIColor *glowColor;
}

- (void)updateText:(NSString*)newText;
- (void)initTextWithSize:(float)size color:(UIColor*)color bgColor:(UIColor*)bgColor;
- (void)setGlow:(BOOL)glowing withColor:(UIColor*)color;
- (void)autoSizeWidthNow;

@property (nonatomic, retain) NSMutableString *curText;

@end