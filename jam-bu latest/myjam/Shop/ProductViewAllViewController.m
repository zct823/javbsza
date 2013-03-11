//
//  ProductViewAllViewController.m
//  myjam
//
//  Created by Azad Johari on 2/13/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductViewAllViewController.h"
#define kTableCellHeight 150
@interface ProductViewAllViewController ()

@end

@implementation ProductViewAllViewController
@synthesize shopInfo, catName, productAllArray, tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"JAM-BU Shop";
    }
    return self;
}
-(id)initWith:(NSDictionary*)shopInfo andCat:(NSString*)catName{
    
   self = [super initWithNibName:@"ProductViewAllViewController" bundle:nil];
    if (self){
        self.shopInfo = shopInfo;
        self.catName = catName;
                
        
        // ...
    }
    
    return self;
    
}
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{   /* UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 435, 320, 44.0);*/
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[mydelegate.window addSubview:button];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if ( ([productAllArray count] % 0) == 0){
        return ([productAllArray count]/3)+1;
    }
    else{
        return (([productAllArray count]/3) + 2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    if(indexPath.row == 0){
        ShopHeaderViewCell *cell = (ShopHeaderViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopHeaderViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.shopLabel.text = [self.shopInfo valueForKey:@"shop_name"];
        if([[self.shopInfo valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
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
    // Configure the cell...
    [self createCellForIndex:indexPath cell:cell];
    return cell;
}

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 44;
    }
    else{
    return kTableCellHeight;
}
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(ProductTableViewCell *)cell
{
    if (indexPath.row ==1){
        UILabel *catNameLabelTemp = [[UILabel alloc] init];
     
          CGSize expectedLabelSize  = [self.catName sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, cell.catNameLabel.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        

        CGRect newFrame = cell.catNameLabel.frame;
        newFrame.size.width = expectedLabelSize.width;
        cell.catNameLabel.text = catName;
        cell.catNameLabel.frame = newFrame;
        [catNameLabelTemp release];
       cell.viewAllButton.hidden = YES;
        cell.middleLine.frame = CGRectMake(expectedLabelSize.width+50,cell.middleLine.frame.origin.y,300-expectedLabelSize.width-50, 1);

    }else{
        cell.productHeader.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // Configure the cell...
    //  cell.topLabel1.text =
    cell.catLabel1.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]  valueForKey:@"product_name"];
    
     cell.productLabel1.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_category"];
    cell.priceLabel1.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_price"];
    cell.transView1.hidden = NO;

    if ([[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
        cell.rateView1.hidden = TRUE;
    }else{
    cell.rateView1.editable = FALSE;
    cell.rateView1.selectedImage = [UIImage imageNamed:@"star.png"];
    cell.rateView1.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
    cell.rateView1.maxRating = 5;
    cell.rateView1.rating = (int)[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_rating"] ;
    }
    cell.button1.tag = 3*(indexPath.row-1)+0;
    [cell.button1 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
     [cell.button1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    if(3*(indexPath.row-1)+1 < [productAllArray count])
    {
    cell.catLabel2.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]  valueForKey:@"product_name"];
     cell.transView2.hidden = NO;
    cell.productLabel2.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_category"];
        cell.priceLabel2.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_price"];
         cell.button2.tag = 3*(indexPath.row-1)+1;
        [cell.button2 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [cell.button2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
            cell.rateView2.hidden = TRUE;
        } else{
        cell.rateView2.editable = FALSE;
        cell.rateView2.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView2.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
        cell.rateView2.maxRating = 5;
            cell.rateView2.rating = (int)[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_rating"] ;}
        
    if(3*(indexPath.row-1)+2 < [productAllArray count])
    {
        cell.catLabel3.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]  valueForKey:@"product_name"];
        
        cell.productLabel3.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_category"];
        cell.priceLabel3.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_price"];
                [cell.button3 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
         cell.transView3.hidden = NO;
         cell.button3.tag = 3*(indexPath.row-1)+2;
        if ([[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
            cell.rateView3.hidden = TRUE;
        }
        else{
        cell.rateView3.editable = FALSE;
        cell.rateView3.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView3.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
        cell.rateView3.maxRating = 5;
            cell.rateView3.rating =(int)[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_rating"] ;}
        
        [cell.button3 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
   }
}
-(void)tapAction:(id)sender{
    DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
    NSLog(@"%@",productAllArray);
    NSString *prodId = [[productAllArray  objectAtIndex:[sender tag] ] valueForKey:@"product_id" ];
    detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:prodId];
     detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
    detailViewController.productId = [prodId mutableCopy];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];

}
-(void) dealloc{
    [productAllArray release];
    [shopInfo release];
    [catName release];
    [tableView release];
    [super dealloc];
}
@end
