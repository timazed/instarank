//
//  ViewController.h
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRInstagramPostView, CKLinkedList;
@interface IRMainViewController : UIViewController
{
    IBOutlet UILabel *_likedLabel;
    IBOutlet UILabel *_notLikedLabel;
    CGPoint _anchorPoint;
    
    NSMutableArray *_imageViews;
    
    IBOutlet UIButton *_likedButton;
    IBOutlet UIButton *_notLikedButton;
    
    NSEnumerator *_instaPostInderator;
    NSUInteger _postCount;
    
    BOOL _initialLoad;
}

@end

