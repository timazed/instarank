//
//  IRInstaPost.h
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRInstaPost : NSObject
{
    NSString *_identifier;
    NSURL *_imageUrl;
}

@property(retain)NSString *identifier;
@property(retain)NSURL *imageUrl;

@end
