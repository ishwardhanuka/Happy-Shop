//
//  WebService.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Connectable <NSObject>
@optional
- (void)setReturnedData:(id)ws;
@optional
- (void)setReturnedFailed:(id)ws;
@optional
- (void)setPercentDone:(long)percent;
@end

@interface WebService : NSObject
{
    id<Connectable> caller;
    double expectedLength, bytesReceived;
}
@property(strong,atomic) NSString *connectionName;
@property(strong,atomic) NSMutableData *data;
@property(strong,nonatomic) NSMutableDictionary *returnParam;
@property(strong,nonatomic) NSURLConnection *urlConnection;
@property (nonatomic, copy) void (^completionHandler)(void);

-(void)setCaller:(id<Connectable>) vc;
-(void)getDataFromUrl:(NSString*)stringUrl withParameters:(NSDictionary*)params;
-(void)getDataFromUrl:(NSString*)stringUrl withStringParameters:(NSString*)params;
-(void)getDataFromUrl:(NSString*)stringUrl;
-(void)getDataFromUrl:(NSString*)stringUrl withParameterData:(NSData*)jsonData;
-(void)getDataFromUrl:(NSString*)stringUrl withStringParameters:(NSMutableDictionary *)params withFile:(NSURL *)filedata;
-(void)stopCaller;
@end

