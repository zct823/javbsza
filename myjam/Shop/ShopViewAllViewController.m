//
//  ShopViewAllViewController.m
//  myjam
//
//  Created by Azad Johari on 2/11/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopViewAllViewController.h"
#define kTableCellHeight 140
@interface ShopViewAllViewController ()

@end

@implementation ShopViewAllViewController
@synthesize catAllArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"JAM-BU Shop";
    }
    return self;
}

- (void)viewDidLoad
{
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
    
    CustomTableHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableHeader" owner:self options:nil]objectAtIndex:0];
    headerView.catTitle.text = [[catAllArray objectAtIndex:0] valueForKey:@"shop_category"];
    
    CGSize expectedLabelSize  = [[[catAllArray objectAtIndex:0] valueForKey:@"shop_category"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, headerView.catTitle.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = headerView.catTitle.frame;
    newFrame.size.width = expectedLabelSize.width;
 headerView.catTitle.text = [[catAllArray objectAtIndex:0] valueForKey:@"shop_category"];
    
    headerView.catTitle.frame = newFrame;
           headerView.middleLine.frame = CGRectMake(expectedLabelSize.width+50,headerView.middleLine.frame.origin.y,300-expectedLabelSize.width-50, 1);
   
    self.tableView.tableHeaderView = headerView;
    [super viewDidLoad];

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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ( ([catAllArray count] % 3) == 0){
        return ([catAllArray count]/3);
    }
    else{
        return (([catAllArray count]/3) + 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ShopTableViewCellwoCat *cell = (ShopTableViewCellwoCat*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCellwoCat" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    // Configure the cell...
       [self createCellForIndex:indexPath cell:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(ShopTableViewCellwoCat *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    //  cell.topLabel1.text =
    cell.catLabel1.text = [[catAllArray objectAtIndex:(3*indexPath.row+0)]  valueForKey:@"shop_name"];
    
    if([[[catAllArray  objectAtIndex:(3*indexPath.row+0)] valueForKey:@"shop_top_seller"]isEqual:@"Y"]){
        cell.topLabel1.hidden=NO;
    }
    cell.shopLabel1.text =[[catAllArray objectAtIndex:(3*indexPath.row+0)] valueForKey:@"shop_category"];
  
 
    cell.button1.tag = 3*indexPath.row+0;
 [cell.button1 setBackgroundImageWithURL:[NSURL URLWithString:[[catAllArray objectAtIndex:(3*indexPath.row+0)]  valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    
     [cell.button1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    if(3*indexPath.row+1 < [catAllArray count])
    {
            cell.button2.tag = 3*indexPath.row+1;
        if([[[catAllArray  objectAtIndex:(3*indexPath.row+1)] valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
            cell.topLabel2.hidden=NO;
        }

        cell.catLabel2.text = [[catAllArray  objectAtIndex:(3*indexPath.row+1)] valueForKey:@"shop_name"];
        cell.shopLabel2.text =[[catAllArray objectAtIndex:(3*indexPath.row+1)] valueForKey:@"shop_category"];
        
        [cell.button2 setBackgroundImageWithURL:[NSURL URLWithString:[[catAllArray objectAtIndex:(3*indexPath.row+1)]  valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
        [cell.button2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(3*indexPath.row+2 < [catAllArray count])
    {
        cell.button3.tag = 3*indexPath.row+2;
        cell.catLabel3.text = [[catAllArray objectAtIndex:(3*indexPath.row+2)] valueForKey:@"shop_name"];
        cell.shopLabel3.text =[[catAllArray objectAtIndex:(3*indexPath.row+2)] valueForKey:@"shop_category"];
        if([[[catAllArray  objectAtIndex:(3*indexPath.row+2)] valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
            cell.topLabel3.hidden=NO;
             [cell.button3 setBackgroundImageWithURL:[NSURL URLWithString:[[catAllArray objectAtIndex:(3*indexPath.row+2)]  valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
            [cell.button3 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];

    }
         
     
    
      
    }
}
-(void)tapAction:(id)sender{
    ShopDetailListingViewController *detailViewController = [[ShopDetailListingViewController alloc] init];
   detailViewController.productArray = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getTopListOfItemsFor:[[catAllArray objectAtIndex:[sender tag]]valueForKey:@"shop_id"]]];
    detailViewController.shopInfo = [[NSDictionary alloc] initWithObjectsAndKeys: [[catAllArray objectAtIndex:[sender tag]]valueForKey:@"shop_id"],@"shop_id",[[catAllArray objectAtIndex:[sender tag]]valueForKey:@"shop_name"], @"shop_name", [[catAllArray objectAtIndex:[sender tag]]valueForKey:@"shop_top_seller"],@"shop_top_seller", nil];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
  //  [detailViewController release];
    NSLog(@"tapped: %d",[sender tag]);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
