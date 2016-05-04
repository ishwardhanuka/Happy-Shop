//
//  ProductsViewController.m
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 1/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductObject.h"
#import "WebService.h"
#import "IconDownloader.h"
#import "ProductDetailViewController.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController

@synthesize category = _category;

const int PAGING_SIZE = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:self.category];
    
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    
    page = 0;
    self.entries = [[NSMutableArray alloc]initWithCapacity:4];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self downloadListings];
    
}

- (void)downloadListings
{
    WebService *ws = [[WebService alloc]init];
    NSMutableData *listingData = [[NSMutableData alloc]init];
    //NSArray *output = @[@"gender",@"price",@"title",@"minLrtDistance",@"image1",@"lat",@"long",@"isVerified",@"country"];
    
    ws.data = listingData;
    
    [ws setCompletionHandler:^{
        
        NSArray *listings = [[NSJSONSerialization JSONObjectWithData:listingData options:kNilOptions error:nil]objectForKey:@"products"];
        
        if([listings count] == 0){
            page = -1;
            
            return;
        }
        
        ProductObject *listing;
        NSDictionary *object;
        
        for(int i=0;i<[listings count];i++)
        {
            listing = [ProductObject alloc];
            object = [listings objectAtIndex:i];
            
            [listing setPrice:[[object objectForKey:@"price"]intValue]];
            [listing setProductId:[object objectForKey:@"id"]];
            [listing setTitle:[object objectForKey:@"name"]];
            [listing setLandingURL:[object objectForKey:@"img_url"]];
            [listing setIsSale:[[object objectForKey:@"under_sale"]boolValue]];
            
            [self.entries addObject:listing];
        }
        
        
        [self.tableView reloadData];
        
    }];
    
    //[ws getDataFromUrl:@"http://myrentbm.appspot.com/main.php?service=GetListingByUserId" withParameters:[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:754177010], @"username",[NSNumber numberWithInt:page],@"page", nil]];
    //[ws getDataFromUrl:@"http://sephora-mobile-takehome-2.herokuapp.com/api/v1/products.json" withParameters:[[NSDictionary alloc]initWithObjectsAndKeys:self.category, @"category",[NSNumber numberWithInt:page],@"page", nil]];
    [ws getDataFromUrl:[NSString stringWithFormat:@"http://sephora-mobile-takehome-2.herokuapp.com/api/v1/products.json?category=%@&page=%d",self.category,page]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    if(page==-1)
        return;
    
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (600);
    if (actualPosition >= contentHeight) {
        page+=1;
        [self downloadListings];
    }
}

- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ProductObject *listing = [self.entries objectAtIndex:indexPath.row];
            
            if (!listing.landingImage)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:listing forIndexPath:indexPath];
            }
        }
    }
}

- (void)startIconDownload:(ProductObject *)listing forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.listing = listing;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *iv = (UIImageView*)[cell viewWithTag:1];
            iv.image = listing.landingImage;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            
            [iv.layer addAnimation:transition forKey:nil];
            
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        
        [iconDownloader startDownload];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.entries count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getListingCellForRow:indexPath];
}

- (UITableViewCell*)getListingCellForRow:(NSIndexPath*)indexPath
{
    ProductObject *listing = (ProductObject*)[self.entries objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"productsCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productsCell"];
        }
    
    
    UIImageView *bg = (UIImageView*)[cell viewWithTag:8];
    bg.layer.shadowColor = [UIColor grayColor].CGColor;
    bg.layer.shadowOffset = CGSizeMake(0, 1);
    bg.layer.shadowOpacity = 1;
    bg.layer.shadowRadius = 1.0f;
    bg.clipsToBounds = NO;
    
    UIImageView *iv = (UIImageView*)[cell viewWithTag:1];
    
    UILabel *label = (UILabel*)[cell viewWithTag:3];
    [label setText:[NSString stringWithFormat:@"%d",listing.price]];
    
    label = (UILabel*)[cell viewWithTag:2];
    [label setText:listing.title];
    
    if (!listing.landingImage)
    {
        if (self.tableView.dragging == NO)
        {
            [self startIconDownload:listing forIndexPath:indexPath];
        }
        
        iv.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    
    else
        iv.image = listing.landingImage;
    
    label = (UILabel*)[cell viewWithTag:4];
    if(listing.isSale) [label setText:@"ON SALE!"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductObject *listing = (ProductObject*)[self.entries objectAtIndex:indexPath.row];
    
    if (!listing.landingImage) [self startIconDownload:listing forIndexPath:indexPath];
    
    else {
        self.product = listing;
        [self performSegueWithIdentifier:@"productDetails" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     ProductDetailViewController *vc = segue.destinationViewController;
     vc.product = self.product;
 }



@end
