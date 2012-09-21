//
//  AppDelegate_iPhone.m
//  Somfy
//
//  Created by Sempercon on 4/22/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "UserService.h"
#import "RoomService.h"
#import "DashboardService.h"
#import "DeviceService.h"
#import "TimerService.h"
#import "ThermostatService.h"
#import "EventsService.h"
#import "AppDelegate_iPhone.h"
#import "SceneConfiguratorHomeownerService.h"
#import "DBAccess.h"
#import "ControllerCustomCell.h"

@interface AppDelegate_iPhone (Private)
-(void)doAuthentication;
-(void)loadGobalValues;
-(void)loadGobalValuesTask;
-(void)postTimerCall;
@end

@implementation AppDelegate_iPhone

@synthesize txtUsername,txtPassword;
@synthesize authenticationProcessing;
@synthesize btnLogin,errorBtn,reloginBtn,backtoControllerBtn;
@synthesize window;
@synthesize spinningWheel;
@synthesize rememberMeBtn;
@synthesize tabBarController;
@synthesize loadingLabel,loadingTitle,errorLabel;
@synthesize g_roomsArray,g_selectedRoomsArray,g_DevicesArray,g_getThermostatsArray,g_lastCommandArray;
@synthesize g_getTriggerDeviceListArray,g_ScenesArray,g_getTimersArray,g_SessionArray,g_ScenesInfoArray;
@synthesize g_getTimersInfoArray,g_getEventsArray,g_getEventsInfoArray,g_formatScheduleList;

@synthesize tahomaControllerView;
@synthesize tahomaControllerTable;
@synthesize scrollView;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
BOOL  _isLOGOUT = NO;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    authenticationProcessing.hidden = YES;
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
	g_lastCommandArray = [[NSMutableArray alloc]init];
	
	//self.tabBarController.selectedIndex = 1;
	//[self.window addSubview:tabBarController.view];
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	txtUsername.leftView = paddingView;
	txtUsername.leftViewMode = UITextFieldViewModeAlways;
	txtUsername.placeholder=@"Username";
	[paddingView release];
	
	UIView *paddingViewRight = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 10, 20)];
	txtUsername.rightView = paddingViewRight;
	txtUsername.rightViewMode = UITextFieldViewModeAlways;
	[paddingViewRight release];
	
	
	UIView *paddingViewPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	txtPassword.leftView = paddingViewPass;
	txtPassword.leftViewMode = UITextFieldViewModeAlways;
	txtPassword.placeholder=@"Password";
	[paddingViewPass release];
	
	UIView *paddingViewPassRight = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 10, 20)];
	txtPassword.rightView = paddingViewPassRight;
	txtPassword.rightViewMode = UITextFieldViewModeAlways;
	[paddingViewPassRight release];

	[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeUnChecked.png"] forState:UIControlStateNormal];

	isremember = NO;
	_isLOGOUT = NO;
	
	[self WindowShuoldAppear];
		
	[self.window makeKeyAndVisible];
    
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
	//NSLog(@"server URL = %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"]);
    
    return YES;
}

+ (AppDelegate_iPhone *)sharedAppDelegate
{
    return (AppDelegate_iPhone *)[UIApplication sharedApplication].delegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)viewWillAppear:(BOOL)animated
{
}

-(void)WindowShuoldAppear
{
	if(_isLOGOUT)
	{
		NSString *query;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[dbobj release];
		[Arr release];
		if([loginArray count]>0)
		{
			txtUsername.text = [[loginArray objectAtIndex:0]objectForKey:@"username"];
			txtPassword.text = [[loginArray objectAtIndex:0]objectForKey:@"password"];
			isremember = YES;
			[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeChecked.png"] forState:UIControlStateNormal];
		}
		else
		{
			txtUsername.text = @"";
			txtPassword.text = @"";
			isremember = NO;
			[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeUnChecked.png"] forState:UIControlStateNormal];
		}
	}
	else if(isremember)
	{
		NSString *query;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[dbobj release];
		[Arr release];
		
		if([loginArray count]>0)
		{
			initEnum = RELOGIN;
			[[AppDelegate_iPhone sharedAppDelegate] showLoadingView];
			[loadGobalValueTimer invalidate];
			loadGobalValueTimer = nil;
			loadGobalValueTimer = [NSTimer scheduledTimerWithTimeInterval:0 
																   target:self 
																 selector:@selector(loadGobalValuesTask) 
																 userInfo:nil 
																  repeats:YES];
		}
		else
		{
			txtUsername.text = @"";
			txtPassword.text = @"";
			[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeUnChecked.png"] forState:UIControlStateNormal];
		}
	}
	else if( !_isLOGOUT && !isremember)
	{
		NSString *query;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[dbobj release];
		[Arr release];
		
		if([loginArray count]>0)
		{
			initEnum = RELOGIN;
			[[AppDelegate_iPhone sharedAppDelegate] showLoadingView];
			[loadGobalValueTimer invalidate];
			loadGobalValueTimer = nil;
			loadGobalValueTimer = [NSTimer scheduledTimerWithTimeInterval:0 
																   target:self 
																 selector:@selector(loadGobalValuesTask) 
																 userInfo:nil 
																  repeats:YES];
		}
		else
		{
			txtUsername.text = @"";
			txtPassword.text = @"";
			[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeUnChecked.png"] forState:UIControlStateNormal];
		}
	}
}

-(IBAction)rememberMeBtnClicked:(id)sender
{
	if(isremember)
	{
		isremember = NO;
		[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeUnChecked.png"] forState:UIControlStateNormal];
	}
	else
	{
		isremember = YES;
		[rememberMeBtn setImage:[UIImage imageNamed:@"iP_remeberMeChecked.png"] forState:UIControlStateNormal];
	}
}


#pragma mark -
#pragma mark LOADING VIEW

- (void)showLoadingView
{
    if (loadingView == nil)
    { 
		loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,320,480)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 1.0;
		//ActivityIndicator shows in the middle of loadingView
		loadingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, 320, 100)];
		loadingTitle.text = @"";
		loadingTitle.textAlignment=UITextAlignmentCenter;
		loadingTitle.font = [UIFont fontWithName:@"Arial Bold" size:30];
		loadingTitle.textColor = [UIColor lightGrayColor];
        loadingTitle.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingTitle];
		
		loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
        loadingLabel.text = @"";
		loadingLabel.textAlignment=UITextAlignmentCenter;
		loadingLabel.font = [UIFont fontWithName:@"Arial Bold" size:20];
		loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingLabel];
		
		spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 280, 20.0, 20.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [loadingView addSubview:spinningWheel];
		
		errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
        errorLabel.text = @"Error Retrieving Home Data";
		errorLabel.hidden = YES;
		errorLabel.textAlignment=UITextAlignmentCenter;
		errorLabel.font = [UIFont fontWithName:@"Arial Bold" size:20];
		errorLabel.textColor = [UIColor redColor];
        errorLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:errorLabel];
		
		errorBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		errorBtn.frame = CGRectMake(20, 278, 278, 46);
		errorBtn.hidden = YES;
		[errorBtn setBackgroundColor:[UIColor clearColor]];
		[errorBtn setBackgroundImage:[UIImage imageNamed:@"Retry_iph.png"] forState:UIControlStateNormal];
		[errorBtn addTarget:self action:@selector(errorHandle) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:errorBtn];
		
		reloginBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		reloginBtn.frame = CGRectMake(20, 348, 278, 46);
		reloginBtn.hidden = YES;
		[reloginBtn setBackgroundColor:[UIColor clearColor]];
		[reloginBtn setBackgroundImage:[UIImage imageNamed:@"Relogin_iph.png"] forState:UIControlStateNormal];
		[reloginBtn addTarget:self action:@selector(ReLogin) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:reloginBtn];
		
		backtoControllerBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backtoControllerBtn.frame = CGRectMake(20, 414, 278, 46);
		backtoControllerBtn.hidden = YES;
		[backtoControllerBtn setBackgroundColor:[UIColor clearColor]];
		[backtoControllerBtn setBackgroundImage:[UIImage imageNamed:@"Controllers_iph.png"] forState:UIControlStateNormal];
		[backtoControllerBtn addTarget:self action:@selector(BackToBoxSelection) forControlEvents:UIControlEventTouchUpInside];
		[loadingView addSubview:backtoControllerBtn];
		
    }
	[self.window addSubview:loadingView];
}

-(void)errorHandle
{
	isRestart = 1;
}

-(void)BackToBoxSelection
{
	isRestart = 2;
}

-(void)ReLogin
{
	isRestart = 3;
}

- (void)showCustomLoadingView
{
	if (newLoadingView == nil)
    { 
		newLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,320,480)];
        newLoadingView.opaque = NO;
        newLoadingView.backgroundColor = [UIColor darkGrayColor];
        newLoadingView.alpha = 0.6;
		
		//ActivityIndicator shows in the middle of loadingView
		UILabel *loadingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
        loadingLabel1.text = @"";
		loadingLabel1.textAlignment=UITextAlignmentCenter;
		loadingLabel1.font = [UIFont fontWithName:@"Arial Bold" size:20];
		loadingLabel1.textColor = [UIColor whiteColor];
        loadingLabel1.backgroundColor = [UIColor clearColor];
        [newLoadingView addSubview:loadingLabel1];
		[loadingLabel1 release];
		
		UIActivityIndicatorView *spinningWheel1 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 280, 20.0, 20.0)];
        [spinningWheel1 startAnimating];
        spinningWheel1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [newLoadingView addSubview:spinningWheel1];
        [spinningWheel1 release];
    }
	[self.tabBarController.view addSubview:newLoadingView];
}

- (void)showtahomaControllerLoadingView
{
	if (tahomaControllerLoadingView == nil)
    { 
		tahomaControllerLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,320,480)];
        tahomaControllerLoadingView.opaque = NO;
        tahomaControllerLoadingView.backgroundColor = [UIColor darkGrayColor];
        tahomaControllerLoadingView.alpha = 0.6;
		
		//ActivityIndicator shows in the middle of loadingView
		UILabel *loadingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
        loadingLabel1.text = @"";
		loadingLabel1.textAlignment=UITextAlignmentCenter;
		loadingLabel1.font = [UIFont fontWithName:@"Arial Bold" size:20];
		loadingLabel1.textColor = [UIColor whiteColor];
        loadingLabel1.backgroundColor = [UIColor clearColor];
        [tahomaControllerLoadingView addSubview:loadingLabel1];
		[loadingLabel1 release];
		
		UIActivityIndicatorView *spinningWheel1 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 280, 20.0, 20.0)];
        [spinningWheel1 startAnimating];
        spinningWheel1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [tahomaControllerLoadingView addSubview:spinningWheel1];
        [spinningWheel1 release];
    }
	[self.window addSubview:tahomaControllerLoadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
	[newLoadingView removeFromSuperview];
	[newLoadingView release];
	newLoadingView=nil;
	[tahomaControllerLoadingView removeFromSuperview];
	[tahomaControllerLoadingView release];
	tahomaControllerLoadingView = nil;
	//[loadingLabel release];
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)btnLoginClicked:(id)sender
{
	authenticationProcessing.hidden = NO;
	[authenticationProcessing startAnimating];
	btnLogin.enabled = NO;
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
	[self doAuthentication];
	
	NSArray *array = tabBarController.viewControllers;
	for (int i=0; i<[array count]; i++) 
	{
		[[array objectAtIndex:i] popToRootViewControllerAnimated:NO];
		NSArray *arr1 = [[array objectAtIndex:i] viewControllers];
		for (int j=0; j<[arr1 count]; j++) 
			[[arr1 objectAtIndex:j] viewDidUnload];
	}

}

#pragma mark -
#pragma mark TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   	return [[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray count]-1;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ControllerCustomCell";
    
	ControllerCustomCell *cell = (ControllerCustomCell *)[tahomaControllerTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 302, 45);
        cell = [[[ControllerCustomCell alloc] initWithFrame:rect reuseIdentifier:CellIdentifier] retain];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
	
	if(indexPath.row == 0)
		cell.imgBg.image = [UIImage imageNamed:@"topControllerBg.png"];
	else if(indexPath.row == [[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray count]-2)
	{
		if(indexPath.row % 2 != 0)
			cell.imgBg.image = [UIImage imageNamed:@"BottomControllerBgGray.png"];
		else
			cell.imgBg.image = [UIImage imageNamed:@"BottomControllerBg.png"];
	}
	else 
	{
		if(indexPath.row % 2 != 0)
			cell.imgBg.image = [UIImage imageNamed:@"middleControllerBgGray.png"];
		else
			cell.imgBg.image = [UIImage imageNamed:@"middleControllerBg.png"];
	}
	
    // Configure the cell...
	cell.lblControllerName.text = [[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray objectAtIndex:indexPath.row+1] objectForKey:@"name"];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//SELECT_CONTROLLER command
	[self showtahomaControllerLoadingView];
	NSString *index = [[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray objectAtIndex:indexPath.row+1] objectForKey:@"idx"];
	[[UserService getSharedInstance]selectTahomaController:index :self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	CGRect viewFrame = self.window.frame;
	viewFrame.origin.y -= 50;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.window setFrame:viewFrame];
	[UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	CGRect viewFrame = self.window.frame;
	viewFrame.origin.y += 50;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.window setFrame:viewFrame];
	[UIView commitAnimations];
	
}

-(void)FormatSchedulesListArray
{
	NSMutableArray *eventArray;
	int condTypeInt,trigReasonIDInt;
	
	
	if([[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList count]>0)
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray objectAtIndex:i];
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList addObject:dict];
	}
	for(int i=0;i<[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray objectAtIndex:i];
		
		eventArray = [[AppDelegate_iPhone sharedAppDelegate].g_getEventsInfoArray objectAtIndex:i];
		
		if([eventArray count]>[eventArray count]-2)
		{
			condTypeInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"condType"] intValue];
			if ( condTypeInt == DEVICE )
			{
				trigReasonIDInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"trigReasonID"] intValue];
				if ( trigReasonIDInt == SUNRISE || trigReasonIDInt == SUNSET )
				{
					[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList addObject:dict];
				}
			}
		}
	}
	//Sorting Schedule Event array
	NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
	[lastNameSorter1 release];
}


#pragma mark -
#pragma mark GET SCHEDULE TIMER INFO 

-(void)getScheduleTimerInfo
{
	scheduleTimerInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
															  target:self 
															selector:@selector(scheduleTimerInfoTask) 
															userInfo:nil 
															 repeats:YES];
	scheduleTimerInfoEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)scheduleTimerInfoTask
{
	switch(scheduleTimerInfoEnum)
	{
		case NONE:
		{
			[g_getTimersInfoArray removeAllObjects];
			scheduleTimerInfoEnum = TIMER_GET_INFO;
			break;
		}
		case TIMER_GET_INFO:
		{
			if([[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count] > g_objectIndex)
			{
				[[TimerService getSharedInstance]timerGetInfo:[[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				scheduleTimerInfoEnum = PROCESSING;
			}
			else 
			{
				scheduleTimerInfoEnum = DONE;
			}
			
			break;
		}
		case TIMER_GET_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count]-1)
			{
				g_objectIndex++;
				scheduleTimerInfoEnum = TIMER_GET_INFO;
			}
			else
				scheduleTimerInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[scheduleTimerInfoTimer invalidate];
			scheduleTimerInfoTimer=nil;
			initEnum = TIMER_GET_INFO_DONE;
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark GET SCHEDULE EVENT INFO 

-(void)getScheduleEventInfo
{
	scheduleEventInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
															  target:self 
															selector:@selector(scheduleEventInfoTask) 
															userInfo:nil 
															 repeats:YES];
	scheduleEventInfoEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)scheduleEventInfoTask
{
	switch(scheduleEventInfoEnum)
	{
		case NONE:
		{
			[g_getEventsInfoArray removeAllObjects];
			scheduleEventInfoEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				scheduleEventInfoEnum = PROCESSING;
			}
			else 
			{
				scheduleEventInfoEnum = DONE;
			}
			
			break;
		}
		case EVENT_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count]-1)
			{
				g_objectIndex++;
				scheduleEventInfoEnum = EVENT_INFO;
			}
			else
				scheduleEventInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[scheduleEventInfoTimer invalidate];
			scheduleEventInfoTimer=nil;
			initEnum = EVENT_INFO_DONE;
			break;
		}
		default:
			break;
	}
}




#pragma mark -
#pragma mark GET SCENE INFO 

-(void)getSceneInfo
{
	sceneInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
													  target:self 
													selector:@selector(sceneInfoTask) 
													userInfo:nil 
													 repeats:YES];
	sceneInfoEnum = NONE;
	sceneInfoCount = 0;
	
	
}

-(void)sceneInfoTask
{
	switch(sceneInfoEnum)
	{
		case NONE:
		{
			[[AppDelegate_iPhone sharedAppDelegate].g_ScenesInfoArray removeAllObjects];
			sceneInfoEnum = GETSCENE_INFO;
			break;
		}
		case GETSCENE_INFO:
		{
			if([[AppDelegate_iPhone sharedAppDelegate].g_ScenesArray count] > sceneInfoCount)
			{
				[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[[[AppDelegate_iPhone sharedAppDelegate].g_ScenesArray objectAtIndex:sceneInfoCount]objectForKey:@"id"] :self];
				sceneInfoEnum = PROCESSING;
			}
			else 
			{
				sceneInfoEnum = DONE;
			}
			
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			if(sceneInfoCount<[[AppDelegate_iPhone sharedAppDelegate].g_ScenesArray count]-1)
			{
				sceneInfoCount++;
				sceneInfoEnum = GETSCENE_INFO;
			}
			else
				sceneInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[sceneInfoTimer invalidate];
			sceneInfoTimer=nil;
			break;
		}
		default:
			break;
	}
}




#pragma mark -
#pragma mark AUTHENTICATION PROCESS

-(void)doAuthentication
{
	authenticateEnum = NONE;
	[authenticateTimer invalidate];
	authenticateTimer = nil;
	authenticateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
														 target:self 
													   selector:@selector(authenticateTask) 
													   userInfo:nil 
														repeats:YES];
}

-(void)authenticateTask
{
	switch(authenticateEnum)
	{
		case NONE:
		{
			authenticateEnum = ENUM_AUTHENTICATE_USER;
			break;
		}
		case ENUM_AUTHENTICATE_USER:
		{
			//TODO Command receives BAD Command error skipped for now
			authenticateEnum = PROCESSING;
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:txtUsername.text forKey:@"username"];
			[commandDictionary setObject:txtPassword.text forKey:@"password"];
			[[UserService getSharedInstance]authenticate:commandDictionary:self];
			[commandDictionary release];
			//authenticateEnum = DONE;
			break;
			
		}
		case DONE:
		{
			[authenticateTimer invalidate];
			authenticateTimer = nil;
			
			/*NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:@"167" forKey:@"id"];	
			[commandDictionary setObject:@"false" forKey:@"getList"];
			[[EventsService getSharedInstance]eventRemove:commandDictionary :self];
			[commandDictionary release];*/
            
            //Update settings url to db.
            NSString *query;
            BOOL result;
            DBAccess *newObj = [[DBAccess alloc]init];
            query =@"UPDATE ServerPath SET RequestUrl=?";
            NSArray *array=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"],nil];
            result = [newObj UpdateValueToDatabase:query :array];
            [array release];
            [newObj release];
			
			if(isremember)
			{
				NSString *userRole = @"";
				
				NSString *query;
				DBAccess *dbobj = [[DBAccess alloc]init];
				NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
				query=@"SELECT * FROM Somfy";
				loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
				[dbobj release];
				[Arr release];
				
				if([g_SessionArray count]>0)
					userRole = [[g_SessionArray objectAtIndex:0] objectForKey:@"userRole"];
				
				if(userRole==nil)
					userRole = @"";
				
				if([loginArray count]==0)
				{
					NSString *query;BOOL result;
					DBAccess *dbobj = [[DBAccess alloc]init];
					//Insert into Somfy table
					query = @"INSERT INTO Somfy(username,password,userrole)VALUES(?,?,?)";
					NSArray *arr=[[NSArray alloc]initWithObjects:txtUsername.text,txtPassword.text,userRole,nil];
					result = [dbobj InsertIntoDB:query :arr];
					[arr release];
					[dbobj release];			
				}
				else
				{
					NSString *query;BOOL result;
					DBAccess *dbobj = [[DBAccess alloc]init];
					//Update into Somfy table
					query =@"UPDATE Somfy SET username=?,password=?,userrole=?";
					NSArray *arr=[[NSArray alloc]initWithObjects:txtUsername.text,txtPassword.text,userRole,nil];
					result = [dbobj UpdateValueToDatabase:query :arr];
					[arr release];
					[dbobj release];
				}
				
			}
			else
			{
				NSString *query;
				BOOL success;
				DBAccess *dbobj = [[DBAccess alloc]init];
				NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
				query=@"SELECT * FROM Somfy";
				loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
				[Arr release];
				if([loginArray count]>0)
				{
					query=@"DELETE FROM Somfy";
					success = [dbobj DeleteFromDB:query];
				}
				[dbobj release];
			}
			
			if([[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray count]>2)
			{
				[self.window addSubview:tahomaControllerView];
				int height = ([[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray count]-1) * 45;
				[tahomaControllerTable setFrame:CGRectMake(9, 119, 303, height)];
				[scrollView setContentSize:CGSizeMake(320, height+119)];
				[self.tahomaControllerTable reloadData];
			}
			else
				[self loadGobalValues];
			
			break;
		}
		case ERROR:
		{
			[authenticateTimer invalidate];
			authenticateTimer = nil;
			break;
		}
		default:
			break;	
	}
}

-(void)loadGobalValues
{
	initEnum = NONE;
	[[AppDelegate_iPhone sharedAppDelegate] showLoadingView];
	[loadGobalValueTimer invalidate];
	loadGobalValueTimer = nil;
	loadGobalValueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
														   target:self 
														 selector:@selector(loadGobalValuesTask) 
														 userInfo:nil 
														  repeats:YES];
}

-(void)loadGobalValuesTask
{
	loadingTitle.text = @"LOADING HOME AUTOMATION DATA";
	
	if(isLoadingError)
	{
		isLoadingError = NO;
		initEnum = ERROR;
	}
	
	switch(initEnum)
	{
		case RELOGIN:
		{
			NSString *query;
			DBAccess *dbobj = [[DBAccess alloc]init];
			NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
			query=@"SELECT * FROM Somfy";
			loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
			[dbobj release];
			[Arr release];
			
			if([loginArray count]>0)
			{
				initEnum = PROCESSING;
				spinningWheel.hidden = NO;
				
				loadingLabel.text = @"Retrieving Session";
				errorLabel.hidden = YES;
				errorBtn.hidden = YES;
				backtoControllerBtn.hidden = YES;
				reloginBtn.hidden = YES;
				spinningWheel.hidden = NO;
				
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
				[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
				[[UserService getSharedInstance]authenticate:commandDictionary:self];
				[commandDictionary release];
				
			}
			else
			{
				//initEnum = NONE;
				[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];

			}
			
			break;
		}
		case NONE:
		{
			spinningWheel.hidden = NO;
            initEnum = GETROOMS;
			loadingLabel.text = @"Retrieving Rooms";
			errorLabel.hidden = YES;
			errorBtn.hidden = YES;
			backtoControllerBtn.hidden = YES;
			reloginBtn.hidden = YES;
			break;
		}
		case GETROOMS:
		{
			[[RoomService getSharedInstance] getRooms:self];
			initEnum = PROCESSING;
			break;
		}
		case GETROOMS_DONE:
		{
			initEnum = GETSELECTEDROOMS;
			loadingLabel.text = @"Retrieving Selected Rooms List";
			break;
		}
		case GETSELECTEDROOMS:
		{
			[[RoomService getSharedInstance] GetSelectedRoom:self];
			initEnum = PROCESSING;
			break;
		}
		case GETSELECTEDROOMS_DONE:
		{
			initEnum = GETDEVICES;
			loadingLabel.text = @"Retrieving Devices";
			break;
		}
		case GETDEVICES:
		{
			[[DeviceService getSharedInstance] getAll:self];
			initEnum = PROCESSING;
			break;
		}
		case GETDEVICES_DONE:
		{
			//initEnum = DONE;
			initEnum = GET_THERMO_STATS;
			loadingLabel.text = @"Retrieving Thermostats";
			break;
		}
		case GET_THERMO_STATS:
		{
			[[ThermostatService getSharedInstance]getThermostats:self];
			initEnum = PROCESSING;
			break;
		}
		case GET_THERMO_STATS_DONE:
		{
			initEnum = GET_TRIGGER_DEVICE_LIST;
			loadingLabel.text = @"Retrieving Thermostats";
			break;
		}
		case GET_TRIGGER_DEVICE_LIST:
		{
			//initEnum = DONE;
			//break;
			[[EventsService getSharedInstance]getTriggerDevicesList:self];
			initEnum = PROCESSING;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST_DONE:
		{
			initEnum = GETSCENES;
			loadingLabel.text = @"Retrieving Scenes";
			break;
		}
		case GETSCENES:
		{
			[[DashboardService getSharedInstance]getScenes:self];
			initEnum = PROCESSING;
			break;
		}
		case GETSCENES_DONE:
		{
			initEnum = GETSCENE_INFO;
			[AppDelegate_iPhone  sharedAppDelegate].loadingLabel.text = @"Retrieving Scenes info";
			break;
		}
		case GETSCENE_INFO:
		{
			initEnum = PROCESSING;
			[self getSceneInfo];
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			initEnum = GET_TIMER;
			[AppDelegate_iPhone  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules";
			break;
		}
			
		case GET_TIMER:
		{
			[[TimerService getSharedInstance]getTimers:self];
			initEnum = PROCESSING;
			break;
		}
		case GET_TIMER_DONE:
		{
			//Sorting Schedule Event array
			NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
			[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			initEnum = TIMER_GET_INFO;
			[AppDelegate_iPhone  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Timer info";
			break;
		}
		case TIMER_GET_INFO:
		{
			initEnum = PROCESSING;
			[self getScheduleTimerInfo];
			break;
		}
		case TIMER_GET_INFO_DONE:
		{
			initEnum = GET_EVENT;
			[AppDelegate_iPhone  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Event";
			break;
		}
		case GET_EVENT:
		{
			[[EventsService getSharedInstance]getEvents:self];
			initEnum = PROCESSING;
			break;
		}
		case GET_EVENT_DONE:
		{
			//Sorting Schedule Event array
			NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
			[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			
			initEnum = EVENT_INFO;
			[AppDelegate_iPhone  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Event info";
			break;
		}
		case EVENT_INFO:
		{
			initEnum = PROCESSING;
			[self getScheduleEventInfo];
			break;
		}
		case EVENT_INFO_DONE:
		{
			[self FormatSchedulesListArray];
			initEnum = DONE;
			break;
		}
		case DONE:
		{
			[loadGobalValueTimer invalidate];
			loadGobalValueTimer=nil;
			[self postTimerCall];
			break;
		}
		case ERROR:
		{
			if(isRestart==1)
			{
				isRestart =0;
				loadingLabel.hidden = NO;
				if([g_SessionArray count]>0)
					initEnum = NONE;
				else
					initEnum = RELOGIN;
			}
			else if(isRestart==2)
			{
				isRestart =0;
				loadingLabel.hidden = NO;
				
				[self hideLoadingView];
				[self.window addSubview:tahomaControllerView];
				int height = ([[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray count]-1) * 45;
				[tahomaControllerTable setFrame:CGRectMake(9, 119, 303, height)];
				[scrollView setContentSize:CGSizeMake(320, height+119)];
				[self.tahomaControllerTable reloadData];
			}
			else if(isRestart==3)
			{
				isRestart =0;
				loadingLabel.hidden = NO;
				
				[self hideLoadingView];
				
				NSString *query;
				BOOL success;
				DBAccess *dbobj = [[DBAccess alloc]init];
				NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
				query=@"SELECT * FROM Somfy";
				loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
				[Arr release];
				if([loginArray count]>0)
				{
					query=@"DELETE FROM Somfy";
					success = [dbobj DeleteFromDB:query];
				}
				[dbobj release];
				[loadGobalValueTimer invalidate];
				loadGobalValueTimer=nil;
				[self WindowShuoldAppear];
			}
			break;
		}

		default:
			break;
	}
}

-(void)postTimerCall
{
	[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
	[authenticationProcessing stopAnimating];
	authenticationProcessing.hidden = YES;
	btnLogin.enabled = YES;
	
	//txtUsername.text = @"";
	txtPassword.text = @"";
	self.tabBarController.selectedIndex = 0;
	[self.window addSubview:tabBarController.view];
	[self.window makeKeyAndVisible];	
}


#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	isLoadingError = NO;
	if(strCommand == AUTHENTICATE_USER)
	{
		
		g_SessionArray = [resultArray mutableCopy];
		/*if ([[[g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4)
		{
			//authenticateEnum = DONE;
			//initEnum = NONE;
			
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			
			[authenticationProcessing stopAnimating];
			authenticationProcessing.hidden = YES;
			errorLabel.text = @"Not an authorized user.";
			errorLabel.hidden = NO;
			errorBtn.hidden = NO;
			reloginBtn.hidden = NO;
			if([g_SessionArray count]>2)
			{
				backtoControllerBtn.hidden = NO;
			}
			else
				backtoControllerBtn.hidden = YES;
			loadingLabel.hidden = YES;
			btnLogin.enabled = YES;
			authenticateEnum = ERROR;
			initEnum = ERROR;
			
		}
		else 
		{*/
			if(authenticateEnum == PROCESSING)
				authenticateEnum = DONE;
			else
				initEnum = NONE;
		//}
	}
	else if(strCommand == SELECT_CONTROLLER)
	{
		[self hideLoadingView];
		[tahomaControllerView removeFromSuperview];
		[self loadGobalValues];
	}
	else if(strCommand==GET_ROOMS_COMMAND)
	{
		initEnum = GETROOMS_DONE;
		//Copy the getrooms result 
		g_roomsArray = [resultArray mutableCopy];
	}
	else if(strCommand==SELECTED_ROOM_COMMAND)
	{
		initEnum = GETSELECTEDROOMS_DONE;
		[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray removeAllObjects];
		BOOL isExist;		
		NSArray * array =[[[resultArray objectAtIndex:0]objectForKey:@"dataString"]componentsSeparatedByString:@"."];
		for(int i=0;i<[array count];i++)
		{
			if([array objectAtIndex:i]!=nil&&![[array objectAtIndex:i] isEqualToString:@""])
			{
				NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
				[dict setValue:[NSNumber numberWithInt:[[array objectAtIndex:i]intValue]] forKey:@"sortingKey"];
				[dict setObject:[array objectAtIndex:i] forKey:@"roomKey"];
				[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray addObject:dict];
				[dict release];
			}
		}
		
		NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"sortingKey" ascending:YES];
		[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
		[lastNameSorter1 release];
		
		//Check if all selectedroomlist id's in the getrorom list
		for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count];i++)
		{
			isExist = NO;
			for(int j=0;j<[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray count];j++)
			{
				if([[[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i]objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
				{
					isExist = YES;
					break;
				}
			}
			if(!isExist)
				[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:i];
		}
	}
	else if(strCommand==GET_ALL)
	{
		initEnum = GETDEVICES_DONE;
		//Copy the getdevices result
		//[g_DevicesArray removeAllObjects];
		g_DevicesArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_THERMOSTATS)
	{
		initEnum = GET_THERMO_STATS_DONE;
		//Copy the getdevices result
		//[g_getThermostatsArray removeAllObjects];
		g_getThermostatsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_TRIGGER_DEVICES_LIST)
	{
		initEnum = GET_TRIGGER_DEVICE_LIST_DONE;
		//Copy the getdevices result
		//[g_getTriggerDeviceListArray removeAllObjects];
		g_getTriggerDeviceListArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_SCENES)
	{
		initEnum = GETSCENES_DONE;
		//Copy the getscenes result
		//[g_ScenesArray removeAllObjects];
		g_ScenesArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_SCENE_INFO)
	{
		//Copy the getdevices result
		NSMutableArray *tempArr = [resultArray mutableCopy];
		[[AppDelegate_iPhone sharedAppDelegate].g_ScenesInfoArray addObject:tempArr];
		sceneInfoEnum = GETSCENE_INFO_DONE;
		if([[AppDelegate_iPhone sharedAppDelegate].g_ScenesInfoArray count]==[[AppDelegate_iPhone sharedAppDelegate].g_ScenesArray count])
		{
			initEnum = GETSCENE_INFO_DONE;
		}
	}
	else if(strCommand==GET_TIMERS)
	{
		initEnum = GET_TIMER_DONE;
		//Copy the g_scheduleList result
		//[g_getTimersArray removeAllObjects];
		g_getTimersArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_INFO)
	{
		scheduleTimerInfoEnum = TIMER_GET_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[g_getTimersInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand==GET_EVENTS)
	{
		initEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		//[g_getEventsArray removeAllObjects];
		g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		scheduleEventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		//[g_getEventsInfoArray removeAllObjects];
		[g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand == LOGOUT)
	{
		[self hideLoadingView];
		
		_isLOGOUT = YES;
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
    [self hideLoadingView];
	isLoadingError = YES;
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	spinningWheel.hidden = YES;
	[authenticationProcessing stopAnimating];
	authenticationProcessing.hidden = YES;
	errorLabel.text = @"Error Retrieving Home Data";	
	errorLabel.hidden = NO;
	
	errorBtn.hidden = NO;
	reloginBtn.hidden = NO;
	if([g_SessionArray count]>2)
	{
		backtoControllerBtn.hidden = NO;
	}
	else
		backtoControllerBtn.hidden = YES;
	
	loadingLabel.hidden = YES;
	btnLogin.enabled = YES;
	authenticateEnum = ERROR;
	initEnum = ERROR;
	
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
	[tahomaControllerView release];
	[tahomaControllerTable release];
    [window release];
	[spinningWheel release];
	[rememberMeBtn release];
	[errorBtn,btnLogin,reloginBtn,backtoControllerBtn release];
	[g_getEventsArray,g_getEventsInfoArray,g_formatScheduleList,g_lastCommandArray release];
	[g_getTriggerDeviceListArray,g_ScenesArray,g_getTimersArray,g_getTimersInfoArray release];
	[g_roomsArray,g_selectedRoomsArray,g_DevicesArray,g_getThermostatsArray,g_SessionArray,g_ScenesInfoArray release];
	[tabBarController release];
	[loadingLabel,loadingTitle,errorLabel release];
	[scrollView release];
    [super dealloc];
}


@end
