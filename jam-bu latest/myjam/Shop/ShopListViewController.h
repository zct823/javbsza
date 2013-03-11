//
//  ShopListViewController.h
//  myjam
//
//  Created by Azad Johari on 1/29/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "ShopDetailListingViewController.h"
#import "AppDelegate.h"
#import "MJModel.h"
#import "CustomHeader.h"
#import "ShopViewAllViewController.h"
#import "ShopTableViewCell.h"
#import "CustomHeaderCell.h"
#import "ShopDetailListingViewController.h"
#import <SDWebImage/UIButton+WebCache.h>


@interface ShopListViewController : PullRefreshTableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *catArray;

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern andOptions:optionData;
@property (retain, nonatomic) NSString *selectedCategories;
@property (retain, nonatomic) NSString *searchedText;
@end
