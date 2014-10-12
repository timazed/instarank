//
//  UIColor+HexColor.h
//  Canvas
//
//  Created by Adam Muhlbauer on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface UIColor (HexColor)

// create a UIColor from a given representative hex colour string
+ (UIColor *)colorWithHexString: (NSString *)hex;
+ (UIColor *)colorWithHexString: (NSString *)hex alpha:(CGFloat)alpha;

@end
