#import "CustomFontBase.h"

@interface CompleteInHimFont : CustomFontBase { }

- (void)createLabel:(NSString*)text;
- (void)createLabel:(NSString*)text withTextSize:(float)tSize;

@end