//
//  ThermostatView.m
//  Somfy
//
//  Created by Sempercon 5/12/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ThermostatView.h"
#import "ThermostatService.h"
#import "DashboardService.h"
#import "AppDelegate_iPad.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"


@interface ThermostatView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)getThermostatInfo;
- (void)thermostatTask;
@end

@implementation ThermostatView
@synthesize delegate;
@synthesize _thermostatInfo,themostatDesiredTempArray;
@synthesize lblCurrentTemperature,lblPointTemperature,lblEsSetPoint;
@synthesize thermostatModeBtn,thermostatFanModeBtn,thermostatScheduleBtn;
@synthesize energySavingModeBtn,btnEsSetPointDown,btnEsSetPointUp;
@synthesize btnPointTemperatureUp,btnPointTemperatureDown;
@synthesize lblEsPointDeg,lblTemperatureDeg,lblThermostat;
@synthesize deviceDict;
@synthesize selectedRoomDeviceArray;

#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

//Load thermostatview from nib file
+ (ThermostatView*) thermostatview
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"ThermostatView" owner:self options:nil];
	return [array objectAtIndex:0]; 
}

//Set maindelegate to get back to MainViewControllers
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback
{
	delegate = callback;
	[delegate retain];
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict;
{
	deviceDict = dict;
	[deviceDict retain];
    lblThermostat.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		lblThermostat.text = @"Thermostat";
}

-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr
{
	selectedRoomDeviceArray = arr;
	[selectedRoomDeviceArray retain];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	
	// Disable all UIButtons and enable when its data retrived from the server
	thermostatModeBtn.enabled = NO;thermostatFanModeBtn.enabled = NO;thermostatScheduleBtn.enabled = NO;
	energySavingModeBtn.enabled = NO;btnEsSetPointDown.enabled = NO;btnEsSetPointUp.enabled = NO;
	btnPointTemperatureUp.enabled = NO;btnPointTemperatureDown.enabled = NO;
	
	
    // Drawing code.
	initTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 
												 target:self 
											   selector:@selector(getThermostatInfo) 
											   userInfo:nil 
												repeats:YES];
	
}

-(void)setCurMetaData:(int)mData
{
	curMetaData = mData;
}

-(void)determineModeButtonLabel:(int)mode
{
	switch (mode) {
		case OFF:
		{
			[thermostatModeBtn setTitle:@"OFF" forState:UIControlStateNormal];
			lblPointTemperature.hidden = YES;
			lblTemperatureDeg.hidden = YES;
			lblEsSetPoint.hidden = YES;
			lblEsPointDeg.hidden = YES;
			btnPointTemperatureUp.enabled = NO;
			btnPointTemperatureDown.enabled = NO;
			btnEsSetPointDown.hidden = YES;
			btnEsSetPointUp.hidden = YES;
			break;
		}
		case HEAT:
		{
			[thermostatModeBtn setTitle:@"HEAT" forState:UIControlStateNormal];
			lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;
			btnPointTemperatureUp.enabled = YES;
			btnPointTemperatureDown.enabled = YES;
			btnEsSetPointDown.hidden = NO;
			btnEsSetPointUp.hidden = NO;
			break;
		}
		case COOL:
		{
			[thermostatModeBtn setTitle:@"COOL" forState:UIControlStateNormal];
			lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;
			btnPointTemperatureUp.enabled = YES;
			btnPointTemperatureDown.enabled = YES;
			btnEsSetPointDown.hidden = NO;
			btnEsSetPointUp.hidden = NO;
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
			[thermostatFanModeBtn setTitle:@"ON" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_LOW:
			[thermostatFanModeBtn setTitle:@"AUTO" forState:UIControlStateNormal];
			break;
		case FAN_HIGH:
			[thermostatFanModeBtn setTitle:@"HIGH" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_HIGH:
			[thermostatFanModeBtn setTitle:@"AUTO HIGH" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)determineScheduleModeButtonLabel:(int)mode
{
	switch (mode) {
		case USE_SCHEDULE:
			[thermostatScheduleBtn setTitle:@"HOLD" forState:UIControlStateNormal];
			break;
		case BYPASS_SCHEDULE:
			[thermostatScheduleBtn setTitle:@"BYPASS" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)setEnergySavingMode:(int)mode
{
	switch (mode) {
		case NORMAL_MODE:
		{
			[energySavingModeBtn setTitle:@"ENERGY SAVINGS MODE" forState:UIControlStateNormal];
			
			//lblEsSetPoint.hidden = YES;
			//btnEsSetPointDown.hidden = YES;
			//btnEsSetPointUp.hidden = YES;
			//lblEsPointDeg.hidden = YES;
			esModeValue = 0;
			break;
		}
		case ENERGY_SAVINGS_MODE:
		{
			[energySavingModeBtn setTitle:@"NORMAL MODE" forState:UIControlStateNormal];
			//lblEsSetPoint.hidden = NO;
			//btnEsSetPointDown.hidden = NO;
			//btnEsSetPointUp.hidden = NO;
			//lblEsPointDeg.hidden = NO;
			esModeValue = 100;
			break;
		}
		default:
			break;
	}
}

-(void)TemperatureValues
{
	
	lblCurrentTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"ambientTemp"];
	lblPointTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
	if([[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"]intValue ] != 0)
		lblEsSetPoint.text = [[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"];
	else 
		lblEsSetPoint.text =@"";
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
	
	//[self showLoadingView];
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
			[self hideLoadingView];
			
			//Enable ALL UIBUTTONS
			// Disable all UIButtons and enable when its data retrived from the server
			thermostatModeBtn.enabled = YES;thermostatFanModeBtn.enabled = YES;thermostatScheduleBtn.enabled = YES;
			energySavingModeBtn.enabled = YES;btnEsSetPointDown.enabled = YES;btnEsSetPointUp.enabled = YES;
			btnPointTemperatureUp.enabled = YES;btnPointTemperatureDown.enabled = YES;
			
			break;
		}
		default:
			break;
	}
}


/*-(void)commitProperties
 {
 //need to go through and set the values of the text properties and also 
 //set the values of the buttons
 
 //Lets set the label of the mode button to the correct value based on the 
 //value of the mode property
 btnMode.label = [self determineModeButtonLabel: _thermostatInfo.mode];
 btnFanMode.label = determineFanModeButtonLabel( _thermostatInfo.fanMode );
 
 //Need to determine the state of the schedule bypass satte
 if ( _thermostatInfo.scheduleBypass == ThermostatScheduleBypassEnums.USE_SCHEDULE )
 {
 tgbScheduleByPass.selected = true;
 tgbScheduleByPass.label = "BYPASS SCHEDULE";
 }else if ( _thermostatInfo.scheduleBypass == ThermostatScheduleBypassEnums.BYPASS_SCHEDULE )
 {
 tgbScheduleByPass.selected = false;
 tgbScheduleByPass.label = "USE SCHEDULE";
 }
 
 if ( _thermostatInfo.engSaveMode == ThermostatEnergySaveModeEnum.NORMAL_MODE )
 {
 tgbEngSaveMode.selected = true;
 tgbEngSaveMode.label = 'NORMAL MODE';
 tiEsSetPoint.enabled = false;
 
 lblEsSetPointValue.enabled = false;
 btnEsSetPointDown.enabled = false;
 btnEsSetPointUp.enabled = false;
 }
 else if ( _thermostatInfo.engSaveMode == ThermostatEnergySaveModeEnum.ENERGY_SAVINGS_MODE )
 {
 tgbEngSaveMode.selected = false;
 tgbEngSaveMode.label = 'ENERGY MODE';
 tiEsSetPoint.enabled = true;
 
 lblEsSetPointValue.enabled = true;
 btnEsSetPointDown.enabled = true;
 btnEsSetPointUp.enabled = true;
 }
 
 
 //Set the values for the text fields
 lblAmbientTemp.text = String(_thermostatInfo.ambientTemp) + "¬∫";
 
 //Set the setpoint temperature
 if ( _thermostatInfo.mode != ThermostateModeEnum.OFF )
 tiSetTemp.text = String ( _thermostatInfo.setTemp ) + "¬∫";
 else
 tiSetTemp.text = '';
 
 //Need to set the off value for the es set point
 if ( _thermostatInfo.mode == ThermostateModeEnum.OFF )
 {
 lblEsSetPointValue.text = '';
 }
 else if ( _thermostatInfo.esSetPoint != 0 )
 {				
 lblEsSetPointValue.text = String ( _thermostatInfo.esSetPoint ) + "¬∫";
 }
 
 //For degree
 @"\xC2\xB0"
 
 -(void)TemperatureValues
 {
 lblCurrentTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"ambientTemp"];
 lblPointTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
 lblEsSetPoint.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"esSetPoint"];
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
 
 }*/




#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)CloseBtnClicked:(id)sender
{
	[delegate removePopup];
}

-(IBAction)thermostatModeBtnClicked:(id)sender
{
	[self showLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleMode:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)thermostatFanModeBtnClicked:(id)sender
{
	[self showLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleFanMode:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)thermostatScheduleBtnClicked:(id)sender
{
	[self showLoadingView];
	[[DashboardService getSharedInstance]setThermostatToggleScheduleHold:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)energySavingModeBtnClicked:(id)sender
{
	esModeValue = 0;
	if([[energySavingModeBtn currentTitle] isEqualToString:@"NORMAL MODE"])
	{
		esModeValue = 100;
		[energySavingModeBtn setTitle:@"ENERGY SAVINGS MODE" forState:UIControlStateNormal];
	}
	else
	{
		esModeValue = 0;
		[energySavingModeBtn setTitle:@"NORMAL MODE" forState:UIControlStateNormal];
	}
	
	
	[self showLoadingView];
	//TODO Need to check the command
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:@"0" forKey:@"mode"];
	[dataDict setObject:@"0" forKey:@"devType"];
	[dataDict setObject:@"0" forKey:@"roomID"];
	[dataDict setObject:@"0" forKey:@"fanMode"];
	[dataDict setObject:[NSString stringWithFormat:@"%d",esModeValue] forKey:@"engSaveMode"];
	[dataDict setObject:@"0" forKey:@"esSetPoint"];
	[dataDict setObject:@"0" forKey:@"setTemp"];
	[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
	[dataDict setObject:@"0" forKey:@"scheduleBypass"];
	[dataDict setObject:@"0" forKey:@"ambientTemp"];
	[[DashboardService getSharedInstance]setThermostatEnergySaveMode:dataDict :self];
	[dataDict release];
}

-(IBAction)btnEsSetPointDownClicked:(id)sender
{
}

-(IBAction)btnEsSetPointUpClicked:(id)sender
{
}

-(IBAction)btnPointTemperatureUpClicked:(id)sender
{
	[self showLoadingView];
	[[DashboardService getSharedInstance]setThermostatTempUp:[deviceDict objectForKey:@"zwaveID"] :self];
}

-(IBAction)btnPointTemperatureDownClicked:(id)sender
{
	[self showLoadingView];
	[[DashboardService getSharedInstance]setThermostatTempDown:[deviceDict objectForKey:@"zwaveID"] :self];
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
		UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 1024, 100)];
        loadingLabel.text = @"";
		loadingLabel.textAlignment=UITextAlignmentCenter;
		loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
		loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingLabel];
		[loadingLabel release];
		
		UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(494, 402, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    
	[self addSubview:loadingView];
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
	if(strCommand==THERMOSTAT_GET_STATUS)
	{
		//Copy the getscenes result
		_thermostatInfo = [resultArray mutableCopy];
		//update in gobal array
		NSString *devId = [deviceDict objectForKey:@"zwaveID"];
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray count];i++)
		{
			if([devId isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]] )
			{
				if([_thermostatInfo count] > 0)
					[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray replaceObjectAtIndex:i withObject:[_thermostatInfo objectAtIndex:0]];
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
		[delegate refreshViewFromPopup];
	}
	else if(strCommand==SET_THERMOSTAT_TEMP_DOWN||strCommand==SET_THERMOSTAT_TEMP_UP||strCommand==THERMOSTAT_TOGGLE_SCHEDULE_HOLD||strCommand==THERMOSTAT_TOGGLE_FAN_MODE||strCommand==THERMOSTAT_TOGGLE_MODE)
	{
		[self getThermostatInfo];
	}
	else if(strCommand == SET_THERMOSTAT_ENERGY_SAVE_MODE)
	{
		[self hideLoadingView];
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPad sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
		{
			if ([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4 && [[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 2)
			{
				UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
				
				[self hideLoadingView];
			}
			else 
			{
				[self hideLoadingView];
			}
		}
	}
}
-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	[self hideLoadingView];
	[ProcessTimer invalidate];
	ProcessTimer = nil;
	thermostatEnum = NONE;
	
	if([errorMsg isEqualToString:@"SESSION EXPIRED"])
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert setTag:255];
		[errorAlert show];
		[errorAlert release];
		
		/*[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
		NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
		for (int i=0; i<[array count]; i++) {
			[[array objectAtIndex:i] removeFromSuperview];
		}
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];*/
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
			[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
			//Send authenticate command 
			[self showLoadingView];
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
			[[UserService getSharedInstance]authenticate:commandDictionary:self];
			[commandDictionary release];
			
		}
		else
		{
			[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
			NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
			for (int i=0; i<[array count]; i++) {
				[[array objectAtIndex:i] removeFromSuperview];
			}
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
	[selectedRoomDeviceArray release];
	[deviceDict release];
	[lblEsPointDeg,lblTemperatureDeg,lblThermostat release];
	[btnPointTemperatureUp,btnPointTemperatureDown release];
	[energySavingModeBtn,btnEsSetPointDown,btnEsSetPointUp release];
	[thermostatModeBtn,thermostatFanModeBtn,thermostatScheduleBtn release];
	[lblCurrentTemperature,lblPointTemperature,lblEsSetPoint release];
	[_thermostatInfo,themostatDesiredTempArray release];
	[delegate release];
    [super dealloc];
}


@end