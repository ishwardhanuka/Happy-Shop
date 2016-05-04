//
//  CategoryTableViewController.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 1/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UITableViewController

@property(nonatomic,strong) NSString *category;

@property (weak, nonatomic) IBOutlet UILabel *cartCountLabel;
@end
