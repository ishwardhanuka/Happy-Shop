//
//  ProductDetailViewController.h
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"

@interface ProductDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descView;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic,strong) ProductObject *product;

- (IBAction)addToCart:(id)sender;
@end
