//
//  ThermostatDevice.m
//  Somfy
//
//  Created by Sempercon on 4/28/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ThermostatDevice.h"
#import "ThermostatEnergySavingMode.h"
#import "AppDelegate_iPhone.h"
#import "ThermostatService.h"
#import "DashboardService.h"
#import "UserService.h"
#import "DBAccess.h"

extern BOOL  _isLOGOUT;

@implementation ThermostatDevice

@synthesize heatBtn,autoBtn,holdBtn,btnBack;
@synthesize deviceDict;
@synthesize roomNameString;
@synthesize temperatureLbl,deviceNameLbl,roomNameLbl;
@synthesize _thermostatInfo,themostatDesiredTempArray;
@synthesize increaseBtn,decreaseBtn,forwardBtn;
@synthesize lblCurrenttemp,lblEnergyTemp,temperatureLblDeg,lblEnergyTempDeg,lblSetTempDeg;
@synthesize Logout;

#pragma mark -
#pragma mark VIEW CALLBACKS

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.view = nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	// Drawing code.
	//Set DeviceName and RoomName
	roomNameLbl.text = roomNameString;
	deviceNameLbl.text = [deviceDict objectForKey:@"name"];
	initTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 
												 target:self 
											   selector:@selector(getThermostatInfo) 
											   userInfo:nil 
												repeats:YES];
	self.navigationController.navigationBar.hidden = YES;
	
	
	lblCurrenttemp.hidden = YES;
	lblSetTempDeg.hidden = YES;
	lblEnergyTemp.hidden = YES;
	lblEnergyTempDeg.hidden = YES;
}

#pragma mark -
#pragma mark INITIAL LOAD

-(void)determineModeButtonLabel:(int)mode
{
	increaseBtn.enabled = YES;
	decreaseBtn.enabled = YES;
	//forwardBtn.enabled = YES;
	switch (mode) {
		case OFF:
		{
			[heatBtn setTitle:@"OFF" forState:UIControlStateNormal];
			increaseBtn.enabled = NO;
			decreaseBtn.enabled = NO;
			//forwardBtn.enabled = NO;
			/*lblPointTemperature.hidden = YES;
			lblTemperatureDeg.hidden = YES;
			lblEsSetPoint.hidden = YES;
			lblEsPointDeg.hidden = YES;*/
			break;
		}
		case HEAT:
		{
			[heatBtn setTitle:@"HEAT" forState:UIControlStateNormal];
			/*lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;*/
			break;
		}
		case COOL:
		{
			[heatBtn setTitle:@"COOL" forState:UIControlStateNormal];
			/*lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;*/
			break;
		}
		default:
			break;
	}
}

-(void)determineFanModeButtonLabel:(int)mode
{
	switch (mode) {
		case FAN_LOW:
			[autoBtn setTitle:@"ON" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_LOW:
			[autoBtn setTitle:@"AUTO" forState:UIControlStateNormal];
			break;
		case FAN_HIGH:
			[autoBtn setTitle:@"HIGH" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_HIGH:
			[autoBtn setTitle:@"AUTO HIGH" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)determineScheduleModeButtonLabel:(int)mode
{
	switch (mode) {
		case USE_SCHEDULE:
			[holdBtn setTitle:@"HOLD" forState:UIControlStateNormal];
			break;
		case BYPASS_SCHEDULE:
			[holdBtn setTitle:@"BYPASS" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)setEnergySavingMode:(int)mode
{
	/*switch (mode) {
		case NORMAL_MODE:
		{
			[energySavingModeBtn setTitle:@"NORMAL MODE" forState:UIControlStateNormal];
			lblEsSetPoint.hidden = YES;
			btnEsSetPointDown.hidden = YES;
			btnEsSetPointUp.hidden = YES;
			lblEsPointDeg.hidden = YES;
			break;
		}
		case ENERGY_SAVINGS_MODE:
		{
			[energySavingModeBtn setTitle:@"ENERGY SAVINGS MODE" forState:UIControlStateNormal];
			lblEsSetPoint.hidden = NO;
			btnEsSetPointDown.hidden = NO;
			btnEsSetPointUp.hidden = NO;
			lblEsPointDeg.hidden = NO;
			break;
		}
		default:
			break;
	}*/
}

-(void)TemperatureValues
{
	if([[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue] == OFF)
	{
		temperatureLbl.text = @"OFF";
		temperatureLblDeg.hidden = YES;
		lblEnergyTemp.text=@"";
		lblEnergyTempDeg.hidden = YES;
		lblCurrenttemp.hidden = YES;
		lblSetTempDeg.hidden = YES;
		
	}
	else
	{
		if([[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue] == HEAT)
		{
			lblEnergyTemp.hidden = NO;
			lblEnergyTempDeg.hidden = NO;
			lblEnergyTemp.text=[[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
			
			lblCurrenttemp.hidden = YES;
			lblSetTempDeg.hidden = YES;
		}
		else if([[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue] == COOL)
		{
			lblSetTempDeg.hidden = NO;
			lblCurrenttemp.hidden = NO;
			lblCurrenttemp.text=[[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
			
			lblEnergyTemp.hidden = YES;
			lblEnergyTempDeg.hidden = YES;
		}
		
		//temperatureLbl.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
		temperatureLbl.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"ambientTemp"];
		temperatureLblDeg.hidden = NO;
	}
}


-(void)UpdateUI
{
	//set thermostat mode btn lbl
	[self determineModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue]];
	//set thermostat fan mode btn lbl
	[self determineFanModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"fanMode"]intValue]];
	//set thermostat schedule mode btn lbl
	[self determineScheduleModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"scheduleBypass"]intValue]];
	//setEnergysaving mode
	[self setEnergySavingMode:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"engSaveMode"]intValue]];
	//set all label value
	[self TemperatureValues];
}


-(void)getThermostatInfo
{
	
	if(initTimer!=nil)
	{
		[initTimer invalidate];
		initTimer = nil;
	}
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	ProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
												  selector:@selector(thermostatTask) 
												  userInfo:nil 
												   repeats:YES];
	thermostatEnum = NONE;
}

-(void)thermostatTask
{
	switch(thermostatEnum)
	{
		case NONE:
		{
			thermostatEnum = GET_THERMOSTATUS;
			break;
		}
		case GET_THERMOSTATUS:
		{
			[[DashboardService getSharedInstance]getThermostatStatus:[deviceDict objectForKey:@"zwaveID"] :self];
			thermostatEnum = PROCESSING;
			break;
		}
		case GET_THERMOSTATUS_DONE:
		{
			thermostatEnum = GET_THERMOSTAT_DESIRED_TEMP;
			break;
		}
		case GET_THERMOSTAT_DESIRED_TEMP:
		{
			//TODO Need to check the command
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"0" forKey:@"esSetPoint"];
			[dataDict setObject:@"0" forKey:@"ambientTemp"];
			[dataDict setObject:@"0" forKey:@"setTemp"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"] forKey:@"mode"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"engSaveMode"] forKey:@"engSaveMode"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"fanMode"] forKey:@"fanMode"];
			[dataDict setObject:@"0" forKey:@"roomID"];
			[dataDict setObject:@"0" forKey:@"devType"];
			[dataDict setObject:@"0" forKey:@"scheduleBypass"];
			[[DashboardService getSharedInstance]getThermostatDesiredTemp:dataDict :self];
			[dataDict release];
			
			thermostatEnum = PROCESSING;
			break;
		}
		case GET_THERMOSTAT_DESIRED_TEMP_DONE:
		{
			thermostatEnum = DONE;
			break;
		}
		case DONE:
		{
			[ProcessTimer invalidate];
			ProcessTimer=nil;
			[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)thermostatHeat:(id)sender
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleMode:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)thermostatAuto:(id)sender
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleFanMode:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)thermostatHold:(id)sender
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleScheduleHold:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)ApplyClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)thermostatIncrease:(id)sender
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatTempUp:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)thermostatDecrease:(id)sender
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatTempDown:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)forwardBtnClicked:(id)sender
{
	ThermostatEnergySavingMode *thermostatEnergySavingMode = [[ThermostatEnergySavingMode alloc]initWithNibName:@"ThermostatEnergySavingMode" bundle:nil];
	thermostatEnergySavingMode.deviceDict = deviceDict;
	thermostatEnergySavingMode.roomNameString = roomNameString;
	thermostatEnergySavingMode._thermostatInfo = _thermostatInfo;
	thermostatEnergySavingMode.themostatDesiredTempArray = themostatDesiredTempArray;
	[self.navigationController pushViewController:thermostatEnergySavingMode animated:YES];
	[thermostatEnergySavingMode release];
}

-(IBAction)btnBackClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)LOGOUT:(id)sender
{
	//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	//[[UserService getSharedInstance]Logout:self];
	
	// Hint
	UIAlertView *alertLOGOUT = [[UIAlertView alloc]initWithTitle:@"Logout Confirmation" 
														 message:@"Do you really want to logout of TaHomA?" 
														delegate:self 
											   cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alertLOGOUT setTag: 325];
	[alertLOGOUT show];
	[alertLOGOUT release];
}

#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==THERMOSTAT_GET_STATUS)
	{
		//Copy the getscenes result
		_thermostatInfo = [resultArray mutableCopy];
		//update in gobal array
		NSString *devId = [deviceDict objectForKey:@"zwaveID"];
		for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray count];i++)
		{
			if([devId isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]] )
			{
				if([_thermostatInfo count] > 0)
					[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray replaceObjectAtIndex:i withObject:[_thermostatInfo objectAtIndex:0]];
				break;
			}
		}
		[self UpdateUI];
		thermostatEnum = GET_THERMOSTATUS_DONE;
	}
	else if(strCommand==THERMOSTAT_GET_DESIRED_TEMP)
	{
		thermostatEnum = GET_THERMOSTAT_DESIRED_TEMP_DONE;
		//Copy the getscenes result
		themostatDesiredTempArray = [resultArray mutableCopy];
		[self UpdateUI];
	}
	else if(strCommand==SET_THERMOSTAT_TEMP_DOWN||strCommand==SET_THERMOSTAT_TEMP_UP||strCommand==THERMOSTAT_TOGGLE_SCHEDULE_HOLD||strCommand==THERMOSTAT_TOGGLE_FAN_MODE||strCommand==THERMOSTAT_TOGGLE_MODE)
	{
		[self getThermostatInfo];
	}
	else if(strCommand == LOGOUT)
	{
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
		
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
		
		_isLOGOUT = YES;
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPhone sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		/*if ([[[[AppDelegate_iPhone sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4)
		{
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}
		else 
		{
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}*/
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
	
	if([errorMsg isEqualToString:@"SESSION EXPIRED"])
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert setTag:255];
		[errorAlert show];
		[errorAlert release];
		
		/*[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];*/
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 255)
	{
		/*[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
		 [[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		 [[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];*/
		
		//Check if rememberme button is selected while login
		NSString *query;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[Arr release];
		[dbobj release];
		if([loginArray count]>0)
		{
			//Remove previous session from sessionArray
			[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
			//Send authenticate command 
			[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
			[[UserService getSharedInstance]authenticate:commandDictionary:self];
			[commandDictionary release];
			
		}
		else
		{
			[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
			[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
			[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];
		}
	}
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
		{
			[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [Logout release];
	[increaseBtn,decreaseBtn,forwardBtn,btnBack release];
	[temperatureLbl,deviceNameLbl,roomNameLbl release];
	[_thermostatInfo,themostatDesiredTempArray release];
	[heatBtn,autoBtn,holdBtn release];
	[deviceDict release];
	[roomNameString release];
	[lblCurrenttemp,lblEnergyTemp,temperatureLblDeg,lblEnergyTempDeg,lblSetTempDeg release];
    [super dealloc];
}


@end
