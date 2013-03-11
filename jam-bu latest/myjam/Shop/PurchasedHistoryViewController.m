//
//  PurchasedHistoryViewController.m
//  myjam
//
//  Created by Azad Johari on 2/23/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PurchasedHistoryViewController.h"

@interface PurchasedHistoryViewController ()

@end

@implementation PurchasedHistoryViewController
@synthesize purchasedHistory;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCategories = @"";
    self.searchedText = @"";
    self.selectedStatus = @"";
    self.purchasedHistory = [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getPurchasedHistoryItems]];
    self.purchasedHistoryArray = [[NSMutableArray alloc] initWithArray:[self.purchasedHistory valueForKey:@"list"]];
    self.totalPage = [self.purchasedHistory valueForKey:@"pagecount"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshPurchaseHistory" object:nil];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];


    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        kDisplayPerscreen = 4;
    } else {
        // code for 3.5-inch screen
        kDisplayPerscreen = 3;
    }
    
   
}

- (void)loadData
{
    [self.activityIndicator startAnimating];
    //    [self performSelectorOnMainThread:@selector(setupView) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(setupView) withObject:nil];
}

- (void)setupView
{
    self.selectedCategories = @"";
    self.searchedText = @"";
    self.selectedStatus = @"";
    
    NSString *isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"]copy];
    
    // check if login is remembered in local cache
    if ([isLogin isEqualToString:@"YES"]) {
        
        int nextPage = (int)[self.purchasedHistory valueForKey:@"page"] +1;
        NSDictionary *result = [[MJModel sharedInstance] getPurchasedHistoryFor:self.searchedText cats:self.searchedText arrangedBy:self.selectedStatus forPage:[NSString stringWithFormat:@"%d",nextPage ]];
        
        if ([[result valueForKey:@"list" ] count]  > 0) {
            self.purchasedHistory = result;
        }
        
    
    }
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark Bottom Loadmore action

- (void) addItemsToEndOfTableView{
    //    [super addItemsToEndOfTableView];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageCounter >= self.totalPage)
        {
            if (([self.purchasedHistoryArray count] > kDisplayPerscreen)) {
                [self.tableView setContentOffset:CGPointMake(0, (([self.purchasedHistoryArray count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
            }else{
                
                CGRect screenBounds = [[UIScreen mainScreen] bounds];
                if (screenBounds.size.height != 568) {
                    // code for 4-inch screen
                    [self.tableView setContentOffset:CGPointMake(0, (([self.purchasedHistoryArray count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
                }
            }
            
        }else if (self.pageCounter < self.totalPage){
            self.pageCounter++;
            NSArray *list = [self loadMoreFromServer];
            
            if ([list count] > 0) {
                [self.purchasedHistoryArray addObjectsFromArray:list];
            }
            
        }
    }];
}

- (NSMutableArray *)loadMoreFromServer
            {
             
                NSDictionary *resultsDictionary =  [[MJModel sharedInstance] getPurchasedHistoryFor:self.searchedText cats:self.selectedCategories arrangedBy:self.selectedStatus forPage:[NSString stringWithFormat:@"%d",self.pageCounter+1]];
            if([resultsDictionary count])
                {
                NSString *status = [resultsDictionary objectForKey:@"status"];
                    NSMutableArray* resultArray;
                    
                    if ([status isEqualToString:@"ok"])
                    {
                        self.totalPage = [[resultsDictionary objectForKey:@"pagecount"] intValue];
                        
                        resultArray = [resultsDictionary objectForKey:@"list"];
                        
                        for (id row in resultArray)
                        {
                            [self.purchasedHistoryArray addObject:row];
                        
                        }
                    }
                        if (![resultArray count] || self.totalPage == 0)
                        {
                            [self.activityIndicator setHidden:YES];
                            
                            NSString *aMsg = [resultsDictionary objectForKey:@"message"];
                            
                            if([aMsg length] < 1)
                            {
                                if (self.selectedCategories.length > 0)
                                {
                                    aMsg = @"No data matched.";
                                }
                            }
                            
                            
                            self.loadingLabel.text = [NSString stringWithFormat:@"%@",aMsg];
                            [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                            self.loadingLabel.textColor = [UIColor grayColor];
                          
                        }
                        
                        NSLog(@"page now is %d",self.pageCounter);
                        NSLog(@"totpage %d",self.totalPage);
                        
                        // if data is less, then hide the loading view
                        if (([[resultsDictionary valueForKey:@"list"] count] > 0 && [[resultsDictionary valueForKey:@"list"] count] < kListPerpage)) {
                            NSLog(@"here xx");
                            [self.activityIndicatorView setHidden:YES];
                            
                        }
                        
                
            

if ([status isEqualToString:@"error"]) {
                    [self.activityIndicatorView setHidden:NO];
                    [self.activityIndicator setHidden:YES];
                    
                    NSString *errorMsg = [resultsDictionary objectForKey:@"message"];
                    
                    if([errorMsg length] < 1)
                        errorMsg = @"Failed to retrieve data.";
                    
                    self.loadingLabel.text = [NSString stringWithFormat:@"%@",errorMsg];
                    [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                    self.loadingLabel.textColor = [UIColor grayColor];
                    
                }
                
                if ([status isEqualToString:@"ok"] && self.totalPage == 0) {
                    NSLog(@"empty");
                    [self.activityIndicatorView setHidden:NO];
                    [self.activityIndicator setHidden:YES];
                    self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
                    [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                    self.loadingLabel.textColor = [UIColor grayColor];
                }
                
                if ([status isEqualToString:@"ok"] && self.totalPage > 1 && ![[resultsDictionary objectForKey:@"list"] count]) {
                    NSLog(@"data empty");
                    [self.activityIndicatorView setHidden:YES];
                    //        [self.tableView setContentOffset:CGPointMake(0, (([self.tableData count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
                }
                
                
                [resultsDictionary release];
                
                        }

            }
                
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [self.purchasedHistoryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PurchasedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedViewCell" owner:nil options:nil]  objectAtIndex:0];
        
    }
   [self createCellForIndex:indexPath cell:cell];
    return cell;
}

-(void)createCellForIndex:(NSIndexPath*)indexPath cell:(PurchasedViewCell*)cell{
    cell.productName.text =[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"product_name"];
    cell.priceLabel.text =[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"price"];
    cell.dateLabel.text =[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"date_purchased"];
     cell.qtyLabel.text =[[self.purchasedHistoryArray objectAtIndex:indexPath.section] valueForKey:@"quantity"];
    if (![[[[ self.purchasedHistoryArray objectAtIndex:indexPath.section] valueForKey:@"size_name"] class] isEqual:[NSNull class]]){
         cell.sizeLabel.text = [[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"size_name"];
    }
   
    cell.statusLabel.text = [[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"order_status"] stringByStrippingHTML];
    if (![[[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"product_image"] class] isEqual:[NSNull class]]){
         [cell.imageView setImageWithURL:[NSURL URLWithString:[[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"product_image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]]; 
    }
  
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
    detailViewController.productInfo = [[MJModel sharedInstance] getPuchasedInfoForId:[[[purchasedHistory valueForKey:@"list" ]objectAtIndex:indexPath.section]valueForKey:@"order_item_id"]];
       detailViewController.buyButton = [[NSString alloc] initWithString:@"not-ok"];
    detailViewController.productId = [[self.purchasedHistoryArray objectAtIndex:indexPath.section]valueForKey:@"product_id"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
  }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PurchasedHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedHeaderView" owner:self options:nil]objectAtIndex:0];
    header.sellerName.text= [[[purchasedHistory valueForKey:@"list" ]objectAtIndex:section]valueForKey:@"shop_name"];
    header.orderNo.text=[[[purchasedHistory valueForKey:@"list" ]objectAtIndex:section]valueForKey:@"order_no"];
    
   
    
    return  header;
}
- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern andOptions:(NSString*)optionData{
    
    NSLog(@"Filtering news list with searched text %@",str);
    self.purchasedHistory =  [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getPurchasedHistoryFor:pattern cats:str arrangedBy:optionData forPage:@"1"]];
                                                                                               

    [[super tableView] reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
    
    
}
-(void)refreshTable:(NSNotification*)notification{
    
    [self refreshTableItemsWithFilter:@"" andSearchedText:@"" andOptions:@""];

}



@end
