//
//  DimmerDeviceView.m
//  Somfy
//
//  Created by mac user on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DimmerDeviceView.h"
#import "Constants.h"
#import "AppDelegate_iPad.h"
#import "DeviceService.h"
#import "DashboardService.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"

@interface DimmerDeviceView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
-(void)scenSetMemberSetting;
@end

@implementation DimmerDeviceView
@synthesize delegate;
@synthesize trackView;
@synthesize trackingImg;
@synthesize DimmerValueLbl;
@synthesize DimmerDeviceIncreaseBtn,DimmerDeviceDecreasBtn;
@synthesize deviceDict;
@synthesize selectedRoomDeviceArray;
@synthesize DimmerValueLbl1;
@synthesize btnDimmer;
@synthesize applyALLBtn;
@synthesize sceneValueChangedLbl;

//Dimmer device slider constants
float SLIDER_OFFSET = 1.2;
float totalOffset = 134;
int SLIDER_X = 78;

#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

+ (DimmerDeviceView*) dimmerDeviceview
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"DimmerDeviceView" owner:self options:nil];
	return [array objectAtIndex:0];
}
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback
{
	delegate = callback;
	[delegate retain];
	isFromScene = 0;
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict;
{
	deviceDict = dict;
	[deviceDict retain];
    DimmerValueLbl1.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		DimmerValueLbl1.text = @"Main Light";
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

-(void)setSliderPosition:(int)value
{
	sliderValue = value;
	float sliderPos;
	sliderPos = totalOffset - (value * SLIDER_OFFSET);
	lastYPoint = sliderPos;
	trackingImg.center = CGPointMake(SLIDER_X+12.5, sliderPos);
	DimmerValueLbl.center = CGPointMake(SLIDER_X-45, sliderPos);
	DimmerValueLbl.text = [NSString stringWithFormat:@"%d",value];
	DimmerValueLbl.text = [DimmerValueLbl.text stringByAppendingString:@"%"];
	//DimmerDeviceImage.image = [self getDeviceImageForValue:value];
	[btnDimmer setBackgroundImage:[self getDeviceImageForValue:value] forState:UIControlStateNormal];
}


-(void)LoadImageView:(float)val
{
	float sliderVal=0.0;
	sliderVal = val ;
	
	//Find value of adjust slider
	float result = (totalOffset - sliderVal) / 1.2;
	sliderValue = result;
	
	if(sliderValue>100)
		sliderValue = 100;
	if(sliderValue<0)
		sliderValue = 0;
	
	if(sliderValue>=0 && sliderValue<10)
		sliderValue = 0;
	else if(sliderValue>=10 && sliderValue<20)
		sliderValue = 10;
	else if(sliderValue>=20 && sliderValue<30)
		sliderValue = 20;
	else if(sliderValue>=30 && sliderValue<40)
		sliderValue = 30;
	else if(sliderValue>=40 && sliderValue<50)
		sliderValue = 40;
	else if(sliderValue>=50 && sliderValue<60)
		sliderValue = 50;
	else if(sliderValue>=60 && sliderValue<70)
		sliderValue = 60;
	else if(sliderValue>=70 && sliderValue<80)
		sliderValue = 70;
	else if(sliderValue>=80 && sliderValue<90)
		sliderValue = 80;
	else if(sliderValue>=90 && sliderValue<100)
		sliderValue = 90;
	
	//Calculate thumb image position from sliderValue
	sliderVal = totalOffset - (sliderValue * 1.2);
	
	//Set tracking image as center
	trackingImg.center = CGPointMake(SLIDER_X+12.5, sliderVal);
	DimmerValueLbl.center = CGPointMake(SLIDER_X-45, sliderVal);
	
	//set slider value label text
	DimmerValueLbl.text = [NSString stringWithFormat:@"%d",sliderValue];
	DimmerValueLbl.text = [DimmerValueLbl.text stringByAppendingString:@"%"];
	//DimmerDeviceImage.image = [self getDeviceImageForValue:sliderValue];
	[btnDimmer setBackgroundImage:[self getDeviceImageForValue:sliderValue] forState:UIControlStateNormal];
}

-(UIImage *) getDeviceImageForValue :(int)deviceValue
{
	NSString *roomImageName;
	UIImage *roomImage;
	
	
	//Determine the device type based on the DeviceTypeEnum of device types
	if(deviceValue >= 0 && deviceValue <= 9 )
		roomImageName = @"iP_Room_dimmer_Light0";
	else if(deviceValue >= 10 && deviceValue <= 19 )
		roomImageName = @"iP_Room_dimmer_Light10";
	else if(deviceValue >= 20 && deviceValue <= 29 )
		roomImageName = @"iP_Room_dimmer_Light20";
	else if(deviceValue >= 30 && deviceValue <= 39 )
		roomImageName = @"iP_Room_dimmer_Light30";
	else if(deviceValue >= 40 && deviceValue <= 49 )
		roomImageName = @"iP_Room_dimmer_Light40";
	else if(deviceValue >= 50 && deviceValue <= 59 )
		roomImageName = @"iP_Room_dimmer_Light50";
	else if(deviceValue >= 60 && deviceValue <= 69 )
		roomImageName = @"iP_Room_dimmer_Light60";
	else if(deviceValue >= 70 && deviceValue <= 79 )
		roomImageName = @"iP_Room_dimmer_Light70";
	else if(deviceValue >= 80 && deviceValue <= 89 )
		roomImageName = @"iP_Room_dimmer_Light80";
	else if(deviceValue >= 90 && deviceValue <= 99 )
		roomImageName = @"iP_Room_dimmer_Light90";
	else if(deviceValue >= 100)
		roomImageName = @"iP_Room_dimmer_Light100";
	
	//get the device image with the devicetype name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
}

#pragma mark -
#pragma mark TOUCH DELEGATES

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		CGPoint touchPoint = [touch locationInView:trackView];
		if(touchPoint.x>78&&touchPoint.x<102&&touchPoint.y>12&&touchPoint.y<=135)
		{
			DimmerValueLbl.hidden = NO;
			lastSliderValue = sliderValue;
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		CGPoint touchPoint = [touch locationInView:trackView];
		if(touchPoint.x>78&&touchPoint.x<102&&touchPoint.y>12&&touchPoint.y<=135)
		{
			DimmerValueLbl.hidden = NO;
			[self LoadImageView:touchPoint.y];
			lastYPoint = touchPoint.y;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	DimmerValueLbl.hidden = YES;
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		if(lastSliderValue!=sliderValue)
		{
			[self showLoadingView];
			NSString *deviceId = [deviceDict objectForKey:@"id"];
			if(isFromScene == 1)
				[self scenSetMemberSetting];
			else
				[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
		}
	}
	
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)btnDimmerClicked:(id)sender
{
	[self showLoadingView];
	
	if(sliderValue == 0)
		sliderValue =100;
	else if (sliderValue >0)
		sliderValue = 0;
	
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else
	{
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
	}
	[self setSliderPosition:sliderValue];
}

-(IBAction)CloseBtnClicked:(id)sender
{
	[delegate removePopup];
	[tempDevicesArray release];
}

-(IBAction)DimmerDeviceIncreaseBtnClicked:(id)sender
{
	lastYPoint-= 12;
	if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 14;
		[self LoadImageView:lastYPoint];
	}
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
}

-(IBAction)DimmerDeviceDecreasBtnClicked:(id)sender
{
	lastYPoint+= 12;
	if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 134;
		[self LoadImageView:lastYPoint];
	}
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
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
			[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :[[tempDevicesArray objectAtIndex:deviceIndex]objectForKey:@"id"] :self];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	DimmerValueLbl.hidden = YES;
    sceneValueChangedLbl.alpha = 0.0f;
	tempDevicesArray = [[NSMutableArray alloc]init];
	if(isFromScene == 1)
	{
		[self setSliderPosition:[[deviceDict objectForKey:@"setting"]intValue]];
		applyALLBtn.hidden = YES;
	}
	else 
	{
		[self setSliderPosition:[[deviceDict objectForKey:@"value"]intValue]];
		applyALLBtn.hidden = NO;
	}
	
	lastSliderValue = [[deviceDict objectForKey:@"value"]intValue];
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
			[dataDict setObject:[NSString stringWithFormat:@"%d",sliderValue] forKey:@"value"];
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
		else
			[[DeviceService getSharedInstance] getAll:self];
	}
	else if (strCommand == GET_ALL)
	{
		if(queueEnum == PROCESSING)
			queueEnum = APPLYTO_ALLDONE;
		
		[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		[delegate refreshViewFromPopup];
		[self hideLoadingView];
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
	commandTimer=nil;
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
    [sceneValueChangedLbl release];
	[applyALLBtn release];
	[btnDimmer release];
    [DimmerValueLbl1 release];
	[deviceDict release];
	[selectedRoomDeviceArray release];
	[DimmerDeviceIncreaseBtn,DimmerDeviceDecreasBtn release];
	[DimmerValueLbl release];
	[trackView release];
	[trackingImg release];
	[delegate release];
    [super dealloc];
}


@end
