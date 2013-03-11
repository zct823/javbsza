//
//  JBoxViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "JBoxViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"
#import "AGalleryViewController.h"

@interface JBoxViewController ()

@end

@implementation JBoxViewController

- (void)viewDidLoad
{
    self.selectedApp = @"";
    [super viewDidLoad];
    [self loadData];
}

// Overidden method to change API
- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/qrcode_scan_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    NSLog(@"box scan datacontent");
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"news_category_id\":\"%@\",\"keyword\":\"%@\",\"app_type\":\"%@\"}",self.pageCounter, kListPerpage, self.selectedCategories, self.searchedText,self.selectedApp];
}

#pragma mark -
#pragma mark didSelectRow extended action

//- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSLog(@"type is %@",[aQRcodeType objectAtIndex:indexPath.row]);
//    if ([[aQRcodeType objectAtIndex:indexPath.row] isEqualToString:@"JAM-BU Gallery"]) {
//        AGalleryViewController *gallery = [[AGalleryViewController alloc] init];
//        gallery.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
//        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [mydelegate.boxNavController pushViewController:gallery animated:YES];
//        [gallery release];
//        
//    }
//    else{
//        MoreViewController *detailView = [[MoreViewController alloc] init];
//        detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
//        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [mydelegate.boxNavController pushViewController:detailView animated:YES];
//        [detailView release];
//    }
//}

- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.boxNavController pushViewController:detailView animated:YES];
    [detailView release];
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    NSLog(@"Filtering Scanbox list with searched text %@",str);
    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
}


- (void) refreshTableItemsWithFilterApp:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    NSLog(@"Filtering Scanbox list with searched app %@",str);
    self.selectedApp = @"";
    self.selectedApp = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

@end
