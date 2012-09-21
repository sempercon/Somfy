//
//  BinaryLightDeviceView.m
//  Somfy
//
//  Created by Sempercon on 5/11/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "BinaryLightDeviceView.h"
#import "DashboardService.h"
#import "Constants.h"
#import "DeviceService.h"
#import "AppDelegate_iPad.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"

@interface BinaryLightDeviceView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
-(void)scenSetMemberSetting;
@end

@implementation BinaryLightDeviceView
@synthesize imgView,deskLampImg;
@synthesize delegate;
@synthesize ONBtn,OFFBtn;
@synthesize DeviceNameLbl;
@synthesize deviceDict;
@synthesize selectedRoomDeviceArray;
@synthesize BinaryDeviceToggleImgBtn;
@synthesize applyALLBtn;
@synthesize sceneValueChangedLbl;

#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (BinaryLightDeviceView*) binarylightview
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"BinaryLightDeviceView" owner:self options:nil];
	return [array objectAtIndex:0]; 
}

-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
{
	delegate = callback;
	[delegate retain];
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict;
{
	deviceDict = dict;
	[deviceDict retain];
	isFromScene = 0;
    DeviceNameLbl.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		DeviceNameLbl.text = @"Desk lamp";
}

-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr
{
	selectedRoomDeviceArray = arr;
	[selectedRoomDeviceArray retain];
}

-(void)setSceneId:(int)sceneId
{
	curSceneID = sceneId;
}
-(void)setSceneIndex:(int)sceneIdx
{
	curSceneIdx = sceneIdx;
}

-(void)setIsFromScene:(int)indicator
{
	isFromScene = indicator;
}

-(void)setCurMetaData:(int)mData
{
	curMetaData = mData;
}


-(void)SetDeviceStateValue:(int)Value
{
	if(Value==0)
	{
		isOn = NO;
		[BinaryDeviceToggleImgBtn setBackgroundImage:[UIImage imageNamed:@"LargeLight_gray.png"] forState:UIControlStateNormal];
		[OFFBtn setBackgroundImage:[UIImage imageNamed:@"OFF_disabled.png"] forState:UIControlStateNormal];
		[ONBtn setBackgroundImage:[UIImage imageNamed:@"ON_down.png"] forState:UIControlStateNormal];
		ONBtn.userInteractionEnabled = YES;
		OFFBtn.userInteractionEnabled= NO;
	}
	else
	{
		isOn = YES;
		[BinaryDeviceToggleImgBtn setBackgroundImage:[UIImage imageNamed:@"light_device_icon.png"] forState:UIControlStateNormal];
		[ONBtn setBackgroundImage:[UIImage imageNamed:@"ON_disabled.png"] forState:UIControlStateNormal];
		[OFFBtn setBackgroundImage:[UIImage imageNamed:@"OFF_down.png"] forState:UIControlStateNormal];
		ONBtn.userInteractionEnabled = NO;
		OFFBtn.userInteractionEnabled= YES;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)ONClicked:(id)sender
{
	//Call set value command to  binary light device
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	currentValue = 100;
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];
}

-(IBAction)OFFClicked:(id)sender
{
	//Call set value command to  binary light device
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	currentValue = 0;
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];
}

-(IBAction)BinaryDeviceToggleImgBtnClicked:(id)sender
{
	if([BinaryDeviceToggleImgBtn currentBackgroundImage]==[UIImage imageNamed:@"light_device_icon.png"])
	{
		//Call set value command to  binary light device
		[self showLoadingView];
		NSString *deviceId = [deviceDict objectForKey:@"id"];
		currentValue = 0;
		if(isFromScene == 1)
			[self scenSetMemberSetting];
		else 
			[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];
	}
	else
	{
		//Call set value command to  binary light device
		[self showLoadingView];
		NSString *deviceId = [deviceDict objectForKey:@"id"];
		currentValue = 100;
		if(isFromScene == 1)
			[self scenSetMemberSetting];
		else 
			[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];
	}
}


-(void)setApplyAlltoDevices
{
	[self showLoadingView];
	QueueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
												  target:self 
												selector:@selector(QueueProcess) 
												userInfo:nil 
												 repeats:YES];
	queueEnum = NONE;
	deviceIndex = 0;
}

-(void)QueueProcess
{
	switch(queueEnum)
	{
		case NONE:
		{
			queueEnum = SET_DEVICE_VALUE;
			break;
		}
		case SET_DEVICE_VALUE:
		{
			[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",currentValue] :[[tempDevicesArray objectAtIndex:deviceIndex]objectForKey:@"id"] :self];
			queueEnum = PROCESSING;
			break;
		}
		case SET_DEVICE_VALUE_DONE:
		{
			if(deviceIndex<[tempDevicesArray count]-1)
			{
				deviceIndex++;
				queueEnum = SET_DEVICE_VALUE;
			}
			else
				queueEnum = GET_ALL_DEVICE_INFO;
			break;
		}
		case GET_ALL_DEVICE_INFO:
		{
			queueEnum = PROCESSING;
			[[DeviceService getSharedInstance] getAll:self];
		}
		case APPLYTO_ALLDONE:
		{
			[QueueTimer invalidate];
			QueueTimer=nil;
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}


-(IBAction)APPLYTOALLClicked:(id)sender
{
	if([tempDevicesArray count]>0)
		[tempDevicesArray removeAllObjects];
	
	if(selectedRoomDeviceArray!=nil)
	{
		for (int i=0; i<[selectedRoomDeviceArray count]; i++) {
			int deviceType = [[[selectedRoomDeviceArray objectAtIndex:i]objectForKey:@"deviceType"] intValue];
			if(deviceType == [[deviceDict objectForKey:@"deviceType"] intValue] && 
			   [[[selectedRoomDeviceArray objectAtIndex:i]objectForKey:@"id"] intValue] != [[deviceDict objectForKey:@"id"] intValue])
			{
				//Add all same devicetype devices in the tempDevicesArray 
				[tempDevicesArray addObject:[selectedRoomDeviceArray objectAtIndex:i]];
			}
		}
	}
	
	if([tempDevicesArray count]>0)
		[self setApplyAlltoDevices];
}

-(IBAction)CloseClicked:(id)sender
{
	[delegate removePopup];
	[tempDevicesArray release];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    sceneValueChangedLbl.alpha = 0.0f;
	tempDevicesArray = [[NSMutableArray alloc]init];
	if(isFromScene == 1)
	{
		applyALLBtn.hidden = YES;
		[self SetDeviceStateValue:[[deviceDict objectForKey:@"setting"]intValue]];
	}
	else
	{
		applyALLBtn.hidden = NO;
		[self SetDeviceStateValue:[[deviceDict objectForKey:@"value"]intValue]];
	}
}

-(void)hideSceneValueLabel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    sceneValueChangedLbl.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void)showSceneValueLabel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    sceneValueChangedLbl.alpha = 1.0f;
    [UIView commitAnimations];
}
		 
-(void)scenSetMemberSetting
{
	
	if(commandTimer!=nil)
	{
		[commandTimer invalidate];
		commandTimer = nil;
	}
	[self showLoadingView];
	commandTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
												  selector:@selector(setMemberSettingTask) 
												  userInfo:nil 
												   repeats:YES];
	commandEnum = NONE;
}
	 
-(void)setMemberSettingTask
{
	switch(commandEnum)
	{
		case NONE:
		{
			commandEnum = SET_SCENE_MEMBER_SETTING;
			break;
		}
		case SET_SCENE_MEMBER_SETTING:
		{
			[self showLoadingView];
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"1" forKey:@"include"];
			[dataDict setObject:[deviceDict objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",curSceneID] forKey:@"scene"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",ZWAVE_DEVICE] forKey:@"settingType"];
			[dataDict setObject:@"1" forKey:@"setValue"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",currentValue] forKey:@"value"];
			//[[SceneConfiguratorHomeownerService getSharedInstance]setMemberSetting:[deviceDict objectForKey:@"zwaveID"] :self];
			[[SceneConfiguratorHomeownerService getSharedInstance]setMemberSetting:dataDict :self];
			[dataDict release];
			commandEnum = PROCESSING;
			break;
		}
		case SET_SCENE_MEMBER_SETTING_DONE:
		{
			commandEnum = GETSCENE_INFO;
			break;
		}
		case GETSCENE_INFO:
		{
			[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[NSString stringWithFormat:@"%d",curSceneID] :self];
			commandEnum = PROCESSING;
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			commandEnum = DONE;
			break;
		}
		case DONE:
		{
			[commandTimer invalidate];
			commandTimer=nil;
			[self hideLoadingView];
            if(isFromScene == 1)
            {
                [self showSceneValueLabel];
                [self performSelector:@selector(hideSceneValueLabel) withObject:nil afterDelay:2.5];
            }
			break;
		}
		default:
			break;
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
	if(strCommand == DEVICE_SETVALUE)
	{
		if(queueEnum == PROCESSING)
		{
			queueEnum = SET_DEVICE_VALUE_DONE;
		}
		else if(isOn)
		{
			[self SetDeviceStateValue:0];
			if(isFromScene == 0)
				[[DeviceService getSharedInstance] getAll:self];
		}
		else if(isOn == NO)
		{
			[self SetDeviceStateValue:100];
			if(isFromScene == 0)
				[[DeviceService getSharedInstance] getAll:self];
		}
		else if(strCommand==SET_MEMBER_SETTINGS)
		{
			commandEnum = SET_SCENE_MEMBER_SETTING_DONE;
		}
		else if(strCommand==GET_SCENE_INFO)
		{
			//NSMutableDictionary *tempdict = [resultArray objectAtIndex:0];
			[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray replaceObjectAtIndex:curSceneIdx withObject:resultArray];
			commandEnum = GETSCENE_INFO_DONE;
		}

	}
	else if(strCommand==SET_MEMBER_SETTINGS)
	{
		commandEnum = SET_SCENE_MEMBER_SETTING_DONE;
		[self SetDeviceStateValue:currentValue];
	}
	else if(strCommand==GET_SCENE_INFO)
	{
		//NSMutableDictionary *tempdict = [resultArray objectAtIndex:0];
		[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray replaceObjectAtIndex:curSceneIdx withObject:resultArray];
		commandEnum = GETSCENE_INFO_DONE;
	}
	else if (strCommand == GET_ALL)
	{
		if(queueEnum == PROCESSING)
			queueEnum = APPLYTO_ALLDONE;
		
		[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		[delegate refreshViewFromPopup];
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
	[QueueTimer invalidate];
	QueueTimer=nil;
	queueEnum = NONE;
	[commandTimer invalidate];
	commandTimer = nil;
	commandEnum = NONE;
	
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
	[applyALLBtn release];
	[BinaryDeviceToggleImgBtn release];
	[deviceDict release];
	[selectedRoomDeviceArray release];
	[ONBtn,OFFBtn release];
	[DeviceNameLbl release];
	[imgView,deskLampImg release];
	[delegate release];
    [sceneValueChangedLbl release];
    [super dealloc];
}


@end
