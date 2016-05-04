//
//  ProductDetailViewController.m
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "WebService.h"
#import "ProductObject.h"

@implementation ProductDetailViewController

@synthesize product = _product;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupView];
    [self fetchData];
}

- (void)fetchData{
    WebService *ws = [[WebService alloc]init];
    NSMutableData *listingData = [[NSMutableData alloc]init];
    //NSArray *output = @[@"gender",@"price",@"title",@"minLrtDistance",@"image1",@"lat",@"long",@"isVerified",@"country"];
    
    ws.data = listingData;
    
    [ws setCompletionHandler:^{
        NSDictionary *prod = [[NSJSONSerialization JSONObjectWithData:listingData options:kNilOptions error:nil]objectForKey:@"product"];
        [self.product setDesc:[prod objectForKey:@"description"]];
        [self updateDesc];
    }];
    
    [ws getDataFromUrl:[NSString stringWithFormat:@"http://sephora-mobile-takehome-2.herokuapp.com/api/v1/products/%@.json",self.product.productId]];
}

- (void)setupView{
    [self setTitle:self.product.title];
    [self.titleLabel setText:self.product.title];
    [self.priceLabel setText:[NSString stringWithFormat:@"%d",self.product.price]];
    [self.iv setImage:self.product.landingImage];
    
    if(self.product.isSale) [self.saleLabel setText:@"ON SALE"];
    
    [self updateCartLabel];
}

- (void)updateCartLabel{
    if([self existsInCart]) [self.addCartButton setTitle:@"Remove from Cart" forState:UIControlStateNormal];
    else [self.addCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
}
- (void)updateDesc{
    [self.descView setText:self.product.desc];
}

- (NSMutableArray*)getCartItems{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *items = [[def objectForKey:@"items"]mutableCopy];
    
    if(!items) items = [[NSMutableArray alloc]init];
    return items;
}

- (BOOL)existsInCart{
    return [[self getCartItems] containsObject:self.product.productId];
}
- (IBAction)addToCart:(id)sender {
    NSMutableArray *items = [self getCartItems];
    
    if([self existsInCart]) [items removeObject:self.product.productId];
    else [items addObject:self.product.productId];
    
    [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"items"];
    
    [self updateCartLabel];
}
@end
