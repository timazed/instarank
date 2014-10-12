//
//  JMImageView.m
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import "IRInstaPostView.h"
#import "IRInstaPost.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface IRInstaPostView ()

@property(nonatomic) UIImageView *imageView;

@end

@implementation IRInstaPostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor grayColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark - Property Setters

- (void)setPost:(IRInstaPost *)post
{
    _post = post;
    [self.imageView setImageWithURL: post.imageUrl placeholderImage:[UIImage imageWithColor:[UIColor grayColor] frame:self.bounds]];
}

-(IRInstaPost*)post
{
    return _post;
}

-(UIImage*)image
{
    return self.imageView.image;
}

@end
