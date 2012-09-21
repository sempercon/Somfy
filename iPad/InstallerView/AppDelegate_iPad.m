//
//  AppDelegate_iPad.m
//  Somfy
//
//  Created by Sempercon on 4/28/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "RoomSelector_ipad.h"
#import "LiveviewDashboard.h"
#import "SceneConfigurator_Homeowner.h"
#import "Scheduleconfigurator_Homeowner.h"
#import "LoginScreen_iPad.h"
#import "MJPEGViewer_iPad.h"
#import "SceneConfigurator_iPad.h"
#import "EventConfigurator_iPad.h"
#import "ScheduleConfigurator_iPad.h"

@implementation AppDelegate_iPad

@synthesize window;
@synthesize tabBarController;
@synthesize tabBarController2;

@synthesize viewController;
@synthesize DeviceConfigviewController,SceneConfigviewController,EventConfigviewController,ScheduleConfigviewController;
@synthesize DashboardviewController,ScheduleConfigHomeviewController,SceneConfigHomeviewController;
@synthesize MJPEGViewer_iPadController;

@synthesize g_roomsArray,g_selectedRoomsArray,g_DevicesArray,g_getThermostatsArray,g_formatScheduleList;
@synthesize g_getTriggerDeviceListArray,g_ScenesArray,g_getTimersArray,g_SessionArray,g_ScenesInfoArray;
@synthesize g_getTimersInfoArray,g_getEventsArray,g_getEventsInfoArray;
@synthesize g_getTriggerReasonListByDeviceIDArray,g_homeOccupancyArray;
@synthesize loginScreen_iPadController;
@synthesize loadingLabel,loadingTitle,errorLabel;
@synthesize errorBtn,reloginBtn,backtoControllerBtn;
@synthesize isRestart;
@synthesize spinningWheel;
@synthesize Logout;
@synthesize g_ip_camera_list_Array;

int InstallerViewIndex=1,HomeownerViewIndex=1;
BOOL  isAddRoom = NO;
BOOL  isLOGOUT = NO;


#pragma mark -
#pragma mark Application lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) 
	{ 
		return YES; 
	} 
	return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	g_roomsArray = [[NSMutableArray alloc]init];
	g_selectedRoomsArray = [[NSMutableArray alloc]init];
	g_DevicesArray = [[NSMutableArray alloc]init];
	g_getThermostatsArray = [[NSMutableArray alloc]init];
	g_getTriggerDeviceListArray = [[NSMutableArray alloc]init];
	g_ScenesArray = [[NSMutableArray alloc]init];
	g_getTimersArray = [[NSMutableArray alloc]init];
	g_SessionArray = [[NSMutableArray alloc]init];
	g_ScenesInfoArray = [[NSMutableArray alloc]init];
	g_getTimersInfoArray = [[NSMutableArray alloc]init];
	g_getEventsArray = [[NSMutableArray alloc]init];
	g_getEventsInfoArray = [[NSMutableArray alloc]init];
	g_formatScheduleList = [[NSMutableArray alloc]init];
	g_getTriggerReasonListByDeviceIDArray = [[NSMutableArray alloc]init];
	g_homeOccupancyArray = [[NSMutableArray alloc]init];
	g_ip_camera_list_Array = [[NSMutableArray alloc]init];
	
	
	[self SetHomeownerViewIndex:1];
	[self SetInstallerViewIndex:1];
    
 
    [self.window addSubview:loginScreen_iPadController.view];
    [self.window makeKeyAndVisible];
    isLOGOUT = NO;
    
    
    //Settings for server url
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
		
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
		
		NSString *serverURL=@"";
        BOOL   isDefaultON;
		NSDictionary *prefItem;
		
        for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:@"ServerURL"])
			{
				serverURL = defaultValue;
			}
            else if([keyValueStr isEqualToString:@"isDefaultServer"])
            {
                isDefaultON = (BOOL)defaultValue;
            }
		}
		
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:serverURL,@"ServerURL",nil];
        [[NSUserDefaults standardUserDefaults] setBool:isDefaultON forKey:@"isDefaultServer"];
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    
	//NSLog(@"server URL = %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"]);
    //BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"isDefaultServer"];	

	//islocal=1// http://office.slamm.com:8080/support/xmltest.php
	//islocal=0 https://connect.somfytahoma.com/support/xml.php
	
    return YES;
}

+ (AppDelegate_iPad *)sharedAppDelegate
{
    return (AppDelegate_iPad *)[UIApplication sharedApplication].delegate;
}

-(void)SetInstallerViewIndex:(int)idx
{
	InstallerViewIndex = idx;
}
-(int)GetInstallerViewIndex
{
	return InstallerViewIndex;
}
-(void)SetHomeownerViewIndex:(int)idx
{
	HomeownerViewIndex = idx;
}
-(int)GetHomeownerViewIndex
{
	return HomeownerViewIndex;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark LOADING VIEW

- (void)showLoadingView:(NSString*)strControllerType
{
    if (loadingView == nil)
    { 
		loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,1024,768)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 1.0;
		
		//ActivityIndicator shows in the middle of loadingView
		loadingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 1024, 100)];
		loadingTitle.text = @"";
		loadingTitle.textAlignment=UITextAlignmentCenter;
		loadingTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
		loadingTitle.textColor = [UIColor lightGrayColor];
        loadingTitle.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingTitle];
		
		loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 1024, 100)];
        loadingLabel.text = @"";
		loadingLabel.textAlignment=UITextAlignmentCenter;
		loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
		loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingLabel];
		
		spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(494, 402, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
		
		errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 1024, 100)];
        errorLabel.text = @"Error Retrieving Home Data";
		errorLabel.hidden = YES;
		errorLabel.textAlignment=UITextAlignmentCenter;
		errorLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
		errorLabel.textColor = [UIColor redColor];
        errorLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:errorLabel];
		
		backtoControllerBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backtoControllerBtn.frame = CGRectMake(239, 400, 155, 45);
		backtoControllerBtn.hidden = YES;
		[backtoControllerBtn setBackgroundColor:[UIColor clearColor]];
		[backtoControllerBtn setBackgroundImage:[UIImage imageNamed:@"Controller_Btn.png"] forState:UIControlStateNormal];
		[backtoControllerBtn addTarget:self action:@selector(BackToBoxSelection) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:backtoControllerBtn];
		
		errorBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		errorBtn.frame = CGRectMake(424, 400, 155, 45);
		errorBtn.hidden = YES;
		[errorBtn setBackgroundColor:[UIColor clearColor]];
		[errorBtn setBackgroundImage:[UIImage imageNamed:@"Retry_Btn.png"] forState:UIControlStateNormal];
		[errorBtn addTarget:self action:@selector(errorHandle) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:errorBtn];
		
		reloginBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		reloginBtn.frame = CGRectMake(609, 400, 155, 45);
		reloginBtn.hidden = YES;
		[reloginBtn setBackgroundColor:[UIColor clearColor]];
		[reloginBtn setBackgroundImage:[UIImage imageNamed:@"Relogin_Btn.png"] forState:UIControlStateNormal];
		[reloginBtn addTarget:self action:@selector(ReLogin) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:reloginBtn];
    }
	
    if([strControllerType isEqualToString:@"LoginPage"])
		[loginScreen_iPadController.view addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
	//[loadingLabel release];
}

-(void)errorHandle
{
	isRestart = @"1";
}

-(void)BackToBoxSelection
{
	isRestart = @"2";
}

-(void)ReLogin
{
	isRestart = @"3";
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
	[g_ip_camera_list_Array release];
    [Logout release];
    [MJPEGViewer_iPadController release];
	[reloginBtn,backtoControllerBtn release];
    [window release];
	[spinningWheel release];
	[g_getTriggerReasonListByDeviceIDArray release];
	[g_getTimersInfoArray,g_getEventsArray,g_getEventsInfoArray,g_formatScheduleList release];
	[g_getTriggerDeviceListArray,g_ScenesArray,g_getTimersArray release];
	[g_roomsArray,g_selectedRoomsArray,g_DevicesArray,g_getThermostatsArray,g_SessionArray,g_ScenesInfoArray release];
	[g_homeOccupancyArray release];
	[DashboardviewController,ScheduleConfigHomeviewController,SceneConfigHomeviewController release];
	[DeviceConfigviewController,SceneConfigviewController,EventConfigviewController,ScheduleConfigviewController release];
	[viewController release];
	[tabBarController2 release];
	[tabBarController release];
	[loginScreen_iPadController release];
	[loadingLabel,loadingTitle,errorLabel release];
	[errorBtn release];
	[isRestart release];
    [super dealloc];
}


@end
