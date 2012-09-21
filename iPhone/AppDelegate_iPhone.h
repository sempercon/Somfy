//
//  AppDelegate_iPhone.h
//  Somfy
//
//  Created by Sempercon on 4/22/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SendCommand.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate,ParserCallback> {
    UIWindow *window;
	UILabel *loadingLabel,*errorLabel;
	UILabel *loadingTitle;
	UIView *loadingView,*newLoadingView;
	UIActivityIndicatorView *spinningWheel;
	IBOutlet UITabBarController *tabBarController;
	IBOutlet UITextField *txtUsername,*txtPassword;
	NSTimer		   *authenticateTimer,*loadGobalValueTimer,*sceneInfoTimer,*timerInfoTimer,*scheduleTimerInfoTimer,*scheduleEventInfoTimer;;
	IBOutlet UIActivityIndicatorView *authenticationProcessing;
	IBOutlet UIButton *btnLogin,*errorBtn,*reloginBtn,*backtoControllerBtn;
	ProcessEnum	   authenticateEnum,initEnum,sceneInfoEnum,timerInfoEnum,scheduleTimerInfoEnum,scheduleEventInfoEnum;
	int sceneInfoCount,timerInfoId,g_objectIndex,isRestart;
	NSMutableDictionary		*g_timerInfoMutableDict;
	NSMutableArray			*loginArray;
	BOOL					isremember,isLoadingError;
	IBOutlet UIButton	*rememberMeBtn;
	
	//TAHOMA CONTROLLER
	IBOutlet UIView			*tahomaControllerView;
	IBOutlet UITableView	*tahomaControllerTable;
	IBOutlet UIScrollView   *scrollView;
	UIView					*tahomaControllerLoadingView;
	
	//Globals default array
	NSMutableArray *g_roomsArray,*g_selectedRoomsArray,*g_DevicesArray,*g_getThermostatsArray,*g_lastCommandArray;
	NSMutableArray *g_getTriggerDeviceListArray,*g_ScenesArray,*g_getTimersArray,*g_SessionArray,*g_ScenesInfoArray;
	NSMutableArray *g_getTimersInfoArray,*g_getEventsArray,*g_getEventsInfoArray,*g_formatScheduleList;
}

@property (nonatomic, retain) UIButton	*rememberMeBtn;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIActivityIndicatorView *spinningWheel;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *loadingTitle,*errorLabel;

//TAHOMA CONTROLLER
@property (nonatomic, retain) UIView			*tahomaControllerView;
@property (nonatomic, retain) UITableView		*tahomaControllerTable;
@property (nonatomic, retain) UIScrollView		*scrollView;


//Globals default array
@property (nonatomic, retain) NSMutableArray *g_roomsArray,*g_selectedRoomsArray,*g_DevicesArray,*g_getThermostatsArray,*g_lastCommandArray;
@property (nonatomic, retain) NSMutableArray *g_getTriggerDeviceListArray,*g_ScenesArray,*g_getTimersArray,*g_SessionArray,*g_ScenesInfoArray;
@property (nonatomic, retain) NSMutableArray *g_getTimersInfoArray,*g_getEventsArray,*g_getEventsInfoArray,*g_formatScheduleList;

@property (nonatomic, retain) UITextField *txtUsername,*txtPassword;
@property (nonatomic, retain) UIButton *btnLogin,*errorBtn,*reloginBtn,*backtoControllerBtn;
@property (nonatomic, retain) UIActivityIndicatorView *authenticationProcessing;

+ (AppDelegate_iPhone *)sharedAppDelegate;
-(IBAction)btnLoginClicked:(id)sender;
-(IBAction)rememberMeBtnClicked:(id)sender;
- (void)showLoadingView;
- (void)showCustomLoadingView;
-(void)hideLoadingView;
-(void)WindowShuoldAppear;

@end

