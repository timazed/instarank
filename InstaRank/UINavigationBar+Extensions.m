//
//  UINavigationBar+UtilMethods.m
//  loggit
//
//  Created by Timothy Zelinsky on 18/09/13.
//  Copyright (c) 2013 Timothy Zelinsky. All rights reserved.
//

#import "UINavigationBar+Extensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (Extensions)

-(void)applyTheme
{
    UIImage *color = [UIImage imageWithColor:[UIColor colorWithHexString:kNavBarBackgroundColor]
                                       frame:CGRectMake(0, 0, 1, 1)];
//    [self setTintColor: [UIColor colorWithHexString:kMenuButtonColor]];
    UIFont *font = [UIFont fontWithName:kLogoFontName size:kLogoFontSize];
    self.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:font};

    UIImage *line = [UIImage imageWithColor:[UIColor whiteColor]
                                      frame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1)];

    
    [self setBackgroundColor:[UIColor colorWithHexString:kNavBarBackgroundColor]];
    [self setBackgroundImage: color forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:line];

}

@end
