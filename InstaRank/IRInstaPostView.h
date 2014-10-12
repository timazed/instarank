//
//  JMImageView.h
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRInstaPost;
@interface IRInstaPostView : UIControl
{
    IRInstaPost *_post;
}

@property(retain)IRInstaPost *post;
@property(readonly)UIImage *image;

@end
