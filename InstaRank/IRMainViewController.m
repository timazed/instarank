//
//  ViewController.m
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import "IRMainViewController.h"
#import "IRInstagramClient.h"
#import "IRInstaPost.h"
#import "IRInstaPostView.h"
#import <POP/POP.h>

typedef struct {
    CGFloat progress;
    CGFloat toValue;
    CGFloat currentValue;
} AnimationInfo;

typedef enum {
    kLiked,
    kNotLiked,
    kDoNothing
} Action;

@interface IRMainViewController ()

- (void)touchDown:(UIControl *)sender;
- (void)touchUpInside:(UIControl *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)scaleDownView:(UIView *)view;
- (void)scaleUpView:(UIView *)view;
- (void)pauseAllAnimations:(BOOL)pause forLayer:(CALayer *)layer;
- (AnimationInfo)animationInfoForLayer:(CALayer *)layer;

@end

@implementation IRMainViewController

#define kPadding 20
#define kNavBarHeight 64

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO Calcuate a better anchor point.
    CGFloat height = CGRectGetWidth(self.view.bounds) - kPadding;
    _anchorPoint = CGPointMake(self.view.center.x, self.view.center.y - height/3);
    _initialLoad = YES;
    _imageViews = [NSMutableArray arrayWithCapacity:3];
    //setup three images.
    [_imageViews addObject:[self imageView]];
    [_imageViews addObject:[self imageView]];
    [_imageViews addObject:[self imageView]];
    
    for (int i=(int)_imageViews.count-1; i>= 0; i--)
    {
        [self.view addSubview:[_imageViews objectAtIndex:i]];
    }

    [self loadImages];
    [self.navigationController.navigationBar applyTheme];
}


-(void)loadImages
{
    [[IRInstagramClient defaultClient] fetchMostPopularSuccess:^(NSArray *posts) {
        _instaPostInderator = [posts objectEnumerator];
        for (IRInstaPostView *imageView in _imageViews)
        {
            IRInstaPost *post = [_instaPostInderator nextObject];
            [imageView setPost:post];
            [self scaleDownView:imageView];
        }
    } failure:^(NSInteger code) {
        //TODO.
    }];
}

-(void)showNext
{
    IRInstaPost *post = [_instaPostInderator nextObject];
    if (post != nil)
    {
        [[_imageViews lastObject] setPost:post];
    }
    else
    {
        [self loadImages];
    }
}


-(IBAction)liked:(id)sender
{
    IRInstaPostView *view = [_imageViews firstObject];
    [self performActionOnView: view
                 withVelocity: CGPointMake(0, 0)
                   toPosition:CGPointMake(CGRectGetWidth(self.view.frame) + CGRectGetWidth(view.frame),  view.center.y)
                       action:kLiked];
}

-(IBAction)notLiked:(id)sender
{
    IRInstaPostView *view = [_imageViews firstObject];
    [self performActionOnView: view
                 withVelocity: CGPointMake(0, 0)
                   toPosition: CGPointMake(-(CGRectGetWidth(self.view.frame) + CGRectGetWidth(view.frame)), view.center.y)
                       action:kNotLiked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Instance methods

-(IRInstaPostView*)imageView
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePan:)];
    
    CGFloat width = CGRectGetWidth(self.view.bounds) - kPadding;
    CGFloat height = width;
    IRInstaPostView *imageView = [[IRInstaPostView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.center = _anchorPoint;
    [imageView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [imageView addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addGestureRecognizer:recognizer];
    return imageView;
}

- (void)touchDown:(UIControl *)sender
{
    [self pauseAllAnimations:YES forLayer:sender.layer];
    [self scaleUpView:sender];
}

- (void)touchUpInside:(UIControl *)sender
{
    [sender.layer pop_removeAllAnimations];
    [self scaleDownView:sender];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([self hasLiked:recognizer.view])
        {
            [self performActionOnView: (IRInstaPostView*)recognizer.view
                         withVelocity: [recognizer velocityInView:self.view]
                           toPosition:CGPointMake(CGRectGetWidth(self.view.frame) + CGRectGetWidth(recognizer.view.frame),
                                                                               CGRectGetMaxY(recognizer.view.frame))
                   action:kLiked];
        }
        else if([self hasNotLiked:recognizer.view])
        {
            
            [self performActionOnView: (IRInstaPostView*)recognizer.view
              withVelocity: [recognizer velocityInView:self.view]
                toPosition: CGPointMake(-(CGRectGetWidth(self.view.frame) + CGRectGetWidth(recognizer.view.frame)),
                                                                               CGRectGetMinY(recognizer.view.frame))
                   action:kNotLiked];
        }
        else
        {
            [self performActionOnView: (IRInstaPostView*)recognizer.view
                         withVelocity: [recognizer velocityInView:self.view]
                           toPosition:_anchorPoint
                               action:kDoNothing];
        }
    }
}

-(void)performActionOnView:(IRInstaPostView*)view withVelocity:(CGPoint)velocity toPosition:(CGPoint)position action:(Action)action
{
    if (action != kDoNothing)
    {
        [_imageViews removeObject:view];
    }
    
    if (action == kLiked)
    {
        [PFCloud callFunctionInBackground:@"likePost" withParameters:@{@"postId":view.post.identifier, @"imageUrl":view.post.imageUrl.absoluteString} block:^(id object, NSError *error) {
            //TODO:
        }];
    }
    else if (action == kNotLiked)
    {
        [PFCloud callFunctionInBackground:@"notLikePost" withParameters:@{@"postId":view.post.identifier, @"imageUrl":view.post.imageUrl.absoluteString} block:^(id object, NSError *error) {
            //tODO
        }];
    }
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
    positionAnimation.dynamicsTension = 50.f;
    positionAnimation.dynamicsFriction = 10.0f;
    positionAnimation.springBounciness = 12.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:position];
    [view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    
    
    [positionAnimation setCompletionBlock:^(POPAnimation *ainmation, BOOL finished) {
        if (action != kDoNothing)
        {
            //TODO: This is super inefficient, you should NEVER remove from the head dont' have time to write a double ended LinkedList
            [self.view sendSubviewToBack:view];
            view.center = _anchorPoint;
            [_imageViews addObject:view];
            
            //this is a bit dirty but running short on time
            [self.view sendSubviewToBack:_likedButton];
            [self.view sendSubviewToBack:_notLikedButton];
            
            [self showNext];
        }
    }];
    
    [self scaleDownView:view];
}

-(BOOL)hasLiked:(UIView*)view
{
    // if 1 3rd is off the screen the action is deemed true
    CGFloat distance = CGRectGetWidth(view.frame) / 3;
    return (CGRectGetMaxX(view.frame) >= CGRectGetWidth(self.view.frame) + distance);
}

-(BOOL)hasNotLiked:(UIView*)view
{
    // if 1 3rd is off the screen the action is deemed true
    CGFloat distance = CGRectGetWidth(view.frame) / 3;
    return (view.frame.origin.x < 0 && view.frame.origin.x <= -distance);
}

-(void)scaleUpView:(UIView *)view
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:_anchorPoint];
    [view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.springBounciness = 10.f;
    [view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)scaleDownView:(UIView *)view
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    scaleAnimation.springBounciness = 10.f;
    [view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)pauseAllAnimations:(BOOL)pause forLayer:(CALayer *)layer
{
    for (NSString *key in layer.pop_animationKeys)
    {
        POPAnimation *animation = [layer pop_animationForKey:key];
        [animation setPaused:pause];
    }
}

- (AnimationInfo)animationInfoForLayer:(CALayer *)layer
{
    POPSpringAnimation *animation = [layer pop_animationForKey:@"scaleAnimation"];
    CGPoint toValue = [animation.toValue CGPointValue];
    CGPoint currentValue = [[animation valueForKey:@"currentValue"] CGPointValue];
    
    CGFloat min = MIN(toValue.x, currentValue.x);
    CGFloat max = MAX(toValue.x, currentValue.x);
    
    AnimationInfo info;
    info.toValue = toValue.x;
    info.currentValue = currentValue.x;
    info.progress = min / max;
    return info;
}


@end
