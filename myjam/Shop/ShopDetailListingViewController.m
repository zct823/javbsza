//
//  ShopDetailListingViewController.m
//  myjam
//
//  Created by Azad Johari on 1/30/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopDetailListingViewController.h"



#define kTableCellHeight 170
@interface ShopDetailListingViewController ()

@end

@implementation ShopDetailListingViewController
@synthesize shopInfo=_shopInfo;
@synthesize productArray = _productArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"JAM-BU Shop";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_productArray count] ==0){
        return 1;
    }
    // Return the number of sections.
    else return [_productArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_productArray count] ==0){
        return 1;
    }
    // Return the number of rows in the section.
   
    else if(section == 0){
        return 2;
    }
    else {
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row== 0 && indexPath.section == 0){
        return 44;
    }
    else{
    return kTableCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  static NSString *CellIdentifier = @"Cell";
    
    if(indexPath.row == 0 && indexPath.section == 0 ){
        ShopHeaderViewCell *cell = (ShopHeaderViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopHeaderViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        cell.shopLabel.text = [_shopInfo valueForKey:@"shop_name"];
        if([[_shopInfo valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
            cell.topSellerLabel.hidden=NO;
        }
        
        return cell;
    }
    else{
    ProductTableViewCell *cell = (ProductTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [self createCellForIndex:indexPath cell:cell];
    
    return cell;
    }
}

- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(ProductTableViewCell *)cell
{
    if ((indexPath.row ==1 && indexPath.section==0) ||indexPath.row==0 ){

    
        CGSize expectedLabelSize  = [[[_productArray objectAtIndex:indexPath.section] valueForKey:@"category_name"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, cell.catNameLabel.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        CGRect newFrame = cell.catNameLabel.frame;
        newFrame.size.width = expectedLabelSize.width;
        cell.catNameLabel.text = [[_productArray objectAtIndex:indexPath.section] valueForKey:@"category_name"];
        cell.catNameLabel.frame = newFrame;
        if ([[[_productArray objectAtIndex:indexPath.section] valueForKey:@"category_product_count"] integerValue] <4){
            cell.viewAllButton.hidden = YES;
            cell.middleLine.frame = CGRectMake(expectedLabelSize.width+50,cell.middleLine.frame.origin.y,300-expectedLabelSize.width-50, 1);
        }
        else{
            cell.middleLine.frame = CGRectMake(expectedLabelSize.width+50,cell.middleLine.frame.origin.y,300-expectedLabelSize.width-120, 1);
            cell.viewAllButton.tag = indexPath.section;
            [cell.viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
        
        }
             
        
        
    }else{
        cell.productHeader.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    //  cell.topLabel1.text =
    cell.catLabel1.text = [[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_name"];
    
       cell.productLabel1.text =[[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_category"];
    
    cell.priceLabel1.text =[[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_price"];
    cell.button1.tag =  3*indexPath.section+0;
    if( [[[[[_productArray objectAtIndex:indexPath.section]
            valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_rating"] isEqual:@"0.0"]){
        cell.rateView1.hidden = TRUE;
    }
    else{
    cell.rateView1.rating = [[[[[_productArray objectAtIndex:indexPath.section]
                              valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_rating"] intValue];
    cell.rateView1.editable = FALSE;
    cell.rateView1.selectedImage = [UIImage imageNamed:@"star.png"];
    cell.rateView1.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
    cell.rateView1.maxRating = 5;
    cell.transView1.hidden = NO;
    }
    [cell.button1 setBackgroundImageWithURL:[[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:0] valueForKey:@"product_image"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
    [cell.button1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] count] >1){
        
    
    cell.catLabel2.text = [[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_name"];
    cell.productLabel2.text =[[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_category"];
    cell.priceLabel2.text =[[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_price"];
        if( [[[[[_productArray objectAtIndex:indexPath.section]
               valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_rating"] isEqual:@"0.0"]){
            cell.rateView2.hidden = TRUE;
        }
        else{
        cell.rateView2.rating = [[[[[_productArray objectAtIndex:indexPath.section]
                                    valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_rating"] intValue];
        cell.rateView2.editable = FALSE;
        cell.rateView2.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView2.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
        cell.rateView2.maxRating = 5;
        cell.transView2.hidden = NO;
        }
        cell.button2.tag = 3*indexPath.section+1;
           [cell.button2 setBackgroundImageWithURL:[[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:1] valueForKey:@"product_image"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [cell.button2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    if ([[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] count] >2){
    cell.catLabel3.text = [[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_name"];
    cell.productLabel3.text =[[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_category"];
     cell.priceLabel3.text =[[[[_productArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_price"];
        if( [[[[[_productArray objectAtIndex:indexPath.section]
                valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_rating"] isEqual:@"0.0"]){
            cell.rateView3.hidden = TRUE;
        }
        else{
        cell.rateView3.rating = [[[[[_productArray objectAtIndex:indexPath.section]
                                    valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_rating"] intValue];
        cell.rateView3.editable = FALSE;
        cell.rateView3.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView3.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
        cell.rateView3.maxRating = 5;
        cell.transView3.hidden = NO;
        }
        cell.button3.tag = 3*indexPath.section+2;
           [cell.button3 setBackgroundImageWithURL:[[[[_productArray objectAtIndex:indexPath.section] valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_image"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
          [cell.button3 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Table view delegate

-(void)viewAll:(id)sender{
    ProductViewAllViewController *detailViewController = [[ProductViewAllViewController alloc] initWith:_shopInfo andCat:[[_productArray objectAtIndex:[sender tag] ]valueForKey:@"category_name"]];
                                                         
    detailViewController.productAllArray =[[MJModel sharedInstance] getFullListOfProductsFor:[_shopInfo valueForKey:@"shop_id"] inCat:[[_productArray objectAtIndex:[sender tag]] valueForKey:@"category_id"] andPage:@"1"];

    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
   // [detailViewController release];
}
-(void)tapAction:(id)sender{

    DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
    NSString *prodId = [[[[_productArray objectAtIndex:([sender tag]/3)] valueForKey:@"product_list"] objectAtIndex:([sender tag]%3)] valueForKey:@"product_id" ];
    detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:prodId];
    detailViewController.productId = [prodId mutableCopy];
      detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)locateStore:(id)sender {
    ShopAddressViewController *detailViewController = [[ShopAddressViewController alloc] init];
    NSLog(@"%@",_shopInfo);
    detailViewController.shopId = [_shopInfo valueForKey:@"shop_id"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    // [detailViewController release];

}
-(void)dealloc{
    [super dealloc];
    [_shopInfo release];
    [_productArray release];
}
@end
