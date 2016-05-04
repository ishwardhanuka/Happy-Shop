//
//  ProductsViewController.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 1/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"

@interface ProductsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    int page;
}

@property(nonatomic,strong) NSString *category;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSMutableArray *entries;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) ProductObject *product;

@end
