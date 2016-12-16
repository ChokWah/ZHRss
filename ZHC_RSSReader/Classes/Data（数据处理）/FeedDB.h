//
//  FeedDB.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/28.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XmlModel;
@class RACSignal;
@interface FeedDB : NSObject

+ (instancetype)shareDB;

// 插入模型到数据库，插入完成发送模型的fid
- (RACSignal *)insertWithXmlModel:(XmlModel *)xmlmodel;

// 返回一个信号，更新完成之后发送信号，不用block回调
//- (void)getAllFeeds:(void (^)(NSArray *))result;
- (RACSignal *)getAllFeeds;

- (RACSignal *)queryFeedWithName:(NSString *)name;
@end
