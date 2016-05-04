//
//  ProductObject.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProductObject : NSObject

@property (assign) int price;
@property (assign) BOOL isSale;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *image_url;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *landingURL;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) UIImage *landingImage;

@end
