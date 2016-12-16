//
//  FeedStore.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "FeedStore.h"
#import "XmlModel.h"
#import "AFNetworking.h"
#import "Ono.h"
#import "FeedDB.h"


//http://feed.cnblogs.com/blog/sitehome/rss
//https://36kr.com/feed
//https://www.zhihu.com/rss
//http://www.ifanr.com/feed
//http://www.geekpark.net/rss

@implementation FeedStore

+ (NSMutableArray *)defaultModelsArray{
    
    NSMutableArray *defaultFeedsArr = [NSMutableArray array];
    
    [defaultFeedsArr addObject:[[XmlModel alloc]initWithTitle:@"博客园精选" andLink:@"http://feed.cnblogs.com/blog/sitehome/rss"]];
    [defaultFeedsArr addObject:[[XmlModel alloc]initWithTitle:@"36氢"      andLink:@"https://36kr.com/feed"]];
    [defaultFeedsArr addObject:[[XmlModel alloc]initWithTitle:@"知乎精选"   andLink:@"https://www.zhihu.com/rss"]];
    [defaultFeedsArr addObject:[[XmlModel alloc]initWithTitle:@"爱范儿"     andLink:@"http://www.ifanr.com/feed"]];
    [defaultFeedsArr addObject:[[XmlModel alloc]initWithTitle:@"极客公园"   andLink:@"http://www.geekpark.net/rss"]];

    return defaultFeedsArr;
}

// 解析XML放进模型内
- (XmlModel *)setModelWithData:(NSData *)data WithModel:(XmlModel *)xmlModel{
    
    NSError *error = nil;
    XmlModel *model = [[XmlModel alloc] initWithTitle:xmlModel.title andLink:xmlModel.link];
    model.title = xmlModel.title;
    model.link  = xmlModel.link;
    model.feedUrl = xmlModel.feedUrl;
    NSMutableArray *itemArray = [NSMutableArray array];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
    
    for (ONOXMLElement *element in document.rootElement.children) {
        
#pragma mark - rss2类型 :36ke，知乎
        if ([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"channel"]) {
            
            for (ONOXMLElement *channelChild in element.children) {
                
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"title"]){
                    model.title = channelChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"link"]){
                    model.link = channelChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"generator"]){
                    model.generator = channelChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"description"]){
                    model.rssDescription = channelChild.stringValue;
                }
                if ([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"copyright"]) {
                    model.copyright = channelChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"lastBuildDate"] || [self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"pubDate"]){
                    model.lastUpdateDate == nil ? xmlModel.lastUpdateDate = channelChild.stringValue : nil;
                }
                if([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"subtitle"]){
                    model.subtitle = channelChild.stringValue;
                }
                if ([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"image"]) {
                    for (ONOXMLElement *channelImage in channelChild.children) {
                        if ([self isEqualToWithDoNotCareLowcaseString:channelImage.tag compareString:@"url"]) {
                            if (channelImage.stringValue.length > 0 && !(xmlModel.imageUrl.length > 0)) {
                                model.imageUrl = channelImage.stringValue;
                            }
                        }
                    }
                }
                if ([self isEqualToWithDoNotCareLowcaseString:channelChild.tag compareString:@"item"]) {
                    // 在item标签里，循环
                    FeedModel *feedmodel = [[FeedModel alloc]init];
                    feedmodel.feedName = model.title;
                    for (ONOXMLElement *channelItem in channelChild.children) {
                        if([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"title"]){
                            feedmodel.title = channelItem.stringValue;
                        }
                        if([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"link"]){
                            feedmodel.link = channelItem.stringValue;
                        }
                        if([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"pubDate"]){
                            feedmodel.updatedDate = channelItem.stringValue;
                        }
                        if([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"author"] || [self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"creator"]){
                            feedmodel.authorName == nil ?  feedmodel.authorName = channelItem.stringValue : nil;
                        }
                        if ([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"category"]) {
                            feedmodel.category = channelItem.stringValue;
                        }
                        if ([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"encoded"] || [self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"description"]) {
                            feedmodel.feedDescription = channelItem.stringValue;
                        }
                        if ([self isEqualToWithDoNotCareLowcaseString:channelItem.tag compareString:@"description"]) {
                            feedmodel.summary = channelItem.stringValue;
                        }
                    }
                    [itemArray addObject:feedmodel];
                }// end item
            }// end channel
        }
        
        
        
#pragma mark - atom类型，博客园
        if([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"title"]){
            model.title = element.stringValue;
        }
        if([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"subtitle"]){
            model.subtitle = element.stringValue;
            model.rssDescription = element.stringValue;
        }
        if([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"generator"]){
            model.generator = element.stringValue;
        }
        if([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"updated"]){
            model.lastUpdateDate = element.stringValue;
        }
        if([self isEqualToWithDoNotCareLowcaseString:element.tag compareString:@"entry"]){
            
            // 在entry标签里，循环
            FeedModel *feedmodel = [[FeedModel alloc]init];
            feedmodel.feedName = model.title;
            for (ONOXMLElement *entryChild in element.children) {
                
                if([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"link"]){
                    feedmodel.link = (NSString *)[entryChild valueForAttribute:@"href"];
                }
                if([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"title"]){
                    feedmodel.title = entryChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"summary"]){
                    feedmodel.summary = entryChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"author"]){
                    
                    for (ONOXMLElement *authorChild in entryChild.children) {
                        if([self isEqualToWithDoNotCareLowcaseString:authorChild.tag compareString:@"name"]){
                            feedmodel.authorName = authorChild.stringValue;
                        }
                    }
                    entryChild.children.count == 0 ? feedmodel.authorName = entryChild.stringValue : nil;
                }
                if ([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"updated"]) {
                    feedmodel.updatedDate = entryChild.stringValue;
                }
                if([self isEqualToWithDoNotCareLowcaseString:entryChild.tag compareString:@"content"]){
                    feedmodel.feedDescription = entryChild.stringValue;
                }
                
            }
            [itemArray addObject:feedmodel];
        }// end entry
    }
    
    model.xID = xmlModel.xID;
    model.unreadCount = xmlModel.unreadCount;
    model.modelArray = itemArray;
    return model;
}

// 获取文章内容（feed内只有大概描述）
- (BOOL)getAtomDescriptionWith:(FeedModel *)model{
    
    NSError *error;
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.link]];
    ONOXMLDocument *html = [ONOXMLDocument XMLDocumentWithData:htmlData error:&error];
    ONOXMLElement *postElement = [html firstChildWithXPath:@"//*[@id='cnblogs_post_body']"];
    model.feedDescription = postElement.stringValue;
    
    if (postElement.stringValue.length > 0) {
        return YES;
    }
    
    return NO;
}

// 只比较小写
- (BOOL)isEqualToWithDoNotCareLowcaseString:(NSString *)string compareString:(NSString *)compareString {
    if ([string.lowercaseString isEqualToString:compareString.lowercaseString]) {
        return YES;
    }
    return NO;
}

@end
