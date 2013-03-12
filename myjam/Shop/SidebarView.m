//
//  SidebarView.m
//  myjam
//
//  Created by nazri on 11/19/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "SidebarView.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "ContactViewController.h"
#import "CalenderViewController.h"
#import "MapViewController.h"
#import "ShowSocialViewController.h"
#import "FAQViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"

#define kTableCellHeight 80
@interface SidebarView ()

@end

@implementation SidebarView
@synthesize cartItems;
-(id)init{
    self = [super init];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCartChange:) name:@"cartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"reloadImage"
                                               object:nil];
    

    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
        [self retrieveImageFromAPI];
        
        [self setUserInfo];

    // To initiate Cart
 
}



- (void)viewDidLoad
{
       self.cartItems = [[MJModel sharedInstance] getCartList]  ;
    [self updateTabBar];
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    
//    NSString *fullname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"] copy];
//    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] copy];
//    self.nameLabel.text = fullname;
//    self.emailLabel.text = email;
    
    UISwipeGestureRecognizer *swipeRightRecognizer;
    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self contentView] addGestureRecognizer:swipeRightRecognizer];
    [swipeRightRecognizer release];
    
    self.contactLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapContactRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleContact)];
    [self.contactLabel addGestureRecognizer:tapContactRecoginzer];
    [tapContactRecoginzer release];
    
    self.calenderLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapCalendarRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCalendar)];
    [self.calenderLabel addGestureRecognizer:tapCalendarRecoginzer];
    [tapCalendarRecoginzer release];
    
    self.mapsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMap)];
    [self.mapsLabel addGestureRecognizer:tapMapRecognizer];
    [tapMapRecognizer release];
    
    self.socialLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSocialRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSocial)];
    [self.socialLabel addGestureRecognizer:tapSocialRecognizer];
    [tapSocialRecognizer release];
    
    self.faqLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFAQRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFAQ)];
    [self.faqLabel addGestureRecognizer:tapFAQRecognizer];
    [tapFAQRecognizer release];
    
    self.settingsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSettingsRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSettings)];
    [self.settingsLabel addGestureRecognizer:tapSettingsRecognizer];
    [tapSettingsRecognizer release];
    
    self.feedbackLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFeedbackRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFeedback)];
    [self.feedbackLabel addGestureRecognizer:tapFeedbackRecognizer];
    [tapFeedbackRecognizer release];
    
    self.aboutLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAboutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAbout)];
    [self.aboutLabel addGestureRecognizer:tapAboutRecognizer];
    [tapAboutRecognizer release];
    
    self.logoutLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLogoutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogout)];
    [self.logoutLabel addGestureRecognizer:tapLogoutRecognizer];
    [tapLogoutRecognizer release];
}


- (void)retrieveImageFromAPI
{
    NSString *flag = @"DEFAULT";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\"}",flag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    //NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSDictionary* resultProfile;
        
        
        if ([status isEqualToString:@"ok"])
        {
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            resultProfile = [resultsDictionary objectForKey:@"profile"];
            
            NSString *fname = [resultProfile objectForKey:@"fullname"];
            NSString *email = [resultProfile objectForKey:@"email"];
            NSString *mobile = [resultProfile objectForKey:@"mobileno"];
            
            [localData setObject:fname forKey:@"fullname"];
            [localData setObject:email forKey:@"email"];
            [localData setObject:mobile forKey:@"mobile"];
            
            NSString *urlImg = [resultProfile objectForKey:@"avatar_url"];
            NSLog(@"urlImg :%@",urlImg);
            [self.profileImage setImageWithURL:[NSURL URLWithString:urlImg]
                              placeholderImage:[UIImage imageNamed:@"blank_avatar.png"]];
        }
        
    }
    [resultsDictionary release];
}

#pragma mark -
#pragma mark notification Center

- (void) reloadImage
{
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadImage"object:self];
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"reloadImage"]) {
        NSLog (@"Successfully reload image!");
        [self retrieveImageFromAPI];
        [self setUserInfo]; //just add this code.
    }
}
- (void)setUserInfo
{
    NSString *fullname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"] copy];
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] copy];
    NSString *mobile = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] copy];
    self.nameLabel.text = fullname;
    self.emailLabel.text = email;
    self.mobileLabel.text = mobile;
    
    [fullname release];
    [email release];
    [mobile release];
}

- (void)viewDidUnload
{
    [self setContactLabel:nil];
    [self setCalenderLabel:nil];
    [self setMapsLabel:nil];
    [self setSocialLabel:nil];
    [self setLogoutLabel:nil];
    [self setNameLabel:nil];
    [self setEmailLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    self.contentView = nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushController:(UIViewController *)controller
{
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate handleTab5];
    [mydelegate.otherNavController popToRootViewControllerAnimated:NO];
    [mydelegate.otherNavController pushViewController:controller animated:NO];
    [mydelegate.tabView activateController:4];
    
    
    // Manually change the selected tabButton
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == 4) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
}

- (void)handleSwipeRight
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate handleTab5];
}

- (void)handleContact
{
    NSLog(@"handleContact");
    
    ContactViewController *contact = [[ContactViewController alloc] init];
    [self pushController:contact];
    [contact release];
}

- (void)handleCalendar
{
    NSLog(@"handleCalendar");
    
    CalenderViewController *cal = [[CalenderViewController alloc] init];
    [self pushController:cal];
    [cal release];
}

- (void)handleMap
{
    NSLog(@"handleMap");
    
    MapViewController *map = [[MapViewController alloc] init];
    [self pushController:map];
    [map release];
}


- (void)handleSocial
{
    NSLog(@"handleSocial");
    
    ShowSocialViewController *soc = [[ShowSocialViewController alloc] init];
    [self pushController:soc];
    [soc release];
}

- (void)handleFAQ
{
    NSLog(@"handleFAQ");
    
    FAQViewController *faq = [[FAQViewController alloc] init];
    [self pushController:faq];
    [faq release];
}

- (void)handleFeedback
{
    NSLog(@"handleFeedback");
    
    FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
    [self pushController:feedback];
    [feedback release];
}
- (void)handleSettings
{
    NSLog(@"handleSettings");
    
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self pushController:settings];
    [settings release];
}

- (void)handleAbout
{
    AboutViewController *about = [[AboutViewController alloc] init];
    [self pushController:about];
    [about release];
}


- (void)handleLogout
{
    NSLog(@"handleLogout");
    
    // If OK, go to alertview delegate
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Logout JAM-BU" message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
    [alert release];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [mydelegate presentLoginPage];
        NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
        [localData setObject:@"" forKey:@"tokenString"];
        [localData setObject:@"" forKey:@"fullname"];
        [localData setObject:@"" forKey:@"email"];
        [localData setObject:@"" forKey:@"mobile"];
        [localData setObject:@"NO" forKey:@"islogin"];
        [localData setObject:@"YES" forKey:@"isReloadNewsNeeded"];
        [localData synchronize];
        [mydelegate handleTab5];
        [mydelegate.tabView activateController:0];
        [mydelegate.tabView activateTabItem:0];
    }
    
}

- (void)dealloc {
    [_contactLabel release];
    [_calenderLabel release];
    [_mapsLabel release];
    [_socialLabel release];
    [_contentView release];
    [_logoutLabel release];
    [_nameLabel release];
    [_emailLabel release];
    [cartItems release];
    [_tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    if ([cartItems count] > 0 ){
         return [cartItems count];
    }
    else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[[cartItems objectAtIndex:section] valueForKey:@"item_list" ] count] >0 ){
       return ([[[cartItems objectAtIndex:section] valueForKey:@"item_list" ] count] + 2);
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //if last row
    
    if (indexPath.row == ([[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] count]+1 )){
        
        SideBarFooterCell *cell = (SideBarFooterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideBarFooterCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
       //     cell.adminFeeLabel.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"admin_fee" ] componentsSeparatedByString:@":"] objectAtIndex:1] ;
            cell.totalLabel.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"grand_total" ] componentsSeparatedByString:@":"] objectAtIndex:1];
            cell.shopNameLabel.text =[[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_name" ] ;
            [cell.checkOutButton setTag:indexPath.section];
            [cell.checkOutButton addTarget:self action:@selector(checkOutTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
      //  [self createCellForIndex:indexPath cell:cell];
        
        return cell;
    }
    //if first row
    else if(indexPath.row == 0 )
    
    {
        SidebarTableHeaderView *cell = (SidebarTableHeaderView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SidebarTableHeaderView" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.shopName.text = [[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_name" ] ;
            [cell.shopLogo setImageWithURL:[[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_logo" ]  placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
        }
        
        return cell;
    }
    else{
    
    SideBarCartCell *cell = (SideBarCartCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideBarCartCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [self createCellForIndex:indexPath cell:cell];
    return cell;
}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ([[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] count] + 1 )){
        return 150;
    }
    else if(indexPath.row == 0){
        return 80;
    }
    else{
       return kTableCellHeight;
    }
    
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(SideBarCartCell *)cell
{
    NSLog(@"%@", cartItems);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![[[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]  valueForKey:@"product_name"] class ]isEqual:[NSNull class]]){
      cell.productItem.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]  valueForKey:@"product_name"];
    }
    
    cell.priceLabel.text =  [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ]  objectAtIndex:indexPath.row-1] valueForKey:@"total_price"];
    cell.qtyLabel.text =  [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]valueForKey:@"quantity"];
    
    if ([[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ]   objectAtIndex:indexPath.row-1] valueForKey:@"color_code"] isEqual:@""]){
        cell.colorView.hidden = true;
    }
    else{
        [cell.colorView setBackgroundColor:[UIColor colorWithHex:[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"color_code"]]];
    }
    if ([[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"size_name"] isEqual:@""]){
        cell.colorView.hidden=TRUE;
    }else{
        cell.sizeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_button.png",[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"size_name" ]]];
    }
    
    if (![[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"product_image"]isKindOfClass: [NSNull class]])
    {
        [cell.productImage setImageWithURL:[NSURL URLWithString:[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"product_image"] ] placeholderImage:[UIImage imageNamed:@"default_icon.png"]] ;
    }
    else{
        cell.productImage.image = [UIImage imageNamed:@"default_icon.png"];
    }
    cell.minusButton.tag = indexPath.section*1000 + indexPath.row*100 +1;
    cell.addButton.tag = indexPath.section*1000 + indexPath.row*100 ;
    [cell.addButton addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusButton addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)changeQty:(id)sender{
    NSString *newQty ;
    //For add item
    NSLog(@"%d", [sender tag]);
    if (([sender tag] % 2) == 0){
        NSLog(@"%d",(([sender tag]/100)-1));
          NSLog(@"%@",cartItems);
        newQty = [NSString stringWithFormat:@"%d",([[[[[cartItems objectAtIndex:([sender tag]/1000)] valueForKey:@"item_list"]  objectAtIndex:((([sender tag]%1000)/100)-1)]  valueForKey:@"quantity" ] intValue] +1)  ];
        
    }
    //For minus item
    else{
         newQty = [NSString stringWithFormat:@"%d",([[[[[cartItems objectAtIndex:([sender tag]/1000)] valueForKey:@"item_list"]  objectAtIndex:((([sender tag]%1000)/100)-1)]   valueForKey:@"quantity" ] intValue] -1)  ];;
        
        }
    if ([newQty isEqualToString:@"-1"])
    {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Unsuccessful"
                                  message: @"Insufficient stock"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    
    //TODO if cart empty
    
    self.cartItems = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] updateProduct:[[[[cartItems objectAtIndex:([sender tag]/1000)] valueForKey:@"item_list"]  objectAtIndex:((([sender tag]%1000)/100)-1)] valueForKey:@"cart_item_id"] forCart:[[cartItems objectAtIndex:([sender tag]/1000)]valueForKey:@"cart_id"]  forQuantity:newQty]];
    
    [self.tableView reloadData];
    [self updateTabBar];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"cartChangedFromView"
     object:self];
  //  [self updatePage];
    
}
- (void)updateTabBar {
     int counter = 0;
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (id row in cartItems ){
        for (id items in [row valueForKey:@"item_list"]){
           
            counter = counter + [[items valueForKey:@"quantity"] intValue];
            
        }
    }
    //  [mydelegate tabView]
    if (counter == 0){
        [mydelegate removeCustomBadge];
    }
    else{
    [mydelegate setCustomBadgeWithText:[NSString stringWithFormat:@"%d",counter]];
    }
}

-(void)shoppingCartChange:(NSNotification *)notification{
    self.cartItems = [[MJModel sharedInstance] getCartList];
  
    [self updateTabBar];
  
    [self.tableView reloadData];
    
    
   // [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:@"1"];
}
-(void)checkOutTapped:(id)sender{
    CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
    detailViewController.cartList = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForRow:[NSNumber numberWithInteger:[sender tag]]] ];
    detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"checkOutFooterView" owner:self options:nil]objectAtIndex:0];
    detailViewController.footerType = @"0";
   

    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:NO];

    
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^
     {
         mydelegate.tabView.view.frame = CGRectMake(0, 0.0f, mydelegate.window.frame.size.width, mydelegate.window.frame.size.height);
      //   mydelegate.bannerView.frame = CGRectMake(0, mydelegate.window.frame.size.height-39-bannerHeight, mydelegate.window.frame.size.width, mydelegate.bannerHeight);
         mydelegate.sidebarController.view.frame = CGRectMake(320.0f, 0.0f, mydelegate.sidebarController.view.frame.size.width, mydelegate.window.frame.size.height);
         
     }
                     completion:^(BOOL finished){}];
    
    //[mydelegate->frontLayerView removeFromSuperview];
   // [self pushController:detailViewController];
    [detailViewController release];
   }
@end
