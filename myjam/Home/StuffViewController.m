//
//  StuffViewController.m
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "StuffViewController.h"
#import "ASIWrapper.h"
#import "Banner.h"

@interface StuffViewController ()

@end

@implementation StuffViewController

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
    // Setup Banner
//    Banner *bannerView = [[Banner alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
//    [bannerView setBackgroundColor:[UIColor blueColor]];
//    
//    [self.view addSubview:bannerView];
//    [self.view bringSubviewToFront:bannerView];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Setup carousel
    
    
//    [self setup];
}

- (void)setup
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/jambu_ads.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:@""];
    NSLog(@"request %@\n\nresponse data: %@", urlString, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    NSLog(@"dict %@",resultsDictionary);
    if([resultsDictionary count])
    {
        
    }

}

- (void)retrieveImages:(NSString *)uri
{
    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:uri]];
    
    [imageRequest startSynchronous];
    [imageRequest setTimeOutSeconds:2];
    NSError *error = [imageRequest error];
    
    UIImage *aImg = [[UIImage alloc] initWithData:[imageRequest responseData]];
    
    if (error) {
        NSLog(@"error retrieve image: %@",error);
    }
    
    [aImg release];
    [imageRequest release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
