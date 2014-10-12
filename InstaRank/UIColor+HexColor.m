//
//  UIColor+HexColor.m
//  Canvas
//
//  Created by Adam Muhlbauer on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    return [UIColor colorWithHexString:hex alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor whiteColor]; // default color if we have an error.
    
	NSString *colorString = [[hex stringByTrimmingCharactersInSet:
							  [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([colorString characterAtIndex:0] == '#')
	{
		colorString = [colorString substringFromIndex:1];
	}
	
	if ([colorString length] == 6)
	{
		unsigned int rgbValue;
		[[NSScanner scannerWithString:colorString] scanHexInt:&rgbValue];
		color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
								green:((float)((rgbValue & 0xFF00) >> 8))/255.0
								 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
        
	}
    
	return color;
}

@end
