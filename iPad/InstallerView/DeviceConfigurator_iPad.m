//
//  DeviceConfigurator_iPad.m
//  Somfy
//
//  Created by Sempercon on 4/29/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "RoomSelector_ipad.h"
#import "AppDelegate_iPad.h"
#import "DeviceConfigurator_iPad.h"
#import "SceneConfigurator_iPad.h"
#import "EventConfigurator_iPad.h"
#import "ScheduleConfigurator_iPad.h"
#import "LiveviewDashboard.h"
#import "Scheduleconfigurator_Homeowner.h"
#import "SceneConfigurator_Homeowner.h"
#import "DeviceService.h"
#import "DeviceIconMapper.h"
#import "DeviceSkinChooser.h"
#import "ConfigurationService.h"
#import "SceneControllerSevice.h"
#import "EventsService.h"
#import "DeviceCell.h"
#import "DashboardService.h"
#import "SceneConfiguratorHomeownerService.h"
#import "ManufacturerIdToNameMapper.h"
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "RRSGlowLabel.h"
#import "MJPEGViewer_iPad.h"

@interface DeviceConfigurator_iPad (Private)
-(void) LoadAllDevicesToUI :(NSMutableArray*)DeviceListArr;
- (void)showLoadingView;
-(void)changeStatusDeviceTools;
-(void)OpenDeviceToolsWindow;
- (void)hideLoadingView;
-(void)OpenWindow;
-(void)callzwaveGetStatus;
-(void)CloseWindow;
-(void)CloseDeviceToolsWindow;
-(void)collectGlobalScenes;
@end

extern BOOL  isLOGOUT;

@implementation DeviceConfigurator_iPad

@synthesize Logout;
@synthesize scrollView,sceneControllerScrollView,statusMessageTextView;
@synthesize RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn;
@synthesize popupView,popupSceneControllerView;
@synthesize sceneControllerDeviceName;
@synthesize globalScenesArray,getSceneControlsArray,orphanedEventsArray,rediscoveredArray;
@synthesize pickerPopupView,pickerPopupsubView;
@synthesize pickerOkBtn,pickerCancelBtn;
@synthesize scenesPicker;
@synthesize editAnimationScrollView,editAnimationView;

@synthesize startListeningView,supportView;
@synthesize startListeningBtn;
@synthesize startListeningRestartBtn,startListeningSupportBtn,startListeningCancelBtn;
@synthesize nameLbl,roomLbl,message1Lbl,message2Lbl;
@synthesize ListeningDeviceNameText,ListeningRoomNameText;
@synthesize ListeningSaveBtn,ListeningCancelBtn,ListeningComboBtn;


//DEVICE REMOVAL SCREENS
@synthesize deviceRemovalView,deviceRemovalSupportView;
@synthesize removalRestartBtn,removalSupportBtn,removalDoneBtn,removalCancelBtn,removalCloseBtn;
@synthesize removalMainLbl,removalSubLbl1,removalSubLbl2;
@synthesize deviceGridBtn,deviceTableListBtn;

@synthesize animationScrollView;
@synthesize animationView;
@synthesize runningImageView;
@synthesize advacnedToolsBtn,advancedArrowImgBtn,advancedArrowImg1Btn;

//DEVICE CONFIGURATOR EDIT SCREEN
@synthesize editView;
@synthesize devicesListView;
@synthesize devicesTableSubView;
@synthesize somfyImgView;
@synthesize roomNamePicker;
@synthesize lblSomfyDeviceName;
@synthesize editSaveBtn,editCancelBtn,editComboBtn;
@synthesize editDeviceNameTextField,editRoomNameTextField;

//DEVICE TOOLS
@synthesize rediscoverDeviceBtn,deviceSetupBtn,replaceFailedBtn,removeFailedBtn,zwaveCancelBtn,deviceToolsBtn;
@synthesize statusMessageLbl1,statusMessageLbl2;
@synthesize indicatorImageView;

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
	
	[[AppDelegate_iPad sharedAppDelegate]SetInstallerViewIndex:2];
	[DeviceConfigBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [selectedRoomListArray removeAllObjects];
    
    // Check for room selection
	for(int h=0;h<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];h++)
	{
		NSString *roomKey = [[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:h] objectForKey:@"roomKey"];
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];i++)
		{
			if([roomKey isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]objectForKey:@"id"]])
			{
				[selectedRoomListArray addObject:[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]];
				break;
			}
		}
	}
	
	[self collectGlobalScenes];
    [self LoadAllDevicesToUI:[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    if (isLocal == 1)
        self.Logout.hidden = YES;
        
	zwaveAddID = 0;
	isStartListeningADD = NO;
	isDeviceToolsEnabled = NO;
	isRestartDeviceRemoval = NO;
	isRestartStartListening = NO;
	isAdvancedTools = NO;
	deviceRemovalSupportView.hidden = YES;
	isDeviceToolsOpen = NO;
	supportView.hidden = YES;
	isStartListening = NO;isDeviceMetaDataChanged = NO;
	statusMessageTextView.text = @"";
	isFirstBool = NO;isSecondBool = NO;
	isSomfyILT = NO;isSomfyRTS=NO;
	isOpen = NO;isEditScreen = NO;
	isAnimationProcessing = NO;
	animationScrollView.hidden = YES;
	runningImageView.hidden = YES;
	
	removalRestartBtn.hidden = YES;
	removalSupportBtn.hidden = YES;
	removalCancelBtn.hidden = YES;
	removalDoneBtn.hidden = YES;
	
	maintenanceDict = [[[NSMutableDictionary alloc]init]retain];
	getSceneControlsArray = [[[NSMutableArray alloc]init]retain];
	globalScenesArray = [[[NSMutableArray alloc]init]retain];
	orphanedEventsArray = [[[NSMutableArray alloc]init]retain];
	selectedRoomListArray = [[[NSMutableArray alloc]init]retain];
	rediscoveredArray = [[[NSMutableArray alloc]init]retain];
	filterDeviceRoomsArray = [[[NSMutableArray alloc]init]retain];
	
    
	// Check for room selection
	for(int h=0;h<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];h++)
	{
		NSString *roomKey = [[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:h] objectForKey:@"roomKey"];
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];i++)
		{
			if([roomKey isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]objectForKey:@"id"]])
			{
				[selectedRoomListArray addObject:[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]];
				break;
			}
		}
	}
	
    [super viewDidLoad];
	[self collectGlobalScenes];
	[self LoadAllDevicesToUI:[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray];
}

#pragma mark -
#pragma mark INITIAL LOAD

-(void)collectGlobalScenes
{
	if([globalScenesArray count]>0)
		[globalScenesArray removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count];i++)
	{
		int zwaveSceneID = [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"zwaveSceneID"] intValue];
		if(zwaveSceneID > 0)
		{
			[globalScenesArray addObject:[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]];
		}
	}
}

-(UIImage*)setDeviceImage:(NSMutableDictionary*)deviceDict;
{
	UIImage *_image = nil;
	NSString *somfyDeviceType;
	int deviceType = [[deviceDict objectForKey:@"deviceType"] intValue];
	
	//Define the image
	if ( _image == nil )
	{
		//Check to see if the device type is a somfy rts device
		if ( deviceType == SOMFY_RTS || deviceType == SOMFY_ILT )
		{
			//Since it is an rts motor, we are going to see if the 
			//metadata is defined
			somfyDeviceType = [deviceDict objectForKey:@"metaData"];
			
			//Determine the somfyDeviceType based on the string
			if ( somfyDeviceType == nil || [somfyDeviceType isEqualToString:@""] )
				_image = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceType:deviceType:UNKNOWN];
			else
				_image = [[DeviceIconMapper getSharedInstance]getSomfyDeviceImageBasedOnDeviceType:[somfyDeviceType intValue]];
		}
		//Need to check to see if the device is a generic motor
		else if (deviceType == MOTOR_GENERIC )
		{
			//For now we are going to just store the image that is going 
			//be displayed for a motor generic
			_image = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceType:deviceType:UNKNOWN];
		}
		else if ( deviceType == STATIC_CONTROLLER && [[deviceDict objectForKey:@"manufacturerID"] intValue] == ZW_MAN_BULOGICS )
		{
			_image = [UIImage imageNamed:@"USBStick.png"];
		}
		else if(deviceType == IP_CAMERA_DEVICE_TYPE)
		{
			_image = [UIImage imageNamed:@"cameraIcon1.png"];
		}
	//Need to get the image of device for the mapper class
		else
		{
			//Retrieve the image based on the device type
			_image = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceType:deviceType:UNKNOWN];						
		}
	}
	return _image;
}


- (void) alignLabelWithTop:(UILabel *)label {
	CGSize maxSize = CGSizeMake(label.frame.size.width, 50);
	label.adjustsFontSizeToFitWidth = NO;
	
	// get actual height
	CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
	CGRect rect = label.frame;
	rect.size.height = actualSize.height;
	label.frame = rect;
}


-(void) LoadAllDevicesToUI :(NSMutableArray*)DeviceListArr
{
	NSString *roomName;
	int roomId;
	UIImage *DeviceImage;
	int DeviceCount =0;
	int x=20,y=0;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [scrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	
	for(int i=0;i<[DeviceListArr count];i++)
	{
		roomName = @"";
		UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x, y, 100, 100);
		[customBtn setTag:i];
		DeviceImage = [self setDeviceImage:[DeviceListArr objectAtIndex:i]];
		[customBtn setBackgroundImage:DeviceImage forState:UIControlStateNormal];
		[customBtn addTarget:self action:@selector(DeviceSelect:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:customBtn];
		[customBtn release];
		
		//Find room name based on device.roomID
		for(int k=0;k<[selectedRoomListArray count];k++)
		{
			roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
			if(roomId == [[[DeviceListArr objectAtIndex:i]objectForKey:@"roomID"] intValue])
			{
				roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
				break;
			}
		}
		
        if([selectedRoomListArray count] == 0)
            roomName = @"Select Room";
		
		// Hint
		RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(x-10, y+100, 120, 50)];
        //RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(x-8, y+100, 155, 250)];
		lbl3.textColor = [UIColor whiteColor];
		lbl3.backgroundColor = [UIColor clearColor];
		lbl3.textAlignment = UITextAlignmentCenter;
		lbl3.lineBreakMode = UILineBreakModeWordWrap;
		lbl3.numberOfLines = 0;
		lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		NSString *Devicename = [[[DeviceListArr objectAtIndex:i]objectForKey:@"name"] stringByAppendingString:@"\n"];
		//lbl3.text = [Devicename stringByAppendingString:roomName];
        lbl3.text = Devicename;
		lbl3.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		lbl3.glowOffset = CGSizeMake(0.0, 0.0);
		lbl3.glowAmount = 10.0;
		
		[self alignLabelWithTop:lbl3];
		[scrollView addSubview:lbl3];
		[lbl3 release];
        
        RRSGlowLabel *roomLbl1 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(x-4, y+100+50, 110, 50)];
		roomLbl1.textColor = [UIColor whiteColor];
		roomLbl1.backgroundColor = [UIColor clearColor];
		roomLbl1.textAlignment = UITextAlignmentCenter;
		roomLbl1.lineBreakMode = UILineBreakModeWordWrap;
		roomLbl1.numberOfLines = 0;
		roomLbl1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		roomLbl1.text = roomName;
        roomLbl1.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		roomLbl1.glowOffset = CGSizeMake(0.0, 0.0);
		roomLbl1.glowAmount = 10.0;
		[self alignLabelWithTop:roomLbl1];
		[scrollView addSubview:roomLbl1];
		[roomLbl1 release];
		
		x = x+100+10;
		
        // Hint
		UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn1.frame = CGRectMake(x, y, 40, 40);
		[customBtn1 setTag:i];
		[customBtn1 setBackgroundImage:[UIImage imageNamed:@"edit_over.png"] forState:UIControlStateNormal];
		[customBtn1 addTarget:self action:@selector(DeviceEdit:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:customBtn1];
		[customBtn1 release];
		
		for(int j=0;j<[rediscoveredArray count];j++)
		{
			NSString *zwaveID = [[rediscoveredArray objectAtIndex:j]objectForKey:@"zwaveID"];
			if([zwaveID isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:i]objectForKey:@"zwaveID"]])
			{
				UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x, y+60, 40, 40);
				[customBtn1 setTag:i];
				
				NSString *status = [[rediscoveredArray objectAtIndex:j]objectForKey:@"Status"];
				if([status isEqualToString:@"NetworkStatusNotFound"])
					[customBtn1 setBackgroundImage:[UIImage imageNamed:@"device_not_found_icon.png"] forState:UIControlStateNormal];
				else
					[customBtn1 setBackgroundImage:[UIImage imageNamed:@"device_found_icon.png"] forState:UIControlStateNormal];
				
				[customBtn1 addTarget:self action:@selector(StatusIcon:) forControlEvents:UIControlEventTouchUpInside];
				[scrollView addSubview:customBtn1];
				[customBtn1 release];
				
				
				break;
			}
		}
		
		x = x+40+10;
		DeviceCount++;
		if(DeviceCount == 5 || i == [DeviceListArr count]-1)
		{
			DeviceCount = 0;
			x=20;
			y=y+210;
			[scrollView setContentSize:CGSizeMake(900, y)];
		}
	}
}

-(void)StatusIcon:(id)sender
{
	
}


-(void)loadSceneController:(int)nCount
{
	int GlobalSceneIndex;
	int y=20;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [sceneControllerScrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	for(int i=0;i<nCount;i++)
	{
		GlobalSceneIndex = -1;
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, y, 90, 30)];
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.numberOfLines = 0;
		label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
		label.text = [@"Button" stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]];
		[sceneControllerScrollView addSubview:label];
		[label release];
		
		UITextField *sceneTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, y, 160, 30)];
		sceneTextField.borderStyle = UITextBorderStyleNone;
		sceneTextField.userInteractionEnabled = NO;
		sceneTextField.backgroundColor = [UIColor whiteColor];
		
		//Check it it is zero
		if([getSceneControlsArray count]>i+1)
		{
			int ID = [[[getSceneControlsArray objectAtIndex:i+1]objectForKey:@"text"] intValue];
			if(ID==0)
				sceneTextField.text = @"";
			for (int j=0;j<[globalScenesArray count];j++) {
				int sceneId = [[[globalScenesArray objectAtIndex:j]objectForKey:@"id"]intValue];
				if(sceneId == ID)
				{
					GlobalSceneIndex = j;
					sceneTextField.text = [[globalScenesArray objectAtIndex:j]objectForKey:@"name"];
					break;
				}
			}
			
		}
		else
			sceneTextField.text = @"";
		
		[sceneControllerScrollView addSubview:sceneTextField];
		[sceneTextField release];
		
		UIButton *comboBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		comboBtn.frame = CGRectMake(278, y-1, 26, 33);
		[comboBtn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
		[comboBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
		[comboBtn setTag:GlobalSceneIndex];
		[comboBtn setBackgroundImage:[UIImage imageNamed:@"Combo_Box.png"] forState:UIControlStateNormal];
		[comboBtn addTarget:self action:@selector(ComboSelect:) forControlEvents:UIControlEventTouchUpInside];
		[sceneControllerScrollView addSubview:comboBtn];
		[comboBtn release];
		
		UIButton * addButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		addButton.frame = CGRectMake(320, y, 40, 30);
		[addButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
		[addButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
		[addButton setTag:GlobalSceneIndex];
		[addButton setBackgroundImage:[UIImage imageNamed:@"scene_device_toggle_plus.png"] forState:UIControlStateNormal];
		[addButton addTarget:self action:@selector(AddSelect:) forControlEvents:UIControlEventTouchUpInside];
		[sceneControllerScrollView addSubview:addButton];
		[addButton release];
		
		UIButton * removeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		removeButton.frame = CGRectMake(370, y, 40, 30);
		[removeButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
		[removeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
		[removeButton setTag:GlobalSceneIndex];
		[removeButton setBackgroundImage:[UIImage imageNamed:@"scene_device_toggle_minus.png"] forState:UIControlStateNormal];
		[removeButton addTarget:self action:@selector(RemoveSelect:) forControlEvents:UIControlEventTouchUpInside];
		[sceneControllerScrollView addSubview:removeButton];
		[removeButton release];
		
		y = y + 60;
		[sceneControllerScrollView setContentSize:CGSizeMake(440, y)];
	}
}


-(void)ComboSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	int index = btn.tag;
	buttonIndex = [[btn currentTitle] intValue];
	if(index!=-1)
	{
		[scenesPicker selectRow:index inComponent:0 animated:NO];
	}
	
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	scenesPicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:scenesPicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
	[scenesPicker reloadAllComponents];
}

-(void)RemoveSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	int index = btn.tag;
	buttonIndex = [[btn currentTitle] intValue]+ 1;
	if(index!=-1)
	{
		[self showLoadingView];
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",buttonIndex] forKey:@"button"];
		[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex]objectForKey:@"zwaveID"] forKey:@"zwaveID"];
		[commandDictionary setObject:@"0" forKey:@"scene"];
		[[SceneControllerSevice getSharedInstance]setButton:commandDictionary :self];
		[commandDictionary release];
	}
}

-(void)AddSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	buttonIndex = [[btn currentTitle] intValue] + 1;
	
	[self showLoadingView];
	sceneControllerTimer = [NSTimer scheduledTimerWithTimeInterval:0 
															target:self 
														  selector:@selector(SceneControllerAddTask) 
														  userInfo:nil 
														   repeats:YES];
	sceneControllerEnum = NONE;
}

-(void)SceneControllerAddTask
{
	switch(sceneControllerEnum)
	{
		case NONE:
		{
			sceneControllerEnum = ENUM_SCENE_ADD;
			break;
		}
		case ENUM_SCENE_ADD:
		{
			NSString *sceneName = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex] objectForKey:@"name"];
			sceneName = [sceneName stringByAppendingString:@"-Button "];
			sceneName = [sceneName stringByAppendingString:[NSString stringWithFormat:@"%d",buttonIndex]];
			
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:sceneName forKey:@"name"];
			[dataDict setObject:@"1" forKey:@"sceneType"];
			[[SceneConfiguratorHomeownerService getSharedInstance] addScene:dataDict :self];
			[dataDict release];
			sceneControllerEnum = PROCESSING;
			break;
		}
		case ENUM_SCENE_ADD_DONE:
		{
			sceneControllerEnum = GETSCENES;
			break;
		}
		case GETSCENES:
		{
			[[DashboardService getSharedInstance]getScenes:self];
			sceneControllerEnum = PROCESSING;
			break;
		}
		case GETSCENES_DONE:
		{
			sceneControllerEnum = SETBUTTON;
			break;
		}
		case SETBUTTON:
		{
			NSString *newlyCreatedSceneId = @"";
			
			NSString *sceneName = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex] objectForKey:@"name"];
			sceneName = [sceneName stringByAppendingString:@"-Button "];
			sceneName = [sceneName stringByAppendingString:[NSString stringWithFormat:@"%d",buttonIndex]];
			
			for (int i=0; i<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count]; i++) {
				NSString *sName = [[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"name"];
				if([sName isEqualToString:sceneName])
				{
					newlyCreatedSceneId = [[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"id"];
					break;
				}
			}
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",buttonIndex] forKey:@"button"];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex]objectForKey:@"zwaveID"] forKey:@"zwaveID"];
			[commandDictionary setObject:newlyCreatedSceneId forKey:@"scene"];
			[[SceneControllerSevice getSharedInstance]setButton:commandDictionary :self];
			[commandDictionary release];
			sceneControllerEnum = PROCESSING;
			break;
		}
		case SETBUTTON_DONE:
		{
			sceneControllerEnum = GETCONTROLLER;
			break;
		}
		case GETCONTROLLER:
		{
			[[SceneControllerSevice getSharedInstance]getController:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex]objectForKey:@"zwaveID"] :self];
			sceneControllerEnum = PROCESSING;
			break;
		}
		case GETCONTROLLER_DONE:
		{
			sceneControllerEnum = DONE;
			break;
		}
		case DONE:
		{
			[sceneControllerTimer invalidate];
			sceneControllerTimer=nil;
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}




#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(NSMutableArray*)filterRoomForDevices:(NSMutableDictionary*)dict
{
	if([filterDeviceRoomsArray count]>0)
		[filterDeviceRoomsArray removeAllObjects];
	
	//Filter with all devices having same room ID
	for(int k=0;k<[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray count];k++)
	{
		int roomId = [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:k] objectForKey:@"roomID"] intValue];
		if(roomId == [[dict objectForKey:@"roomID"] intValue])
		{
			[filterDeviceRoomsArray addObject:[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:k]];
		}
	}
	
	return filterDeviceRoomsArray;
}


-(void)DeviceSelect:(id)sender
{
	int deviceType;
	UIButton *btn = (UIButton*)sender;
	deviceIndex = btn.tag;
	
	NSMutableDictionary *selectedDeviceDict;
	
	//Get the selected device properties
	selectedDeviceDict = [[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:btn.tag];
	deviceType = [[selectedDeviceDict objectForKey:@"deviceType"] intValue];
	
	if(deviceType == SCENE_CONTROLLER || deviceType == SCENE_CONTROLLER_PORTABLE ||deviceType == SCENE_CONTROLLER_TWO ||deviceType == SCENE_CONTROLLER_THREE )
	{
		[self.view addSubview:popupSceneControllerView];
		[self showLoadingView];
		[[SceneControllerSevice getSharedInstance]getController:[selectedDeviceDict objectForKey:@"zwaveID"] :self];
	}
	else
	{
		id subView = [[DeviceSkinChooser getSharedInstance]getDeviceSkinBasedOnDeviceType:deviceType];
		if(subView!=nil)
		{
			popupView =  subView;
			[subView SetMainDelegate:self];
			[subView setDeviceDict:selectedDeviceDict];
			//Filter with each devices in the same roomID
			[subView setSelectedRoomDevicesArray:[self filterRoomForDevices:selectedDeviceDict]];
			[self.view addSubview:subView];
			popupView.alpha = 0;
			[self performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:.3];
		}
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

-(IBAction)deviceListViewSelected:(id)sender
{
	/*devicesListView.hidden = NO;
	scrollView.hidden = YES;
	devicesListView.frame = CGRectMake(60, 160, 900, 450);
	[self.view addSubview:devicesListView];*/
    
	[deviceGridBtn setBackgroundImage:[UIImage imageNamed:@"tileview_normal_up.png"] forState:UIControlStateNormal];
	[deviceTableListBtn setBackgroundImage:[UIImage imageNamed:@"tableview_selected_up.png"] forState:UIControlStateNormal];
	devicesListView.separatorColor = [UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:0.3];
	devicesTableSubView.hidden = NO;
	scrollView.hidden = YES;
	devicesTableSubView.frame = CGRectMake(40, 160, 940, 450);
	[self.view addSubview:devicesTableSubView];
    [self.devicesListView reloadData];
}

-(IBAction)deviceGridViewSelected:(id)sender
{
	devicesTableSubView.hidden = YES;
	scrollView.hidden = NO;
	[devicesTableSubView removeFromSuperview];
	[deviceGridBtn setBackgroundImage:[UIImage imageNamed:@"tileview_selected_up.png"] forState:UIControlStateNormal];
	[deviceTableListBtn setBackgroundImage:[UIImage imageNamed:@"tableview_normal_up.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark DEVICE CONFIGURATION REFRESH

-(IBAction)deviceConfiguratorRefresh:(id)sender
{
	[self showLoadingView];
	removalDoneTimer = [NSTimer scheduledTimerWithTimeInterval:0 
														target:self 
													  selector:@selector(deviceRemovalDoneTask) 
													  userInfo:nil 
													   repeats:YES];
	removalDoneEnum = NONE;
}

#pragma mark -
#pragma mark TABLEVIEW DELEGATES

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[AppDelegate_iPad sharedAppDelegate].g_DevicesArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *roomName=@"";
	int roomId;
	
	static NSString *identifier = @"DeviceCell";
	DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) 
	{
		cell = [[[DeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}	// Configure the cell.
	
	roomName=@"";
	//Find room name based on device.roomID
	for(int k=0;k<[selectedRoomListArray count];k++)
	{
		roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
		if(roomId == [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"roomID"] intValue])
		{
			roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
			break;
		}
	}
	
	cell.lblDeviceName.text = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"name"];
	cell.lblRoomName.text = roomName;
	int deviceType = [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"deviceType"] intValue];
	cell.lblDeviceType.text = [[ManufacturerIdToNameMapper getSharedInstance]mapDeviceIdToName:deviceType];
	cell.lblProductID.text = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"productID"];
	int manuFacturerId = [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"manufacturerID"] intValue];
	cell.lblManufacturer.text = [[ManufacturerIdToNameMapper getSharedInstance]mapManufacturerIdToName:manuFacturerId];
	cell.lblZwaveID.text = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"zwaveID"];
	cell.lblZwaveProtocol.text = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:indexPath.row]objectForKey:@"zwProtocolVersion"];
	
	
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;		
}

#pragma mark -
#pragma mark DEVICE EDIT

-(void)DeviceEdit:(id)sender
{
	NSString *roomName=@"";
	int roomId;
	UIButton *btn = (UIButton*)sender;
	editDeviceIndex = btn.tag;
	
	isStartListening = NO;
	
	//Set default values for all device tools
	isDeviceMetaDataChanged = NO;
	rediscoverDeviceBtn.enabled = YES;
	deviceSetupBtn.enabled = YES;
	replaceFailedBtn.enabled = YES;
	removeFailedBtn.enabled = YES;
	zwaveCancelBtn.enabled = YES;
	deviceToolsBtn.enabled = YES;
	statusMessageLbl1.text = @"";
	statusMessageLbl2.text = @"";
	indicatorImageView.image = [UIImage imageNamed:@""];
	
	for(int j=0;j<[rediscoveredArray count];j++)
	{
		NSString *zwaveID = [[rediscoveredArray objectAtIndex:j]objectForKey:@"zwaveID"];
		if([zwaveID isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"]])
		{
			NSString *status = [[rediscoveredArray objectAtIndex:j]objectForKey:@"Status"];
			if([status isEqualToString:@"NetworkStatusNotFound"])
			{
				rediscoverDeviceBtn.enabled = YES;
				deviceSetupBtn.enabled = YES;
				replaceFailedBtn.enabled = YES;
				removeFailedBtn.enabled = YES;
				zwaveCancelBtn.enabled = YES;
				deviceToolsBtn.enabled = YES;
				statusMessageLbl1.text = @"";
				statusMessageLbl2.text = @"";
				indicatorImageView.image = [UIImage imageNamed:@"rediscovery_network_status_not_found.png"];
			}
			else
			{
				rediscoverDeviceBtn.enabled = YES;
				deviceSetupBtn.enabled = YES;
				replaceFailedBtn.enabled = NO;
				removeFailedBtn.enabled = NO;
				zwaveCancelBtn.enabled = YES;
				deviceToolsBtn.enabled = YES;
				statusMessageLbl1.text = @"";
				statusMessageLbl2.text = @"";
				indicatorImageView.image = [UIImage imageNamed:@"rediscovery_network_status_found.png"];
			}
			break;
		}
	}
	
	
	
	somfyRTSView.hidden = YES;
	somfyILTView.hidden = YES;
	isEditScreen = YES;
	//Find room name based on device.roomID
	for(int k=0;k<[selectedRoomListArray count];k++)
	{
		roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
		if(roomId == [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"roomID"] intValue])
		{
			roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
			break;
		}
	}
	
	if([selectedRoomListArray count]>0)
    {
        if([roomName isEqualToString:@""])
            roomName = [[selectedRoomListArray objectAtIndex:0] objectForKey:@"name"];
    }
	
	editRoomNameTextField.text = roomName;
	editDeviceNameTextField.text = [[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"name"];
	
	int deviceType = [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"deviceType"] intValue];
	
	if ( deviceType == SOMFY_RTS || deviceType == MOTOR_GENERIC ) 
	{
		somfyImgView.hidden = NO;
		lblSomfyDeviceName.hidden = NO;
		[somfyImgView setBackgroundImage:[self setDeviceImage:[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = [[DeviceIconMapper getSharedInstance]determineDeviceLabel:[[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"metaData"] intValue]];
	}
	else if ( deviceType == SOMFY_ILT )
	{
		somfyImgView.hidden = NO;
		lblSomfyDeviceName.hidden = NO;
		[somfyImgView setBackgroundImage:[self setDeviceImage:[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = [[DeviceIconMapper getSharedInstance]determineDeviceLabel:[[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"metaData"] intValue]];
	}
	else
	{
		somfyImgView.hidden = YES;
		
		lblSomfyDeviceName.hidden = YES;
	}
	
	//Add editview 
	[maintenanceDict setObject:editRoomNameTextField.text forKey:@"previousRoomName"];
	[maintenanceDict setObject:editDeviceNameTextField.text forKey:@"previousDeviceName"];
	editSaveBtn.enabled = NO;
	[self.view addSubview:editView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	editSaveBtn.enabled = YES;
}

-(IBAction)editCancelBtnClicked:(id)sender
{
	isDeviceToolsOpen = NO;
	[self CloseDeviceToolsWindow];
	[editView removeFromSuperview];
	isEditScreen = NO;
}

-(IBAction)editSaveBtnClicked:(id)sender
{
	NSString *roomName =@"";
	int roomId ;
	_nameChanged=NO;
	_roomChanged=NO;
	
	if(![editDeviceNameTextField.text isEqualToString:[maintenanceDict objectForKey:@"previousDeviceName"]])
	{
		if(![editDeviceNameTextField.text isEqualToString:@""])
			_nameChanged = YES;
	}

	if(![editRoomNameTextField.text isEqualToString:[maintenanceDict objectForKey:@"previousRoomName"]])
	{
		if(![editRoomNameTextField.text isEqualToString:@""])
			_roomChanged = YES;
	}
	
	if(!_nameChanged && !_roomChanged&&!isDeviceMetaDataChanged)
	{
		isDeviceToolsOpen = NO;
		[self CloseDeviceToolsWindow];
		[editView removeFromSuperview];
		isEditScreen = NO;
		return;
	}
	[self showLoadingView];
	
	//TASK A
	if(_nameChanged)
	{
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"id"];	
		[commandDictionary setObject:editDeviceNameTextField.text forKey:@"name"];
		[[DeviceService getSharedInstance]changeName:commandDictionary :self];
		[commandDictionary release];
	}
	//TASK B
	else if(_roomChanged)
	{
		//Find room name based on device.roomID
		for(int k=0;k<[selectedRoomListArray count];k++)
		{
			roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
			if([roomName isEqualToString:editRoomNameTextField.text])
			{
				roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
				break;
			}
		}
		
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"device"];	
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",roomId] forKey:@"toRoom"];
		[[DeviceService getSharedInstance]changeRoom:commandDictionary :self];
		[commandDictionary release];
	}
	//TASK C
	else if(isDeviceMetaDataChanged)
	{
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"relatedID"];	
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",metaDataValue] forKey:@"metaData"];
		[commandDictionary setObject:@"0" forKey:@"metaDataType"];
		[[ConfigurationService getSharedInstance]setMetaData:commandDictionary :self];
		[commandDictionary release];
	}
}

-(IBAction)editComboBtnClicked:(id)sender
{
	NSString *roomName=@"";
	int roomId;
	editSaveBtn.enabled = YES;
	//Find room name based on device.roomID
	for(int k=0;k<[selectedRoomListArray count];k++)
	{
		roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
		if(roomId == [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"roomID"] intValue])
		{
			roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
			[roomNamePicker selectRow:k inComponent:0 animated:NO];
			break;
		}
	}
	
	if([roomName isEqualToString:@""])
		[roomNamePicker selectRow:0 inComponent:0 animated:NO];
    
    if([selectedRoomListArray count] == 0)
        pickerOkBtn.enabled = NO;
    else
        pickerOkBtn.enabled = YES;
    
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	roomNamePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:roomNamePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
	[roomNamePicker reloadAllComponents];
}

-(void)OpenDeviceToolsWindow
{
	yPosition = -180;
	editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	openTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 
												 target:self 
											   selector:@selector(OpenDeviceToolsWindowTask) 
											   userInfo:nil 
												repeats:YES];
}

-(void)OpenDeviceToolsWindowTask
{
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationBeginsFromCurrentState:YES];
	editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=0)
	{
		yPosition = 0;
		[openTimer invalidate];
		openTimer = nil;
		editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	}
}

-(void)CloseDeviceToolsWindowTask
{
	yPosition-=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationBeginsFromCurrentState:YES];
	editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=-180)
	{
		yPosition = -180;
		[closeTimer invalidate];
		closeTimer = nil;
		editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	}
}

-(void)CloseDeviceToolsWindow
{
	yPosition = 0;
	editAnimationView.frame = CGRectMake(0, yPosition, 393, 200);
	closeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01  
												  target:self 
												selector:@selector(CloseDeviceToolsWindowTask) 
												userInfo:nil 
												 repeats:YES];
}

#pragma mark -
#pragma mark DEVICE TOOLS BLOCKS
-(void)zWaveGetStatusFunction
{
	[[ConfigurationService getSharedInstance]zWaveGetStatus:self];
}

-(void)rediscoverDeviceBtnClicked:(id)sender
{
	statusMessageLbl1.text = @"Running Rediscover Network for device";
	statusMessageLbl2.text = [@"Running Network Rediscovery for Device : " stringByAppendingString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"]];
	isrediscoverEnabled = YES;
	[self zWaveGetStatusFunction];
	
	isDeviceToolsEnabled = YES;
	isStartListening = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = NO;
	isFirstBool = NO;isSecondBool = NO;
	
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"] forKey:@"id"];	
	[commandDictionary setObject:@"false" forKey:@"getList"];
	[[ConfigurationService getSharedInstance]zWaveRediscoverNodesDeviceTools:commandDictionary :self];
	[commandDictionary release];
	
}

-(void)deviceSetupBtnClicked:(id)sender
{
	isrediscoverEnabled = NO;
	isDeviceToolsEnabled = YES;
	isFirstBool = NO;isSecondBool = NO;
	statusMessageLbl2.text = @"Running Device Setup Wizard";
	
	[[ConfigurationService getSharedInstance]runDeviceSetupWizard:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"] :self];
}
-(void)replaceFailedBtnClicked:(id)sender
{
	isrediscoverEnabled = NO;
	isDeviceToolsEnabled = YES;
	isStartListening = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = NO;
	isFirstBool = NO;isSecondBool = NO;
	statusMessageLbl2.text = @"Runs command to replace the failed device.";
	[self zWaveGetStatusFunction];
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"id"];	
	[commandDictionary setObject:@"false" forKey:@"getList"];
	[[ConfigurationService getSharedInstance]zWaveReplaceFailedNode:commandDictionary :self];
	[commandDictionary release];
}
-(void)removeFailedBtnClicked:(id)sender
{
	isrediscoverEnabled = NO;
	isDeviceToolsEnabled = YES;
	isStartListening = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = NO;
	isFirstBool = NO;isSecondBool = NO;
	statusMessageLbl2.text = @"Running Remove Network for Device";
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"id"];	
	[commandDictionary setObject:@"false" forKey:@"getList"];
	[[ConfigurationService getSharedInstance]zWaveRemoveFailedNode:commandDictionary :self];
	[commandDictionary release];
}
-(void)zwaveCancelBtnClicked:(id)sender
{
	isrediscoverEnabled = NO;
	isDeviceToolsEnabled = YES;
	isStartListening = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = NO;
	isFirstBool = NO;isSecondBool = NO;
	statusMessageLbl1.text = @"Running zwaveCancel for Device";
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
}

-(void)changeStatusDeviceTools
{
	if(isDeviceToolsOpen)
	{
		isDeviceToolsOpen = NO;
		[self CloseDeviceToolsWindow];
	}
	else
	{
		isDeviceToolsOpen = YES;
		[self OpenDeviceToolsWindow];
	}
}

-(void)deviceToolsBtnClicked:(id)sender
{
	[self changeStatusDeviceTools];
}

-(IBAction)somfyDeviceTypeSelected:(id)sender
{
	editSaveBtn.enabled = YES;
	int deviceType = [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"deviceType"] intValue];
	
	if ( deviceType == SOMFY_RTS || deviceType == MOTOR_GENERIC ) 
	{
		if(isSomfyRTS)
		{
			isSomfyRTS = NO;
			somfyRTSView.hidden = YES;
		}
		else
		{
			isSomfyRTS = YES;
			somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
			somfyRTSView.hidden = NO;
		}
	}
	else if ( deviceType == SOMFY_ILT )
	{
		if(isSomfyILT)
		{
			isSomfyILT = NO;
			somfyILTView.hidden = YES;
		}
		else
		{
			isSomfyILT = YES;
			somfyILTView.frame = CGRectMake(390, 380, 298, 112);
			somfyILTView.hidden = NO;
		}
	}
}


#pragma mark -
#pragma mark SOMFY RTS HANDLE EVENT

-(IBAction)AwingClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_AWNING;
	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Awning_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Awing";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)BlindClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_BLIND;
	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Blind_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Blind";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)CellularShadeClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_CELLULAR_SHADE;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Cellular Shade";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)DraperyClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_DRAPERY;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"DraPery_Animation6.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Drapery";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)RollarShadeClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_ROLLER_SHADE;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Rollar_Shade_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Roller Shade";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)RollarShutterClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_ROLLER_SHUTTER;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Rollar_Shutter_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Roller Shutter";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)RomanShadeClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_ROMAN_SHADE;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Roman_Shade_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Roman Shade";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)ScreenClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_SCREEN_SHADE;
	
	
	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Screen_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Screen";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}
-(IBAction)SolarScreenClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = RTS_SOLAR_SCREEN;

	if(isSomfyRTS)
	{
		isSomfyRTS = NO;
		somfyRTSView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Solar_Screen_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Solar Screen";
	}
	else
	{
		isSomfyRTS = YES;
		somfyRTSView.frame = CGRectMake(390, 380, 626, 112);
		somfyRTSView.hidden = NO;
	}
}

#pragma mark -
#pragma mark SOMFY ILT HANDLE EVENT

-(IBAction)ILTRollarShaderClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = ILT_ROLLER_SHADE;

	if(isSomfyILT)
	{
		isSomfyILT = NO;
		somfyILTView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Rollar_Shade_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Roller Shade";
	}
	else
	{
		isSomfyILT = YES;
		somfyILTView.frame = CGRectMake(390, 380, 298, 112);
		somfyILTView.hidden = NO;
	}
}
-(IBAction)ILTRomanShadeClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = ILT_ROMAN_SHADE;

	if(isSomfyILT)
	{
		isSomfyILT = NO;
		somfyILTView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Roman_Shade_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Roman Shade";
	}
	else
	{
		isSomfyILT = YES;
		somfyILTView.frame = CGRectMake(390, 380, 298, 112);
		somfyILTView.hidden = NO;
	}
}
-(IBAction)ILTScreenClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = ILT_SCREEN;

	if(isSomfyILT)
	{
		isSomfyILT = NO;
		somfyILTView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Screen_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Screen";
	}
	else
	{
		isSomfyILT = YES;
		somfyILTView.frame = CGRectMake(390, 380, 298, 112);
		somfyILTView.hidden = NO;
	}
}
-(IBAction)ILTSolarScreenClicked:(id)sender
{
	isDeviceMetaDataChanged = YES;
	metaDataValue = ILT_SOLAR_SCREEN;

	if(isSomfyILT)
	{
		isSomfyILT = NO;
		somfyILTView.hidden = YES;
		[somfyImgView setBackgroundImage:[UIImage imageNamed:@"Solar_Screen_Animation1.png"] forState:UIControlStateNormal];
		lblSomfyDeviceName.text = @"Solar Screen";
	}
	else
	{
		isSomfyILT = YES;
		somfyILTView.frame = CGRectMake(390, 380, 298, 112);
		somfyILTView.hidden = NO;
	}
}

#pragma mark -
#pragma mark DEVICE REMOVAL

-(IBAction)deviceRemovalClicked:(id)sender
{
	isStatus = YES;
	
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = YES;
	
	removalCancelBtn.hidden = NO;
	removalDoneBtn.hidden = YES;
	removalRestartBtn.hidden = YES;
	removalSupportBtn.hidden = YES;
	
	removalMainLbl.text = @"INITIATE REMOVE";
	removalSubLbl1.text = @"PRESS THE ZWAVE INCLUSION BUTTON";
	removalSubLbl2.text = @"";
	//removalSubLbl2.text = @"Listening for a device to remove from the network";
	
	
	[[ConfigurationService getSharedInstance]zWaveRemove:self];
	[self callzwaveGetStatus];
	[self.view addSubview:deviceRemovalView];
}
-(IBAction)removalRestartBtnClicked:(id)sender
{
	isStatus = YES;
	
	removalCancelBtn.hidden = NO;
	removalDoneBtn.hidden = YES;
	removalRestartBtn.hidden = YES;
	removalSupportBtn.hidden = YES;
	
	removalMainLbl.text = @"INITIATE REMOVE";
	removalSubLbl1.text = @"PRESS THE ZWAVE INCLUSION BUTTON";
	removalSubLbl2.text = @"Listening for a device to remove from the network";
	
	isDeviceRemoval = YES;
	isRestartDeviceRemoval = YES;
	
	//Cancel zwave command 
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
	
	
	//[[ConfigurationService getSharedInstance]zWaveRemove:self];
	//[self callzwaveGetStatus];
}
-(IBAction)removalSupportBtnClicked:(id)sender
{
	deviceRemovalSupportView.hidden = NO;
}

-(IBAction)removalCancelBtnClicked:(id)sender
{
	isStatus = NO;
	isRestartDeviceRemoval = NO;
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
	[deviceRemovalView removeFromSuperview];
}
-(IBAction)removalCloseBtnClicked:(id)sender
{
	deviceRemovalSupportView.hidden = YES;
}

-(IBAction)removalDoneBtnClicked:(id)sender
{
	[self showLoadingView];
	removalDoneTimer = [NSTimer scheduledTimerWithTimeInterval:0 
														target:self 
													  selector:@selector(deviceRemovalDoneTask) 
													  userInfo:nil 
													   repeats:YES];
	removalDoneEnum = NONE;
}

-(void)deviceRemovalDoneTask
{
	switch(removalDoneEnum)
	{
		case NONE:
		{
			removalDoneEnum = GETDEVICES;
			break;
		}
		case GETDEVICES:
		{
			[[DeviceService getSharedInstance] getAll:self];
			removalDoneEnum = PROCESSING;
			break;
		}
		case GETDEVICES_DONE:
		{
			removalDoneEnum = GET_TRIGGER_DEVICE_LIST;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST:
		{
			[[EventsService getSharedInstance]getTriggerDevicesList:self];
			removalDoneEnum = PROCESSING;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST_DONE:
		{
			removalDoneEnum = DONE;
			break;
		}
			
		case DONE:
		{
			[removalDoneTimer invalidate];
			removalDoneTimer = nil;
			[self hideLoadingView];
			[deviceRemovalView removeFromSuperview];
			[self collectGlobalScenes];
			[self LoadAllDevicesToUI:[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray];
		}
	}
}


#pragma mark -
#pragma mark POPUP CALLBACK

-(void)removePopup
{
	[popupView removeFromSuperview];
}

-(void)refreshViewFromPopup
{
	
}

#pragma mark -
#pragma mark START LISTENING BLOCKS

//Call Zwave get status for every 250 ms 
-(void)callzwaveGetStatus
{
	//_poll = YES;
	//isStatus = YES;
	
	[self performSelector:@selector(zWaveGetStatusFunction) withObject:nil afterDelay:0.2];
}

-(IBAction)startListeningBtnClicked:(id)sender
{
	isDeviceToolsEnabled = NO;
	isAdvancedTools = NO;
	isDeviceRemoval = NO;
	isStartListening = YES;
	
	_poll = YES;
	
	startListeningRestartBtn.hidden = YES;
	startListeningSupportBtn.hidden = YES;
	startListeningCancelBtn.hidden = NO;
	
	nameLbl.hidden = YES;roomLbl.hidden = YES;
	ListeningDeviceNameText.hidden = YES;ListeningRoomNameText.hidden = YES;
	ListeningSaveBtn.hidden = YES;ListeningCancelBtn.hidden = YES;ListeningComboBtn.hidden = YES;
	
	message1Lbl.text = @"LISTENING FOR DEVICES";
	message2Lbl.text = @"";
	//message2Lbl.text = @"Listening for a device to add to the network";
	
	UIButton *button = (UIButton*)sender;
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"start_listening_up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"stop_listening_up.png"] forState:UIControlStateNormal];
		[self.view addSubview:startListeningView];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"start_listening_up.png"] forState:UIControlStateNormal];
		[startListeningView removeFromSuperview];
	}
	
	
	
	NSString *randomNumber = [NSString stringWithFormat:@"%ld",arc4random()];
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:randomNumber forKey:@"name"];	
	[commandDictionary setObject:@"0" forKey:@"id"];
	[[ConfigurationService getSharedInstance]zWaveAdd:commandDictionary :self];
	[commandDictionary release];
	
	[self callzwaveGetStatus];
}

-(IBAction)startListeningCancel:(id)sender
{
	//isStartListening = NO;
	//[startListeningView removeFromSuperview];
	//[startListeningBtn setBackgroundImage:[UIImage imageNamed:@"start_listening_up.png"] forState:UIControlStateNormal];
	
	_poll = NO;
	isRestartStartListening = NO;
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
}

-(IBAction)startListeningRestart:(id)sender
{
	isRestartStartListening = YES;
	_poll = YES;
	isStartListening = YES;
	startListeningRestartBtn.hidden = YES;
	startListeningSupportBtn.hidden = YES;
	startListeningCancelBtn.hidden = NO;
	
	nameLbl.hidden = YES;roomLbl.hidden = YES;
	ListeningDeviceNameText.hidden = YES;ListeningRoomNameText.hidden = YES;
	ListeningSaveBtn.hidden = YES;ListeningCancelBtn.hidden = YES;ListeningComboBtn.hidden = YES;
	
	message1Lbl.text = @"LISTENING FOR DEVICES";
	message2Lbl.text = @"Listening for a device to add to the network";
	
	//When click restart command we need to send zwavecancel command first.
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
	
	/*[self performSelector:@selector(callzwaveGetStatus) withObject:nil afterDelay:1];
	
	NSString *randomNumber = [NSString stringWithFormat:@"%ld",arc4random()];
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:randomNumber forKey:@"name"];	
	[commandDictionary setObject:@"0" forKey:@"id"];
	[[ConfigurationService getSharedInstance]zWaveAdd:commandDictionary :self];
	[commandDictionary release];*/
}

-(IBAction)startListeningSupport:(id)sender
{
	//[self.view addSubview:supportView];
	supportView.hidden = NO;
}

-(IBAction)supportClose:(id)sender
{
	//[supportView removeFromSuperview];
	supportView.hidden = YES;
}

-(IBAction)ListeningSaveBtnClicked:(id)sender
{
	NSString *roomName =@"";
	int roomId ;
	_nameChanged=NO;
	_roomChanged=NO;
	isDeviceMetaDataChanged = NO;
	
	if(![ListeningDeviceNameText.text isEqualToString:[maintenanceDict objectForKey:@"previousDeviceName"]])
	{
		if(![ListeningDeviceNameText.text isEqualToString:@""])
			_nameChanged = YES;
	}
	
	if(![ListeningRoomNameText.text isEqualToString:[maintenanceDict objectForKey:@"previousRoomName"]])
	{
		if(![ListeningRoomNameText.text isEqualToString:@""])
			_roomChanged = YES;
	}
	
	if(!_nameChanged && !_roomChanged)
		return;
	
	//isStartListeningADD = NO;
	[self showLoadingView];
	
	//TASK A
	if(_nameChanged)
	{
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",zwaveAddID] forKey:@"id"];	
		[commandDictionary setObject:ListeningDeviceNameText.text forKey:@"name"];
		[[DeviceService getSharedInstance]changeName:commandDictionary :self];
		[commandDictionary release];
	}
	//TASK B
	else if(_roomChanged)
	{
		//Find room name based on device.roomID
		for(int k=0;k<[selectedRoomListArray count];k++)
		{
			roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
			if([roomName isEqualToString:ListeningRoomNameText.text])
			{
				roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
				break;
			}
		}
		
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",zwaveAddID] forKey:@"device"];	
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",roomId] forKey:@"toRoom"];
		[[DeviceService getSharedInstance]changeRoom:commandDictionary :self];
		[commandDictionary release];
	}
	
}
-(IBAction)ListeningCancelBtnClicked:(id)sender
{
	isStartListeningADD = NO;
	[startListeningView removeFromSuperview];
	[startListeningBtn setBackgroundImage:[UIImage imageNamed:@"start_listening_up.png"] forState:UIControlStateNormal];
}
-(IBAction)ListeningComboBtnClicked:(id)sender
{
	[roomNamePicker selectRow:0 inComponent:0 animated:NO];
	
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	roomNamePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:roomNamePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
}


#pragma mark -
#pragma mark ADVANCED TOOLS BLOCKS

-(IBAction)rediscoverNetworkClicked:(id)sender
{
	isAdvancedTools = YES;
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isDeviceRemoval = NO;
	
	
	isFirstBool = NO;isSecondBool = NO;
	runningImageView.hidden = NO;
	runningImageView.frame = CGRectMake(0, -2, 115, 191);
	
	//First call method bulogics_zwave_rediscover_nodes
	NSString *xmlString=@"";
	xmlString = [xmlString stringByAppendingString:@"<command>"];
	xmlString = [xmlString stringByAppendingString:@"<sessionid>"];
	if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
		xmlString = [xmlString stringByAppendingString:[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"sessionid"]];
	else 
		xmlString = [xmlString stringByAppendingString:sessionid];
	xmlString = [xmlString stringByAppendingString:@"</sessionid>"];
	xmlString = [xmlString stringByAppendingString:@"<name>"];
	xmlString = [xmlString stringByAppendingString:ZWAVE_REDISCOVER_NODES];
	xmlString = [xmlString stringByAppendingString:@"</name>"];
	xmlString = [xmlString stringByAppendingString:@"<arg>"];
	for (int i =0 ; i < [[AppDelegate_iPad sharedAppDelegate].g_DevicesArray count]; i++)
	{
		xmlString = [xmlString stringByAppendingString:@"<instance>"];
		xmlString = [xmlString stringByAppendingString:@"<id>"];
		xmlString = [xmlString stringByAppendingString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:i]objectForKey:@"id"]];
		xmlString = [xmlString stringByAppendingString:@"</id>"];
		xmlString = [xmlString stringByAppendingString:@"<getList>false</getList>"];
		xmlString = [xmlString stringByAppendingString:@"</instance>"];
	}
	xmlString = [xmlString stringByAppendingString:@"</arg>"];
	xmlString = [xmlString stringByAppendingString:@"</command>"];
	
	[[ConfigurationService getSharedInstance]zWaveRediscoverNodes:xmlString :self];
	
	
	//Second call bulogics_zwave_get_status
	[self zWaveGetStatusFunction];
	//[self performSelector:@selector(zWaveGetStatusFunction) withObject:nil afterDelay:2];
	
	
	/*advancedEnum = NONE;
	advancedTimer = [NSTimer scheduledTimerWithTimeInterval:0 
												 target:self 
											   selector:@selector(AdvancedToolsTask) 
											   userInfo:nil 
												repeats:YES];*/
}
-(IBAction)optimizeNetworkClicked:(id)sender
{
	runningImageView.hidden = NO;
	runningImageView.frame = CGRectMake(0,33,115,191);
	
	isAdvancedTools = YES;
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isDeviceRemoval = NO;
	
	isFirstBool = NO;isSecondBool = NO;
	
	statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
	statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"Starting to remove orphaned events."];
	
	CGPoint p = [statusMessageTextView contentOffset];
	[statusMessageTextView setContentOffset:p animated:NO];
	[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
	
	advancedEnum = NONE;
	advancedTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													 target:self 
												   selector:@selector(AdvancedToolsTask) 
												   userInfo:nil 
													repeats:YES];
}
-(IBAction)learnNetworkClicked:(id)sender
{
	runningImageView.hidden = NO;
	runningImageView.frame = CGRectMake(0,68,115,191);
	
	isAdvancedTools = YES;
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isDeviceRemoval = NO;
	
	isFirstBool = NO;isSecondBool = NO;
	
	[[ConfigurationService getSharedInstance]zWaveLearn:self];
	
	//Second call bulogics_zwave_get_status
	[self performSelector:@selector(zWaveGetStatusFunction) withObject:nil afterDelay:0.2];
}
-(IBAction)sendNodeInformationClicked:(id)sender
{
	runningImageView.hidden = NO;
	runningImageView.frame = CGRectMake(0,102,115,191);
	
	isAdvancedTools = YES;
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isDeviceRemoval = NO;
	
	isFirstBool = NO;isSecondBool = NO;
	
	[[ConfigurationService getSharedInstance]zWaveBroadcastNodeInfo:self];
}
-(IBAction)cancelRunningCommandClicked:(id)sender
{
	runningImageView.hidden = YES;
	
	isAdvancedTools = YES;
	isDeviceToolsEnabled = NO;
	isStartListening = NO;
	isDeviceRemoval = NO;
	
	isFirstBool = NO;isSecondBool = NO;
	
	[[ConfigurationService getSharedInstance]zWaveCancel:self];
}

-(IBAction)clearStatus:(id)sender
{
	isDeviceToolsEnabled = NO;
	statusMessageTextView.text  = @"";
	
	CGPoint p = [statusMessageTextView contentOffset];
	[statusMessageTextView setContentOffset:p animated:NO];
	[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
}

-(void)getEventInfo
{
	EventInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
															  target:self 
															selector:@selector(EventInfoTask) 
															userInfo:nil 
															 repeats:YES];
	EventInfoEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)EventInfoTask
{
	switch(EventInfoEnum)
	{
		case NONE:
		{
			EventInfoEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				EventInfoEnum = PROCESSING;
			}
			else 
			{
				EventInfoEnum = DONE;
			}
			
			break;
		}
		case EVENT_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count]-1)
			{
				g_objectIndex++;
				EventInfoEnum = EVENT_INFO;
			}
			else
				EventInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[EventInfoTimer invalidate];
			EventInfoTimer=nil;
			advancedEnum = EVENT_INFO_DONE;
			break;
		}
		default:
			break;
	}
}

-(void)eventRemove
{
	eventRemoveTimer = [NSTimer scheduledTimerWithTimeInterval:0
													  target:self 
													selector:@selector(EventRemoveTask) 
													userInfo:nil 
													 repeats:YES];
	eventRemoveEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)EventRemoveTask
{
	switch(eventRemoveEnum)
	{
		case NONE:
		{
			eventRemoveEnum = ENUM_EVENT_REMOVE;
			break;
		}
		case ENUM_EVENT_REMOVE:
		{
			if([orphanedEventsArray count] > g_objectIndex)
			{
				NSMutableArray *eventsArray = [orphanedEventsArray objectAtIndex:g_objectIndex];
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[eventsArray objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];	
				[commandDictionary setObject:@"false" forKey:@"getList"];
				[[EventsService getSharedInstance]eventRemove:commandDictionary :self];
				[commandDictionary release];
				eventRemoveEnum = PROCESSING;
			}
			else 
			{
				eventRemoveEnum = DONE;
			}
			
			break;
		}
		case ENUM_EVENT_REMOVE_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count]-1)
			{
				g_objectIndex++;
				eventRemoveEnum = EVENT_INFO;
			}
			else
				eventRemoveEnum = DONE;
			break;
		}
		case DONE:
		{
			[eventRemoveTimer invalidate];
			eventRemoveTimer=nil;
			advancedEnum = ENUM_EVENT_REMOVE_DONE;
			break;
		}
		default:
			break;
	}
}


-(void)fillOrphanedArray
{
	if([orphanedEventsArray count]>0)
		[orphanedEventsArray removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray count];i++)
	{
		NSMutableArray *eventsInfoArray = [[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:i];
		if([eventsInfoArray count]>=3)
		{
			int trigDeviceId = [[[eventsInfoArray objectAtIndex:[eventsInfoArray count]-2] objectForKey:@"trigDeviceID"] intValue];
			if(trigDeviceId==0)
			{
				[orphanedEventsArray addObject:eventsInfoArray];
			}
		}
	}
}



-(void)AdvancedToolsTask
{
	switch(advancedEnum)
	{
		case NONE:
		{
			advancedEnum = GET_EVENT;
			break;
		}
		case GET_EVENT:
		{
			[[EventsService getSharedInstance]getEvents:self];
			advancedEnum = PROCESSING;
			break;
		}
		case GET_EVENT_DONE:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray count]>0)
				[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray removeAllObjects];
			advancedEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			advancedEnum = PROCESSING;
			[self getEventInfo];
			break;
		}
		case EVENT_INFO_DONE:
		{
			[self fillOrphanedArray];
			if([orphanedEventsArray count]>0)
				advancedEnum = ENUM_EVENT_REMOVE;
			else
				advancedEnum = DONE;
			break;
		}
		case ENUM_EVENT_REMOVE:
		{
			[self eventRemove];
			advancedEnum = PROCESSING;
		}
		case ENUM_EVENT_REMOVE_DONE:
		{
			advancedEnum = DONE;
		}
		case DONE:
		{
			[advancedTimer invalidate];
			advancedTimer=nil;
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"Completed removal of orphaned events."];
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"OptimizeNetwork Command Complete"];
			
			runningImageView.hidden = YES;
			
			CGPoint p = [statusMessageTextView contentOffset];
			[statusMessageTextView setContentOffset:p animated:NO];
			[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
			
			break;
		}
		default:
			break;
	}
}


#pragma mark -
#pragma mark ANIMATION BLOCKS

-(IBAction)advacnedTools:(id)sender
{
	if(isAnimationProcessing)
		return;
	
	if(isOpen)
	{
		isOpen = NO;
		runningImageView.hidden = YES;
		[self CloseWindow];
	}
	else
	{
		advacnedToolsBtn.hidden = YES;
		advancedArrowImgBtn.hidden = YES;
		isOpen = YES;
		runningImageView.hidden = YES;
		[self OpenWindow];
	}
}

-(void)OpenWindow
{
	//Kill all previous timer
	[openTimer invalidate];
    openTimer = nil;
    [closeTimer invalidate];
    closeTimer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CloseWindow) object:nil];
	
	isAnimationProcessing = YES;
	animationScrollView.hidden = NO;
	animationView.frame = CGRectMake(0, -291, 805, 330);
	yPosition = -291;
	openTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 
												 target:self 
											   selector:@selector(OpenDisplayTask) 
											   userInfo:nil 
												repeats:YES];
}

-(void)OpenDisplayTask
{
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animationView.frame = CGRectMake(0, yPosition, 805, 330);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=-30)
	{
		yPosition = -30;
		[advancedArrowImg1Btn setBackgroundImage:[UIImage imageNamed:@"toggle_up.png"] forState:UIControlStateNormal];
		animationView.frame = CGRectMake(0, yPosition, 805, 330);
		[openTimer invalidate];
		openTimer = nil;
		isAnimationProcessing = NO;
	}
}

-(void)CloseDisplayTask
{
	//Kill open timer
	[openTimer invalidate];
    openTimer = nil;
	
	yPosition-=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animationView.frame = CGRectMake(0, yPosition, 805, 330);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=-291)
	{
		animationScrollView.hidden = YES;
		advacnedToolsBtn.hidden = NO;
		advancedArrowImgBtn.hidden = NO;
		[advancedArrowImg1Btn setBackgroundImage:[UIImage imageNamed:@"toggle_down.png"] forState:UIControlStateNormal];
		yPosition = -291;
		animationView.frame = CGRectMake(0, -291, 805, 330);
		[closeTimer invalidate];
		closeTimer = nil;
		isAnimationProcessing = NO;
	}
}

-(void)CloseWindow
{
	isAdvancedTools = NO;
	isAnimationProcessing = YES;
	closeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01  
												  target:self 
												selector:@selector(CloseDisplayTask) 
												userInfo:nil 
												 repeats:YES];
}

#pragma mark -
#pragma mark SCENE_CONTROLLER

-(IBAction)pickerOkClicked:(id)sender
{
	if(isEditScreen)
	{
		editRoomNameTextField.text = [[selectedRoomListArray objectAtIndex:sceneLastPickerRowIndex]objectForKey:@"name"];
		[pickerPopupView removeFromSuperview];
	}
	else if(isStartListeningADD)
	{
		ListeningRoomNameText.text = [[selectedRoomListArray objectAtIndex:sceneLastPickerRowIndex]objectForKey:@"name"];
		[pickerPopupView removeFromSuperview];
	}
	else
	{
		
		[self showLoadingView];
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[NSString stringWithFormat:@"%d",buttonIndex] forKey:@"button"];
		[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex]objectForKey:@"zwaveID"] forKey:@"zwaveID"];
		[commandDictionary setObject:[[globalScenesArray objectAtIndex:sceneLastPickerRowIndex]objectForKey:@"id"] forKey:@"scene"];
		[[SceneControllerSevice getSharedInstance]setButton:commandDictionary :self];
		[commandDictionary release];
		[pickerPopupView removeFromSuperview];
		
	}
}

-(IBAction)pickerCancelClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
}


-(IBAction)sceneControllerClose:(id)sender
{
	[popupSceneControllerView removeFromSuperview];
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
#pragma mark PICKER DELEGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1; // We only need one column so we will return 1.
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	if(thePickerView == roomNamePicker)
		return [selectedRoomListArray count];
	else
		return [globalScenesArray count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	if(thePickerView == roomNamePicker)
		return [[selectedRoomListArray objectAtIndex:row] objectForKey:@"name"];
	else
		return [[globalScenesArray objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
	sceneLastPickerRowIndex = row;
}




#pragma mark -
#pragma mark BOTTOM TABS SWITCHING ITEMS

-(IBAction)LOGOUT:(id)sender
{
	//[self showLoadingView];
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

//5 Tabs switching items
-(IBAction)RoomSelector:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
}
-(IBAction)DeviceConfigurator:(id)sender
{
}
-(IBAction)SceneConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view];
}
-(IBAction)EventConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view];
}
-(IBAction)ScheduleConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
}

-(IBAction)Homeowner:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetHomeownerViewIndex]) {
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
			break;
		}
		default:
			break;
	}
}

-(BOOL)deviceRediscoveryStatus:(int)statusValue
{
	BOOL rediscovered;
	
	//Determine the value based on the status value of the 
	//arguement
	switch ( statusValue )
	{
		case FE_SUCCESS :
		case FE_ZW_FOUND_DEVICE:
			rediscovered = YES;
			break;
		case FE_FAILURE:
		case FE_FAIL_COULDNT_START_REDISCOVERY:
		case FE_FAIL_COULDNT_COMMUNICATE:
		case FE_FAIL_NOT_LISTENING:
		case FE_FAIL_TIMEOUT:
			rediscovered = NO;
			break;
	}
	
	//Return the state of the device
	return rediscovered;
}

-(void)handleNetworkDiscoveryMessage:(NSMutableArray*)array
{
	NSMutableDictionary *dict = [array objectAtIndex:0];
	
	if ( [[dict objectForKey:@"nodeID"] intValue] == [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"] intValue] )
	{
		
		if ( [[dict objectForKey:@"zwaveAction"]intValue] == FE_REDISCOVERY )
		{
			BOOL isState = [self deviceRediscoveryStatus:[[dict objectForKey:@"statusValue"]intValue]];
			if(isState)
			{
				replaceFailedBtn.enabled = NO;
				removeFailedBtn.enabled = NO;
				indicatorImageView.hidden = NO;
				indicatorImageView.image = [UIImage imageNamed:@"rediscovery_network_status_found.png"];
				
				//If already discovered we dont added in the array
				BOOL isExists = NO;
				for(int i=0;i<[rediscoveredArray count];i++)
				{
					NSString *zwaveID = [[rediscoveredArray objectAtIndex:i]objectForKey:@"zwaveID"];
					if([zwaveID isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"]])
					{
						isExists = YES;
						break;
					}
				}
				
				//If not exists added in the rediscovered array
				if(!isExists)
				{
					NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
					[dict setObject:@"NetworkStatusFound" forKey:@"Status"];
					[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"] forKey:@"zwaveID"];
					[rediscoveredArray addObject:dict];
					[dict release];
				}
				
			}
			else
			{
				replaceFailedBtn.enabled = YES;
				removeFailedBtn.enabled = YES;
				indicatorImageView.hidden = NO;
				indicatorImageView.image = [UIImage imageNamed:@"rediscovery_network_status_not_found.png"];
				
				
				//If already discovered we dont added in the array
				BOOL isExists = NO;
				for(int i=0;i<[rediscoveredArray count];i++)
				{
					NSString *zwaveID = [[rediscoveredArray objectAtIndex:i]objectForKey:@"zwaveID"];
					if([zwaveID isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"]])
					{
						isExists = YES;
						break;
					}
				}
				
				//If not exists added in the rediscovered array
				if(!isExists)
				{
					NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
					[dict setObject:@"NetworkStatusNotFound" forKey:@"Status"];
					[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"zwaveID"] forKey:@"zwaveID"];
					[rediscoveredArray addObject:dict];
					[dict release];
				}
				
			}
			
			[self LoadAllDevicesToUI:[AppDelegate_iPad sharedAppDelegate].g_DevicesArray];
		}
		
	}
}



#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)BOOLCHANGED
{
	isSecondBool = YES;
}

-(void)EmptyString
{
	statusMessageLbl1.text = @"";
	statusMessageLbl2.text = @"";
}

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand == GET_CONTROLLER)
	{
		if(sceneControllerEnum == PROCESSING)
		{
			sceneControllerEnum = GETCONTROLLER_DONE;
			getSceneControlsArray = [resultArray mutableCopy];
			[self collectGlobalScenes];
			[self loadSceneController:[[[resultArray objectAtIndex:0]objectForKey:@"numButtons"]intValue]];
		}
		else
		{
			getSceneControlsArray = [resultArray mutableCopy];
			[self loadSceneController:[[[resultArray objectAtIndex:0]objectForKey:@"numButtons"]intValue]];
			[self hideLoadingView];
		}
	}
	else if(strCommand == ADD_SCENE)
	{
		sceneControllerEnum	= ENUM_SCENE_ADD_DONE;
	}
	else if(strCommand == GET_SCENES)
	{
		sceneControllerEnum = GETSCENES_DONE;
		//Copy the getscenes result
		[AppDelegate_iPad  sharedAppDelegate].g_ScenesArray = [resultArray mutableCopy];
		
	}
	else if(strCommand == ZWAVE_REMOVE)
	{
		isStatus = NO;
		removalDoneBtn.hidden = NO;
		removalCancelBtn.hidden = YES;
		removalRestartBtn.hidden = YES;
		removalSupportBtn.hidden = YES;
		
		removalMainLbl.text = @"DEVICE REMOVED";
		removalSubLbl1.text = @"";
		removalSubLbl2.text = @"";
		
		isDeviceRemoval = NO;
	}
	else if(strCommand == ZWAVE_ADD)
	{
		if([resultArray count]>0)
		{
			if([[resultArray objectAtIndex:0]objectForKey:@"id"]!=nil)
			{
				zwaveAddID = [[[resultArray objectAtIndex:0]objectForKey:@"id"]intValue];
				if(zwaveAddID!=0)
				{
					_poll = NO;
					isStartListening = NO;
					isStartListeningADD = YES;
					nameLbl.hidden = NO;roomLbl.hidden = NO;
					ListeningDeviceNameText.hidden = NO;ListeningRoomNameText.hidden = NO;
					ListeningSaveBtn.hidden = NO;ListeningCancelBtn.hidden = NO;ListeningComboBtn.hidden = NO;
					
					startListeningRestartBtn.hidden = YES;startListeningSupportBtn.hidden = YES;startListeningCancelBtn.hidden = YES;
					message1Lbl.text = @"DEVICE FOUND";
					message2Lbl.text = @"";
					
					ListeningDeviceNameText.text = [[resultArray objectAtIndex:0]objectForKey:@"name"];
					ListeningRoomNameText.text = @"";
					
					[maintenanceDict setObject:ListeningRoomNameText.text forKey:@"previousRoomName"];
					[maintenanceDict setObject:ListeningDeviceNameText.text forKey:@"previousDeviceName"];
					
					//ADDED If device found and type was binary sensor, we need to call "execut" function	
					
					if ( [[[resultArray objectAtIndex:0]objectForKey:@"deviceType"]intValue] == BINARY_SENSOR || [[[resultArray objectAtIndex:0]objectForKey:@"deviceType"]intValue] == BINARY_SENSOR_TWO )
					{
						homeOccupancyStateMachineCount = 0;
						NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
						[dict setObject:[NSString stringWithFormat:@"%d",zwaveAddID] forKey:@"device"];
						if([[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray count]>1)
							[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray objectAtIndex:1] objectForKey:@"id"] forKey:@"groupID"];
						else
							[dict setObject:@"1" forKey:@"groupID"];
						[dict setObject:@"0" forKey:@"conditionForDevValue"];
						[dict setObject:@"100" forKey:@"value"];
						[[UserService getSharedInstance]HomeOccupancyStateGroupDeviceAdd:dict :self];
						[dict release];
					}
					
				}
			}
		}
	}
	else if(strCommand == HOME_OCCUPANCY_STATE_GROUP_DEVICE_ADD)
	{
		if(homeOccupancyStateMachineCount==0)
		{
			homeOccupancyStateMachineCount = 1;
			NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
			[dict setObject:[NSString stringWithFormat:@"%d",zwaveAddID] forKey:@"device"];
			if([[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray count]>2)
				[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray objectAtIndex:2] objectForKey:@"id"] forKey:@"groupID"];
			else
				[dict setObject:@"2" forKey:@"groupID"];
			[dict setObject:@"0" forKey:@"conditionForDevValue"];
			[dict setObject:@"0" forKey:@"value"];
			[[UserService getSharedInstance]HomeOccupancyStateGroupDeviceAdd:dict :self];
			[dict release];
		}
	}
	else if(strCommand == ZWAVE_GET_STATUS)
	{
		if(isDeviceToolsEnabled)
		{
			if(!isFirstBool || !isSecondBool)
			{
				if([resultArray count]>0)
				{
					if(![[[resultArray objectAtIndex:0]objectForKey:@"statusString"] isEqualToString:@"No Status"])
					{
						statusMessageLbl2.text = [[resultArray objectAtIndex:0]objectForKey:@"statusString"];
						if(isrediscoverEnabled)
							[self handleNetworkDiscoveryMessage:resultArray];
					}
				}
				[self performSelector:@selector(zWaveGetStatusFunction) withObject:nil afterDelay:1];
			}
			else
			{
				statusMessageLbl1.text = @"";
				statusMessageLbl2.text = @"";
			}
		}
		else if(isStartListening)
		{
			if ( _poll )
			{
				if([resultArray count]>0)
				{
					if(![[[resultArray objectAtIndex:0]objectForKey:@"statusString"] isEqualToString:@"No Status"])
						message2Lbl.text = [[resultArray objectAtIndex:0]objectForKey:@"statusString"];
				}
				[self callzwaveGetStatus];
			}
		}
		else if(isDeviceRemoval)
		{
			if ( isStatus )
			{
				if([resultArray count]>0)
				{
					if(![[[resultArray objectAtIndex:0]objectForKey:@"statusString"] isEqualToString:@"No Status"])
						removalSubLbl2.text = [[resultArray objectAtIndex:0]objectForKey:@"statusString"];
				}
				[self callzwaveGetStatus];
			}
		}
		else if(isAdvancedTools)
		{
			if(!isFirstBool || !isSecondBool)
			{
				if([resultArray count]>0)
				{
					if(![[[resultArray objectAtIndex:0]objectForKey:@"statusString"] isEqualToString:@"No Status"])
					{
						statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:[[resultArray objectAtIndex:0]objectForKey:@"statusString"]];
						//statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
						
						CGPoint p = [statusMessageTextView contentOffset];
						[statusMessageTextView setContentOffset:p animated:NO];
						[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
					}
				}
				[[ConfigurationService getSharedInstance]zWaveGetStatus:self];
			}
			else
			{
				statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"Rediscover task completed"];
				
				runningImageView.hidden = YES;
				//statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
				
				CGPoint p = [statusMessageTextView contentOffset];
				[statusMessageTextView setContentOffset:p animated:NO];
				[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
			}
		}
	}
	else if(strCommand == ZWAVE_REMOVE_FAILED_NODE)
	{
		statusMessageLbl2.text = @"Running Remove Network for Device Complete";
		[self performSelector:@selector(EmptyString) withObject:nil afterDelay:0.5];
	}
	else if(strCommand == ZWAVE_REPLACE_FAILED_NODE)
	{
		isFirstBool = YES;
		[self performSelector:@selector(BOOLCHANGED) withObject:nil afterDelay:2];
	}
	else if(strCommand == DEVICE_SETUP_WIZARD_RUN)
	{
		statusMessageLbl2.text = @"Device Setup Wizard Complete";
		[self performSelector:@selector(EmptyString) withObject:nil afterDelay:0.5];
	}
	else if(strCommand == SET_BUTTON)
	{
		if(sceneControllerEnum == PROCESSING)
		{
			sceneControllerEnum = SETBUTTON_DONE;
		}
		else
			[[SceneControllerSevice getSharedInstance]getController:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:deviceIndex]objectForKey:@"zwaveID"] :self];
	}
	else if(strCommand == ZWAVE_REDISCOVER_NODES)
	{
		isFirstBool = YES;
		[self performSelector:@selector(BOOLCHANGED) withObject:nil afterDelay:2];
	}
	else if(strCommand == ZWAVE_LEARN)
	{
		isFirstBool = YES;
		[self performSelector:@selector(BOOLCHANGED) withObject:nil afterDelay:2];
		statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
		statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"Learn Network Command Complete"];
		
		runningImageView.hidden = YES;
		
		CGPoint p = [statusMessageTextView contentOffset];
		[statusMessageTextView setContentOffset:p animated:NO];
		[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
	}
	else if(strCommand == ZWAVE_CANCEL)
	{
		if(isDeviceToolsEnabled)
		{
			statusMessageLbl2.text = @"zWave Cancel Command Completed";
		}
		else if(isDeviceRemoval)
		{
			if(isRestartDeviceRemoval)
			{
				//If device removal restart button is pressed first we need to send zwave cancel command in the replay we need to send zwave remove and zwavegetstatus
				[[ConfigurationService getSharedInstance]zWaveRemove:self];
				[self callzwaveGetStatus];
			}
			else
				[deviceRemovalView removeFromSuperview];
		}
		else if(isStartListening)
		{
			if(isRestartStartListening)
			{
				NSString *randomNumber = [NSString stringWithFormat:@"%ld",arc4random()];
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:randomNumber forKey:@"name"];	
				[commandDictionary setObject:@"0" forKey:@"id"];
				[[ConfigurationService getSharedInstance]zWaveAdd:commandDictionary :self];
				[commandDictionary release];
				
				[self performSelector:@selector(callzwaveGetStatus) withObject:nil afterDelay:1];
			}
			else
			{
				_poll = NO;
				isStartListening = NO;
				[startListeningView removeFromSuperview];
				[startListeningBtn setBackgroundImage:[UIImage imageNamed:@"start_listening_up.png"] forState:UIControlStateNormal];
			}
		}
		else
		{
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
			statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"zWave Cancel Command Completed"];
			
			runningImageView.hidden = YES;
			
			CGPoint p = [statusMessageTextView contentOffset];
			[statusMessageTextView setContentOffset:p animated:NO];
			[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
		}
	}
	else if(strCommand == ZWAVE_BROADCAST_NODE_INFO)
	{
		statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"\n"];
		statusMessageTextView.text = [statusMessageTextView.text stringByAppendingString:@"Send Node Information Command Complete"];
		
		runningImageView.hidden = YES;
		
		CGPoint p = [statusMessageTextView contentOffset];
		[statusMessageTextView setContentOffset:p animated:NO];
		[statusMessageTextView scrollRangeToVisible:NSMakeRange([statusMessageTextView.text length], 0)];
	}
	else if(strCommand==GET_EVENTS)
	{
		advancedEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		EventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand == EVENT_REMOVE)
	{
		eventRemoveEnum = ENUM_EVENT_REMOVE_DONE;
	}
	else if(strCommand == CHANGE_NAME)
	{
		NSString *roomName;
		int roomId;
		_nameChanged = NO;
		if(_roomChanged)
		{
			if(isStartListeningADD)
			{
				//Find room name based on device.roomID
				for(int k=0;k<[selectedRoomListArray count];k++)
				{
					roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
					if([roomName isEqualToString:ListeningRoomNameText.text])
					{
						roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
						break;
					}
				}
				
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[NSString stringWithFormat:@"%d",zwaveAddID] forKey:@"device"];	
				[commandDictionary setObject:[NSString stringWithFormat:@"%d",roomId] forKey:@"toRoom"];
				[[DeviceService getSharedInstance]changeRoom:commandDictionary :self];
				[commandDictionary release];
			}
			else
			{
				//Find room name based on device.roomID
				for(int k=0;k<[selectedRoomListArray count];k++)
				{
					roomName = [[selectedRoomListArray objectAtIndex:k] objectForKey:@"name"];
					if([roomName isEqualToString:editRoomNameTextField.text])
					{
						roomId = [[[selectedRoomListArray objectAtIndex:k] objectForKey:@"id"] intValue];
						break;
					}
				}
				
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"device"];	
				[commandDictionary setObject:[NSString stringWithFormat:@"%d",roomId] forKey:@"toRoom"];
				[[DeviceService getSharedInstance]changeRoom:commandDictionary :self];
				[commandDictionary release];
			}
		}
		else
		{
			[[DeviceService getSharedInstance] getAll:self];
		}
	}
	else if(strCommand == CHANGE_ROOM)
	{
		_roomChanged = NO;
		if(isDeviceMetaDataChanged)
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:editDeviceIndex]objectForKey:@"id"] forKey:@"relatedID"];	
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",metaDataValue] forKey:@"metaData"];
			[commandDictionary setObject:@"0" forKey:@"metaDataType"];
			[[ConfigurationService getSharedInstance]setMetaData:commandDictionary :self];
			[commandDictionary release];
		}
		else
		{
			[[DeviceService getSharedInstance] getAll:self];
		}
	}
	else if(strCommand == SET_METADATA)
	{
		isDeviceMetaDataChanged = NO;
		[[DeviceService getSharedInstance] getAll:self];
	}
	else if(strCommand == GET_ALL)
	{
		if(removalDoneEnum == PROCESSING)
		{
			removalDoneEnum = GETDEVICES_DONE;
			[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		}
		else
		{
			[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
			[self LoadAllDevicesToUI:[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray];
			[editView removeFromSuperview];
			[startListeningView removeFromSuperview];
			isStartListeningADD = NO;
			[startListeningBtn setBackgroundImage:[UIImage imageNamed:@"start_listening_up.png"] forState:UIControlStateNormal];
			[self hideLoadingView];
			
		}
	}
	else if(strCommand==EVENT_GET_TRIGGER_DEVICES_LIST)
	{
		removalDoneEnum = GET_TRIGGER_DEVICE_LIST_DONE;
		//Copy the getdevices result
		[AppDelegate_iPad  sharedAppDelegate].g_getTriggerDeviceListArray = [resultArray mutableCopy];
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
	isFirstBool = YES;
	isSecondBool = YES;
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
		return;
	}
	if(isStartListening)
	{
		//Add restart button and status message button on the startlistening screen
		_poll = NO;
		startListeningRestartBtn.hidden = NO;
		startListeningSupportBtn.hidden = NO;
		startListeningCancelBtn.hidden = YES;
		
		nameLbl.hidden = YES;roomLbl.hidden = YES;
		ListeningDeviceNameText.hidden = YES;ListeningRoomNameText.hidden = YES;
		ListeningSaveBtn.hidden = YES;ListeningCancelBtn.hidden = YES;ListeningComboBtn.hidden = YES;
		
		message1Lbl.text = @"DEVICE FINDER ERROR";
		message2Lbl.text = @"PROBLEM FINDING A DEVICE";
		
	}
	else if(isDeviceRemoval)
	{
		isStatus = NO;
		removalRestartBtn.hidden = NO;
		removalSupportBtn.hidden = NO;
		removalCancelBtn.hidden = YES;
		removalDoneBtn.hidden = NO;
		
		removalMainLbl.text = @"DEVICE REMOVAL ERROR";
		removalSubLbl1.text = @"ERROR REMOVING DEVICE";
		removalSubLbl2.text = @"";
	}
	else
	{
		[editView removeFromSuperview];
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex1
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
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex1==1)
		{
			[self showLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
	[Logout release];
	//DEVICE CONFIGURATOR EDIT SCREEN
	[filterDeviceRoomsArray release];
	[devicesListView release];
	[devicesTableSubView release];
	[maintenanceDict release];
	[editAnimationScrollView,editAnimationView release];
	[selectedRoomListArray release];
	[editView release];
	[roomNamePicker release];
	[somfyImgView release];
	[lblSomfyDeviceName release];
	[editSaveBtn,editCancelBtn,editComboBtn release];
	[editDeviceNameTextField,editRoomNameTextField release];
	
	[nameLbl,roomLbl,message1Lbl,message2Lbl release];
	[ListeningDeviceNameText,ListeningRoomNameText release];
	[ListeningSaveBtn,ListeningCancelBtn,ListeningComboBtn release];
	
	//DEVICE REMOVAL SCREENS
	[deviceRemovalView,deviceRemovalSupportView release];
	[removalRestartBtn,removalSupportBtn,removalDoneBtn,removalCancelBtn,removalCloseBtn release];
	[removalMainLbl,removalSubLbl1,removalSubLbl2 release];
	
	[rediscoverDeviceBtn,deviceSetupBtn,replaceFailedBtn,removeFailedBtn,zwaveCancelBtn,deviceToolsBtn release];
	[statusMessageLbl1,statusMessageLbl2 release];
	[indicatorImageView release];
	[deviceGridBtn,deviceTableListBtn release];
	
	[runningImageView release];
	[supportView release];
	[startListeningView,startListeningBtn,statusMessageTextView release];
	[startListeningRestartBtn,startListeningSupportBtn,startListeningCancelBtn release];
	[advacnedToolsBtn,advancedArrowImgBtn,advancedArrowImg1Btn release];
	[animationScrollView release];
	[animationView release];
	[scenesPicker release];
	[pickerOkBtn,pickerCancelBtn release];
	[pickerPopupView,pickerPopupsubView release];
	[getSceneControlsArray,globalScenesArray,orphanedEventsArray,rediscoveredArray release];
	[sceneControllerDeviceName release];
	[popupView,popupSceneControllerView release];
	[scrollView,sceneControllerScrollView release];
	[RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn release];
    [super dealloc];
}


@end
