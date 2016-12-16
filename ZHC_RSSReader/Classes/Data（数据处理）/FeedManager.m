//
//  FeedManager.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "FeedManager.h"
#import "XmlModel.h"
#import "AFNetworking.h"
#import "Ono.h"
#import "FeedDB.h"
#import "FeedStore.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FeedManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) FeedStore *feedstore;

@end

@implementation FeedManager

#pragma mark - 单例
static FeedManager *manager;
+ (instancetype)defaultManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        manager = [[self alloc]init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
     
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          manager = [super allocWithZone:zone];
     });
     return manager;
}

- (id)copyWithZone:(NSZone *)zone{
     
     return manager;
}

- (NSMutableArray *)feedmodels{
     
     if (!_feedmodels) {
          _feedmodels = [NSMutableArray array];
     }
     return _feedmodels;
}

#pragma mark - Get方法
- (AFHTTPSessionManager *)manager{
     
     if (!_manager) {
          
          _manager = [AFHTTPSessionManager manager];
          _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
          _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"application/atom+xml", @"application/rss+xml",@"text/xml", nil];
     }
     return _manager;
}

- (FeedStore *)feedstore{
     
     if (!_feedstore) {
          _feedstore = [[FeedStore alloc] init];
     }
     return _feedstore;
}

#pragma mark - 抓取所有Feed的内容
- (RACSignal *)fetchAllFeedsModel:(NSMutableArray *)models{
     
     // 传入Main的数据源数组
     @weakify(self);
     return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
          @strongify(self);
          dispatch_queue_t feedsQueue = dispatch_queue_create("com.ZHC_RSSReader.fetchAllFeedsModel",  DISPATCH_QUEUE_CONCURRENT);
          dispatch_group_t group = dispatch_group_create();
          self.feedmodels = models;
          
//          __block XmlModel *newModel;
          // 取出models，遍历发送get请求
          for (int i = 0 ; i < models.count ; i++) {
               
               dispatch_group_enter(group);
               XmlModel *model = models[i];
               [self.manager GET:model.feedUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    dispatch_async(feedsQueue, ^{
                         @strongify(self);
                         self.feedmodels[i]  = [self.feedstore setModelWithData:responseObject WithModel:model];
                         // 处理完后拿到新的模型，把新模型存入
                         [[[FeedDB shareDB] insertWithXmlModel:self.feedmodels[i]] subscribeNext:^(id x) {
                              // TODO：每个XML的头像保存
                              [subscriber sendNext:@(i)];
                              dispatch_group_leave(group);
                         }];
                    });
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error : %@",error);
                    // 更新失败后把当前的XML模型写入数据库
                    dispatch_async(feedsQueue, ^{
                       
//                         @strongify(self);
                         [[[FeedDB shareDB] insertWithXmlModel:model] subscribeNext:^(id x) {
//                              XmlModel *model = (XmlModel*)self.feedmodels[i];
                              model.xID = [x integerValue];
                              dispatch_group_leave(group);
                         }];
                    });
               }];
               
          }
          dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
               [subscriber sendCompleted];
          });
          return nil;
     }];
}

#pragma mark - 获取文章内容（针对博客园这种feed内只有大概描述的）
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
