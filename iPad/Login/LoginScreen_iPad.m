    //
//  LoginScreen_iPad.m
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "RoomService.h"
#import "DashboardService.h"
#import "DeviceService.h"
#import "TimerService.h"
#import "ThermostatService.h"
#import "EventsService.h"
#import "AppDelegate_iPad.h"
#import "RoomSelector_ipad.h"
#import "DeviceConfigurator_iPad.h"
#import "EventConfigurator_iPad.h"
#import "SceneConfigurator_iPad.h"
#import "ScheduleConfigurator_iPad.h"
#import "Scheduleconfigurator_Homeowner.h"
#import "LiveviewDashboard.h"
#import "SceneConfiguratorHomeownerService.h"
#import "Constants.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"
#import	"ipCameraService.h"


@interface LoginScreen_iPad (Private)
-(void)doAuthentication;
-(void)showLoadingView;
-(void)loadGobalValues;
-(void)loadGobalValuesTask;
-(void)postTimerCall;
-(void)getSceneInfo;
@end

extern BOOL  isLOGOUT;


@implementation LoginScreen_iPad

@synthesize txtUsername,txtPassword;
@synthesize authenticationProcessing;
@synthesize btnLogin;
@synthesize rememberMeBtn;
@synthesize tahomaControllerView;
@synthesize tahomaControllerTable;
@synthesize btnRelogin,btnRetry,btnControllers;

#pragma mark -
#pragma mark VIEW CALLBACKS
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    if (isLocal == 1) 
	{
         self.btnRelogin.hidden = YES;
         //self.btnRetry.hidden = YES;
         self.btnControllers.hidden = YES;
        [AppDelegate_iPad  sharedAppDelegate].reloginBtn.hidden = YES;
        [self loadGobalValues];
    }
	
	[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeUnChecked.png"] forState:UIControlStateNormal];
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
	txtUsername.leftView = paddingView;
	txtUsername.leftViewMode = UITextFieldViewModeAlways;
	txtUsername.placeholder=@"Username";
	[paddingView release];
	
	UIView *paddingViewRight = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 10, 20)];
	txtUsername.rightView = paddingViewRight;
	txtUsername.rightViewMode = UITextFieldViewModeAlways;
	[paddingViewRight release];
	
	
	UIView *paddingViewPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
	txtPassword.leftView = paddingViewPass;
	txtPassword.leftViewMode = UITextFieldViewModeAlways;
	txtPassword.placeholder=@"Password";
	[paddingViewPass release];
	
	UIView *paddingViewPassRight = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 10, 20)];
	txtPassword.rightView = paddingViewPassRight;
	txtPassword.rightViewMode = UITextFieldViewModeAlways;
	[paddingViewPassRight release];
	
	isremember = NO;
	authenticationProcessing.hidden = YES;
	tahomaControllerTable.separatorColor = [UIColor lightGrayColor];
    

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    
	if(isLOGOUT)
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
			[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeChecked.png"] forState:UIControlStateNormal];
		}
		else
		{
			txtUsername.text = @"";
			txtPassword.text = @"";
			isremember = NO;
			[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeUnChecked.png"] forState:UIControlStateNormal];
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
			[[AppDelegate_iPad sharedAppDelegate] showLoadingView:@"LoginPage"];
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
		}
	}
	else if( !isLOGOUT && !isremember)
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
			[[AppDelegate_iPad sharedAppDelegate] showLoadingView:@"LoginPage"];
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
		}
	}
    
	//[self.view addSubview:tahomaControllerView];
}

#pragma mark -
#pragma mark TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   	return [[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]-1;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:indexPath.row+1] objectForKey:@"name"];
	cell.textLabel.font= [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
	cell.textLabel.textColor=[UIColor colorWithRed:(float)64/255 green:(float)64/255 blue:(float)64/255 alpha:1.0 ];
	cell.detailTextLabel.text = @"CONNECT";
	cell.detailTextLabel.font= [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
	cell.detailTextLabel.textColor=[UIColor colorWithRed:(float)87/255 green:(float)166/255 blue:(float)48/255 alpha:1.0 ];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//SELECT_CONTROLLER command
	[self showLoadingView];
	NSString *index = [[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:indexPath.row+1] objectForKey:@"idx"];
	[[UserService getSharedInstance]selectTahomaController:index :self];
}



-(IBAction)rememberMeBtnClicked:(id)sender
{
	if(isremember)
	{
		isremember = NO;
		[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeUnChecked.png"] forState:UIControlStateNormal];
	}
	else
	{
		isremember = YES;
		[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeChecked.png"] forState:UIControlStateNormal];
	}
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) 
	{ 
		return YES; 
	} 
	return NO;
}

-(void)FormatSchedulesListArray
{
	NSMutableArray *eventArray;
	int condTypeInt,trigReasonIDInt;
	if([[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList count]>0)
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPad sharedAppDelegate].g_getTimersArray objectAtIndex:i];
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList addObject:dict];
	}
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:i];
		
		eventArray = [[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:i];
		
		if([eventArray count]>[eventArray count]-2)
		{
			condTypeInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"condType"] intValue];
			if ( condTypeInt == DEVICE )
			{
				trigReasonIDInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"trigReasonID"] intValue];
				if ( trigReasonIDInt == SUNRISE || trigReasonIDInt == SUNSET )
				{
					[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList addObject:dict];
				}
			}
		}
	}
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getTimersInfoArray removeAllObjects];
			scheduleTimerInfoEnum = TIMER_GET_INFO;
			break;
		}
		case TIMER_GET_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count] > g_objectIndex)
			{
				[[TimerService getSharedInstance]timerGetInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
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
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count]-1)
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray removeAllObjects];
			scheduleEventInfoEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
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
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count]-1)
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
			[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray removeAllObjects];
			sceneInfoEnum = GETSCENE_INFO;
			break;
		}
		case GETSCENE_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count] > sceneInfoCount)
			{
				[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:sceneInfoCount]objectForKey:@"id"] :self];
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
			if(sceneInfoCount<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count]-1)
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
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)btnLoginClicked:(id)sender
{
	authenticationProcessing.hidden = NO;
	[authenticationProcessing startAnimating];
	btnLogin.enabled = NO;
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
	[self doAuthentication];
	
	// ReInitialize all VIEW CONTROLLERS IN IPAD
	[[[AppDelegate_iPad sharedAppDelegate] viewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] DeviceConfigviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] SceneConfigviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] EventConfigviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] ScheduleConfigviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] DashboardviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] ScheduleConfigHomeviewController] viewDidUnload];
	[[[AppDelegate_iPad sharedAppDelegate] SceneConfigHomeviewController] viewDidUnload];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
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
				
				if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
					userRole = [[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"];
				
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

			if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>2)
			{
				[self.view addSubview:tahomaControllerView];
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
	[[AppDelegate_iPad sharedAppDelegate] showLoadingView:@"LoginPage"];
	[loadGobalValueTimer invalidate];
	loadGobalValueTimer = nil;
	loadGobalValueTimer = [NSTimer scheduledTimerWithTimeInterval:0 
														 target:self 
													   selector:@selector(loadGobalValuesTask) 
													   userInfo:nil 
														repeats:YES];
}

-(void)loadGobalValuesTask
{
	[AppDelegate_iPad  sharedAppDelegate].loadingTitle.text = @"LOADING HOME AUTOMATION DATA";
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
				[AppDelegate_iPad  sharedAppDelegate].spinningWheel.hidden = NO;
				
				[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Session";
				[AppDelegate_iPad  sharedAppDelegate].errorLabel.hidden = YES;
				[AppDelegate_iPad  sharedAppDelegate].errorBtn.hidden = YES;
				[AppDelegate_iPad  sharedAppDelegate].reloginBtn.hidden = YES;
				[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.hidden = YES;
				
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
				[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
				[[UserService getSharedInstance]authenticate:commandDictionary:self];
				[commandDictionary release];
				
			}
			else
			{
				//initEnum = NONE;
				[[AppDelegate_iPad sharedAppDelegate] hideLoadingView];
			}
			
			break;
		}
		case NONE:
		{
			//initEnum = DONE;
			
			initEnum = HOME_OCCUPANCY;
			[AppDelegate_iPad  sharedAppDelegate].spinningWheel.hidden = NO;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Home Occupancy info";
			[AppDelegate_iPad  sharedAppDelegate].errorLabel.hidden = YES;
			[AppDelegate_iPad  sharedAppDelegate].errorBtn.hidden = YES;
			[AppDelegate_iPad  sharedAppDelegate].reloginBtn.hidden = YES;
			[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.hidden = YES;
			break;
		}
		case HOME_OCCUPANCY:
		{
			[[UserService getSharedInstance]HomeOccupationGetInfo:self];
			initEnum = PROCESSING;
			break;
		}
		case HOME_OCCUPANCY_DONE:
		{
			initEnum = GETROOMS;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Rooms";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Selected Rooms List";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Devices";
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
            initEnum = GETIP_CAMERAS;
            [AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Camera info";
			break;
		}
		case GETIP_CAMERAS:
		{
			[[ipCameraService getSharedInstance] get_zonoff_ip_camera_get_list:self];
			initEnum = PROCESSING;
			break;
		}
		case GETIP_CAMERAS_DONE:
		{
			initEnum = GET_THERMO_STATS;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Thermostats";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Thermostats";
          	break;
		}
		case GET_TRIGGER_DEVICE_LIST:
		{
			[[EventsService getSharedInstance]getTriggerDevicesList:self];
			initEnum = PROCESSING;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST_DONE:
		{
			initEnum = GETSCENES;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Scenes";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Scenes info";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Timer";
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			initEnum = TIMER_GET_INFO;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Timer info";
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
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Event";
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
						
			initEnum = EVENT_INFO;
			[AppDelegate_iPad  sharedAppDelegate].loadingLabel.text = @"Retrieving Schedules Event info";
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
			if([[AppDelegate_iPad  sharedAppDelegate].isRestart isEqualToString:@"1"])
			{
				[AppDelegate_iPad  sharedAppDelegate].isRestart =@"0";
				[AppDelegate_iPad sharedAppDelegate].loadingLabel.hidden = NO;
				
				if(isLocal==1)
					initEnum = NONE;
				else
				{
					if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
						initEnum = NONE;
					else
						initEnum = RELOGIN;
				}
			}
			else if([[AppDelegate_iPad  sharedAppDelegate].isRestart isEqualToString:@"2"])
			{
				[AppDelegate_iPad  sharedAppDelegate].isRestart =@"0";
				[AppDelegate_iPad sharedAppDelegate].loadingLabel.hidden = NO;
				
				[[AppDelegate_iPad sharedAppDelegate] hideLoadingView];
				[self.view addSubview:tahomaControllerView];
				[self.tahomaControllerTable reloadData];
			}
			else if([[AppDelegate_iPad  sharedAppDelegate].isRestart isEqualToString:@"3"])
			{
				txtPassword.text = @"";
				txtUsername.text =@"";
				[rememberMeBtn setImage:[UIImage imageNamed:@"remeberMeUnChecked.png"] forState:UIControlStateNormal];
				[AppDelegate_iPad  sharedAppDelegate].isRestart =@"0";
				[AppDelegate_iPad sharedAppDelegate].loadingLabel.hidden = NO;
				
				[[AppDelegate_iPad sharedAppDelegate] hideLoadingView];
				
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
				
			}
			//[loadGobalValueTimer invalidate];
			//loadGobalValueTimer=nil;
			break;
		}

		default:
			break;
	}
}

-(void)postTimerCall
{
	[[AppDelegate_iPad sharedAppDelegate] hideLoadingView];
	[authenticationProcessing stopAnimating];
	authenticationProcessing.hidden = YES;
	btnLogin.enabled = YES;
	txtPassword.text = @"";
	//authenticateEnum = ERROR;
	//initEnum = ERROR;
	
	[[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view removeFromSuperview];
	
	if(isLocal==1)
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
	else
	{
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
		{
			if([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] == 4)
				[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
			else if ([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"] intValue] == 2)
				[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
		}
		else
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
	}
}

#pragma mark -
#pragma mark LOADING VIEW

- (void)showLoadingView
{
    if (loadingView == nil)
    { 
		loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,1024,768)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.5;
		
		//ActivityIndicator shows in the middle of loadingView
		UILabel *loadingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 1024, 100)];
		loadingTitle.text = @"";
		loadingTitle.textAlignment=UITextAlignmentCenter;
		loadingTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
		loadingTitle.textColor = [UIColor lightGrayColor];
        loadingTitle.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingTitle];
		[loadingTitle release];
		
		UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(494, 402, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    [self.view addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
}


#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	isLoadingError = NO;
	if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPad  sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
		{
			if ([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4 && [[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 2)
			{
				UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
				
				[authenticationProcessing stopAnimating];
				authenticationProcessing.hidden = YES;
				btnLogin.enabled = YES;
				authenticateEnum = ERROR;
				initEnum = ERROR;
				
			}
			else 
			{
				if(authenticateEnum == PROCESSING)
					authenticateEnum = DONE;
				else
					initEnum = NONE;
			}
		}
	}
	else if(strCommand == HOME_OCCUPANCY_INFO_GET)
	{
		initEnum = HOME_OCCUPANCY_DONE;
		[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray = [resultArray mutableCopy];
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
		//[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_roomsArray = [resultArray mutableCopy];
	}
	else if(strCommand==SELECTED_ROOM_COMMAND)
	{
		BOOL isExist;
		initEnum = GETSELECTEDROOMS_DONE;
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeAllObjects];
		NSArray * array =[[[resultArray objectAtIndex:0]objectForKey:@"dataString"]componentsSeparatedByString:@"."];
		
		for(int i=0;i<[array count];i++)
		{
			if([array objectAtIndex:i]!=nil&&![[array objectAtIndex:i] isEqualToString:@""])
			{
				NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
				[dict setValue:[NSNumber numberWithInt:[[array objectAtIndex:i]intValue]] forKey:@"sortingKey"];
				[dict setObject:[array objectAtIndex:i] forKey:@"roomKey"];
				[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray addObject:dict];
				[dict release];
			}
		}
		
		NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"sortingKey" ascending:YES];
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
		[lastNameSorter1 release];
	
		//Check if all selectedroomlist id's in the getrorom list
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];i++)
		{
			isExist = NO;
			for(int j=0;j<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];j++)
			{
				if([[[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i]objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
				{
					isExist = YES;
					break;
				}
			}
			if(!isExist)
				[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:i];
		}
		
	}
	else if(strCommand==GET_ALL)
	{
		initEnum = GETDEVICES_DONE;
		//Copy the getdevices result
		//[[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
	}
	else if(strCommand==ZONOFF_IP_CAMERA_GET_LIST)
	{
		initEnum = GETIP_CAMERAS_DONE;
		[AppDelegate_iPad  sharedAppDelegate].g_ip_camera_list_Array = [resultArray mutableCopy];
	}
	else if(strCommand==GET_THERMOSTATS)
	{
		initEnum = GET_THERMO_STATS_DONE;
		//Copy the getdevices result
		//[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_TRIGGER_DEVICES_LIST)
	{
		initEnum = GET_TRIGGER_DEVICE_LIST_DONE;
		//Copy the getdevices result
		//[[AppDelegate_iPad  sharedAppDelegate].g_getTriggerDeviceListArray removeAllObjects]; 
		[AppDelegate_iPad  sharedAppDelegate].g_getTriggerDeviceListArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_SCENES)
	{
		initEnum = GETSCENES_DONE;
		//Copy the getscenes result
		//[[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_TIMERS)
	{
		initEnum = GET_TIMER_DONE;
		//Copy the g_scheduleList result
		//[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_INFO)
	{
		scheduleTimerInfoEnum = TIMER_GET_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPad  sharedAppDelegate].g_getTimersInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand==GET_EVENTS)
	{
		initEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		//[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray removeAllObjects];
		[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		scheduleEventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	
	else if(strCommand==GET_SCENE_INFO)
	{
		//Copy the getdevices result
		NSMutableArray *tempArr = [resultArray mutableCopy];
		[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray addObject:tempArr];
		sceneInfoEnum = GETSCENE_INFO_DONE;
		if([[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray count]==[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count])
		{
			initEnum = GETSCENE_INFO_DONE;
		}
	}
	else if(strCommand == LOGOUT)
	{
		[[AppDelegate_iPad sharedAppDelegate] hideLoadingView];
		isLOGOUT = YES;
		NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
		for (int i=0; i<[array count]; i++) {
			[[array objectAtIndex:i] removeFromSuperview];
		}
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	[self hideLoadingView];
	[authenticationProcessing stopAnimating];
	authenticationProcessing.hidden = YES;
	[AppDelegate_iPad  sharedAppDelegate].errorLabel.hidden = NO;
	[AppDelegate_iPad  sharedAppDelegate].errorBtn.hidden = NO;
	[AppDelegate_iPad  sharedAppDelegate].reloginBtn.hidden = NO;
	[AppDelegate_iPad  sharedAppDelegate].spinningWheel.hidden = YES;
	
	if(isLocal==1)
	{
		[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.hidden = YES;
		[AppDelegate_iPad  sharedAppDelegate].reloginBtn.hidden = YES;
		[AppDelegate_iPad  sharedAppDelegate].errorBtn.hidden = NO;
		[AppDelegate_iPad  sharedAppDelegate].errorBtn.frame = CGRectMake(424, 400, 155, 45);
	}
	else
	{
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>2)
		{
			[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.hidden = NO;
			[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.frame = CGRectMake(239, 400, 155, 45);
			[AppDelegate_iPad  sharedAppDelegate].errorBtn.frame = CGRectMake(424, 400, 155, 45);
			[AppDelegate_iPad  sharedAppDelegate].reloginBtn.frame = CGRectMake(609, 400, 155, 45);
		}
		else
		{
			[AppDelegate_iPad  sharedAppDelegate].backtoControllerBtn.hidden = YES;
			[AppDelegate_iPad  sharedAppDelegate].errorBtn.frame = CGRectMake(332, 400, 155, 45);
			[AppDelegate_iPad  sharedAppDelegate].reloginBtn.frame = CGRectMake(517, 400, 155, 45);
		}
	}
	
	
	[AppDelegate_iPad  sharedAppDelegate].loadingLabel.hidden = YES;
	btnLogin.enabled = YES;
	authenticateEnum = ERROR;
	initEnum = ERROR;
	isLoadingError = YES;
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [btnRetry release];
    [btnControllers release];
    [btnRelogin release];
	[tahomaControllerView release];
	[tahomaControllerTable release];
	[rememberMeBtn release];
	[txtUsername release];
	[txtPassword release];
	[authenticationProcessing release];
	[btnLogin release];
    [super dealloc];
}


@end
