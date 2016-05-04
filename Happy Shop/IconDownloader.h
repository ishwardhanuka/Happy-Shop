//
//  IconDownloader.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductObject;

@interface IconDownloader : NSObject

@property (nonatomic, strong) ProductObject *listing;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
