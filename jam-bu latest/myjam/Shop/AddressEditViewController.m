//
//  AddressEditViewController.m
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AddressEditViewController.h"

@interface AddressEditViewController ()

@end

@implementation AddressEditViewController
@synthesize addressInfo, stateSelection, countrySelection,stateButton, countryButton;

#pragma mark -
#pragma mark -Lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Checkout";
        // Custom initialization
    }
    return self;
}

- (void)setStateLabel
{
    for (int i = 0; i <[[addressInfo valueForKey:@"state_list"] count]; i++ ){
        if ([[addressInfo valueForKey:@"delivery_state_code"] isEqual:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"]]){
            [stateButton setTitle:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_name"] forState:UIControlStateNormal];
            self.stateSelection =[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"];
            break;
        }
        
    }
}
- (void)setCountryLabel
{
    for (int i = 0; i <[[addressInfo valueForKey:@"country_list"] count]; i++ ){
        if ([[addressInfo valueForKey:@"delivery_country_code"] isEqual:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_code"]]){
            [countryButton setTitle:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_name"] forState:UIControlStateNormal];
            self.countrySelection =[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_code"];
            return;
        }
        
    }
}
- (void)viewDidLoad
{
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
    self.cityLabel.text = [addressInfo valueForKey:@"delivery_city"];
    self.addressLabel.text =[addressInfo valueForKey:@"delivery_address"] ;
    self.postcodeLabel.text = [addressInfo valueForKey:@"delivery_postcode"];
    if (![[addressInfo valueForKey:@"delivery_state_code"] isEqualToString:@""]){
        [self setStateLabel];
          }
    else{
        self.stateSelection = @"KUL";
        [self.stateButton setTitle:@"Federal Territory of Kuala Lumpur" forState:UIControlStateNormal];

    }
    if (![[addressInfo valueForKey:@"delivery_country_code"] isEqualToString:@""]){
        [self setCountryLabel];
       
    }
    else{
        self.countrySelection  = @"MY";
        [self.countryButton setTitle:@"Malaysia" forState:UIControlStateNormal];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_addressLabel release];
    [_cityLabel release];
    [_postcodeLabel release];
    [stateButton release];
    [countryButton release];
    [addressInfo release];
    [_SelectAddressButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setAddressLabel:nil];
    [self setCityLabel:nil];
    [self setPostcodeLabel:nil];
    [self setStateButton:nil];
    [self setCountryButton:nil];
    [self setSelectAddressButton:nil];
    [super viewDidUnload];

}

#pragma mark -
#pragma mark -IBaction for 3 buttons

- (IBAction)stateTapped:(id)sender {
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 180, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.tag = 0;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden= FALSE;
    [self.view addSubview:myPickerView];
    [myPickerView release];
}

- (IBAction)countryTapped:(id)sender {
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 180, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.tag = 1;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden= FALSE;
    [self.view addSubview:myPickerView];
      [myPickerView release];
}

- (IBAction)selectAddress:(id)sender {
    DeliveryOptionViewController *detailViewController = [[DeliveryOptionViewController alloc] init];
    detailViewController.cartId =_cartId;
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
}
- (void)createAlertViewFor:(NSString*)labelName {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@ is required",labelName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (IBAction)nextTapped:(id)sender {

        if ([self.addressLabel.text isEqualToString:@""]){
            [self createAlertViewFor:@"Address"];
            
            
        } else if([self.cityLabel.text isEqualToString:@""]){
            [self createAlertViewFor:@"City"];
        }else if ([self.postcodeLabel.text isEqualToString:@""]){
            [self createAlertViewFor:@"Postcode"];
            
        } else{
            DeliveryChoiceViewController *detailViewController = [[DeliveryChoiceViewController alloc] initWithNibName:@"DeliveryChoiceViewController" bundle:nil];
        
            NSDictionary *status = [[MJModel sharedInstance] submitAddressForCart:_cartId forAddress:self.addressLabel.text  inCity:self.cityLabel.text withPostcode:_postcodeLabel.text inState:stateSelection inCountry:countrySelection];
            
            if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
                detailViewController.deliveryInfo = [[MJModel sharedInstance] getDeliveryInfoFor:_cartId];
                detailViewController.cartId = _cartId;
                
                AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
            }
            
            //[self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
    
    
}

#pragma mark -
#pragma mark -UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 0){
        [self.stateButton setTitle:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_name"]  forState:UIControlStateNormal];
        stateSelection =[[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_code"];
          
               
    }
    else if (pickerView.tag == 1){
        [self.countryButton setTitle:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_name"] forState:UIControlStateNormal];
        countrySelection = [[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_code"];


    }
    
    pickerView.hidden = TRUE;
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 0){
        return [[addressInfo valueForKey:@"state_list"] count];
    }
    else if (pickerView.tag == 1){
        return [[addressInfo valueForKey:@"country_list"] count];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (pickerView.tag == 0){
        title = [[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_name"];
      
    }
    else if (pickerView.tag == 1){
        title = [[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_name"];
            }
   
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}
#pragma mark-
#pragma mark Textview delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}


@end
