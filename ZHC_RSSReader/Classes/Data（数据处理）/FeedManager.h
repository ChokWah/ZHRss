//
//  FeedManager.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XmlModel;
@class FeedModel;
@class RACSignal;

@interface FeedManager : NSObject

@property (nonatomic, strong) NSMutableArray *feedmodels;

+ (instancetype)defaultManager;

- (RACSignal *)fetchAllFeedsModel:(NSMutableArray *)models;

- (BOOL)getAtomDescriptionWith:(FeedModel *)model;

@end
