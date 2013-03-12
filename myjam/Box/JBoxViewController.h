//
//  JBoxViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"


@interface JBoxViewController : NewsViewController

@property (retain, nonatomic) NSString *selectedApp;

- (void) refreshTableItemsWithFilterApp:(NSString *)str andSearchedText:(NSString *)pattern;

@end
