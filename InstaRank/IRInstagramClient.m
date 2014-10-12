//
//  InstagramClient.m
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import "IRInstagramClient.h"
#import "IRInstaPost.h"

@implementation IRInstagramClient

static IRInstagramClient *_client = nil;
static dispatch_once_t onceToken;

#define kClientToken @"6b6fd97d269145a1b109a56957aa365b"

+(instancetype)defaultClient
{
    dispatch_once(&onceToken, ^{
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
        NSString *serviceUrl = @"https://api.instagram.com";
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setURLCache:URLCache];
        _client = [[IRInstagramClient alloc] initWithBaseURL:[NSURL URLWithString:serviceUrl] sessionConfiguration:config];
    });
    
    return _client;
}

-(void)fetchMostPopularSuccess:(void (^)(NSArray *))success failure:(void(^)(NSInteger))failure
{
    //https://api.instagram.com/v1/media/popular?client_id=CLIENT-ID
    [self GET:@"v1/media/popular" parameters:@{@"client_id": kClientToken} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /// TODO: MOVE THIS OFF THE MAIN THREAD.
        
        if ([responseObject[@"meta"][@"code"] integerValue] != 200)
        {
            failure([responseObject[@"meta"][@"code"] integerValue]);
        }
        else
        {
            NSArray *items = responseObject[@"data"];
            NSMutableArray *instaPosts = [NSMutableArray arrayWithCapacity:items.count];
            for (NSDictionary *item in items)
            {
                IRInstaPost *post = [[IRInstaPost alloc] init];
                post.identifier = item[@"id"];
                post.imageUrl = [NSURL URLWithString: item[@"images"][@"standard_resolution"][@"url"]];
                [instaPosts addObject:post];
            }
            
            success(instaPosts);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(-1);
    }];
}

@end
