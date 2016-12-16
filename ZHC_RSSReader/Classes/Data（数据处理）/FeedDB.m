//
//  FeedDB.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/28.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "FeedDB.h"
#import "FMDB.h"
#import "XmlModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FeedDB ()

@property (nonatomic, copy) NSString *sqlPath;

@end

@implementation FeedDB

#pragma mark - 初始化
static FeedDB *db;
+ (instancetype)shareDB{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        db = [[self alloc]init];
    });
    return db;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _sqlPath = [ZHdocumentPath stringByAppendingPathComponent:@"feeds.sqlite"];
        if (![ZHFILEMANAGER fileExistsAtPath:_sqlPath]) { // 创建库

            FMDatabase *db = [FMDatabase databaseWithPath:_sqlPath];
            if ([db open]) {
                
                // 创建表
                NSString *createSql = @"create table feeds (fid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, title text, subtitle text, lastUpdateDate text, generator text, rssDescription text, link text, copyright text, imageUrl text, feedUrl text, unreadCount integer)";
                [db executeUpdate:createSql];
                
                NSString *createItemSql = @"create table feeditem (iid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,fid integer, link text, title text, summary text, category text, updatedDate text, authorName text, feedDescription blob, isRead integer)";
                [db executeUpdate:createItemSql];
            }
        }
    }
    return self;

}

#pragma mark - 数据库增删改
- (RACSignal *)insertWithXmlModel:(XmlModel *)xmlmodel{
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.sqlPath];
        if ([db open]) {
            
            int fid = 0;
            FMResultSet *rsl = [db executeQuery:@"select fid from feeds where feedurl = ?",xmlmodel.feedUrl];
            if (![rsl next]) {
                
                [db executeUpdate:@"insert into feeds (title, subtitle, lastUpdateDate, generator, rssDescription, link, copyright, imageUrl, feedUrl, unreadCount) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", xmlmodel.title, xmlmodel.subtitle, xmlmodel.lastUpdateDate, xmlmodel.generator, xmlmodel.rssDescription, xmlmodel.link, xmlmodel.copyright, xmlmodel.imageUrl, xmlmodel.feedUrl, xmlmodel.unreadCount];
                FMResultSet *fidRsl = [db executeQuery:@"select fid from feeds where feedurl = ?",xmlmodel.feedUrl];
                NSLog(@"=%@",xmlmodel);
                if ([fidRsl next]) {
                    fid = [fidRsl intForColumn:@"fid"];
                }
                
            }else{
                
                fid = [rsl intForColumn:@"fid"];
            }
            
            // 添加feeditem
            if (xmlmodel.modelArray.count > 0) {
                
                for (FeedModel *feedmodel in xmlmodel.modelArray) {
                    
                    FMResultSet *iRsl = [db executeQuery:@"select iid from feeditem where link = ?",feedmodel.link];
                    if (![iRsl next]) {
                        
                        [db executeUpdate:@"insert into feeditem (link, title, summary, category, updatedDate, authorName,  feedDescription, isRead, fid) values (?, ?, ?, ?, ?, ?, ?, ?, ?)",feedmodel.link, feedmodel.title, feedmodel.summary, feedmodel.category, feedmodel.updatedDate, feedmodel.authorName, feedmodel.feedDescription, @0, @(fid)];
                        [db executeUpdate:@"update feeds set lastUpdateDate = ? where fid = ?",@(time(NULL)),@(fid)];
                    }
                }
            }
            // 读取未读item数
            FMResultSet *uRsl = [db executeQuery:@"select iid from feeditem where fid = ? and isread = ?",@(fid), @0];
            NSUInteger count = 0;
            while ([uRsl next]) {  count++; }
            xmlmodel.unreadCount = count;
            
            // 更新到数据库
            [db executeUpdate:@"update feeds set title = ?, subtitle = ?, lastUpdateDate = ?, generator = ?, rssDescription = ?, link = ?, copyright = ?, imageUrl = ?, unreadCount = ? where fid = ? ",xmlmodel.title, xmlmodel.subtitle, xmlmodel.lastUpdateDate, xmlmodel.generator, xmlmodel.rssDescription, xmlmodel.link, xmlmodel.copyright, xmlmodel.imageUrl, @(count), @(fid)];
            // 发送通知
            [subscriber sendNext:@(fid)];
            [subscriber sendCompleted];
            [db close];
        }
        return nil;
    }];
}

- (RACSignal *)getAllFeeds{
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.sqlPath];
        NSMutableArray *arrResult = [NSMutableArray array];
        if ([db open]) {
            
            FMResultSet *rsl = [db executeQuery:@"select * from feeds"]; // 按照时间排序 order by lastUpdateDate desc
            NSUInteger count = 0;
            while ([rsl next]) {
                
                XmlModel *model = [[XmlModel alloc]initWithTitle:[rsl stringForColumn:@"title"] andLink:[rsl stringForColumn:@"link"]];
                model.subtitle = [rsl stringForColumn:@"subtitle"];
                model.lastUpdateDate = [rsl stringForColumn:@"lastUpdateDate"];
                model.generator = [rsl stringForColumn:@"generator"];
                model.rssDescription = [rsl stringForColumn:@"rssDescription"];
                model.copyright = [rsl stringForColumn:@"copyright"];
                model.imageUrl = [rsl stringForColumn:@"imageUrl"];
                model.feedUrl = [rsl stringForColumn:@"feedUrl"];
                model.xID = [[rsl stringForColumn:@"fid"] integerValue];
                model.unreadCount = [rsl intForColumn:@"unreadCount"];
                [arrResult addObject:model];
                count++;
            }
            [subscriber sendNext:arrResult];//发送信号内容
            [subscriber sendCompleted];
            [db close];
        }
        return nil;
    }];
}


- (RACSignal *)queryFeedWithName:(NSString *)name{
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.sqlPath];
        if ([db open]) {
        
            FMResultSet *rsl = [db executeQuery:@"select * from feeds where title = ?;",name];
            
            if ([rsl next]) {// 查询到
                
                XmlModel *model = [[XmlModel alloc]initWithTitle:[rsl stringForColumn:@"title"] andLink:[rsl stringForColumn:@"link"]];
                model.subtitle = [rsl stringForColumn:@"subtitle"];
                model.lastUpdateDate = [rsl stringForColumn:@"lastUpdateDate"];
                model.generator = [rsl stringForColumn:@"generator"];
                model.rssDescription = [rsl stringForColumn:@"rssDescription"];
                model.copyright = [rsl stringForColumn:@"copyright"];
                model.imageUrl = [rsl stringForColumn:@"imageUrl"];
                model.feedUrl = [rsl stringForColumn:@"feedUrl"];
                model.xID = [[rsl stringForColumn:@"fid"] integerValue];
                model.unreadCount = [rsl intForColumn:@"unreadCount"];
                [subscriber sendNext:model];//发送信号
                
            }else{
                [subscriber sendNext:@"no"];//发送信号
            }
            [subscriber sendCompleted];
            [db close];
        }
        return nil;
    }];
}

@end
