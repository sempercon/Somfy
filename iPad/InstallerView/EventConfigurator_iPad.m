//
//  EventConfigurator_iPad.m
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
#import "DeviceIconMapper.h"
#import "EventsService.h"
#import "TimeConverterUtil.h"
#import "SceneControllerSevice.h"
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "RRSGlowLabel.h"
#import "MJPEGViewer_iPad.h"

@interface EventConfigurator_iPad (Private)
-(void)eventTriggerDevices;
- (void)showLoadingView;
-(void)InitializeAndMaintainDefaultSceneInfoValues;
- (void)hideLoadingView;
-(void)saveEventChangeOneByOne;
-(void)FillPopUPTimeView;
-(void)startTimer;
-(void)collectLocalScenes;
-(void)FillPopupArray;
-(void)loadPopupAllEvents:(NSMutableArray*)eventArr;
-(void)loadAllEvents:(NSMutableArray*)eventArr;
-(void)changeDaysActiveMask:(int)mask :(NSMutableDictionary*)dictionary;
-(void)handleDayClick :(int)_currentDays :(int)DayNoofWeek :(NSMutableDictionary*)dict;
- (void) alignLabelWithTop:(UILabel *)label;
@end

extern BOOL  isLOGOUT;

@implementation EventConfigurator_iPad
@synthesize Logout;
@synthesize scrollView,popupScrollView;
@synthesize popupEventView,popupEventTimeView;
@synthesize popupNameLabel,messageLabel;
@synthesize RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn;
@synthesize g_triggerDevicesList,g_popupEventsInfoArray,temp_infoArray,localScenesArray;
@synthesize g_sunBtn,g_monBtn,g_tueBtn,g_wedBtn,g_thuBtn,g_friBtn,g_satBtn,g_allBtn;
@synthesize saveBtn,resetBtn,closeBtn,fromTimeBtn,toTimeBtn;
@synthesize fromTimeTextField,toTimeTextField;
@synthesize segControl;
@synthesize maintenanceArray;
@synthesize fromTimePicker,toTimePicker;
@synthesize scenesPicker;
@synthesize pickerOkBtn,pickerCancelBtn;
@synthesize pickerPopupView,pickerPopupsubView;
@synthesize sceneMaintenanceArray;

@synthesize eventInitializeView;
@synthesize eventInitializeNameLabel,eventInitializeStatusLabel;
@synthesize eventInitializeCloseBtn,eventInitializeBtn;

@synthesize enableHomeOccupancyBtn;
@synthesize occupancyLabel;

@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle;

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
-(void)viewWillAppear:(BOOL)animated
{
	[[AppDelegate_iPad sharedAppDelegate]SetInstallerViewIndex:4];
	[EventConfigBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    if (isLocal == 1)
        self.Logout.hidden = YES;
    
	isSceneController = NO;
	isSingleEventInfo = NO;
	
	animationTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 350, 70)];
	animationTitle.lineBreakMode = UILineBreakModeWordWrap;
	animationTitle.numberOfLines = 0;
	animationTitle.textAlignment = UITextAlignmentCenter;
	animationTitle.font = [UIFont systemFontOfSize:13];
	animationTitle.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle];
	animationTitle.text = @"Successfully Updated";
	
	g_triggerDevicesList = [[[NSMutableArray alloc]init] retain];
	g_popupEventsInfoArray = [[[NSMutableArray alloc]init] retain];
	temp_infoArray = [[[NSMutableArray alloc]init] retain];
	localScenesArray = [[[NSMutableArray alloc]init] retain];
	maintenanceArray = [[[NSMutableArray alloc]init] retain];
	sceneMaintenanceArray = [[[NSMutableArray alloc]init] retain];
	deviceONIdArray = [[[NSMutableArray alloc]init] retain];
	deviceOFFIdArray = [[[NSMutableArray alloc]init] retain];
	getSceneControlsArray = [[[NSMutableArray alloc]init] retain];
	button1Array = [[[NSMutableArray alloc]init] retain];
	button2Array = [[[NSMutableArray alloc]init] retain];
	button3Array = [[[NSMutableArray alloc]init] retain];
	button4Array = [[[NSMutableArray alloc]init] retain];
	button5Array = [[[NSMutableArray alloc]init] retain];
	
	
	if([[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray count]>0)
	{
		if([[[[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray objectAtIndex:0] objectForKey:@"enabled"] isEqualToString:@"1"])
		{
			isEnableOccupancy = YES;
			[enableHomeOccupancyBtn setImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
		}
		else
		{
			isEnableOccupancy = NO;
			[enableHomeOccupancyBtn setImage:[UIImage imageNamed:@"EmptyBox.png"] forState:UIControlStateNormal];
		}
		
		RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(680, 119, 209, 30)];
		lbl3.textColor = [UIColor blackColor];
		lbl3.backgroundColor = [UIColor clearColor];
		lbl3.textAlignment = UITextAlignmentCenter;
		lbl3.lineBreakMode = UILineBreakModeWordWrap;
		lbl3.numberOfLines = 0;
		lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
		lbl3.text = @"Enable Home Occupancy";
		lbl3.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		lbl3.glowOffset = CGSizeMake(0.0, 0.0);
		lbl3.glowAmount = 10.0;
		[self.view addSubview:lbl3];
		[lbl3 release];
		
		enableHomeOccupancyBtn.hidden = NO;
	}
	else
	{
		enableHomeOccupancyBtn.hidden = YES;
		isEnableOccupancy = NO;
		[enableHomeOccupancyBtn setImage:[UIImage imageNamed:@"EmptyBox.png"] forState:UIControlStateNormal];
	}
	
	
	[self collectLocalScenes];
	[self eventTriggerDevices];
	[self loadAllEvents:g_triggerDevicesList];
	
    [super viewDidLoad];
}


#pragma mark -
#pragma mark INITIAL LOAD

-(void)collectLocalScenes
{
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count];i++)
	{
		int zwaveSceneID = [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"zwaveSceneID"] intValue];
		if(zwaveSceneID == 0)
		{
			[localScenesArray addObject:[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]];
		}
	}
}

-(void)sceneMaintenanceArrayFilled
{
	NSString *sceneName,*sceneId;
	if([sceneMaintenanceArray count]>0)
		[sceneMaintenanceArray removeAllObjects];
	
	for(int i=0;i<[g_popupEventsInfoArray count];i++)
	{
		maintenanceDictionary = [[NSMutableDictionary alloc]init];
		
		NSMutableArray *eventArray = [g_popupEventsInfoArray objectAtIndex:i];
		if([eventArray count]==4)
		{
			sceneName = [[eventArray objectAtIndex:1] objectForKey:@"name"];
			sceneId = [[eventArray objectAtIndex:1] objectForKey:@"id"];
			
			[maintenanceDictionary setObject:[[eventArray objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
			[maintenanceDictionary setObject:sceneName forKey:@"currentSceneName"];
			[maintenanceDictionary setObject:sceneId forKey:@"currentSceneId"];
			[maintenanceDictionary setObject:sceneName forKey:@"previousSceneName"];
			[maintenanceDictionary setObject:sceneId forKey:@"previousSceneId"];
		}
		else
		{
			[maintenanceDictionary setObject:[[eventArray objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
			[maintenanceDictionary setObject:@"" forKey:@"currentSceneName"];
			[maintenanceDictionary setObject:@"" forKey:@"currentSceneId"];
			[maintenanceDictionary setObject:@"" forKey:@"previousSceneName"];
			[maintenanceDictionary setObject:@"" forKey:@"previousSceneId"];
		}
		
		[sceneMaintenanceArray addObject:maintenanceDictionary];
		[maintenanceDictionary release];
	}
}


-(void)eventTriggerDevices
{
    NSMutableArray *tempArr1 = nil;
    
    for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getTriggerDeviceListArray count];i++)
    {
        int triggerId = [[[[AppDelegate_iPad sharedAppDelegate].g_getTriggerDeviceListArray objectAtIndex:i]objectForKey:@"id"] intValue];
        
        if(triggerId != 240)
        {
            for(int j=0;j<[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray count];j++)
			{
				if(triggerId == [[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"id"] intValue])
				{
					NSMutableDictionary *dict = [[AppDelegate_iPad sharedAppDelegate].g_getTriggerDeviceListArray objectAtIndex:i];
					[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"deviceType"] forKey:@"deviceType"];
					[g_triggerDevicesList addObject:dict];
					break;
				}
			}
        }
    }
    
    //Get mutable Copy of g_triggerDevicesList into tempArr1 and removeall objects in g_triggerDevicesList.
    tempArr1 = [g_triggerDevicesList mutableCopy];
    [g_triggerDevicesList removeAllObjects];
	
    //eventTriggerExcludedDeviceList this is the excluded device type defined in contants.h
    NSArray *array = [eventTriggerExcludedDeviceList componentsSeparatedByString:@","];
	for (int i=0;i<[tempArr1 count]; i++) {
        BOOL isExists = NO;
		int devType = [[[tempArr1 objectAtIndex:i]objectForKey:@"deviceType"] intValue];
		for (int j=0; j<[array count]; j++) 
        {
			if([[array objectAtIndex:j] intValue] == devType)
			{
				isExists = YES;
				break;
			}
		}
        if(!isExists)
            [g_triggerDevicesList addObject:[tempArr1 objectAtIndex:i]];
	}
}

-(void)FillPopupArray
{
	NSMutableArray *eventInfoArray;
	int eventInfoTriggerId;
	
	int triggerId = [[[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"] intValue];
	//Check the trigger id is equal to event info triggerdevice id
	
	if([g_popupEventsInfoArray count]>0)
		[g_popupEventsInfoArray removeAllObjects];
	
	for(int j=0;j<[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray count];j++)
	{
		eventInfoArray = [[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:j];
		if([eventInfoArray count]>[eventInfoArray count]-2)
		{
			if([[eventInfoArray objectAtIndex:[eventInfoArray count]-2]objectForKey:@"trigDeviceID"]!=nil)
			{
				eventInfoTriggerId = [[[eventInfoArray objectAtIndex:[eventInfoArray count]-2]objectForKey:@"trigDeviceID"] intValue];
				if(triggerId == eventInfoTriggerId)
				{
					[g_popupEventsInfoArray addObject:[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:j]];
				}
			}
		}
	}
	
	if([g_popupEventsInfoArray count]==0)
	{
		//IF count is zero show initialize screen
		messageLabel.hidden = NO;
		popupScrollView.hidden = YES;
		eventInitializeBtn.hidden = NO;
		eventInitializeCloseBtn.hidden = NO;
		messageLabel.text = @"Device not initialized ,click the INITIALIZE button to create the events for each button.";
	}
	else
	{
		//Show popup list of events 
		messageLabel.hidden = YES;
		popupScrollView.hidden = NO;
		eventInitializeBtn.hidden = YES;
		eventInitializeCloseBtn.hidden = NO;
		[self sceneMaintenanceArrayFilled];
		[self loadPopupAllEvents:g_popupEventsInfoArray];
		
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

-(void)loadAllEvents:(NSMutableArray*)eventArr
{
	UIImage *DeviceImage;
	int x=10,y=0,nEventCount =0;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [scrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	
	for(int i=0;i<[eventArr count];i++)
	{
		UIButton * eventBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		eventBtn.frame = CGRectMake(x+20, y, 100, 100);
		[eventBtn setTag:i];
		DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceType:[[[eventArr objectAtIndex:i]objectForKey:@"deviceType"]intValue]:UNKNOWN];
		[eventBtn setBackgroundImage:DeviceImage forState:UIControlStateNormal];
		[eventBtn addTarget:self action:@selector(EventSelect:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:eventBtn];
		[eventBtn release];
		
		id value;
		NSMutableString *str = [[NSMutableString alloc]initWithCapacity:255];
		RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(x-5, y+115, 155, 250)];
		lbl3.textColor = [UIColor whiteColor];
		lbl3.backgroundColor = [UIColor clearColor];
		lbl3.textAlignment = UITextAlignmentCenter;
		lbl3.lineBreakMode = UILineBreakModeWordWrap;
		lbl3.numberOfLines = 0;
		lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		value = [NSMutableString stringWithString:[[eventArr objectAtIndex:i]objectForKey:@"name"]];
		[value replaceOccurrencesOfString:@"-" withString:@"\n" options:0 range:NSMakeRange(0,[value length] )];
		[str appendFormat:@"%@", value];
		lbl3.text = str;
		lbl3.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		//lbl3.glowColor = [UIColor colorWithRed:1.0 green:0.70 blue:1.0 alpha:1.0];
		lbl3.glowOffset = CGSizeMake(0.0, 0.0);
		lbl3.glowAmount = 10.0;
		[self alignLabelWithTop:lbl3];
		[scrollView addSubview:lbl3];
		[lbl3 release];
		[str release];
		x = x+130+40;
		nEventCount++;
		if(nEventCount == 5 || i == [eventArr count]-1)
		{
			nEventCount = 0;
			x=0;
			y=y+200;
			[scrollView setContentSize:CGSizeMake(840, y)];
		}
	}
}

-(void)loadPopupAllEvents:(NSMutableArray*)eventArr
{
	int y=20;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [popupScrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	for(int i=0;i<[eventArr count];i++)
	{
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, y, 90, 30)];
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.numberOfLines = 0;
		label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
		
		if(isSceneController)
			label.text = [@"Button" stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]];
		else
		{
			NSMutableArray *subArray = [eventArr objectAtIndex:i];
			if([[subArray objectAtIndex:[subArray count]-2]objectForKey:@"trigReasonID"]!=nil)
			{
				if([[[subArray objectAtIndex:[subArray count]-2]objectForKey:@"trigReasonID"] intValue] == PresenceDetectorTriggerReasons_ON)
					label.text = @"ON Trigger";
				else if([[[subArray objectAtIndex:[subArray count]-2]objectForKey:@"trigReasonID"] intValue] == PresenceDetectorTriggerReasons_OFF)
					label.text = @"OFF Trigger";
				else if([[[subArray objectAtIndex:[subArray count]-2]objectForKey:@"trigReasonString"] isEqualToString:@"when the device is turned on"])
					label.text = @"ON Trigger";
				else if([[[subArray objectAtIndex:[subArray count]-2]objectForKey:@"trigReasonString"] isEqualToString:@"when the device is turned off"])
					label.text = @"OFF Trigger";
			}
		}
		
		[popupScrollView addSubview:label];
		[label release];
		
		UITextField *sceneTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, y, 160, 30)];
		sceneTextField.borderStyle = UITextBorderStyleNone;
		sceneTextField.userInteractionEnabled = NO;
		sceneTextField.backgroundColor = [UIColor whiteColor];
		sceneTextField.text = [[sceneMaintenanceArray objectAtIndex:i] objectForKey:@"currentSceneName"];
		[popupScrollView addSubview:sceneTextField];
		[sceneTextField release];
		
		UIButton * comboBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		comboBtn.frame = CGRectMake(278, y-1, 26, 33);
		[comboBtn setTag:i];
		[comboBtn setBackgroundImage:[UIImage imageNamed:@"Combo_Box.png"] forState:UIControlStateNormal];
		[comboBtn addTarget:self action:@selector(ComboSelect:) forControlEvents:UIControlEventTouchUpInside];
		[popupScrollView addSubview:comboBtn];
		[comboBtn release];
		
		UIButton * removeBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		removeBtn.frame = CGRectMake(320, y, 40, 30);
		[removeBtn setTag:i];
		[removeBtn setBackgroundImage:[UIImage imageNamed:@"scene_device_toggle_selected_up.png"] forState:UIControlStateNormal];
		[removeBtn addTarget:self action:@selector(removeSelect:) forControlEvents:UIControlEventTouchUpInside];
		[popupScrollView addSubview:removeBtn];
		[removeBtn release];
		
		UIButton * settingBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		settingBtn.frame = CGRectMake(370, y, 40, 30);
		[settingBtn setTag:i];
		[settingBtn setBackgroundImage:[UIImage imageNamed:@"eventSetting.png"] forState:UIControlStateNormal];
		[settingBtn addTarget:self action:@selector(settingSelect:) forControlEvents:UIControlEventTouchUpInside];
		[popupScrollView addSubview:settingBtn];
		[settingBtn release];
		
		y = y + 60;
		[popupScrollView setContentSize:CGSizeMake(440, y)];
	}
}

#pragma mark -
#pragma mark PICKER DELEGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1; // We only need one column so we will return 1.
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	return [localScenesArray count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	return [[localScenesArray objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
	scenePickerRowIndex = row;
}


#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

//Combo box select
-(void)ComboSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	selectedPickerIndex = btn.tag;
	
	NSString *sceneName = [[sceneMaintenanceArray objectAtIndex:btn.tag]objectForKey:@"currentSceneName"];
	
	//Check index of scene name in scenelist array
	for(int i=0;i<[localScenesArray count];i++)
	{
		NSString *scene = [[localScenesArray objectAtIndex:i] objectForKey:@"name"];
		if([scene isEqualToString:sceneName])
		{
			[scenesPicker selectRow:i inComponent:0 animated:NO];
			break;
		}
	}
	
	isFromTimePicker=NO;isToTimePicker=NO;isScenePicker=YES;
	
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
}

-(void)ExcludeorincludeScene
{
	[self showLoadingView];
	includeTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													  target:self 
													selector:@selector(IncludeSceneTask) 
													userInfo:nil 
													 repeats:YES];
	includeEnum = NONE;
}

-(void)IncludeSceneTask
{
	switch(includeEnum)
	{
		case NONE:
		{
			//Load change mask for corresponding schedule
			//_changeMask = [[[maintenanceArray objectAtIndex:0] objectForKey:@"_changeMask"] intValue];
			includeEnum = EXCLUDE_SCENE_EVENT;
			break;
			
		}
		case EXCLUDE_SCENE_EVENT:
		{
			NSMutableDictionary *dict = [sceneMaintenanceArray objectAtIndex:selectedPickerIndex];
			if(![[dict objectForKey:@"previousSceneName"] isEqualToString:[[sceneMaintenanceArray objectAtIndex:selectedPickerIndex]objectForKey:@"currentSceneName"]])
			{
				if(![[dict objectForKey:@"previousSceneName"] isEqualToString:@""])
				{
					//EVENT_SCENE_INCLUDE command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					[commandDictionary setObject:[dict objectForKey:@"id"] forKey:@"intoID"];
					[commandDictionary setObject:[dict objectForKey:@"previousSceneId"] forKey:@"scene"];
					[commandDictionary setObject:@"0" forKey:@"include"];
					[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
					[commandDictionary release];
					includeEnum = PROCESSING_SCH_EXCLUDE_SCHUDLE_FROM_SCENE;
				}
				else
					includeEnum = INCLUDE_SCENE_EVENT;
			}
			else
				includeEnum = INCLUDE_SCENE_EVENT;
			break;
		}
		case INCLUDE_SCENE_EVENT:
		{
			NSMutableDictionary *dict = [sceneMaintenanceArray objectAtIndex:selectedPickerIndex];
			if([[dict objectForKey:@"previousSceneName"] isEqualToString:[[sceneMaintenanceArray objectAtIndex:selectedPickerIndex]objectForKey:@"currentSceneName"]])
			{
				includeEnum = DONE;
			}
			else
			{
				//EVENT_SCENE_INCLUDE command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[dict objectForKey:@"id"] forKey:@"intoID"];
				[commandDictionary setObject:[dict objectForKey:@"currentSceneId"] forKey:@"scene"];
				[commandDictionary setObject:@"1" forKey:@"include"];
				[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
				[commandDictionary release];
				includeEnum = PROCESSING_SCH_INCLUDE_SCHUDLE_TO_SCENE;
			}
			break;
		}
		case DONE:
		{
			[includeTimer invalidate];
			includeTimer=nil;
			[self loadPopupAllEvents:g_popupEventsInfoArray];
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}


//Combo box select
-(void)removeSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	NSMutableDictionary *dict = [sceneMaintenanceArray objectAtIndex:btn.tag];
	
	if([[dict objectForKey:@"currentSceneName"] isEqualToString:@""])
		return;
	else
	{
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:[dict objectForKey:@"id"] forKey:@"intoID"];
		[commandDictionary setObject:[dict objectForKey:@"currentSceneId"] forKey:@"scene"];
		[commandDictionary setObject:@"0" forKey:@"include"];
		[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
		[commandDictionary release];
	}
}

//Combo box select
-(void)settingSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	eventSelectedIndex = btn.tag;
	
	isSingleEventInfo = YES;
	popupEventTimeView.frame = CGRectMake(660, 277, 406, 369);
	[self.view addSubview:popupEventTimeView];
	[self showLoadingView];
	NSMutableArray *subArray = [g_popupEventsInfoArray objectAtIndex:btn.tag];
	if([subArray count]>0)
		[[EventsService getSharedInstance]getInfo:[[subArray objectAtIndex:0]objectForKey:@"id"] :self];
}

-(void)EventSelect:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	eventSelectedIndex = btn.tag;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [popupScrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	
	int deviceType = [[[g_triggerDevicesList objectAtIndex:btn.tag]objectForKey:@"deviceType"] intValue];
	if ( deviceType == SCENE_CONTROLLER_PORTABLE ||  deviceType == SCENE_CONTROLLER_THREE  ||  deviceType == SCENE_CONTROLLER )
	{
		//_triggerEditor = new SceneControllerConfiguratorEditor ();
		//skin=SceneControllerConfiguratorEditorSkin as Class; 
		isSceneController = YES;
	}
	else if ( deviceType == BINARY_SENSOR_TWO ||  deviceType == BINARY_SWITCH  || deviceType == MULTILEVEL_SWITCH|| deviceType == REMOTE_SWITCH)
	{
		//_triggerEditor = new PresenceDetectorConfigurationEditor();
		//skin=PresenceDetectorConfigurationEditorSkin as Class;
		isSceneController = NO;
	}
	else if (deviceType == BULOGICS_CORE ) return;

	//popupNameLabel.text = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"name"];
	//[self.view addSubview:popupEventView];
	
	
	[self.view addSubview:popupEventView];
	popupScrollView.hidden = YES;
	messageLabel.hidden = NO;
	messageLabel.text = @"Retrieving Data";
	popupNameLabel.text = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"name"];
	eventInitializeBtn.hidden = YES;
	eventInitializeCloseBtn.hidden = YES;
	
	[self startTimer];
	
	
	//[self FillPopupArray];
}

-(IBAction)popupEventViewClose:(id)sender
{
	[popupEventView removeFromSuperview];
}

#pragma mark -
#pragma mark EVENT INITIALIZE FUNCTION


-(IBAction)eventInitializeCloseBtnClicked:(id)sender
{
	[popupEventView removeFromSuperview];
}

-(IBAction)eventInitializeBtnClicked:(id)sender
{
	[self showLoadingView];
	if(isSceneController)
	{
		eventInitializeTimer = [NSTimer scheduledTimerWithTimeInterval:0 
																target:self 
															  selector:@selector(eventInitializeSceneControllerTask) 
															  userInfo:nil 
															   repeats:YES];
		eventInitializeEnum = NONE;
		buttonCount = 0;
	}
	else
	{
		eventInitializeTimer = [NSTimer scheduledTimerWithTimeInterval:0 
																target:self 
															  selector:@selector(eventInitializeDefaultTask) 
															  userInfo:nil 
															   repeats:YES];
		eventInitializeEnum = NONE;
	}
}

-(void)eventInitializeSceneControllerTask
{
	switch(eventInitializeEnum)
	{
		case NONE:
		{
			eventInitializeEnum = SCENE_CTRLR_GET;
			break;
		}
		case SCENE_CTRLR_GET:
		{
			[[SceneControllerSevice getSharedInstance]getController:[[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"] :self];
			eventInitializeEnum = PROCESSING;
		}
		case SCENE_CTRLR_GET_DONE:
		{
			eventInitializeEnum = GET_TRIGGER_DEVICE_LIST;
		}
		case GET_TRIGGER_DEVICE_LIST:
		{
			[[EventsService getSharedInstance]getTriggerDevicesList:self];
			eventInitializeEnum = PROCESSING;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST_DONE:
		{
			eventInitializeEnum = GET_TRIGGERREASONLISTBYID;
			break;
		}
		case GET_TRIGGERREASONLISTBYID:
		{
			NSString *ID = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"];
			[[EventsService getSharedInstance]getTriggerReasonListById:ID :self];
			eventInitializeEnum = PROCESSING;
			break;
		}
		case GET_TRIGGERREASONLISTBYID_DONE:
		{
			eventInitializeEnum = BULOGICS_EVENT_ADD;
			buttonCount = 0;
			break;
		}
		//5 TIMES LOOP THE EVENT ADD AND STORE ITS RESULT ARRAY
		case BULOGICS_EVENT_ADD:
		{
			NSString *deviceName = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"name"];
			NSArray *array = [deviceName componentsSeparatedByString:@"-"];
			if([array count]>0)
			{
				deviceName = [[array objectAtIndex:0] stringByAppendingString:@" Button"];
				deviceName = [deviceName stringByAppendingString:[NSString stringWithFormat:@"%d",buttonCount]];
			}
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:deviceName forKey:@"name"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"127" forKey:@"daysActiveMask"];
			[[EventsService getSharedInstance]add:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = BULOGICS_EVENT_ADD_PROCESSING;
			break;
		}
		case BULOGICS_EVENT_ADD_DONE:
		{
			if(buttonCount>=5)
			{
				eventInitializeEnum = SET_TRIGGERDEVICE;
				buttonCount = 0;
			}
			else
				eventInitializeEnum = BULOGICS_EVENT_ADD;
			break;
		}
		case SET_TRIGGERDEVICE:
		{
			NSString *eventID = @"";
			switch (buttonCount) {
				case 0:
				{
					eventID = [[button1Array objectAtIndex:0]objectForKey:@"id"];
					break;
				}
				case 1:
				{
					eventID = [[button2Array objectAtIndex:0]objectForKey:@"id"];
					break;
				}
				case 2:
				{
					eventID = [[button3Array objectAtIndex:0]objectForKey:@"id"];
					break;
				}
				case 3:
				{
					eventID = [[button4Array objectAtIndex:0]objectForKey:@"id"];
					break;
				}
				case 4:
				{
					eventID = [[button5Array objectAtIndex:0]objectForKey:@"id"];
					break;
				}
				default:
					break;
			}
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:eventID forKey:@"eventID"];
			[commandDictionary setObject:[[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"] forKey:@"deviceID"];
			[[EventsService getSharedInstance]setTriggerDevice:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_DONE:
		{
			if(buttonCount>=5)
			{
				eventInitializeEnum = SET_TRIGGERDEVICE_REASON;
				buttonCount = 0;
			}
			else
				eventInitializeEnum = SET_TRIGGERDEVICE;
			break;
		}
		case SET_TRIGGERDEVICE_REASON:
		{
			NSString *eventID = @"",*reasonID=@"";
			switch (buttonCount) {
				case 0:
				{
					eventID = [[button1Array objectAtIndex:0]objectForKey:@"id"];
					reasonID = @"1";
					break;
				}
				case 1:
				{
					eventID = [[button2Array objectAtIndex:0]objectForKey:@"id"];
					reasonID = @"2";
					break;
				}
				case 2:
				{
					eventID = [[button3Array objectAtIndex:0]objectForKey:@"id"];
					reasonID = @"3";
					break;
				}
				case 3:
				{
					eventID = [[button4Array objectAtIndex:0]objectForKey:@"id"];
					reasonID = @"4";
					break;
				}
				case 4:
				{
					eventID = [[button5Array objectAtIndex:0]objectForKey:@"id"];
					reasonID = @"5";
					break;
				}
				default:
					break;
			}
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:eventID forKey:@"eventID"];
			[commandDictionary setObject:reasonID forKey:@"reasonID"];
			[[EventsService getSharedInstance]setTriggerDeviceReason:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_REASON_DONE:
		{
			if(buttonCount>=5)
			{
				eventInitializeEnum = DONE;
				buttonCount = 0;
			}
			else
				eventInitializeEnum = SET_TRIGGERDEVICE_REASON;
			break;
		}
		case DONE:
		{
			[eventInitializeTimer invalidate];
			eventInitializeTimer=nil;
			[self hideLoadingView];
			[popupEventView removeFromSuperview];
			break;
		}
		default:
			break;
	}
}


-(void)eventInitializeDefaultTask
{
	switch(eventInitializeEnum)
	{
		case NONE:
		{
			eventInitializeEnum = GET_TRIGGER_DEVICE_LIST;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST:
		{
			[[EventsService getSharedInstance]getTriggerDevicesList:self];
			eventInitializeEnum = PROCESSING;
			break;
		}
		case GET_TRIGGER_DEVICE_LIST_DONE:
		{
			eventInitializeEnum = GET_TRIGGERREASONLISTBYID;
			break;
		}
		case GET_TRIGGERREASONLISTBYID:
		{
			NSString *ID = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"];
			[[EventsService getSharedInstance]getTriggerReasonListById:ID :self];
			eventInitializeEnum = PROCESSING;
			break;
		}
		case GET_TRIGGERREASONLISTBYID_DONE:
		{
			eventInitializeEnum = TRIGGERDEVICE_ON;
			break;
		}
		case TRIGGERDEVICE_ON:
		{
			NSString *deviceName = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"name"];
			NSArray *array = [deviceName componentsSeparatedByString:@"-"];
			if([array count]>0)
				deviceName = [[array objectAtIndex:0] stringByAppendingString:@" ON"];
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:deviceName forKey:@"name"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"127" forKey:@"daysActiveMask"];
			[[EventsService getSharedInstance]add:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = TRIGGERDEVICE_ON_PROCESSING;
			break;
		}
		case TRIGGERDEVICE_ON_DONE:
		{
			eventInitializeEnum = TRIGGERDEVICE_OFF;
			break;
		}
		case TRIGGERDEVICE_OFF:
		{
			NSString *deviceName = [[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"name"];
			NSArray *array = [deviceName componentsSeparatedByString:@"-"];
			if([array count]>0)
				deviceName = [[array objectAtIndex:0] stringByAppendingString:@" OFF"];
			
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:deviceName forKey:@"name"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"127" forKey:@"daysActiveMask"];
			[[EventsService getSharedInstance]add:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = TRIGGERDEVICE_OFF_PROCESSING;
			break;
		}
		case TRIGGERDEVICE_OFF_DONE:
		{
			eventInitializeEnum = SET_TRIGGERDEVICE_ON;
			break;
		}
		case SET_TRIGGERDEVICE_ON:
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[deviceONIdArray objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
			[commandDictionary setObject:[[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"] forKey:@"deviceID"];
			[[EventsService getSharedInstance]setTriggerDevice:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_ON_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_ON_DONE:
		{
			eventInitializeEnum = SET_TRIGGERDEVICE_OFF;
			break;
		}
		case SET_TRIGGERDEVICE_OFF:
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[deviceOFFIdArray objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
			[commandDictionary setObject:[[g_triggerDevicesList objectAtIndex:eventSelectedIndex]objectForKey:@"id"] forKey:@"deviceID"];
			[[EventsService getSharedInstance]setTriggerDevice:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_OFF_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_OFF_DONE:
		{
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_ON;
			break;
		}
		case SET_TRIGGERDEVICE_REASON_ON:
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[deviceONIdArray objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
			[commandDictionary setObject:@"1" forKey:@"reasonID"];
			[[EventsService getSharedInstance]setTriggerDeviceReason:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_ON_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_REASON_ON_DONE:
		{
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_OFF;
			break;
		}
		case SET_TRIGGERDEVICE_REASON_OFF:
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[deviceOFFIdArray objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
			[commandDictionary setObject:@"2" forKey:@"reasonID"];
			[[EventsService getSharedInstance]setTriggerDeviceReason:commandDictionary :self];
			[commandDictionary release];
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_OFF_PROCESSING;
			break;
		}
		case SET_TRIGGERDEVICE_REASON_OFF_DONE:
		{
			eventInitializeEnum = DONE;
			break;
		}
		case DONE:
		{
			[eventInitializeTimer invalidate];
			eventInitializeTimer=nil;
			[self hideLoadingView];
			[popupEventView removeFromSuperview];
			break;
		}
		default:
			break;
	}
}



#pragma mark -
#pragma mark TIMER POPUPVIEW SAVE/CLOSE/RESET

-(IBAction)popupEventTimeViewClose:(id)sender
{
	[popupEventTimeView removeFromSuperview];
}
-(IBAction)popupEventTimeViewSave:(id)sender
{
	[self saveEventChangeOneByOne];
}

-(IBAction)popupEventTimeViewReset:(id)sender
{
	[self InitializeAndMaintainDefaultSceneInfoValues];
}

-(void)saveEventChangeOneByOne
{
	[self showLoadingView];
	eventSaveTimer = [NSTimer scheduledTimerWithTimeInterval:0 
														 target:self 
													   selector:@selector(eventSaveTask) 
													   userInfo:nil 
														repeats:YES];
	eventSaveEnum = NONE;
}


-(void)eventSaveTask
{
	switch(eventSaveEnum)
	{
		case NONE:
		{
			//Load change mask for corresponding schedule
			_changeMask = [[[maintenanceArray objectAtIndex:0] objectForKey:@"_changeMask"] intValue];
			eventSaveEnum = SCH_SET_DAYS_MASK;
			break;
			
		}
		case SCH_SET_DAYS_MASK:
		{
			//Need to set up the tasks for the save based on the change mask
			if (_changeMask & DAY_MASK)
			{
				//EVENT_SET_DAYS_MASK command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:@"0" forKey:@"sunriseSunsetOffset"];
				[commandDictionary setObject:@"0" forKey:@"numScenesInEvent"];
				[commandDictionary setObject:[[maintenanceArray objectAtIndex:0] objectForKey:@"daysActiveMask"] forKey:@"daysActiveMask"];
				[commandDictionary setObject:@"1" forKey:@"sunriseOrSunset"];
				[commandDictionary setObject:@"false" forKey:@"enabled"];
				[commandDictionary setObject:@"0" forKey:@"numCondsInEvent"];
				[commandDictionary setObject:[[maintenanceArray	objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
				[[EventsService getSharedInstance]setDaysMask:commandDictionary :self];
				[commandDictionary release];
				
				eventSaveEnum = PROCESSING;
			}
			else
				eventSaveEnum = SCH_SET_TIME_TYPE;
			
			break;
		}
		case SCH_SET_TIME_TYPE:
		{
			//Add the task to change the randomize setting of the schedule
			if (_changeMask & TIME_TYPE)
			{
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[maintenanceArray objectAtIndex:0]objectForKey:@"condType"] forKey:@"condType"];
				[commandDictionary setObject:@"0" forKey:@"timeStart"];
				[commandDictionary setObject:@"0" forKey:@"id"];
				[commandDictionary setObject:[[maintenanceArray	objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
				[commandDictionary setObject:@"0" forKey:@"trigDeviceID"];
				[commandDictionary setObject:@"0" forKey:@"trigReasonID"];
				[commandDictionary setObject:@"0" forKey:@"timeEnd"];
				[[EventsService getSharedInstance]setTimeType:commandDictionary :self];
				[commandDictionary release];
				
				eventSaveEnum = PROCESSING;
			}
			else 
				eventSaveEnum = SCH_START_CHANGE;
			break;
		}
		case SCH_START_CHANGE:
		{
			//Add the start change 
			if ( (_changeMask & TIME_START) || (_changeMask & TIME_END) )
			{
				//EVENT_SET_TIME command 
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:@"0" forKey:@"condType"];
				[commandDictionary setObject:[[maintenanceArray objectAtIndex:0]objectForKey:@"timeStart"] forKey:@"timeStart"];
				[commandDictionary setObject:@"0" forKey:@"id"];
				[commandDictionary setObject:[[maintenanceArray objectAtIndex:0]objectForKey:@"id"] forKey:@"eventID"];
				[commandDictionary setObject:@"0" forKey:@"trigDeviceID"];
				[commandDictionary setObject:@"0" forKey:@"trigReasonID"];
				[commandDictionary setObject:[[maintenanceArray objectAtIndex:0]objectForKey:@"timeEnd"] forKey:@"timeEnd"];
				[[EventsService getSharedInstance]setTime:commandDictionary :self];
				[commandDictionary release];
				
				eventSaveEnum = PROCESSING;				
			}
			else {
				eventSaveEnum = EVENT_INFO;
			}
			
			break;
		}
		case EVENT_INFO:
		{
			[[EventsService getSharedInstance]getInfo:[[maintenanceArray objectAtIndex:0]objectForKey:@"id"] :self];
			eventSaveEnum = PROCESSING;	
			break;
		}
		case DONE:
		{
			[eventSaveTimer invalidate];
			eventSaveTimer=nil;
			[self InitializeAndMaintainDefaultSceneInfoValues];
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR DAYMASK CHANGE BUTTON CLICK EVENT

-(IBAction)sunBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :1 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)monBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :2 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)tueBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :3 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)wedBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :4 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)thuBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :5 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)friBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :6 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)satBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :7 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
}
-(IBAction)allBtnClicked:(id)sender
{	
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"daysActiveMask"] intValue] :8 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_sunBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"sunbtnselected"];
		}
		else
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_monBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"monbtnselected"];
		}
		else
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_tueBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"tuebtnselected"];
		}
		else
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_wedBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"wedbtnselected"];
		}
		else
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_thuBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"thubtnselected"];
		}
		else
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_friBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"fribtnselected"];
		}
		else
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
		if([g_satBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-selected.png"])
		{
			[dict setObject:@"YES" forKey:@"satbtnselected"];
		}
		else
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"sunbtnselected"] isEqualToString:@"YES"])
		{
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"monbtnselected"] isEqualToString:@"YES"])
		{
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"tuebtnselected"] isEqualToString:@"YES"])
		{
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"wedbtnselected"] isEqualToString:@"YES"])
		{
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"thubtnselected"] isEqualToString:@"YES"])
		{
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"fribtnselected"] isEqualToString:@"YES"])
		{
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"satbtnselected"] isEqualToString:@"YES"])
		{
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	}
}


#pragma mark -
#pragma mark HANDLERS FOR SET CHANGED STATE HANDLERS

//Set weekday button selected state
-(void)setWeekdayButtonSelectedState:(int)_currentDays
{		
	if(_currentDays & SUNDAY )
		[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & MONDAY )
		[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & TUESDAY )
		[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & WEDNESDAY )
		[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & THURSDAY )
		[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & FRIDAY )
		[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if(_currentDays & SATURDAY )
		[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	
	if ( _currentDays == 127 )
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
}

-(void)setActivationTime:(NSString*)strTime:(NSString*)keyField
{
	NSString *typoString = @"";
	[[TimeConverterUtil getSharedInstance]convertTimeFromMinutesAfterMidnight:[strTime intValue]];
	int hours =[[TimeConverterUtil getSharedInstance]getHours];
	int mins	=[[TimeConverterUtil getSharedInstance]getMinutes];
	//Determine the values for the ampm group
	if ( hours >= 12 )
		typoString = @"PM";
	else
		typoString = @"AM";
	
	//Determin the value for the hours property
	if ( hours > 13 )
	{
		hours = hours - 12;
	}
	//Last check..if the get hours is equivalant to 0 then we are 
	//going to just store the hours as 12
	if ( hours == 0 )
		hours = 12;
	
	NSString *minutes = [NSString stringWithFormat:@"%d",mins];
	if([minutes length]==1)
		minutes = [@"0" stringByAppendingString:minutes];
	
	NSString *strFormat = [[NSString stringWithFormat:@"%d",hours] stringByAppendingString:@":"];
	strFormat = [strFormat stringByAppendingString:minutes];
	strFormat = [strFormat stringByAppendingString:@" "];
	strFormat = [strFormat stringByAppendingString:typoString];
	[maintenanceDictionary setObject:strFormat forKey:keyField];
}

-(void)handleDayClick :(int)_currentDays :(int)DayNoofWeek :(NSMutableDictionary*)dict
{
	int _cachedDays;
	switch ( DayNoofWeek )
	{
		case 1:
			_currentDays=_currentDays ^ SUNDAY;
			break;
		case 2:
			_currentDays=_currentDays ^ MONDAY;
			break;
		case 3:
			_currentDays=_currentDays ^ TUESDAY;
			break;
		case 4:
			_currentDays=_currentDays ^ WEDNESDAY;
			break;
		case 5:
			_currentDays=_currentDays ^ THURSDAY;
			break;
		case 6:
			_currentDays=_currentDays ^ FRIDAY;
			break;
		case 7:
			_currentDays=_currentDays ^ SATURDAY;
			break;
		case 8:
			if ( _currentDays == ALL )
				_currentDays=_cachedDays;
			else
			{
				_cachedDays=_currentDays;
				_currentDays=ALL;
			}
			break;
	}
	
	[self changeDaysActiveMask:_currentDays :dict];
}

-(void)handleConditionChange:(int)timeType:(NSMutableDictionary*)dictionary
{	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	if ( !( _changeMask & TIME_TYPE ) ) 
		_changeMask = _changeMask ^ TIME_TYPE;
	
	if ( ( [[dictionary objectForKey:@"condType"] intValue] == timeType ) && ( _changeMask & TIME_TYPE ) )
		_changeMask = _changeMask ^ TIME_TYPE;
	
	
	//Store the new value
	[dictionary setObject:[NSString stringWithFormat:@"%d",timeType] forKey:@"condType"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
}

-(void)handleTimeStartChange:(NSMutableDictionary*)dictionary
{
	//Now that we are changing the activate time, we are 
	//going to need to pass in the information to the
	
	int currentTimeinSec=0;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh:mm a"];
	NSDate *date = [dateFormatter dateFromString:[dictionary objectForKey:@"timeStartText"]];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:date];
	NSInteger hour = [components hour];
	NSInteger minute = [components minute];
	[dateFormatter release];
	
	currentTimeinSec = [[TimeConverterUtil getSharedInstance]convertTimeToMinutesAfterMidnight:hour :minute];

	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set the change mask if it is not currently set
	if ( !( _changeMask & TIME_START ) )
		_changeMask = _changeMask ^ TIME_START;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"timeStart"] intValue] == currentTimeinSec ) && ( _changeMask & TIME_START ) )
		_changeMask = _changeMask ^ TIME_START;
	
	//Store the new value
	[dictionary setObject:[NSString stringWithFormat:@"%d",currentTimeinSec] forKey:@"timeStart"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	//Need to dispatch an event that the info changedNS
	//dispatchEvent ( new Event ( Event.CHANGE ) );
	
	saveBtn.enabled = YES;resetBtn.enabled = YES;
}

-(void)handleTimeEndChange:(NSMutableDictionary*)dictionary
{
	//Now that we are changing the activate time, we are 
	//going to need to pass in the information to the
	
	int currentTimeinSec=0,hours;
	NSString *currentTimeString = [dictionary objectForKey:@"timeStartText"];
	
	if ([currentTimeString rangeOfString:@"AM"].location == NSNotFound) 
		hours = 12;
	else
		hours = 0;
	
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@"AM" withString:@""];
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@"PM" withString:@""];
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	NSArray *HousMins = [currentTimeString componentsSeparatedByString:@":"];
	if([HousMins count]>1)
	{
		hours+= [[HousMins objectAtIndex:0]intValue];
		currentTimeinSec = [[TimeConverterUtil getSharedInstance]convertTimeToMinutesAfterMidnight:hours :[[HousMins objectAtIndex:1]intValue]];
	}
	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set the change mask if it is not currently set
	if ( !( _changeMask & TIME_END ) )
		_changeMask = _changeMask ^ TIME_END;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"timeStart"] intValue] == currentTimeinSec ) && ( _changeMask & TIME_END ) )
		_changeMask = _changeMask ^ TIME_END;
	
	//Store the new value
	[dictionary setObject:[NSString stringWithFormat:@"%d",currentTimeinSec] forKey:@"timeStart"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	//Need to dispatch an event that the info changedNS
	//dispatchEvent ( new Event ( Event.CHANGE ) );
	
	saveBtn.enabled = YES;resetBtn.enabled = YES;
	
}

-(void)changeDaysActiveMask:(int)mask :(NSMutableDictionary*)dictionary
{
	//Need to change the value stored for the change mask in 
	int newMaskValue = mask;
	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//ScheduleChangeMaskEnum
	if ( !( _changeMask & DAY_MASK ) )
		_changeMask = _changeMask ^ DAY_MASK;
	
	if ( ( [[dictionary objectForKey:@"daysActiveMask"] intValue] == newMaskValue ) && ( _changeMask & DAY_MASK ) )
	{
		_changeMask = _changeMask ^ DAY_MASK;
	}
	
	[dictionary setObject:[NSString stringWithFormat:@"%d",newMaskValue] forKey:@"daysActiveMask"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	
	saveBtn.enabled = YES;resetBtn.enabled = YES;
}

-(void)changeSelectedScene:(NSString*)strSceneName :(NSString*)strSceneId :(NSMutableDictionary*)dictionary
{
	if( [[dictionary objectForKey:@"currentSceneName"] isEqualToString:@""] && [[dictionary objectForKey:@"previousSceneName"] isEqualToString:@""])
	{
		[dictionary setObject:strSceneName forKey:@"currentSceneName"];
		[dictionary setObject:strSceneId forKey:@"currentSceneId"];
		[dictionary setObject:@"" forKey:@"previousSceneName"];
		[dictionary setObject:@"" forKey:@"previousSceneId"];
	}
	else
	{
		//Store current scenename as previous scene name and id
		[dictionary setObject:[dictionary objectForKey:@"currentSceneName"] forKey:@"previousSceneName"];
		[dictionary setObject:[dictionary objectForKey:@"currentSceneId"] forKey:@"previousSceneId"];
		
		//Store New value changed here
		[dictionary setObject:strSceneName forKey:@"currentSceneName"];
		[dictionary setObject:strSceneId forKey:@"currentSceneId"];
	}
}

#pragma mark -
#pragma mark HOME OCCUPANCY CONTROLS

-(IBAction)enableHomeOccupancyBtnClicked:(id)sender
{
	[self showLoadingView];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	
	//Set id for home occupancy
	if([[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray count]>0)
		[dict setObject:[[[AppDelegate_iPad sharedAppDelegate].g_homeOccupancyArray objectAtIndex:0] objectForKey:@"id"] forKey:@"id"];
	else
		[dict setObject:@"1" forKey:@"id"];
	
	//Set value for home occupancy	
	if(isEnableOccupancy)
		[dict setObject:@"0" forKey:@"value"];
	else
		[dict setObject:@"1" forKey:@"value"];
	
	[[UserService getSharedInstance]HomeOccupationEnable:dict :self];
	[dict release];
}

#pragma mark -
#pragma mark ANIMATION BLOCKS

-(void)OpenWindow
{	
	//Kill all previous timer
	[openTimer invalidate];
    openTimer = nil;
    [closeTimer invalidate];
    closeTimer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CloseWindow) object:nil];
	
	
	animationScrollView.hidden = NO;
	animateImageView.frame = CGRectMake(38, 210, 455, 289);
	yPosition = 210;
	openTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 
												 target:self 
											   selector:@selector(OpenDisplayTask) 
											   userInfo:nil 
												repeats:YES];
}

-(void)OpenDisplayTask
{
	yPosition-=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(38, yPosition, 455, 289);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=25)
	{
		yPosition = 25;
		[openTimer invalidate];
		openTimer = nil;
		[self performSelector:@selector(CloseWindow) withObject:nil afterDelay:2];
	}
}

-(void)CloseDisplayTask
{
	//Kill open timer
	[openTimer invalidate];
    openTimer = nil;
	
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(38, yPosition, 455, 289);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=210)
	{
		yPosition = 210;
		[closeTimer invalidate];
		closeTimer = nil;
		animationScrollView.hidden = YES;
	}
}

-(void)CloseWindow
{
	closeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02  
												  target:self 
												selector:@selector(CloseDisplayTask) 
												userInfo:nil 
												 repeats:YES];
}



#pragma mark -
#pragma mark INITIALIZE DEFAULTS/ RESET 

-(void)InitializeAndMaintainDefaultSceneInfoValues
{
	if([maintenanceArray count]>0)
		[maintenanceArray removeAllObjects];
	
	maintenanceDictionary = [[NSMutableDictionary alloc]init];
	
	if([temp_infoArray count]>2)
	{
		[maintenanceDictionary setObject:[[temp_infoArray objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
		[maintenanceDictionary setObject:[[temp_infoArray objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"daysActiveMask"];
		[maintenanceDictionary setObject:[[temp_infoArray objectAtIndex:[temp_infoArray count]-1]objectForKey:@"condType"] forKey:@"condType"];
		[maintenanceDictionary setObject:[[temp_infoArray objectAtIndex:[temp_infoArray count]-1]objectForKey:@"timeStart"] forKey:@"timeStart"];
		[self setActivationTime:[[temp_infoArray objectAtIndex:[temp_infoArray count]-1]objectForKey:@"timeStart"]:@"timeStartText"];
		[maintenanceDictionary setObject:[[temp_infoArray objectAtIndex:[temp_infoArray count]-1]objectForKey:@"timeEnd"] forKey:@"timeEnd"];
		[self setActivationTime:[[temp_infoArray objectAtIndex:[temp_infoArray count]-1]objectForKey:@"timeEnd"]:@"timeEndText"];
		[maintenanceDictionary setObject:@"0" forKey:@"_changeMask"];
	}
	
	[maintenanceArray addObject:maintenanceDictionary];
	[maintenanceDictionary release];
	[self FillPopUPTimeView];
}


-(void)FillPopUPTimeView
{
	saveBtn.enabled = NO; resetBtn.enabled = NO;
	isLoadingTimeLineView = YES;
	if([maintenanceArray count]>0)
	{
		[self setWeekdayButtonSelectedState:[[[maintenanceArray objectAtIndex:0]objectForKey:@"daysActiveMask"]intValue]];
		segControl.selectedSegmentIndex = [[[maintenanceArray objectAtIndex:0]objectForKey:@"condType"]intValue];
		fromTimeTextField.text = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeStartText"];
		toTimeTextField.text = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeEndText"];
	}
	isLoadingTimeLineView = NO;
}

-(IBAction)ChangeSegmentAction:(id)sender
{
	if(!isLoadingTimeLineView)
	{
		switch (segControl.selectedSegmentIndex) {
			case 0:
			{
				fromTimeTextField.enabled = NO;
				fromTimeBtn.enabled = NO;
				toTimeTextField.enabled = NO;
				toTimeBtn.enabled = NO;
				break;
			}
			case 1:
			{
				fromTimeTextField.enabled = YES;
				fromTimeBtn.enabled = YES;
				toTimeTextField.enabled = NO;
				toTimeBtn.enabled = NO;
				break;
			}
			case 2:
			{
				fromTimeTextField.enabled = YES;
				fromTimeBtn.enabled = YES;
				toTimeTextField.enabled = NO;
				toTimeBtn.enabled = NO;
				break;
			}
			case 3:
			{
				fromTimeTextField.enabled = YES;
				fromTimeBtn.enabled = YES;
				toTimeTextField.enabled = YES;
				toTimeBtn.enabled = YES;
				break;
			}
			default:
				break;
		}
		
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
		[self handleConditionChange:segControl.selectedSegmentIndex :dict];

	}
}

#pragma mark -
#pragma mark ALL PICKER FUNCTIONS

-(IBAction)pickerOkClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
	if(isFromTimePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		[dict setObject:[dateFormatter stringFromDate:fromTimePicker.date] forKey:@"timeStartText"];
		
		//Set changed current time in maintenance dict
		[self handleTimeStartChange:dict];
		
		fromTimeTextField.text = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeStartText"];
		
		[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
		[dateFormatter release];
	}
	else if(isToTimePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		[dict setObject:[dateFormatter stringFromDate:toTimePicker.date] forKey:@"timeEndText"];
		
		//Set changed current time in maintenance dict
		[self handleTimeEndChange:dict];
		
		toTimeTextField.text = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeEndText"];
		
		[maintenanceArray replaceObjectAtIndex:0 withObject:dict];
		[dateFormatter release];
	}
	else if(isScenePicker)
	{
		NSMutableDictionary *dict = [sceneMaintenanceArray objectAtIndex:selectedPickerIndex];
		//set change selected scene in maintenacne dict
		[self changeSelectedScene:[[localScenesArray objectAtIndex:scenePickerRowIndex] objectForKey:@"name"] :[[localScenesArray objectAtIndex:scenePickerRowIndex] objectForKey:@"id"] :dict];
		[sceneMaintenanceArray replaceObjectAtIndex:selectedPickerIndex withObject:dict];
		
		[self ExcludeorincludeScene];
	}
}

-(IBAction)pickerCancelClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
}

-(IBAction)fromTimeBtnClicked:(id)sender
{
	NSString *strTime = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeStartText"];
	if(![strTime isEqualToString:@""]&&strTime!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		fromTimePicker.date = [dateFormatter dateFromString:strTime];
		[dateFormatter release];
	}
	
	isFromTimePicker=YES;isToTimePicker=NO;isScenePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	fromTimePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:fromTimePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
}

-(IBAction)toTimeBtnClicked:(id)sender
{
	NSString *strTime = [[maintenanceArray objectAtIndex:0]objectForKey:@"timeEndText"];
	if(![strTime isEqualToString:@""]&&strTime!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		toTimePicker.date = [dateFormatter dateFromString:strTime];
		[dateFormatter release];
	}
	
	isFromTimePicker=NO;isToTimePicker=YES;isScenePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	toTimePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:toTimePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
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
	[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
}
-(IBAction)DeviceConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view];
}
-(IBAction)SceneConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view];
}
-(IBAction)EventConfigurator:(id)sender
{
}
-(IBAction)ScheduleConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
}

-(IBAction)Homeowner:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetHomeownerViewIndex]) {
			
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
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
#pragma mark GET SCHEDULE EVENT INFO 

-(void)EventInfo
{
	eventInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
													  target:self 
													selector:@selector(EventInfoTask) 
													userInfo:nil 
													 repeats:YES];
	eventEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)EventInfoTask
{
	switch(eventEnum)
	{
		case NONE:
		{
			eventEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				eventEnum = PROCESSING;
			}
			else 
			{
				eventEnum = DONE;
			}
			
			break;
		}
		case EVENT_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count]-1)
			{
				g_objectIndex++;
				eventEnum = EVENT_INFO;
			}
			else
				eventEnum = DONE;
			break;
		}
		case DONE:
		{
			[eventInfoTimer invalidate];
			eventInfoTimer=nil;
			processEnum = EVENT_INFO_DONE;
			break;
		}
		default:
			break;
	}
}

-(void)startTimer
{
	[self showLoadingView];
	ProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
													target:self 
												  selector:@selector(processingTimer) 
												  userInfo:nil 
												   repeats:YES];
	processEnum = NONE;
}

-(void)stopTimer
{
	[ProcessTimer invalidate];
	ProcessTimer=nil;
}

-(void)processingTimer
{
	switch(processEnum)
	{
		case NONE:
		{
			processEnum = GET_EVENT;
			break;
		}
		case GET_EVENT:
		{
			[[EventsService getSharedInstance]getEvents:self];
			processEnum = PROCESSING;
			break;
		}
		case GET_EVENT_DONE:
		{
			//Sorting Schedule Event array
			processEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			processEnum = PROCESSING;
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray count]>0)
				[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray removeAllObjects];
			[self EventInfo];
			break;
		}
		case EVENT_INFO_DONE:
		{
			processEnum = DONE;
		}	
		case DONE:
		{
			[self stopTimer];
			[self FillPopupArray];
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==GET_EVENTS)
	{
		processEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand == HOME_OCCUPANCY_ENABLE)
	{
		[self hideLoadingView];
		if(!isEnableOccupancy)
		{
			isEnableOccupancy = YES;
			[enableHomeOccupancyBtn setImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
		}
		else
		{
			isEnableOccupancy = NO;
			[enableHomeOccupancyBtn setImage:[UIImage imageNamed:@"EmptyBox.png"] forState:UIControlStateNormal];
		}
		[self OpenWindow];
	}
	else if(strCommand == GET_CONTROLLER)
	{
		eventInitializeEnum = SCENE_CTRLR_GET_DONE;
		getSceneControlsArray = [resultArray mutableCopy];
	}
	else if(strCommand == EVENT_GET_TRIGGER_DEVICES_LIST)
	{
		eventInitializeEnum = GET_TRIGGER_DEVICE_LIST_DONE;
		//Copy the getTriggerdevices result
		[AppDelegate_iPad  sharedAppDelegate].g_getTriggerDeviceListArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_TRIGGER_REASON_LIST_BY_ID)
	{
		eventInitializeEnum = GET_TRIGGERREASONLISTBYID_DONE;
		//Copy the getdevices result
		[AppDelegate_iPad  sharedAppDelegate].g_getTriggerReasonListByDeviceIDArray = [resultArray mutableCopy];
	}
	else if(strCommand == EVENT_ADD)
	{
		if(eventInitializeEnum == TRIGGERDEVICE_ON_PROCESSING)
		{
			eventInitializeEnum = TRIGGERDEVICE_ON_DONE;
			deviceONIdArray = [resultArray mutableCopy];
		}
		else if(eventInitializeEnum == TRIGGERDEVICE_OFF_PROCESSING)
		{
			eventInitializeEnum = TRIGGERDEVICE_OFF_DONE;
			deviceOFFIdArray = [resultArray mutableCopy];
		}
		else if(eventInitializeEnum == BULOGICS_EVENT_ADD_PROCESSING)
		{
			buttonCount+=1;
			switch (buttonCount) {
				case 1:
					button1Array = [resultArray mutableCopy];
					break;
				case 2:
					button2Array = [resultArray mutableCopy];
					break;
				case 3:
					button3Array = [resultArray mutableCopy];
					break;
				case 4:
					button4Array = [resultArray mutableCopy];
					break;
				case 5:
					button5Array = [resultArray mutableCopy];
					break;
				default:
					break;
			}
			eventInitializeEnum = BULOGICS_EVENT_ADD_DONE;
		}
	}
	else if(strCommand == EVENT_SET_TRIGGER_DEVICE)
	{
		if(eventInitializeEnum == SET_TRIGGERDEVICE_ON_PROCESSING)
			eventInitializeEnum = SET_TRIGGERDEVICE_ON_DONE;
		else if(eventInitializeEnum == SET_TRIGGERDEVICE_OFF_PROCESSING)
			eventInitializeEnum = SET_TRIGGERDEVICE_OFF_DONE;
		else if(eventInitializeEnum = SET_TRIGGERDEVICE_PROCESSING)
		{
			buttonCount+=1;
			eventInitializeEnum = SET_TRIGGERDEVICE_DONE;
		}
	}
	else if(strCommand == EVENT_SET_TRIGGER_REASON)
	{
		if(eventInitializeEnum == SET_TRIGGERDEVICE_REASON_ON_PROCESSING)
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_ON_DONE;
		else if(eventInitializeEnum == SET_TRIGGERDEVICE_REASON_OFF_PROCESSING)
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_OFF_DONE;
		else if(eventInitializeEnum = SET_TRIGGERDEVICE_REASON_PROCESSING)
		{
			buttonCount+=1;
			eventInitializeEnum = SET_TRIGGERDEVICE_REASON_DONE;
		}
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		if(isSingleEventInfo)
		{
			//Copy the timer info array in g_getTimersInfoArray
			[g_popupEventsInfoArray replaceObjectAtIndex:eventSelectedIndex withObject:[resultArray mutableCopy]];
			temp_infoArray = [resultArray mutableCopy];
			[self InitializeAndMaintainDefaultSceneInfoValues];
			[self hideLoadingView];
			isSingleEventInfo = NO;
		}
		else if(eventSaveEnum == PROCESSING)
		{
			//Copy the timer info array in g_getTimersInfoArray
			[g_popupEventsInfoArray replaceObjectAtIndex:eventSelectedIndex withObject:[resultArray mutableCopy]];
			temp_infoArray = [resultArray mutableCopy];
			eventSaveEnum = DONE;
		}
		else
		{
			eventEnum = EVENT_INFO_DONE;
			//Copy the timer info array in g_getTimersInfoArray
			[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
		}
	}
	else if(strCommand == EVENT_SET_DAYS_MASK)
	{
		eventSaveEnum = SCH_SET_TIME_TYPE;
	}
	else if(strCommand == EVENT_SET_TIME_TYPE)
	{
		eventSaveEnum = SCH_START_CHANGE;
	}
	else if(strCommand == EVENT_SET_TIME)
	{
		eventSaveEnum = EVENT_INFO;
	}
	else if(strCommand == EVENT_SCENE_INCLUDE)
	{
		if(includeEnum == PROCESSING_SCH_EXCLUDE_SCHUDLE_FROM_SCENE)
			includeEnum = INCLUDE_SCENE_EVENT;
		else if(includeEnum == PROCESSING_SCH_INCLUDE_SCHUDLE_TO_SCENE)
			includeEnum = DONE;
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
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	
	if(eventInitializeEnum == BULOGICS_EVENT_ADD_PROCESSING)
	{
		buttonCount+=1;
		eventInitializeEnum == BULOGICS_EVENT_ADD_DONE;
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
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
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
	[animateImageView release];
	[animationScrollView release];
	[animationTitle release];
	[occupancyLabel release];
	[enableHomeOccupancyBtn release];
	[getSceneControlsArray release];
	[button1Array,button2Array,button3Array,button4Array,button5Array release];
	[eventInitializeView release];
	[deviceONIdArray,deviceOFFIdArray release];
	[eventInitializeNameLabel,eventInitializeStatusLabel,messageLabel release];
	[eventInitializeCloseBtn,eventInitializeBtn release];
	[pickerPopupView,pickerPopupsubView release];
	[pickerOkBtn,pickerCancelBtn release];
	[fromTimePicker,toTimePicker release];
	[scenesPicker release];
	[maintenanceArray,sceneMaintenanceArray release];
	[segControl release];
	[fromTimeTextField,toTimeTextField release];
	[saveBtn,resetBtn,closeBtn,fromTimeBtn,toTimeBtn release];
	[g_sunBtn,g_monBtn,g_tueBtn,g_wedBtn,g_thuBtn,g_friBtn,g_satBtn,g_allBtn release];
	[popupEventView,popupScrollView,popupEventTimeView release];
	[g_triggerDevicesList,g_popupEventsInfoArray,temp_infoArray,localScenesArray release];
	[scrollView,popupNameLabel release];
	[RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn release];
    [super dealloc];
}


@end
