//
//  IRPost.m
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import "IRPost.h"
#import <Parse/PFObject+Subclass.h>

@implementation IRPost

@dynamic identifier;
@dynamic imageUrl;
@dynamic likedCount;
@dynamic notLikedCount;


+(NSString*)parseClassName
{
    return @"InstaRankPost";
}

@end
