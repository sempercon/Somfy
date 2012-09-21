//
//  AppDelegate_iPad.h
//  Somfy
//
//  Created by Sempercon on 4/28/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
#ifdef __IPHONE_3_0

#else

#endif */



@class RoomSelector_ipad,DeviceConfigurator_iPad,SceneConfigurator_iPad,EventConfigurator_iPad,ScheduleConfigurator_iPad;
@class LiveviewDashboard,Scheduleconfigurator_Homeowner,SceneConfigurator_Homeowner,LoginScreen_iPad;
@class MJPEGViewer_iPad;

@interface AppDelegate_iPad : NSObject {
    UIWindow *window;
	UILabel *loadingLabel,*errorLabel;
	UIButton *errorBtn,*reloginBtn,*backtoControllerBtn;
	UIActivityIndicatorView  *spinningWheel;
	UILabel *loadingTitle;
	UIView *loadingView;
	IBOutlet UITabBarController *tabBarController;
	IBOutlet UITabBarController *tabBarController2;
	
	RoomSelector_ipad			*viewController;
	DeviceConfigurator_iPad		*DeviceConfigviewController;
	SceneConfigurator_iPad		*SceneConfigviewController;
	EventConfigurator_iPad		*EventConfigviewController;
	ScheduleConfigurator_iPad	*ScheduleConfigviewController;
	LiveviewDashboard			*DashboardviewController;
	Scheduleconfigurator_Homeowner	*ScheduleConfigHomeviewController;
	SceneConfigurator_Homeowner		*SceneConfigHomeviewController;
	LoginScreen_iPad		*loginScreen_iPadController;
    MJPEGViewer_iPad *MJPEGViewer_iPadController;
	
	//Globals default array
	NSMutableArray *g_roomsArray,*g_selectedRoomsArray,*g_DevicesArray,*g_getThermostatsArray;
	NSMutableArray *g_getTriggerDeviceListArray,*g_ScenesArray,*g_getTimersArray,*g_SessionArray,*g_ScenesInfoArray;
	NSMutableArray *g_getTimersInfoArray,*g_getEventsArray,*g_getEventsInfoArray,*g_formatScheduleList;
	NSMutableArray *g_getTriggerReasonListByDeviceIDArray,*g_homeOccupancyArray;
	NSMutableArray *g_ip_camera_list_Array;
	NSString *isRestart;
    
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *spinningWheel;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel,*errorLabel;
@property (nonatomic, retain) IBOutlet UILabel *loadingTitle;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UITabBarController *tabBarController2;
@property (nonatomic,retain) IBOutlet UIButton *errorBtn,*reloginBtn,*backtoControllerBtn;

@property (nonatomic, retain) IBOutlet RoomSelector_ipad  *viewController;
@property (nonatomic, retain) IBOutlet DeviceConfigurator_iPad	*DeviceConfigviewController;
@property (nonatomic, retain) IBOutlet SceneConfigurator_iPad		*SceneConfigviewController;
@property (nonatomic, retain) IBOutlet EventConfigurator_iPad		*EventConfigviewController;
@property (nonatomic, retain) IBOutlet ScheduleConfigurator_iPad	*ScheduleConfigviewController;
@property (nonatomic, retain) IBOutlet LiveviewDashboard			*DashboardviewController;
@property (nonatomic, retain) IBOutlet Scheduleconfigurator_Homeowner	*ScheduleConfigHomeviewController;
@property (nonatomic, retain) IBOutlet SceneConfigurator_Homeowner		*SceneConfigHomeviewController;
@property (nonatomic, retain) IBOutlet LoginScreen_iPad					*loginScreen_iPadController;
@property (nonatomic, retain) IBOutlet MJPEGViewer_iPad *MJPEGViewer_iPadController;
@property (nonatomic, retain) NSString *isRestart; 


//Globals default array
@property (nonatomic, retain) NSMutableArray *g_roomsArray,*g_selectedRoomsArray,*g_DevicesArray,*g_getThermostatsArray,*g_formatScheduleList;
@property (nonatomic, retain) NSMutableArray *g_getTriggerDeviceListArray,*g_ScenesArray,*g_getTimersArray,*g_SessionArray,*g_ScenesInfoArray;
@property (nonatomic, retain) NSMutableArray *g_getTimersInfoArray,*g_getEventsArray,*g_getEventsInfoArray;
@property (nonatomic, retain) NSMutableArray *g_getTriggerReasonListByDeviceIDArray,*g_homeOccupancyArray;
@property (nonatomic, retain) NSMutableArray *g_ip_camera_list_Array;

+ (AppDelegate_iPad *)sharedAppDelegate;
- (void)showLoadingView:(NSString*)strControllerType;
-(void)hideLoadingView;
-(void)SetInstallerViewIndex:(int)idx;
-(int)GetInstallerViewIndex;
-(void)SetHomeownerViewIndex:(int)idx;
-(int)GetHomeownerViewIndex;


@end

