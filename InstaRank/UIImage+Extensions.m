//
//  UIImage+UtilMethods.m
//  mylife
//
//  Created by Timothy Zelinsky on 11/09/13.
//  Copyright (c) 2013 Timothy Zelinsky. All rights reserved.
//

#import "UIImage+Extensions.h"
@implementation UIImage (Extensions)

#define kDownloadImageQueue "com.loggitapp.image.download.queue"

+(UIImage*)imageWithColor:(UIColor *)color frame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
