//
//  DeliveryChoiceViewController.m
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliveryChoiceViewController.h"

@interface DeliveryChoiceViewController ()

@end

@implementation DeliveryChoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Checkout";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.priceLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"price"] stringByStrippingHTML];
        [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_priceLabel release];
    [_nextButton release];
    
    [super dealloc];
}
- (void)viewDidUnload {
 
    [self setPriceLabel:nil];
    [self setNextButton:nil];
    
    [super viewDidUnload];
}
- (IBAction)nextButtonTapped:(id)sender {
    NSDictionary *status = [NSDictionary dictionaryWithDictionary:[[MJModel sharedInstance]submitDeliveryOptionFor:_cartId withOption:self.deliverChoice]];
    if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
        CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
        detailViewController.cartList = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForCartId:_cartId]];
        detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:self options:nil]objectAtIndex:0];
        detailViewController.footerType=@"1";
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
        
    }
    
}
  
@end
