//
//  LiveviewDashboard.m
//  Somfy
//
//  Created by Sempercon on 5/3/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "LiveviewDashboard.h"
#import "Scheduleconfigurator_Homeowner.h"
#import "SceneConfigurator_Homeowner.h"
#import "AppDelegate_iPad.h"
#import "RoomSelector_ipad.h"
#import "DeviceConfigurator_iPad.h"
#import "SceneConfigurator_iPad.h"
#import "EventConfigurator_iPad.h"
#import "ScheduleConfigurator_iPad.h"
#import "DashboardService.h"
#import "RoomIconMapper.h"
#import "RoomService.h"
#import "BinaryLightDeviceView.h"
#import "OnewayMotorView.h"
#import "DimmerDeviceView.h"
#import "DeviceService.h"
#import "DeviceIconMapper.h"
#import "DeviceSkinChooser.h"
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "MJPEGViewer_iPad.h"

@interface LiveviewDashboard (Private)
-(void)SelectRoomDevicesArray;
-(void)LoadScenes:(NSMutableArray*)sceneArr;
-(void)LoadRooms:(NSMutableArray*)roomsArr;
-(void)LoadDevicesForRooms;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void)removePopup;
-(NSString*)getDeviceNameAndValue:(NSString*)strName :(NSString*)strValue :(int)deviceType;
-(void) alignLabelWithTop:(UILabel *)label;
@end

extern BOOL  isLOGOUT;


@implementation LiveviewDashboard
@synthesize SceneScrollview,RoomScrollview;
@synthesize TimeLbl1,TimeLbl2,DateLbl,ActivatedLabel;
@synthesize DashboardBtn,SceneConfigBtn,ScheduleConfigBtn,InstallerViewBtn;

@synthesize _selectedRoomDevicesList,_openRoomsArray;
@synthesize popupView;
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    if (isLocal == 1)
        self.Logout.hidden = YES;
	
	_selectedRoomDevicesList = [[NSMutableArray alloc] init];
	_openRoomsArray = [[NSMutableArray alloc] init];
	
	isRoomSelect = NO;
	isSceneSelect = NO;
	//[self startTimer];
	DateTimeDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:1 
															target:self 
														  selector:@selector(DateTimeDisplayTask) 
														  userInfo:nil 
														   repeats:YES];
	
	//[self LoadScenes:[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray];
	//[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray];
	//[self LoadDevicesForRooms];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) 
	{ 
		return YES; 
	} 
	return NO;
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
	self.view = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
	if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
	{
		if([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] == 4)
			InstallerViewBtn.hidden = YES;
		else {
			InstallerViewBtn.hidden = NO;
		}
	}
	
	
	[[AppDelegate_iPad sharedAppDelegate]SetHomeownerViewIndex:1];
	[DashboardBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	
	[self LoadScenes:[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray];
	[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray];
	[self LoadDevicesForRooms];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
	
}

#pragma mark -
#pragma mark INITIAL LOAD


-(void)DateTimeDisplayTask
{
	NSDate *date = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh:mm"];
	TimeLbl1.text = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"a"];
	TimeLbl2.text = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"MM/dd/yy"];
	DateLbl.text = [dateFormatter stringFromDate:date];
	[dateFormatter release];
}

-(void)LoadScenes:(NSMutableArray*)sceneArr
{
	NSArray *subviewArr = [SceneScrollview subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];

	int x=10,y=10;
	for(int i=0;i<[sceneArr count];i++)
	{
		UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x-5, y, 118, 117);
		[customBtn setTag:i];
		[customBtn setBackgroundImage:[UIImage imageNamed:@"ForScene.png"] forState:UIControlStateNormal];
		[customBtn addTarget:self action:@selector(SceneActivate:) forControlEvents:UIControlEventTouchUpInside];
		[SceneScrollview addSubview:customBtn];
		[customBtn release];
		
		//Activate scene label
		UILabel *activateLbl = [[UILabel alloc]initWithFrame:CGRectMake(x+2, y+60, 105, 50)];
		activateLbl.textColor = [UIColor orangeColor];
		activateLbl.hidden = YES;
		activateLbl.backgroundColor = [UIColor clearColor];
		activateLbl.textAlignment = UITextAlignmentCenter;
		activateLbl.lineBreakMode = UILineBreakModeWordWrap;
		activateLbl.numberOfLines = 0;
		[activateLbl setTag:i];
		activateLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
		activateLbl.text = @"ACTIVATED";
		[SceneScrollview addSubview:activateLbl];
		[activateLbl release];
		
		y = y+80;
		
		 UILabel *sceneName = [[UILabel alloc] initWithFrame:CGRectMake(x-8, y+30, 120, 100)];
		 sceneName.textAlignment =UITextAlignmentCenter;
		 sceneName.textColor = [UIColor whiteColor];
		 sceneName.backgroundColor = [UIColor clearColor];
		 sceneName.lineBreakMode = UILineBreakModeWordWrap;
		 sceneName.numberOfLines =5;
		 sceneName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		 sceneName.text=[[sceneArr objectAtIndex:i] objectForKey:@"name"];
		 [sceneName setTag:i];
		 [self alignLabelWithTop:sceneName];
		 [SceneScrollview addSubview:sceneName];
		 [sceneName release];
		
		customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x-8, y, 120, 100);
		customBtn.titleLabel.textAlignment =UITextAlignmentCenter;
		customBtn.titleLabel.textColor = [UIColor clearColor];
		customBtn.titleLabel.backgroundColor = [UIColor clearColor];
		customBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		customBtn.titleLabel.numberOfLines = 5;
		customBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		[customBtn setTag:i];
		[customBtn addTarget:self action:@selector(SceneActivate:) forControlEvents:UIControlEventTouchUpInside];
		[SceneScrollview addSubview:customBtn];
		[customBtn release];
		
		
		x = x+160;
		y=10;
		
		[SceneScrollview setContentSize:CGSizeMake(x, 200)];
	}
}
- (void) alignLabelWithTop:(UILabel *)label {
	CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
	label.adjustsFontSizeToFitWidth = NO;
	
	// get actual height
	CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
	CGRect rect = label.frame;
	rect.size.height = actualSize.height;
	label.frame = rect;
}

-(void)LoadRooms:(NSMutableArray*)roomsArr
{
	int NoofDevice = 0;
	UIImage *RoomImage,*DeviceImage;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [RoomScrollview subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	//Initial x and y values
	int x=10,y=10,newX=10,newY=10;
	int BackgroundWidth;
	BOOL isTrue = NO;
	for(int i=0;i<[roomsArr count];i++)
	{
		isTrue = NO;
		for(int j=0;j<[_openRoomsArray count];j++)
		{
			if(i==[[_openRoomsArray objectAtIndex:j] intValue])
			{
				NSMutableArray *DeviceArr = [_selectedRoomDevicesList objectAtIndex:i];
				NoofDevice = [DeviceArr count];
				
				//Single device width should be 90.So multiply 90 with number of device to find a width of dashboard device background image.
				if(NoofDevice==0)
					BackgroundWidth = 60;
				else
				{
					if(NoofDevice < 4)
						BackgroundWidth = (NoofDevice * 90) + (NoofDevice*10) +35;
					else 
					{
						BackgroundWidth = (NoofDevice * 90) + (NoofDevice*10);
					}

				}
				//Dashboard device background image 
				UIImageView * customImg = [[UIImageView alloc] initWithFrame:CGRectMake(newX+75, newY-5, BackgroundWidth+20, 180)];
				customImg.image	= [UIImage imageNamed:@"dashboard_device_background.png"];
				[RoomScrollview addSubview:customImg];
				[customImg release];
				isTrue = YES;
				//Draw no of device based on rooms
				for(int k=0;k<NoofDevice;k++)
				{
					if(k==0)
						newX = newX+120+10;
					else
						newX = newX+80+10;
					newY = newY+15;
					UIButton * DeviceBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
					DeviceBtn.frame = CGRectMake(newX, newY, 80, 80);
					
					//Set DeviceBtn Tag used as deviceRoomConst
					[DeviceBtn setTag:[[[DeviceArr objectAtIndex:k]objectForKey:@"id"]intValue]];
					//set device image based on device type
					if([[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == THERMOSTATV2 || [[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == THERMOSTAT_RCS)
						DeviceImage = [UIImage imageNamed:@"LargeTheromastat.png"];
					else
					{
						if([[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == SOMFY_RTS || [[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == SOMFY_ILT )
						{
							DeviceImage = [[DeviceIconMapper getSharedInstance]getSomfyDeviceImageBasedOnDeviceType:[[[DeviceArr objectAtIndex:k]objectForKey:@"metaData"]intValue]];
						}
						else if([[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == IP_CAMERA_DEVICE_TYPE)
						{
							DeviceImage = [UIImage imageNamed:@"cameraIcon1.png"];
						}
						else {
							DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceTypeandDeviceValue:[[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] :[[[DeviceArr objectAtIndex:k]objectForKey:@"value"]intValue]:[[[DeviceArr objectAtIndex:k]objectForKey:@"metaData"]intValue]];
							
							}

					}
					[DeviceBtn setBackgroundImage:DeviceImage forState:UIControlStateNormal];
					
					[DeviceBtn addTarget:self action:@selector(DeviceSelect:) forControlEvents:UIControlEventTouchUpInside];
					[RoomScrollview addSubview:DeviceBtn];
					[DeviceBtn release];
					newY = newY+80;
					//Room name label
					UILabel *DeviceName = [[UILabel alloc]initWithFrame:CGRectMake(newX-6, newY, 90, 60)];
					DeviceName.textColor = [UIColor whiteColor];
					DeviceName.backgroundColor = [UIColor clearColor];
					DeviceName.textAlignment = UITextAlignmentCenter;
					DeviceName.lineBreakMode = UILineBreakModeWordWrap;
					DeviceName.numberOfLines = 0;
					DeviceName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                    //NSLog(@"DeviceName frame = %f,%f",DeviceName.frame.origin.x,DeviceName.frame.origin.y);
					
					if ([[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == THERMOSTATV2 || [[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue] == THERMOSTAT_RCS)
					{
                        DeviceName.frame = CGRectMake(newX-6, newY, 90, 40);
                        DeviceName.lineBreakMode = UILineBreakModeTailTruncation;
						DeviceName.text = [[DeviceArr objectAtIndex:k]objectForKey:@"name"];
						//[self alignLabelWithTop:DeviceName];
						[RoomScrollview addSubview:DeviceName];
						
						NSString *devId = [[DeviceArr objectAtIndex:k]objectForKey:@"zwaveID"];
						NSMutableDictionary *curThermostatInfo;
						for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray count];i++)
						{
							if([devId isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]] )
							{
								curThermostatInfo = [[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i];
								break;
							}
						}
						
						newY = newY+40;
                        newX = newX-5;
						//UILabel *AmbientTemp = [[UILabel alloc]initWithFrame:CGRectMake(newX, newY+20, 50, 60)];
                        UILabel *AmbientTemp = [[UILabel alloc]initWithFrame:CGRectMake(newX, newY, 50, 30)];
						AmbientTemp.textColor = [UIColor whiteColor];
						AmbientTemp.backgroundColor = [UIColor clearColor];
						AmbientTemp.textAlignment = UITextAlignmentCenter;
						AmbientTemp.lineBreakMode = UILineBreakModeWordWrap;
						AmbientTemp.numberOfLines = 0;
						AmbientTemp.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
						AmbientTemp.text = [curThermostatInfo objectForKey:@"ambientTemp"];
						[self alignLabelWithTop:AmbientTemp];
						[RoomScrollview addSubview:AmbientTemp];
                        //NSLog(@"AmbientTemp frame = %f,%f",AmbientTemp.frame.origin.x,AmbientTemp.frame.origin.y);
						[AmbientTemp release];
                        
						
						//UILabel *degree1 = [[UILabel alloc]initWithFrame:CGRectMake(newX+25, newY+18, 20, 60)];
                        UILabel *degree1 = [[UILabel alloc]initWithFrame:CGRectMake(newX+25, newY, 20, 30)];
						degree1.textColor = [UIColor whiteColor];
						degree1.backgroundColor = [UIColor clearColor];
						degree1.textAlignment = UITextAlignmentCenter;
						degree1.lineBreakMode = UILineBreakModeWordWrap;
						degree1.numberOfLines = 0;
						degree1.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
						degree1.text = @"o";
						[self alignLabelWithTop:degree1];
						[RoomScrollview addSubview:degree1];
                        //NSLog(@"degree1 frame = %f,%f",degree1.frame.origin.x,degree1.frame.origin.y);
						[degree1 release];
						
						//UILabel *seperator = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10, newY+20, 20, 60)];
                        UILabel *seperator = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10, newY, 20, 60)];
						seperator.textColor = [UIColor whiteColor];
						seperator.backgroundColor = [UIColor clearColor];
						seperator.textAlignment = UITextAlignmentCenter;
						seperator.lineBreakMode = UILineBreakModeWordWrap;
						seperator.numberOfLines = 0;
						seperator.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
						seperator.text = @"|";
						[self alignLabelWithTop:seperator];
						[RoomScrollview addSubview:seperator];
                        //NSLog(@"seperator frame = %f,%f",seperator.frame.origin.x,seperator.frame.origin.y);
						[seperator release];
						
						// Hint
						//UILabel *setTemp = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10+5, newY+20, 50, 60)];
                        UILabel *setTemp = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10+5, newY, 50, 60)];
						setTemp.textColor = [UIColor whiteColor];
						setTemp.backgroundColor = [UIColor clearColor];
						setTemp.textAlignment = UITextAlignmentCenter;
						setTemp.lineBreakMode = UILineBreakModeWordWrap;
						setTemp.numberOfLines = 0;
						setTemp.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
						//  Hint Showing ThermoState Off
						if([[curThermostatInfo objectForKey:@"setTemp"] isEqualToString:@"0"])
							setTemp.text= @"OFF";
						else						
							setTemp.text = [curThermostatInfo objectForKey:@"setTemp"];
						[self alignLabelWithTop:setTemp];
						[RoomScrollview addSubview:setTemp];
                        //NSLog(@"setTemp frame = %f,%f",setTemp.frame.origin.x,setTemp.frame.origin.y);
						[setTemp release];
						
						// Hint if thermostat stat will be off means we dont show an degree
						if(![[curThermostatInfo objectForKey:@"setTemp"] isEqualToString:@"0"])
						{
							//UILabel *degree2 = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10+5+25, newY+18, 20, 60)];
                            UILabel *degree2 = [[UILabel alloc]initWithFrame:CGRectMake(newX+25+10+5+25, newY, 20, 60)];
							degree2.textColor = [UIColor whiteColor];
							degree2.backgroundColor = [UIColor clearColor];
							degree2.textAlignment = UITextAlignmentCenter;
							degree2.lineBreakMode = UILineBreakModeWordWrap;
							degree2.numberOfLines = 0;
							degree2.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
							degree2.text = @"o";
							[self alignLabelWithTop:degree2];
							[RoomScrollview addSubview:degree2];
                             //NSLog(@"degree2 frame = %f,%f",degree2.frame.origin.x,degree2.frame.origin.y);
							[degree2 release];
						}
					}
					else 
					{
						
						DeviceName.text = [self getDeviceNameAndValue :[[DeviceArr objectAtIndex:k]objectForKey:@"name"] :[[DeviceArr objectAtIndex:k]objectForKey:@"value"] :[[[DeviceArr objectAtIndex:k]objectForKey:@"deviceType"]intValue]];
						[self alignLabelWithTop:DeviceName];
						[RoomScrollview addSubview:DeviceName];
					}
					[DeviceName release];
					newY = 10;
				}
			}
		}
		
		//Room images
		UIButton * RoomBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		RoomBtn.frame = CGRectMake(x, y, 102, 102);
		[RoomBtn setTag:i];
		RoomImage = [[RoomIconMapper getSharedInstance]getRoomImageBasedOnRoomId:[[[roomsArr objectAtIndex:i]objectForKey:@"roomKey"]intValue]];
		[RoomBtn setBackgroundImage:RoomImage forState:UIControlStateNormal];
		[RoomBtn addTarget:self action:@selector(RoomClick:) forControlEvents:UIControlEventTouchUpInside];
		[RoomScrollview addSubview:RoomBtn];
		[RoomBtn release];
		
		y = y+110;
	
        //Room name label
		UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(x-15, y, 135, 100)];
		roomName.textAlignment =UITextAlignmentCenter;
		[roomName setTag:i];
		//[roomName addTarget:self action:@selector(RoomClick:) forControlEvents:UIControlEventTouchUpInside];
		roomName.textColor = [UIColor whiteColor];
		roomName.backgroundColor = [UIColor clearColor];
		roomName.lineBreakMode = UILineBreakModeWordWrap;
		roomName.numberOfLines =5;
		roomName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		for(int j=0;j<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];j++)
		{
			if([[[roomsArr objectAtIndex:i]objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
			{
				roomName.text = [[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"name"];
				break;
			}
		}
		[self alignLabelWithTop:roomName];
		[RoomScrollview addSubview:roomName];
		[roomName release];
		
		UIButton * btnroomName = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnroomName.frame = CGRectMake(x-15, y, 135, 100);
		[btnroomName setTag:i];
		[btnroomName addTarget:self action:@selector(RoomClick:) forControlEvents:UIControlEventTouchUpInside];
		btnroomName.titleLabel.textColor = [UIColor clearColor];
		btnroomName.titleLabel.backgroundColor = [UIColor clearColor];
		btnroomName.titleLabel.textAlignment = UITextAlignmentCenter;
		btnroomName.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		btnroomName.titleLabel.numberOfLines = 5;
		btnroomName.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		btnroomName.titleLabel.text = @"";
		[RoomScrollview addSubview:btnroomName];
		[btnroomName release];
		
        // Hint
		if(isTrue)
			x = x+120+BackgroundWidth+20;
		else
			x = x+120+30;
            //x = x+120+120;
		
		y=10;
		
		newX = x;
		newY = y;
        
       	//scrollview content size
		[RoomScrollview setContentSize:CGSizeMake(x, 200)];
	}	
}

-(NSString*)getDeviceNameAndValue:(NSString*)strName :(NSString*)strValue :(int)deviceType
{
	/*NSString *str=@"";
	str = [str stringByAppendingString:strName];
	str = [str stringByAppendingString:@"\n"];*/
	
	//Hint
	NSString *str=@"";
	
	if ([strName length]>19) 
	{
		strName=[strName substringWithRange:NSMakeRange(0,19)];
		strName=[strName stringByAppendingString:@"..."];
		str=[str stringByAppendingString:strName];
		str = [str stringByAppendingString:@"\n"];
	}
	else 
	{
		str = [str stringByAppendingString:strName];
		str = [str stringByAppendingString:@"\n"];
	}
	
	
	
	switch ( deviceType )
	{	
		case BINARY_SWITCH:
		{
			if([strValue intValue] == 0)
				str = [str stringByAppendingString:@"OFF"];
			else
				str = [str stringByAppendingString:@"ON"];
			break;
		}
        case MULTILEVEL_SWITCH:
		case REMOTE_SWITCH:
		{
			str = [str stringByAppendingString:strValue];
			str = [str stringByAppendingString:@"%"];
			break;
		}
		case SOMFY_ILT:
		{
			str = [str stringByAppendingString:strValue];
			str = [str stringByAppendingString:@"%"];
			break;
		}
		case SOMFY_RTS:
		{
			break;
		}
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
		{
			break;	
		}
		case BULOGICS_CORE:
		case INSTALLER_TOOL_PORTABLE:
		case STATIC_CONTROLLER:
		case SCENE_CONTROLLER:
		case SCENE_CONTROLLER_TWO:
		case SCENE_CONTROLLER_THREE:
		case SCENE_CONTROLLER_PORTABLE:
		case BINARY_SENSOR:
		case BINARY_SENSOR_TWO:
		default:
			break;
	}
	return str;
	
}

-(void)LoadDevicesForRooms
{
	if([_selectedRoomDevicesList count]>0)
		[_selectedRoomDevicesList removeAllObjects];
	
	NSMutableArray *excludeDeviceList = [[NSMutableArray arrayWithArray:[dashboardExcludedDeviceTypeList componentsSeparatedByString:@","]]retain];
    
    /// Hint 23
    NSMutableArray *sceneproductList = [[NSMutableArray arrayWithArray:[sceneproductTypeList componentsSeparatedByString:@","]]retain];
	
	for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];i++)
	{
		int roomid = [[[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i] objectForKey:@"roomKey"] intValue];
		NSMutableArray *arr = [[NSMutableArray alloc]init];
		for(int j=0;j<[[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray count];j++)
		{
			if(roomid==[[[[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray objectAtIndex:j] objectForKey:@"roomID"] intValue])
			{
				// Check excludedevicelist in dashboard selection
				NSUInteger index = [excludeDeviceList indexOfObject:[[[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"deviceType"]];
                //// Hint 23
                NSUInteger productIndex = [sceneproductList indexOfObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"productType"]];
				
				if(index==NSNotFound && productIndex==NSNotFound)
				{
                    [arr addObject:[[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray objectAtIndex:j]];
				}
			}
		}
		[_selectedRoomDevicesList addObject:arr];
		[arr release];
	}
}

#pragma mark -
#pragma mark POPUP

-(void)DeviceSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	NSMutableArray *DevicesArr;
	int DeviceId = btn.tag;
	BOOL isDeviceFound = NO;
	NSMutableDictionary *selectedDeviceDict;
	
	//Get the selected device properties
	for (int i=0; i<[_selectedRoomDevicesList count]; i++)
	{
		DevicesArr = [_selectedRoomDevicesList objectAtIndex:i];
		for (int j=0; j < [DevicesArr count]; j++) 
		{
			if (DeviceId == [[[DevicesArr objectAtIndex:j]objectForKey:@"id"] intValue])
			{
				selectedDeviceDict =  [DevicesArr objectAtIndex:j];
				isDeviceFound = YES;
				break;
			}
		}
		if (isDeviceFound)
			break;
	}
	
	id subView = [[DeviceSkinChooser getSharedInstance]getDeviceSkinBasedOnDeviceType:[[selectedDeviceDict objectForKey:@"deviceType"] intValue]];
	if(subView!=nil)
	{
		popupView =  subView;
		[subView SetMainDelegate:self];
		[subView setDeviceDict:selectedDeviceDict];
		[subView setSelectedRoomDevicesArray:DevicesArr];
		[self.view addSubview:subView];
		popupView.alpha = 0;
		[self performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:.3];
	}
}

-(void)initialDelayEnded
{
    popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    popupView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TRANSITION_DURATION/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TRANSITION_DURATION/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TRANSITION_DURATION/2];
	popupView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark POPUP CALLBACK

-(void)removePopup
{
	[popupView removeFromSuperview];
}

-(void)refreshViewFromPopup
{
	isRoomSelect = YES;
	[self LoadDevicesForRooms];
	[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray];
	[RoomScrollview setContentOffset:LastOffsetPointRooms animated:NO];
	isRoomSelect = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if(scrollView==RoomScrollview)
	{
		if(!isRoomSelect)
		{
			LastOffsetPointRooms =  [scrollView contentOffset];
		}
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
#pragma mark BOTTOM TABS

-(IBAction)LOGOUT:(id)sender
{
	/*[self showLoadingView];
	[[UserService getSharedInstance]Logout:self];*/
	
	// Hint
	UIAlertView *alertLOGOUT = [[UIAlertView alloc]initWithTitle:@"Logout Confirmation" 
														 message:@"Do you really want to logout of TaHomA?" 
														delegate:self 
											   cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alertLOGOUT setTag: 325];
	[alertLOGOUT show];
	[alertLOGOUT release];
}
-(IBAction)LiveViewDashboard:(id)sender
{
}
-(IBAction)SceneConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
}
-(IBAction)ScheduleConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view];
}
-(IBAction)InstallerView:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetInstallerViewIndex]) {
			
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view];
			break;
		}
		case 4:
		{
			[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view];
			break;
		}
		case 5:
		{
			[[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)SceneActivate:(id)sender
{
	UIButton * btn = (UIButton*)sender;
	//Call activate scenes
	[[DashboardService getSharedInstance]ActivateScenes:[[[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"id"] :self];
	// Find the selected scenes and activate its label
    int totalSubViews = [[SceneScrollview subviews] count];
    for (int i=0;i < totalSubViews; i++ ) 
    {
        if ([[[SceneScrollview subviews] objectAtIndex:i] isKindOfClass:[UILabel class]])
        {
            UILabel *actLabel = [[SceneScrollview subviews] objectAtIndex:i];
			if(actLabel.tag == btn.tag)
			{
				actLabel.hidden = NO;
				ActivatedLabel = actLabel;
				break;
			}
		}
    }
}

-(void)RoomClick:(id)sender
{
	isRoomSelect = YES;
	BOOL isExists = NO;
	int ExistIndex;
	UIButton *btn = (UIButton*)sender;
	int TagVal =  btn.tag;
	for(int i=0;i<[_openRoomsArray count];i++)
	{
		if(TagVal==[[_openRoomsArray objectAtIndex:i] intValue])
		{
			isExists = YES;
			ExistIndex = i;
			break;
		}
		
	}
	
	if(isExists)
		[_openRoomsArray removeObjectAtIndex:ExistIndex];
	else
		[_openRoomsArray addObject:[NSString stringWithFormat:@"%d",TagVal]];
	
	[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray];
	
	
	//if size less than 950
	CGSize sx = [RoomScrollview contentSize];
	if(sx.width < 950)
	{
		[RoomScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
		LastOffsetPointRooms =  [RoomScrollview contentOffset];
	}
	else 
	{
		[RoomScrollview setContentOffset:LastOffsetPointRooms animated:NO];
	}

	isRoomSelect = NO;
	
}


#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==ACTIVATE_SCENES)
	{
		ActivatedLabel.hidden = YES;
	}
	else if(strCommand == LOGOUT)
	{
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
		
		isLOGOUT = YES;
		NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
		for (int i=0; i<[array count]; i++) {
			[[array objectAtIndex:i] removeFromSuperview];
		}
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPad sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		/*if ([[[[AppDelegate_iPad sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4)
		{
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			
			[self hideLoadingView];
		}
		else 
		{
			[self hideLoadingView];
		}*/
		[self hideLoadingView];
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	[self hideLoadingView];
	
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
            
  /*          id subView = [[DeviceSkinChooser getSharedInstance]getDeviceSkinBasedOnDeviceType:110];
            if(subView!=nil)
            {
                //popupView =  subView;
                [subView SetMainDelegate:self];
                //		[subView setDeviceDict:selectedDeviceDict];
                //Filter with each devices in the same roomID
                //		[subView setSelectedRoomDevicesArray:[self filterRoomForDevices:selectedDeviceDict]];
                [self.view addSubview:subView];
                //		popupView.alpha = 0;
                //		[self performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:.3];
            }
*/
            
//            [[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].MJPEGViewer_iPadController.view];

			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		}
	}
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
		{
			// Hint
			[self showLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [Logout release];
	[DateTimeDisplayTimer invalidate];
	DateTimeDisplayTimer = nil;
	[_selectedRoomDevicesList,_openRoomsArray release];
	[popupView release];
	[DashboardBtn,SceneConfigBtn,ScheduleConfigBtn,InstallerViewBtn release];
	[SceneScrollview,RoomScrollview release];
	[TimeLbl1,TimeLbl2,DateLbl,ActivatedLabel release];
    [super dealloc];
}


@end
