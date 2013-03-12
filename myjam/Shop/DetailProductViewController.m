//
//  DetailProductViewController.m
//  myjam
//
//  Created by Azad Johari on 1/30/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DetailProductViewController.h"
#define kTableCellHeight 70
@interface DetailProductViewController ()

@end

@implementation DetailProductViewController
@synthesize scrollView, aImages, productInfo,headerView,counter,selectedColor, selectedSize, buyButton, tempColorsForSize, tempSizesForColor, cartId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"JAM-BU Shop";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempColorsForSize = [[NSMutableArray alloc] init];
    tempSizesForColor = [[NSMutableArray alloc] init];
    counter = 0;
    self.selectedColor = @"none";
    self.selectedSize = @"none";
    self.cartId = @"";
    if ([[productInfo valueForKey:@"size_available"] count] > 0 ){
        counter = counter+1;
    }
    if ([[productInfo valueForKey:@"color_available"] count] > 0 ){
        counter = counter+2;
    }
     headerView = [[[NSBundle mainBundle] loadNibNamed:@"ProductHeaderView" owner:self options:nil]objectAtIndex:0];
    self.tableView.tableHeaderView = headerView;
    headerView.productName.text = [productInfo valueForKey:@"product_name"];
    headerView.productCat.text = [productInfo valueForKey:@"product_category"];
    headerView.shopName.text = [productInfo valueForKey:@"shop_name"];
    headerView.productPrice.text = [productInfo valueForKey:@"product_price"];
    self.productDesc.text = [productInfo valueForKey:@"product_description"];
    if ([[productInfo valueForKey:@"product_bulky"] isEqualToString:@"Y"]){
        if ([[productInfo valueForKey:@"product_fragile"] isEqualToString:@"Y"]){
            headerView.productState.image = [UIImage imageNamed:@"bulkyfragile.png"];
        }
        else{
             headerView.productState.image = [UIImage imageNamed:@"bulky.png"];
        }
    }
    else if([[productInfo valueForKey:@"product_fragile"] isEqualToString:@"Y"]){
        headerView.productState.image = [UIImage imageNamed:@"fragile.png"];
    }
    
    self.aImages = [[NSMutableArray alloc] initWithCapacity:[[productInfo valueForKey:@"product_image"] count]];
    for (int i=0; i< [[productInfo valueForKey:@"product_image"] count]; i++){
      
        [self retrieveImages:[[productInfo valueForKey:@"product_image"] objectAtIndex:i] ];
        
    }
    
    [self setupCarousel];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [self setProductDesc:nil];
    [self setSizeView:nil];
    [self setColorSelectView:nil];
    [self setTableView:nil];
    [self setTwitterPressed:nil];
    [self setEmailPressed:nil];
    [self setTwitterPressed:nil];
    [self setTwitterPressed:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)setupCarousel{
    carousel = [[Carousel alloc] initWithFrame:CGRectMake(0, 0, 236, 236)];
    carousel.delegate = self;
    // Add some images to carousel
    [carousel setImages:self.aImages];
    
    imgCounter = 0;
    [headerView.leftButton setHidden:YES];
    if ([self.aImages count] == 1) {
        [headerView.rightButton setHidden:YES];
    }
    
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    // Add carousel to view
    [headerView.imageCarouselView addSubview:carousel];
    
    // Add carousel side buttons
    [headerView.leftButton addTarget:self action:@selector(handleLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [headerView.rightButton addTarget:self action:@selector(handleRightButton) forControlEvents:UIControlEventTouchUpInside];
   
   
}
- (void)handleLeftButton
{
    imgCounter--;
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    if(imgCounter == 0)
    {
        [headerView.leftButton setHidden:YES];
    }
    
    if(imgCounter == [self.aImages count]-2)
    {
        [headerView.rightButton setHidden:NO];
    }
}

- (void)handleRightButton
{
    imgCounter++;
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    if(imgCounter == 1)
    {
        [headerView.leftButton setHidden:NO];
    }
    
    if(imgCounter == [self.aImages count]-1)
    {
        [headerView.rightButton setHidden:YES];
    }
}

- (void)retrieveImages: (NSString *)uri
{
    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:uri]];
    
    [imageRequest startSynchronous];
    [imageRequest setTimeOutSeconds:2];
   // NSError *error = [imageRequest error];
   // NSString *contentType = [[imageRequest responseHeaders]
           //                  objectForKey:@"Content-Type"];
UIImage *aImg = [[UIImage alloc] initWithData:[imageRequest responseData]];
    NSLog(@"%@", [aImg class]);
    
    if ([aImg isKindOfClass:[NSData class]]||[aImg isKindOfClass:[UIImage class]] ){
        
    
    }else{
        NSLog(@"img is null");
        aImg = [UIImage imageNamed:@"default_icon.png"];
    }
    [self.aImages addObject:aImg];
    
    [aImg release];
     [imageRequest release];
       
     
         //   }
     
    
   
}
#pragma mark -
#pragma mark Carousel delegate

- (void)didScrollToPage:(int)page
{
    // Check currentpage
    
    imgCounter = page;
    if(imgCounter == 0)
    {
        [headerView.leftButton setHidden:YES];
    }
    
    if(imgCounter == [self.aImages count]-2)
    {
        [headerView.rightButton setHidden:NO];
    }
    
    if(imgCounter == 1)
    {
        [headerView.leftButton setHidden:NO];
    }
    
    if(imgCounter == [self.aImages count]-1)
    {
        [headerView.rightButton setHidden:YES];
    }
}
- (IBAction)facebookPressed:(id)sender {
    [self shareImageOnFBwith:[productInfo valueForKey:@"qrcode_id"] andImage:[aImages lastObject]];
}

- (IBAction)twitterPressed:(id)sender {
    [self shareImageOnTwitterFor: [productInfo valueForKey:@"qrcode_id"] andImage:[aImages lastObject]];
}

- (IBAction)emailPressed:(id)sender {
    [self shareImageOnEmailWithId:[productInfo valueForKey:@"qrcode_id"] withImage:[aImages lastObject]];
}



-(IBAction)readReviews{
    ProductRatingListViewController *detailViewController = [[ProductRatingListViewController alloc] initWithNibName:@"ProductRatingListViewController" bundle:nil];
    detailViewController.reviewList = [[MJModel sharedInstance] getProductReviewFor:_productId inPage:@"1"];
    
    detailViewController.productName = [productInfo valueForKey:@"product_name"];
    detailViewController.productId =[[ NSString alloc] initWithString:_productId];
    detailViewController.shopName = [productInfo valueForKey:@"shop_name"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)reportProduct:(id)sender {
    ProductReportViewController *detailViewController = [[ProductReportViewController alloc] initWithNibName:@"ProductReportViewController" bundle:nil andProductId:self.productId];
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

}
-(void)buyNow:(id)sender{
    if (counter == 3){
        if ([selectedSize isEqualToString:@"none"]){
            [self createAlertFor:@"size"];
            return;
        } else if ([selectedColor isEqualToString:@"none"]){
            [self createAlertFor:@"color"];
            return;
        }
    }else if (counter == 2){
        if ([selectedColor isEqualToString:@"none"]){
            [self createAlertFor:@"color"];
            return;
        }
    }
    else if (counter == 1){
        if ([selectedSize isEqualToString:@"none"]){
            [self createAlertFor:@"size"];
            return;
        }
    }
    NSMutableString *param1 = nil;
    NSMutableString *param2 = nil;
    if ([selectedSize isEqual:@"none"]){
        param1 = [NSMutableString stringWithFormat:@"none"]; ;
    }
    else{
        param1 = [NSMutableString stringWithFormat:@"%@",[[[productInfo valueForKey:@"size_available"] objectAtIndex:[selectedSize intValue]] valueForKey:@"size_id"]];
    }
    if ([selectedColor isEqual:@"none" ]){
        param2 = [NSMutableString stringWithFormat:@"none"];
    }
    else{
        param2 = [NSMutableString stringWithFormat:@"%@",[[[productInfo valueForKey:@"color_available"] objectAtIndex:[selectedColor intValue]] valueForKey:@"color_id"]];
    }
    NSDictionary *purchaseStat = [[MJModel sharedInstance] addToCart:_productId withSize:[NSString stringWithString:param1]  andColor:[NSString stringWithString:param2] ];
    if ([[purchaseStat valueForKey:@"status"] isEqual:@"ok"]){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"cartChanged"
         object:self];
        self.cartId = [NSString stringWithString:[purchaseStat valueForKey:@"cart_id"]];
        [self.tableView reloadData];
    }
    }

-(void)createAlertFor:(NSString*)cat{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Please select a %@ before proceeding",cat] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}
  //  [detailViewController release];


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (counter == 0){
        return 1;
    } else if (counter == 1){
        return 2;
    } else if (counter == 2){
        return 2;
    }
    else if (counter == 3){
        return 3;
    }    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 100;
        
    }
    else return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.row == 0){
        if ([self.buyButton isEqualToString:@"ok"])
        {
            BuyNowCell *cell = (BuyNowCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuyNowCell" owner:nil options:nil];
            if (cell == nil)
            {
                cell = [nib objectAtIndex:0];
                int butbool= 0;
                if ([[productInfo valueForKey:@"product_stockable"] isEqualToString:@"N"]){
                    cell.limitedLabel.hidden = YES;
                }
                
            AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableArray *cartItems = [[NSMutableArray alloc] initWithArray:mydelegate.sidebarController.cartItems];
                for (int i = 0; i< [cartItems count]; i++){
                    NSLog(@"%@",[cartItems objectAtIndex:i]);
                    if ([[[cartItems objectAtIndex:i ] valueForKey:@"shop_name"] isEqual:[productInfo valueForKey:@"shop_name"]] ){
                        for (id row in [[cartItems objectAtIndex:i  ]valueForKey:@"item_list"]){
                            NSLog(@"row: %@", row);
                            if ([self.productId isEqual:[row valueForKey:@"product_id"]]){
                                if (counter == 0){
                                    butbool = 1;
                                    break;
                                }
                                else if (counter == 3){
                                    if ([[[[productInfo valueForKey:@"color_available"] objectAtIndex:[self.selectedColor intValue]] valueForKey:@"color_id"] isEqual:[row valueForKey:@"color_id"]]){
                                        if ([[[[productInfo valueForKey:@"size_available"] objectAtIndex:[self.selectedSize intValue]] valueForKey:@"size_id"] isEqual:[row valueForKey:@"size_id"]]){
                                            butbool =1;
                                            break;
                                        }

                                    }
                                }
                                else if (counter == 2){
                                    if ([[[[productInfo valueForKey:@"color_available"] objectAtIndex:[self.selectedColor intValue]] valueForKey:@"color_id"] isEqual:[row valueForKey:@"color_id"]]){
                                        butbool =1;
                                        break;
                                    }

                                }
                               else if (counter == 1){
                                    if ([[[[productInfo valueForKey:@"size_available"] objectAtIndex:[self.selectedSize intValue]] valueForKey:@"size_id"] isEqual:[row valueForKey:@"size_id"]]){
                                        butbool =1;
                                        break;
                                    }
                                }
                                                            }
                        }
                    }
                                   }
                if (butbool == 0){
                    if ([[productInfo valueForKey:@"product_stock_balance_total"] isEqual:[NSNumber numberWithInt:0]]){
                        [cell.button1 setBackgroundImage:[UIImage imageNamed:@"sold_out"] forState:UIControlStateNormal];
                        [cell.button1 setTitle:@"" forState:UIControlStateNormal];
                        cell.button1.userInteractionEnabled = NO;

                    }
                    else{
                        [cell.button1 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                cell.continueShoppingButton.hidden = YES;
                cell.checkOutButton.hidden = YES;
                
                } else{
                    [cell.button1 setBackgroundImage:[UIImage imageNamed:@"added_cart"] forState:UIControlStateNormal];
                    [cell.button1 setTitle:@"" forState:UIControlStateNormal];
                    cell.button1.userInteractionEnabled = NO;
                    cell.continueShoppingButton.hidden = NO;
                    cell.continueShoppingButton.userInteractionEnabled = YES;
                    [cell.continueShoppingButton addTarget:self action:@selector(continueShopping:) forControlEvents:UIControlEventTouchUpInside];
                    cell.checkOutButton.hidden = NO;
                     cell.checkOutButton.userInteractionEnabled = YES;
                    [cell.checkOutButton addTarget:self action:@selector(checkOut:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                return cell;
            }
        }
            else{
                PurchaseVerificationCell *cell = (PurchaseVerificationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PurchaseVerificationCell" owner:nil options:nil];
                if (cell == nil)
                {
                    
                    cell = [nib objectAtIndex:0];
                    NSLog(@"%@",[productInfo valueForKey:@"order_info"]);
                    NSArray *purchaseInfo =[[productInfo valueForKey:@"order_info"] componentsSeparatedByString:@"<br/>"];
                    cell.orderLabel.text =  [[[[purchaseInfo objectAtIndex:0] stringByStrippingHTML] componentsSeparatedByString:@":"] objectAtIndex:1];
                    cell.qtyLabel.text =  [[[[purchaseInfo objectAtIndex:1] stringByStrippingHTML] componentsSeparatedByString:@":"] objectAtIndex:1];
                    cell.statusLabel.text =  [[[[purchaseInfo objectAtIndex:2] stringByStrippingHTML] componentsSeparatedByString:@":"] objectAtIndex:1];
                    [cell.submitButton addTarget:self action:@selector(submitReport:) forControlEvents:UIControlEventTouchUpInside];
                   
                    return cell;
                }
            }
        }
        
    
    else{
        
    
    if (counter ==1){
        SizeSelectionCell *cell = (SizeSelectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

      if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizeSelectionCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
        cell.sizeSelectView.sizeChoices = [NSMutableArray arrayWithObjects:[productInfo valueForKey:@"size_available"], [productInfo valueForKey:@"stock_balance"], nil];
        ;
        cell.sizeSelectView.editable = YES;
        cell.sizeSelectView.sizeChoicesNum = [[productInfo valueForKey:@"size_available"] count];
        cell.sizeSelectView.delegate = self;
    
        if (![self.selectedSize isEqual:@"none"]){
            cell.sizeSelectView.size = [self.selectedSize intValue];
        }
        return cell;
    }
    if (counter ==2){
        
        ColorSelectionCell *cell = (ColorSelectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ColorSelectionCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.colorSelectView.colorChoices = [NSMutableArray arrayWithObjects:[productInfo valueForKey:@"color_available"], [productInfo valueForKey:@"stock_balance"], nil];
        cell.colorSelectView.editable = YES;
        cell.colorSelectView.colorChoicesNum = [[productInfo valueForKey:@"color_available"] count];
       
        cell.colorSelectView.delegate = self;
        if (![self.selectedColor isEqual:@"none"]){
            cell.colorSelectView.color =[self.selectedColor intValue];
        }
        
        
        return cell;    }
    if (counter ==3){
        if (indexPath.row == 1){
            SizeSelectionCell *cell = (SizeSelectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizeSelectionCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            if (![self.selectedSize isEqual:@"none"]){
                cell.sizeSelectView.size =[self.selectedSize intValue];
            }
           cell.sizeSelectView.sizeChoices = [NSMutableArray arrayWithObjects:[productInfo valueForKey:@"size_available"] , [productInfo valueForKey:@"stock_balance"], nil];
            cell.sizeSelectView.editable = YES;
             cell.sizeSelectView.colorsForSize = tempColorsForSize;
            cell.sizeSelectView.sizeChoicesNum = [[productInfo valueForKey:@"size_available"] count];
            cell.sizeSelectView.delegate = self;
            NSLog(@"%@", tempColorsForSize);
               

            
            return cell;
    }else if (indexPath.row ==2)
    {
        ColorSelectionCell *cell = (ColorSelectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ColorSelectionCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (![self.selectedColor isEqual:@"none"]){
            cell.colorSelectView.color =[self.selectedColor intValue];
        }
        cell.colorSelectView.colorChoices = [NSMutableArray arrayWithObjects:[productInfo valueForKey:@"color_available"], [productInfo valueForKey:@"stock_balance" ] , nil ];
        cell.colorSelectView.editable = YES;
         cell.colorSelectView.sizesForColor = tempSizesForColor;
        cell.colorSelectView.colorChoicesNum = [[productInfo valueForKey:@"color_available"] count];
       
        cell.colorSelectView.delegate = self;
       // self.selectedColor = 0;
        
        return cell;
        }
    }
    }
    
}
-(void)submitReport:(id)sender{
    ProductReportViewController *detailViewController = [[ProductReportViewController alloc] initWithNibName:@"ProductReportViewController" bundle:nil andProductId:self.productId];
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
-(void)checkOut:(id)sender{
    CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
    if ([cartId isEqualToString:@""]){
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSArray *tempArray =  mydelegate.sidebarController.cartItems;
        for (id row in tempArray){
            NSLog(@"%@",row);
            NSLog(@"%@", [productInfo valueForKey:@"shop_name"]);
            if ([[productInfo valueForKey:@"shop_name"] isEqualToString:[row valueForKey:@"shop_name"]]){
                self.cartId = [row valueForKey:@"cart_id"];
                break;
            }
        }

    }
    NSMutableArray *tempAnswer =[[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForCartId:cartId]] ;
    if([[[tempAnswer objectAtIndex:0] valueForKey:@"status"] isEqual:@"failure"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"An error has occurred. Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    else{
        detailViewController.cartList = tempAnswer;
        detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"checkOutFooterView" owner:self options:nil]objectAtIndex:0];
        detailViewController.footerType = @"0";
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    }
   
}
-(void)continueShopping:(id)sender{
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController popViewControllerAnimated:YES];
}
    - (void)dealloc {
        [selectedColor release];
        [selectedSize release];
    [headerView release];
    [_productDesc release];
    [_sizeView release];
    [_colorSelectView release];
    [_tableView release];
        [buyButton release];
     
    [super dealloc];
}
-(void)sizeview:(SizeSelectView *)sizeView sizeDidChange:(int)size{
    self.selectedSize = [NSString stringWithFormat:@"%d", size];
    if (counter == 3){
        [tempSizesForColor removeAllObjects];
for (NSDictionary *row in [productInfo valueForKey:@"stock_balance"]){
                
                if ([[[[productInfo valueForKey:@"size_available"] objectAtIndex:size] valueForKey:@"size_id"] isEqual:[NSString stringWithFormat:@"%@",[row valueForKey:@"size_id"]]]){
                    
                    [tempSizesForColor addObject:row];
                }
            }
            //  NSLog(@"%@", tempArray);
            //= [NSMutableArray arrayWithArray:tempArray];
        [self.tableView reloadData];
    }
    else{
    
    if ([[[[productInfo valueForKey:@"stock_balance"] objectAtIndex:size] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Out of stock" message:@"This product is currently out of stock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        
    }else{
    self.selectedSize = [NSString stringWithFormat:@"%d", size];
    [self.tableView reloadData];
    }
    }
}
-(void)colorview:(ColorSelectView *)colorView colorDidChange:(int)color{
    if (counter == 3){
        self.selectedColor = [NSString stringWithFormat:@"%d", color];
        [tempColorsForSize removeAllObjects];
        for (NSDictionary *row in [productInfo valueForKey:@"stock_balance"]){
         
            if ([[[[productInfo valueForKey:@"color_available"] objectAtIndex:color] valueForKey:@"color_id"] isEqual:[NSString stringWithFormat:@"%@",[row valueForKey:@"color_id"]]]){
               
        [tempColorsForSize addObject:row];
            }
        }
        [self.tableView reloadData];
        
    }
    else{
    
    if ([[[[productInfo valueForKey:@"stock_balance"] objectAtIndex:color] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Out of stock" message:@"This product is currently out of stock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        
    }else{
        self.selectedColor = [NSString stringWithFormat:@"%d", color];
        [self.tableView reloadData];
    }
    }

}
-(void)clearSelectedSize{
    self.selectedSize = @"none";
    NSLog(@"%@",selectedSize);
}
-(void)clearSelectedColor{
    self.selectedColor =@"none";
        NSLog(@"%@",selectedColor);
}

@end
