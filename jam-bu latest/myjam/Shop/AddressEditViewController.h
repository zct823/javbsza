//
//  AddressEditViewController.h
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"
#import "DeliveryDayChoiceViewController.h"
#import "DeliveryChoiceViewController.h"
#import "DeliveryOptionViewController.h"
#import "AppDelegate.h"
#import "MJModel.h"
@interface AddressEditViewController : CoreViewController<UIPickerViewDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSDictionary *addressInfo;
@property (nonatomic, retain) NSString *countrySelection;
@property (nonatomic, retain) NSString *stateSelection;
@property (strong, nonatomic) NSString *cartId;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextView *addressLabel;
@property (retain, nonatomic) IBOutlet UITextView *cityLabel;
@property (retain, nonatomic) IBOutlet UITextView *postcodeLabel;
@property (retain, nonatomic) IBOutlet UIButton *stateButton;
@property (retain, nonatomic) IBOutlet UIButton *countryButton;
@property (retain, nonatomic) UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIButton *SelectAddressButton;
- (IBAction)stateTapped:(id)sender;
- (IBAction)countryTapped:(id)sender;
- (IBAction)selectAddress:(id)sender;

@end
