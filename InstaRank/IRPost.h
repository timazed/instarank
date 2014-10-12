//
//  IRPost.h
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRPost : PFObject<PFSubclassing>

+(NSString*)parseClassName;

@property(retain)NSString *identifier;
@property(readonly)NSInteger likedCount;
@property(readonly)NSInteger notLikedCount;
@property(retain)NSString *imageUrl;

@end
