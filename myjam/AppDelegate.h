//
//  AppDelegate.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTabBar.h"
#import "SidebarView.h"
#import "BottomSwipeView.h"
#import "BottomSwipeViewScanBox.h"
#import "BottomSwipeViewShareBox.h"
#import "BottomSwipeViewFavBox.h"
#import "BottomSwipeViewCreateBox.h"
#import "HomeViewController.h"
#import "Banner.h"
#import "CustomBadge.h"
#import "TutorialView.h"
//#import "ContactViewController.h"
@class SidebarView;
@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	GTabBar *tabView;
    UIView *frontLayerView;
    int LayerOption;
}

@property (nonatomic, retain) UINavigationController* shopNavController;
@property (nonatomic, retain) UINavigationController* scanNavController;
@property (nonatomic, retain) UINavigationController* boxNavController;
@property (nonatomic, retain) UINavigationController* homeNavController;
@property (nonatomic, retain) UINavigationController* otherNavController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SidebarView *sidebarController;
@property (nonatomic, retain) BottomSwipeView *bottomController;
@property (nonatomic, retain) BottomSwipeViewScanBox *bottomSVScanBox;
@property (nonatomic, retain) BottomSwipeViewShareBox *bottomSVShareBox;
@property (nonatomic, retain) BottomSwipeViewFavBox *bottomSVFavBox;
@property (nonatomic, retain) BottomSwipeViewCreateBox *bottomSVCreateBox;
@property (nonatomic, retain) GTabBar *tabView;
@property (nonatomic, retain) Banner *bannerView;
@property (nonatomic, retain) TutorialView *tutorial;
@property (nonatomic, retain) NSString *swipeOptionString;
@property (nonatomic, retain) NSMutableArray *arrayTemp;
@property (nonatomic, retain) CustomBadge *cartCounter;

@property int indexTemp;
@property int swipeController;

@property BOOL isSetupDone;
@property BOOL sideBarOpen;
@property BOOL bottomViewOpen;
@property BOOL swipeBottomEnabled;

- (void)setupViews;
- (void)handleTab5;
- (void)handleSwipeUp;
- (void)presentLoginPage;
- (void)clearViews;

- (void)closeSession; //fb login


@end
