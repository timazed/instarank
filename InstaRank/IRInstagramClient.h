//
//  InstagramClient.h
//  InstaRank
//
//  Created by Timothy Zelinsky on 11/10/2014.
//  Copyright (c) 2014 zelinsky. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface IRInstagramClient : AFHTTPSessionManager

+(instancetype)defaultClient;

-(void)fetchMostPopularSuccess:(void (^)(NSArray *))success failure:(void(^)(NSInteger))failure;

@end
