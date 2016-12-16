//
//  FeedStore.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XmlModel;

@interface FeedStore : NSObject

+ (NSMutableArray *)defaultModelsArray;

//- (BOOL)getAtomDescriptionWith:(FeedModel *)model;

- (XmlModel *)setModelWithData:(NSData *)data WithModel:(XmlModel *)xmlModel;
@end
