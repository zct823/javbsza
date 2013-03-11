//
//  WriteReviewViewController.m
//  myjam
//
//  Created by Azad Johari on 2/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "WriteReviewViewController.h"

@interface WriteReviewViewController ()

@end

@implementation WriteReviewViewController
@synthesize ratingValue,productInfo= _productInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rateView.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
    self.rateView.selectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    self.ratingValue = [_productInfo valueForKey:@"rating"];
    self.rateView.rating = [[_productInfo valueForKey:@"rating"] intValue];
    self.productName.text = [_productInfo valueForKey:@"product_name"];
    self.shopName.text = [_productInfo valueForKey:@"shop_name"];
    self.productReview.text = [_productInfo valueForKey:@"comment"];
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = self.view.frame;
    CGSize expectedLabelSize  = [[_productInfo valueForKey:@"product_name"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(180.0, self.productName.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect newFrame = self.productName.frame;
    newFrame.size.width = expectedLabelSize.width;
    self.productName.frame = newFrame;
   
    self.lineMiddle.frame = CGRectMake(120 ,self.lineMiddle.frame.origin.y,200-expectedLabelSize.width, 1);
 
    [self.view addSubview:self.scrollView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_shopName release];
    [_productName release];
    [_productReview release];
    [ratingValue release];
    [_rateView release];
    [_lineMiddle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShopName:nil];
    [self setProductName:nil];
    [self setProductReview:nil];
 
    [self setRateView:nil];
    [self setLineMiddle:nil];
    [super viewDidUnload];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
- (IBAction)submitReview:(id)sender {
    NSDictionary *answer = [[MJModel sharedInstance] submitReview:self.productReview.text forProduct:[_productInfo valueForKey:@"product_id"] withRating:self.ratingValue];
    NSLog(@"%@",answer);
    if ([[answer valueForKey:@"status"] isEqual:@"ok"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Succesful"
                              message: @"Comment has successfully been added"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CommentWritten"
         object:self];
    }

}

- (void)rateView:(RateView *)rateView ratingDidChange:(int)rating {
    self.ratingValue =  [NSString stringWithFormat:@"%d", rating];
}

- (IBAction)visitShop:(id)sender {
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (int i=0 ; i< [mydelegate.shopNavController.viewControllers count]; i++){
        NSLog(@"%@",[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] );
        
        if( [[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] isEqual:[ShopDetailListingViewController class]])
        {
            NSLog(@"ok");
            
            [mydelegate.shopNavController popToViewController:[mydelegate.shopNavController.viewControllers objectAtIndex:i] animated:YES];
            break;
            
        }
        
        
    }
    
    
    
}
@end
