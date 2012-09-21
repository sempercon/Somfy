//
//  SceneConfigurator_iPad.m
//  Somfy
//
//  Created by Sempercon on 4/30/11.
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
#import "DashboardService.h"
#import "SceneConfiguratorHomeownerService.h"
#import "DeviceIconMapper.h"
#import "RoomService.h"
#import "SceneThermostatView.h"
#import "DeviceSkinChooser.h"
#import "ThermostatSceneView.h"
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "RRSGlowLabel.h"
#import "MJPEGViewer_iPad.h"

@interface SceneConfigurator_iPad (Private)
-(void)startTimer;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void)LoadAllScenes:(NSMutableArray*)sceneArray;
-(void)filterDevicesForScene;
-(void) alignLabelWithTop:(UILabel *)label;
@end

extern BOOL  isLOGOUT;

@implementation SceneConfigurator_iPad
@synthesize Logout;
@synthesize RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn;

@synthesize sceneScrollView;
@synthesize AddsceneView,EditSceneNameView;
@synthesize ActivatedLabel;
@synthesize addTextField,EditTextField;

@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle;
@synthesize popupView;
int selCount =0;
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
    
    if (isLocal == 1)
        self.Logout.hidden = YES;
    
    isSceneEdit = NO;
	animationScrollView.hidden = YES;
	animationTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 350, 60)];
	animationTitle.text = @"Successfully executed the command";
	animationTitle.lineBreakMode = UILineBreakModeWordWrap;
	animationTitle.numberOfLines = 0;
	animationTitle.textAlignment = UITextAlignmentCenter;
	animationTitle.font = [UIFont systemFontOfSize:19];
	animationTitle.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle];
	
	
	selectedScenesArray = [[NSMutableArray alloc]init];
	ExcludedSceneDevicesArray = [[NSMutableArray alloc]init];
	SupportedMaskFilterArray = [[NSMutableArray alloc]init];
	
	//[self startTimer];
	[self filterDevicesForScene];
	[self LoadAllScenes:[AppDelegate_iPad sharedAppDelegate].g_ScenesArray];
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	addTextField.leftView = paddingView;
	addTextField.leftViewMode = UITextFieldViewModeAlways;
	addTextField.placeholder= @"New Scene Name";
	[paddingView release];
	
	UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	EditTextField.leftView = paddingView1;
	EditTextField.leftViewMode = UITextFieldViewModeAlways;
	[paddingView1 release];
	
	[super viewDidLoad];
	
	
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
	xposition=0;
	self.view = nil;
	
}

-(void)viewWillAppear:(BOOL)animated
{
	isAddDeleteScene = NO;
	[[AppDelegate_iPad sharedAppDelegate]SetInstallerViewIndex:3];
	[SceneConfigBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark INITIAL LOAD

//Devices for scene with filter
-(void)filterDevicesForScene
{
	
	if([ExcludedSceneDevicesArray count]>0)
		[ExcludedSceneDevicesArray removeAllObjects];
	if([SupportedMaskFilterArray count]>0)
		[SupportedMaskFilterArray removeAllObjects];
	
	
	
	NSMutableArray *excludeDeviceList = [[NSMutableArray arrayWithArray:[sceneExcludedDeviceList componentsSeparatedByString:@","]]retain];
    /// Hint 23
    NSMutableArray *sceneproductList = [[NSMutableArray arrayWithArray:[sceneproductTypeList componentsSeparatedByString:@","]]retain];
	for(int j=0;j<[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray count];j++)
	{
		// Check excludedevicelist in sceneConfiguratorview
		NSUInteger index = [excludeDeviceList indexOfObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"deviceType"]];
        NSUInteger productIndex = [sceneproductList indexOfObject:[[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"productType"]];
        
        //// Hint 23
		if(index==NSNotFound && productIndex==NSNotFound)
		{
            [ExcludedSceneDevicesArray addObject:[[AppDelegate_iPad sharedAppDelegate].g_DevicesArray objectAtIndex:j]];
		}
	}
	
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count];i++)
	{
		if([[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i] objectForKey:@"zwaveSceneID"] intValue]>0)
		{
			int sceneCapableBit = 1 << 15;
			NSMutableArray *arr = [[NSMutableArray alloc]init];
			for(int j=0;j<[ExcludedSceneDevicesArray count];j++)
			{
				int supportedMask = [[[ExcludedSceneDevicesArray objectAtIndex:j]objectForKey:@"supportedMask"] intValue];
				if( supportedMask & sceneCapableBit )
					[arr addObject:[ExcludedSceneDevicesArray objectAtIndex:j]];
			}
			[SupportedMaskFilterArray addObject:arr];
			[arr release];
		}
		else {
			[SupportedMaskFilterArray addObject:ExcludedSceneDevicesArray];
		}
		
	}
	
}

-(void)LoadAllScenes:(NSMutableArray*)sceneArr
{
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [sceneScrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	BOOL isSelected = NO;
	UIImage *DeviceImage;
	int deviceCount=0;
	int x=4,y=0;
	int subx=20,suby=60,Newy=100;
	for(int i=0;i<[sceneArr count];i++)
	{
		UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 138, 480)];
		bg_image.image = [UIImage imageNamed:@"scene_background.png"];
		bg_image.alpha = 0.5;
		bg_image.contentMode = UIViewContentModeScaleToFill;
		[sceneScrollView addSubview:bg_image];
		[bg_image release];
		
		UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(x+23, y, 120, 30)];
		lbl1.textColor = [UIColor colorWithRed:0.250 green:0.498 blue:0.631 alpha:1];
		lbl1.backgroundColor = [UIColor clearColor];
		lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		lbl1.text = @"SCENE NAME";
		[sceneScrollView addSubview:lbl1];
		[lbl1 release];
		
		y =y+30;
		
		RRSGlowLabel *sceneName = [[RRSGlowLabel alloc] initWithFrame:CGRectMake(x+8, y, 120, 60)];
		sceneName.textAlignment =UITextAlignmentCenter;
		sceneName.textColor = [UIColor whiteColor];
		sceneName.backgroundColor = [UIColor clearColor];
		sceneName.lineBreakMode = UILineBreakModeWordWrap;
		sceneName.numberOfLines =5;
		sceneName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		sceneName.text=[[sceneArr objectAtIndex:i]objectForKey:@"name"];
		[sceneName setTag:i];
		
		sceneName.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		//lbl3.glowColor = [UIColor colorWithRed:1.0 green:0.70 blue:1.0 alpha:1.0];
		sceneName.glowOffset = CGSizeMake(0.0, 0.0);
		sceneName.glowAmount = 10.0;
		
		[self alignLabelWithTop:sceneName];
		[sceneScrollView addSubview:sceneName];
		[sceneName release];
		
		UIButton *customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x+8, y, 120, 60);
		customBtn.titleLabel.textAlignment =UITextAlignmentCenter;
		customBtn.titleLabel.textColor = [UIColor clearColor];
		customBtn.titleLabel.backgroundColor = [UIColor clearColor];
		customBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		customBtn.titleLabel.numberOfLines = 5;
		customBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		[customBtn setTag:i];
		[customBtn addTarget:self action:@selector(SceneNameEdit:) forControlEvents:UIControlEventTouchUpInside];
		[sceneScrollView addSubview:customBtn];
		[customBtn release];
		
		for(int j=0;j<[selectedScenesArray count];j++)
		{
			if(i==[[selectedScenesArray objectAtIndex:j] intValue])
			{
				UIScrollView *scrollsubView = [[UIScrollView alloc]initWithFrame:CGRectMake(x+142, 0, 320, 400)];
				scrollsubView.backgroundColor = [UIColor clearColor];
				//[sceneScrollView addSubview:scrollsubView];
				
				if(currentSceneEditIndex == [[selectedScenesArray objectAtIndex:j]intValue])
				{
					[scrollsubView setFrame:CGRectMake( x-25, 0.0f, 320.0f, 400.0f)]; //notice this is OFF screen!
					[UIView beginAnimations:@"animateTableView" context:nil];
					[UIView setAnimationDuration:0.07];
					[scrollsubView setFrame:CGRectMake( x+142, 0.0f, 320.0f, 400.0f)]; //notice this is ON screen!
					[UIView commitAnimations];
				}
				[sceneScrollView  addSubview:scrollsubView];
				
				if([SupportedMaskFilterArray count]>i)
				{
					NSMutableArray *deviceArr = [SupportedMaskFilterArray objectAtIndex:i];//devices for each scene
					NSMutableArray *SceneInfoDeviceArr = [[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray objectAtIndex:i];
					
					for(int j=0;j<[deviceArr count];j++)
					{
						UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
						customBtn.frame = CGRectMake(subx+10, suby, 74, 74);
						[customBtn setTag:j];//Device index in device Arr
						NSString *btnDeviceTitle = [NSString stringWithFormat:@"%d",i];
						[customBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
						if ([[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] == THERMOSTATV2)
							DeviceImage = [UIImage imageNamed:@"LargeTheromastat.png"];
						else 
						{
							if ([[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] == SOMFY_RTS || [[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] ==	SOMFY_ILT)
								DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceTypeandDeviceValue:[[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] :1 :[[[deviceArr objectAtIndex:j]objectForKey:@"metaData"]intValue]];
							else
                            {
                                if([[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue]==IP_CAMERA_DEVICE_TYPE)
                                    DeviceImage = [UIImage imageNamed:@"cameraIcon1.png"];
                                else
                                {
                                   DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceType:[[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue]:UNKNOWN]; 
                                }
                            }
						}
						
						[customBtn setBackgroundImage:DeviceImage forState:UIControlStateNormal];
						
						//Check if the device is in the scene info list
						BOOL isExists = NO;
						for(int l=0;l<[SceneInfoDeviceArr count];l++)
						{
							int deviceId= [[[deviceArr objectAtIndex:j]objectForKey:@"zwaveID"]intValue];
							if(deviceId == [[[SceneInfoDeviceArr objectAtIndex:l]objectForKey:@"id"]intValue])
							{
								isExists = YES;
								break;
							}
						}
						//Get device image based on devicetype and its value should be zero for now.We treat this image is not present in the scene ,so we send as 0 for device value.
						if(!isExists)
						{
							if ([[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] == THERMOSTATV2)
								DeviceImage = [UIImage imageNamed:@"LargeTheromastatFGray.png"];
							else
                            {
                                if([[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue]==IP_CAMERA_DEVICE_TYPE)
                                    DeviceImage = [UIImage imageNamed:@"cameraIconGray.png"];
                                else
                                {
                                    DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceImageBasedOnDeviceTypeandDeviceValue:[[[deviceArr objectAtIndex:j]objectForKey:@"deviceType"]intValue] :0 :[[[deviceArr objectAtIndex:j]objectForKey:@"metaData"]intValue]];
                                }
                            }
								
							[customBtn setBackgroundImage:DeviceImage forState:UIControlStateNormal];
							//[customBtn setBackgroundImage:[UIImage imageNamed:@"Smalllight_gray.png"] forState:UIControlStateNormal];
							btnDeviceTitle = [btnDeviceTitle stringByAppendingString:@"-0"];
						}
						else
							btnDeviceTitle = [btnDeviceTitle stringByAppendingString:@"-1"];
						[customBtn setTitle:btnDeviceTitle forState:UIControlStateNormal];//scene Index
						[customBtn addTarget:self action:@selector(DeviceSelect:) forControlEvents:UIControlEventTouchUpInside];
						[scrollsubView addSubview:customBtn];
						[customBtn release];
						
						// Hint
						//RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(subx-10, suby+65, 110, 60)];
                        RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(subx-10, suby+85, 110, 50)];
						lbl3.textColor = [UIColor whiteColor];
						lbl3.backgroundColor = [UIColor clearColor];
						lbl3.lineBreakMode = UILineBreakModeWordWrap;
						lbl3.textAlignment = UITextAlignmentCenter;
						lbl3.numberOfLines = 0;
						lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
						lbl3.text = [[deviceArr objectAtIndex:j]objectForKey:@"name"];
						lbl3.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
						//lbl3.glowColor = [UIColor colorWithRed:1.0 green:0.70 blue:1.0 alpha:1.0];
						lbl3.glowOffset = CGSizeMake(0.0, 0.0);
						lbl3.glowAmount = 10.0;
                        [scrollsubView addSubview:lbl3];
						[lbl3 release];
                        
						for(int k=0;k<[[AppDelegate_iPad sharedAppDelegate].g_roomsArray count];k++)
						{
							if([[[deviceArr objectAtIndex:j] objectForKey:@"roomID"] isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_roomsArray objectAtIndex:k]objectForKey:@"id"]])
							{
								//lbl3.text = [lbl3.text stringByAppendingString:@"\n"];
								if([[[AppDelegate_iPad sharedAppDelegate].g_roomsArray objectAtIndex:k]objectForKey:@"name"]!=nil)
                                {
                                    UILabel *roomNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(subx-10, suby+85+40, 110, 50)];
                                    roomNameLbl.textColor = [UIColor whiteColor];
                                    roomNameLbl.backgroundColor = [UIColor clearColor];
                                    roomNameLbl.textAlignment = UITextAlignmentCenter;
                                    roomNameLbl.lineBreakMode = UILineBreakModeWordWrap;
                                    roomNameLbl.numberOfLines = 0;
                                    roomNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
                                    roomNameLbl.text = [[[AppDelegate_iPad sharedAppDelegate].g_roomsArray objectAtIndex:k]objectForKey:@"name"];
                                    [scrollsubView addSubview:roomNameLbl];
                                    [roomNameLbl release];
                                    
                                    
									//lbl3.text = [lbl3.text stringByAppendingString:[[[AppDelegate_iPad sharedAppDelegate].g_roomsArray //objectAtIndex:k]objectForKey:@"name"]];
                                }
								break;
							}
						}
						
                        //[scrollsubView addSubview:lbl3];
						//[lbl3 release];
						
						subx = subx+74+10;
						
						//Newy=80;
						NSString *btnTitle = [[deviceArr objectAtIndex:j] objectForKey:@"zwaveID"];
						btnTitle = [btnTitle stringByAppendingString:@"-"];
						btnTitle = [btnTitle stringByAppendingString:[[deviceArr objectAtIndex:j] objectForKey:@"deviceType"]];
						UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
						customBtn1.frame = CGRectMake(subx+5, Newy-6, 40, 40);
						[customBtn1 setTag:[[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"id"]intValue]];//Scene ID
						[customBtn1 setTitle:btnTitle forState:UIControlStateNormal];//Device ZwaveID
						[customBtn1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
						if(!isExists)
							[customBtn1 setBackgroundImage:[UIImage imageNamed:@"scene_device_toggle_plus.png"] forState:UIControlStateNormal];
						else 
							[customBtn1 setBackgroundImage:[UIImage imageNamed:@"scene_device_toggle_minus.png"] forState:UIControlStateNormal];
						[customBtn1 addTarget:self action:@selector(DeviceAddorRemove:) forControlEvents:UIControlEventTouchUpInside];
						[scrollsubView addSubview:customBtn1];
						[customBtn1 release];
						subx = subx+40+20;
						deviceCount++;
						
						if(deviceCount == 2 || j == [deviceArr count]-1)
						{
							deviceCount = 0;
							subx=20;
							suby=suby+110+70;
							Newy =Newy+110+70;
							[scrollsubView setContentSize:CGSizeMake(320, Newy)];
						}
					}
				}
				
				[scrollsubView release];
				
			}
		}
		
		y =y+30+60;
		isSelected = NO;
		
		for(int j=0;j<[selectedScenesArray count];j++)
		{
			if(i==[[selectedScenesArray objectAtIndex:j] intValue])
			{
				UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn.frame = CGRectMake(x+18, y, 96, 95);
				[customBtn setTag:i];
				[customBtn setBackgroundImage:[UIImage imageNamed:@"ForScene.png"] forState:UIControlStateNormal];
				[customBtn addTarget:self action:@selector(SceneSelect:) forControlEvents:UIControlEventTouchUpInside];
				[sceneScrollView addSubview:customBtn];
				[customBtn release];
				
				//Activate scene label
				UILabel *activateLbl = [[UILabel alloc]initWithFrame:CGRectMake(x+16, y+46, 100, 50)];
				activateLbl.textColor = [UIColor orangeColor];
				activateLbl.hidden = YES;
				activateLbl.backgroundColor = [UIColor clearColor];
				activateLbl.textAlignment = UITextAlignmentCenter;
				activateLbl.lineBreakMode = UILineBreakModeWordWrap;
				activateLbl.numberOfLines = 0;
				[activateLbl setTag:i];
				activateLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
				activateLbl.text = @"ACTIVATED";
				[sceneScrollView addSubview:activateLbl];
				[activateLbl release];
				
				y = y+100+140;
				
				UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x+18, y, 100, 30);
				[customBtn1 setTag:i];
				[customBtn1 setTitle:@"Delete" forState:UIControlStateNormal];
				[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
				customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				[customBtn1 addTarget:self action:@selector(SceneDelete:) forControlEvents:UIControlEventTouchUpInside];
				[sceneScrollView addSubview:customBtn1];
				[customBtn1 release];
				
				y = y+30+10;
				
				
				UIButton * customBtn2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn2.frame = CGRectMake(x+18, y, 100, 30);
				[customBtn2 setTag:i];
				[customBtn2 setTitle:@"Close" forState:UIControlStateNormal];
				[customBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn2 setFont:[UIFont systemFontOfSize:12]];
				customBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn2 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				[customBtn2 addTarget:self action:@selector(SceneClose:) forControlEvents:UIControlEventTouchUpInside];
				[sceneScrollView addSubview:customBtn2];
				[customBtn2 release];
				
				y = y+30+20;
				
				x = x + 460;
				
				isSelected = YES;
			}
		}
		
		if(!isSelected)
		{
			UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			customBtn.frame = CGRectMake(x+18, y, 96, 95);
			[customBtn setTag:i];
			[customBtn setBackgroundImage:[UIImage imageNamed:@"ForScene.png"] forState:UIControlStateNormal];
			[customBtn addTarget:self action:@selector(SceneSelect:) forControlEvents:UIControlEventTouchUpInside];
			[sceneScrollView addSubview:customBtn];
			[customBtn release];
			
			//Activate scene label
			UILabel *activateLbl = [[UILabel alloc]initWithFrame:CGRectMake(x+16, y+46, 100, 50)];
			activateLbl.textColor = [UIColor orangeColor];
			activateLbl.hidden = YES;
			activateLbl.backgroundColor = [UIColor clearColor];
			activateLbl.textAlignment = UITextAlignmentCenter;
			activateLbl.lineBreakMode = UILineBreakModeWordWrap;
			activateLbl.numberOfLines = 0;
			[activateLbl setTag:i];
			activateLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
			activateLbl.text = @"ACTIVATED";
			[sceneScrollView addSubview:activateLbl];
			[activateLbl release];
			
			y = y+100+180;
			
			UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			customBtn1.frame = CGRectMake(x+18, y, 100, 30);
			[customBtn1 setTag:i];
			[customBtn1 setTitle:@"Edit" forState:UIControlStateNormal];
			[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
			customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
			[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
			[customBtn1 addTarget:self action:@selector(SceneEdit:) forControlEvents:UIControlEventTouchUpInside];
			[sceneScrollView addSubview:customBtn1];
			[customBtn1 release];
			
			y = y+30+20;
			
			x= x + 142;
		}
		
		y=0;
		//subx=5;suby=40;Newy=100;
		subx=20;
		suby=60;
		Newy=100;
		
		[sceneScrollView setContentSize:CGSizeMake(x, 340)];
	}
	
	if(isAddDeleteScene)
		[sceneScrollView setContentOffset:rightOffset animated:YES];
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



#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

//Device select 
-(void)DeviceSelect:(id)sender
{
	id subView;
	UIButton *btn = (UIButton*)sender;
	int deviceIdx = btn.tag;
	int sceneIdx = 0;
	int isDeviceActive = 0;
	int sceneId;
	NSMutableDictionary *selectedDeviceDict;
	NSMutableArray* deviceArr;
	int currDeviceZwaveId =0;
	int currentDeviceType=0;
	NSArray *temp = [[btn currentTitle] componentsSeparatedByString:@"-"];
	if([temp count]>0)
	{
		sceneIdx =[[temp objectAtIndex:0] intValue];
		isDeviceActive = [[temp objectAtIndex:1] intValue];
		
	}
	if(isDeviceActive == 0) return;
	
	deviceArr = [SupportedMaskFilterArray objectAtIndex:sceneIdx];
	selectedDeviceDict = [deviceArr objectAtIndex:deviceIdx];
    currentDeviceType = [[selectedDeviceDict objectForKey:@"deviceType"] intValue];
	
	if(currentDeviceType != IP_CAMERA_DEVICE_TYPE)
	{
		NSMutableArray *tempInfoArray = [[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray objectAtIndex:sceneIdx]; 
		sceneId = [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:sceneIdx] objectForKey:@"id"]intValue];
		for(int k=0;k<[tempInfoArray count];k++)
		{
			if([[selectedDeviceDict objectForKey:@"zwaveID"] intValue] == [[[tempInfoArray objectAtIndex:k]objectForKey:@"id"] intValue])
			{
				currDeviceMetaData = [[selectedDeviceDict objectForKey:@"metaData"] intValue];
				currDeviceZwaveId = [[selectedDeviceDict objectForKey:@"zwaveID"] intValue];
				currentDeviceType = [[selectedDeviceDict objectForKey:@"deviceType"] intValue];
				selectedDeviceDict = [tempInfoArray objectAtIndex:k];
				break;
			}
		}
	}
    
	if(currentDeviceType == THERMOSTATV2 || currentDeviceType == THERMOSTAT_RCS)
		subView = [ThermostatSceneView thermostatSceneView];
	else
		subView = [[DeviceSkinChooser getSharedInstance]getDeviceSkinBasedOnDeviceType:currentDeviceType];
	
	popupView =  subView;
	
	[subView SetMainDelegate:self];
	[subView setDeviceDict:selectedDeviceDict];
	[selectedDeviceDict setObject:[[deviceArr objectAtIndex:deviceIdx]objectForKey:@"name"] forKey:@"name"];
	if(currentDeviceType != IP_CAMERA_DEVICE_TYPE)
	{
		[subView setSceneId:sceneId];
		[subView setSceneIndex:sceneIdx];
		[subView setCurMetaData:currDeviceMetaData];
		[subView setIsFromScene:1];
	}
	[self.view addSubview:subView];
	popupView.alpha = 0;
	[self performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:.3];
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


//device add or remove 
-(void)DeviceAddorRemove:(id)sender
{
	UIButton *btnToggle = (UIButton*)sender;
	NSString *include=@"";
	NSArray *arr = [btnToggle.currentTitle componentsSeparatedByString:@"-"];
	
	
	NSString *sceneId = [NSString stringWithFormat:@"%d",btnToggle.tag];
	NSString *deviceZwaveId = [arr objectAtIndex:0];
	int deviceType = [[arr objectAtIndex:1] intValue];
	
	if([btnToggle backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"scene_device_toggle_minus.png"])
	{
		include=@"0";
	}
	else
	{
		include=@"1";
	}
	
	NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
	[commandDictionary setObject:include forKey:@"include"];
	[commandDictionary setObject:deviceZwaveId forKey:@"id"];
	[commandDictionary setObject:sceneId forKey:@"scene"];
    [commandDictionary setObject:include forKey:@"settingType"];
    
	if(deviceType == THERMOSTAT || deviceType == THERMOSTAT_RCS || deviceType == THERMOSTATV2)
	{
		[commandDictionary setObject:@"1" forKey:@"setValue"];
		[commandDictionary setObject:@"65535" forKey:@"value"];
	}
	else 
	{
		[commandDictionary setObject:@"0" forKey:@"setValue"];
		[commandDictionary setObject:@"0" forKey:@"value"];
	}
	curSceneEditToggle = [sceneId intValue];
	[[SceneConfiguratorHomeownerService getSharedInstance]includeSceneMember:commandDictionary :self];
	[commandDictionary release];
	rightOffset = sceneScrollView.contentOffset;
	[self showLoadingView];
	
}

//scene select
-(void)SceneSelect:(id)sender
{
	UIButton * btn = (UIButton*)sender;
	rightOffset = sceneScrollView.contentOffset;
	//Call activate scenes
	[[DashboardService getSharedInstance]ActivateScenes:[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"id"] :self];
	// Find the selected scenes and activate its label
    int totalSubViews = [[sceneScrollView subviews] count];
    for (int i=0;i < totalSubViews; i++ ) 
    {
        if ([[[sceneScrollView subviews] objectAtIndex:i] isKindOfClass:[UILabel class]])
        {
            UILabel *actLabel = [[sceneScrollView subviews] objectAtIndex:i];
			if(actLabel.tag == btn.tag&&[actLabel.text isEqualToString:@"ACTIVATED"])
			{
				actLabel.hidden = NO;
				ActivatedLabel = actLabel;
				break;
			}
		}
    }
}

-(IBAction)SceneEditSaveBtnClicked:(id)sender
{
	if(![EditTextField.text isEqualToString:@""]&&EditTextField.text!=nil)
	{
		rightOffset = sceneScrollView.contentOffset;
		[[SceneConfiguratorHomeownerService getSharedInstance]ChangeSceneName:EditTextField.text :[NSString stringWithFormat:@"%d",g_selectedSceneId] :self];
		[EditSceneNameView removeFromSuperview];
	}
}

-(IBAction)SceneEditCancelBtnClicked:(id)sender
{
	[EditSceneNameView removeFromSuperview];
}

//Scene name edit
-(void)SceneNameEdit:(id)sender
{
	UIButton *btn = (UIButton*)sender;
    ///// Hint 23 //TaHomA Home TaHomA Away
    NSString *sceneName = [[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"name"];
    sceneName           = [sceneName uppercaseString];
    
    if ([sceneName isEqualToString:@"TAHOMA HOME"] || [sceneName isEqualToString:@"TAHOMA AWAY"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" 
                                                       message:@"You can't edit 'TaHomA Home' and 'TaHomA Away' scene name." 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self.view addSubview:EditSceneNameView];
        g_selectedSceneId = [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"id"]intValue ];
        EditTextField.text	= [[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"name"];
        [self.view addSubview:EditSceneNameView];
    }
}


//scene edit
-(void)SceneEdit:(id)sender
{
	isAddDeleteScene = NO;
	issceneSelect = YES;
	BOOL isExists = NO;
	int ExistIndex;
	UIButton *btn = (UIButton*)sender;
	int TagVal =  btn.tag;
	
	
	for(int i=0;i<[selectedScenesArray count];i++)
	{
		if(TagVal==[[selectedScenesArray objectAtIndex:i] intValue])
		{
			isExists = YES;
			ExistIndex = i;
			break;
		}
	}
	
	currentSceneEditIndex = TagVal;
	
	if(isExists)
		[selectedScenesArray removeObjectAtIndex:ExistIndex];
	else
		[selectedScenesArray addObject:[NSString stringWithFormat:@"%d",TagVal]];
	
	//Store last scrollview position while editing 
	editOffSetPoint = sceneScrollView.contentOffset;
	//Hint
    for(int m=0;m<[selectedScenesArray count];m++)
    {
        if([[selectedScenesArray objectAtIndex:m]intValue] <=TagVal)
            selCount++;
    }
    if((xposition+300)>((TagVal*142)+((selCount-1)*320)))
    {
        int Currpos = xposition;
        rightOffset = CGPointMake(Currpos,0);
    }
    else if(((xposition+300)<((TagVal*142)+((selCount-1)*320))) && ((xposition+400)>((TagVal*142)+((selCount-1)*320))))
    {
        int Currpos = xposition+150;//TagVal*165;
        rightOffset = CGPointMake(Currpos,0);
		
        
    }
    else if(((xposition+400)<((TagVal*142)+((selCount-1)*320))) && ((xposition+500)>((TagVal*142)+((selCount-1)*320))))
        
    {
        int Currpos = xposition+240;//TagVal*165;
        rightOffset = CGPointMake(Currpos,0);
    }
    else
    {
        /*int Currpos = xposition+320;//TagVal*165;
		 rightOffset = CGPointMake(Currpos,0);*/
		
		int currentSceneEditWidth = (TagVal * 142) + 142 +((selCount-1) * 320);//142 width of one scene bg + gap
		int curWidth = currentSceneEditWidth - xposition;
		int widthToAdd = (curWidth+320)-840;
		int Currpos = xposition + widthToAdd;
		
		rightOffset = CGPointMake(Currpos,0);
		
        
    }
    selCount=0;
    
    
   // int Currpos = Currpos-320;
	[self LoadAllScenes:[AppDelegate_iPad sharedAppDelegate].g_ScenesArray];
	[sceneScrollView setContentOffset:rightOffset animated:NO];
	
	if(sceneScrollView.contentSize.width < 840)
		[sceneScrollView setContentSize:CGSizeMake(sceneScrollView.contentSize.width + 150, 340)];
	
	
	issceneSelect = NO;
  


}
//scene delete
-(void)SceneDelete:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	deleteSceneIndex = btn.tag;
	g_selectedSceneId = [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:btn.tag]objectForKey:@"id"] intValue];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" 
												   message:@"Do you really want to delete this scene ?" 
												  delegate:self 
										 cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}


//scene close
-(void)SceneClose:(id)sender
{
	issceneSelect = YES;
	BOOL isExists = NO;
	int ExistIndex;
	UIButton *btn = (UIButton*)sender;
	int TagVal =  btn.tag;
	for(int i=0;i<[selectedScenesArray count];i++)
	{
		if(TagVal==[[selectedScenesArray objectAtIndex:i] intValue])
		{
			isExists = YES;
			ExistIndex = i;
			break;
		}
	}
	if(isExists)
		[selectedScenesArray removeObjectAtIndex:ExistIndex];
	else
		[selectedScenesArray addObject:[NSString stringWithFormat:@"%d",TagVal]];
	
	[self LoadAllScenes:[AppDelegate_iPad sharedAppDelegate].g_ScenesArray];
	
	if(rightOffset.x < 100 || sceneScrollView.contentSize.width<840)
	 {
	 rightOffset.x = 0;
	 rightOffset.y =0;
	 [sceneScrollView setContentOffset:rightOffset animated:NO];
	 }
	 else {
	 [sceneScrollView setContentOffset:rightOffset animated:NO];
	 }
	
	//[sceneScrollView setContentOffset:editOffSetPoint animated:NO];
	
	
	issceneSelect = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if(scrollView==sceneScrollView)
	{
		if(!issceneSelect)
		{
			rightOffset =  [sceneScrollView contentOffset];
		}
	}
    xposition =scrollView.contentOffset.x;
}

//scene add and refresh button click
-(IBAction)SceneAddBtnClicked:(id)sender
{
	isAddDeleteScene = YES;
	if([sceneScrollView contentSize].width > 850)
		rightOffset = CGPointMake([sceneScrollView contentSize].width-700,0);
	else
		rightOffset = sceneScrollView.contentOffset;
	[self.view addSubview:AddsceneView];
	
}

-(IBAction)SceneRefreshBtnClicked:(id)sender
{
}
//scene create and cancelbtn click
-(IBAction)SceneCreateBtnClicked:(id)sender
{
	if(addTextField.text!=nil&&![addTextField.text isEqualToString:@""])
	{
		NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
		[dataDict setObject:addTextField.text forKey:@"name"];
		[dataDict setObject:@"0" forKey:@"sceneType"];
		[[SceneConfiguratorHomeownerService getSharedInstance] addScene:dataDict :self];
		[dataDict release];
		[AddsceneView removeFromSuperview];
	}
}
-(IBAction)SceneCancelBtnClicked:(id)sender
{
	[AddsceneView removeFromSuperview];
}

-(void)startTimer
{
	[self showLoadingView];
	ProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
													target:self 
												  selector:@selector(processingTimer) 
												  userInfo:nil 
												   repeats:YES];
	sceneEnum = NONE;
}

-(void)stopTimer
{
	[ProcessTimer invalidate];
	ProcessTimer=nil;
}

-(void)getSceneInfo
{
	QueueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
												  target:self 
												selector:@selector(QueueProcess) 
												userInfo:nil 
												 repeats:YES];
	queueEnum = NONE;
	SceneInfoId = 0;
}

-(void)QueueProcess
{
	switch(queueEnum)
	{
		case NONE:
		{
			queueEnum = GETSCENE_INFO;
			if([[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray count]>0)
				[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray removeAllObjects];
			break;
		}
		case GETSCENE_INFO:
		{
			[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:SceneInfoId]objectForKey:@"id"] :self];
			queueEnum = PROCESSING;
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			if(SceneInfoId<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count]-1)
			{
				SceneInfoId++;
				queueEnum = GETSCENE_INFO;
			}
			else
				queueEnum = DONE;
			break;
		}
		case DONE:
		{
			[QueueTimer invalidate];
			QueueTimer=nil;
			sceneEnum = GETSCENE_INFO_DONE;
			break;
		}
		default:
			break;
	}
}



-(void)processingTimer
{
	switch(sceneEnum)
	{
		case NONE:
		{
			sceneEnum = GETSCENES;
			break;
		}
		case GETSCENES:
		{
			[[DashboardService getSharedInstance]getScenes:self];
			sceneEnum = PROCESSING;
			break;
		}
		case GETSCENES_DONE:
		{
			sceneEnum = GETSCENE_INFO;
			break;
		}
		case GETSCENE_INFO:
		{
			[self getSceneInfo];
			sceneEnum = PROCESSING;
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			sceneEnum = DONE;
			break;
		}
		case DONE:
		{
			[self stopTimer];
			[self filterDevicesForScene];
			[self LoadAllScenes:[AppDelegate_iPad sharedAppDelegate].g_ScenesArray];
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
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
	
	if(yPosition<=50)
	{
		yPosition = 50;
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
#pragma mark POPUP CALLBACK

-(void)removePopup
{
	[popupView removeFromSuperview];
}

-(void)refreshViewFromPopup
{
}


#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==ACTIVATE_SCENES)
	{
		ActivatedLabel.hidden = YES;
	}
	else if(strCommand==REMOVE_SCENE||strCommand==ADD_SCENE||strCommand==CHANGE_SCENE_NAME)
	{
		if(strCommand == REMOVE_SCENE)
		{
			BOOL isExists = NO;
			int ExistIndex;
			for(int i=0;i<[selectedScenesArray count];i++)
			{
				if(deleteSceneIndex==[[selectedScenesArray objectAtIndex:i] intValue])
				{
					isExists = YES;
					ExistIndex = i;
					break;
				}
			}
			if(isExists)
				[selectedScenesArray removeObjectAtIndex:ExistIndex];
		}
		[self startTimer];
	}
	else if(strCommand==GET_SCENES)
	{
		sceneEnum = GETSCENES_DONE;
		//Copy the getscenes result
		[AppDelegate_iPad sharedAppDelegate].g_ScenesArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_SCENE_INFO)
	{
		if(queueEnum==PROCESSING)
		{
			[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray addObject:[resultArray mutableCopy]];
			queueEnum = GETSCENE_INFO_DONE;
		}
		else
		{
			NSMutableArray *tempArr = [resultArray mutableCopy];
			for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray count];i++)
			{
				if(curSceneEditToggle == [[[[AppDelegate_iPad sharedAppDelegate].g_ScenesArray objectAtIndex:i]objectForKey:@"id"]intValue])
				{
					[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray replaceObjectAtIndex:i withObject:tempArr];
					[self filterDevicesForScene];
					issceneSelect = YES;
					[self LoadAllScenes:[AppDelegate_iPad sharedAppDelegate].g_ScenesArray];
					[sceneScrollView setContentOffset:rightOffset animated:NO];
					issceneSelect = NO;
					[self hideLoadingView];
					[self OpenWindow];
					break;
				}
			}
		}
	}
	else if(strCommand == INCLUDE_MEMBER)
	{
		[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[NSString stringWithFormat:@"%d",curSceneEditToggle]:self];
		
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
    ActivatedLabel.hidden = YES;
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
	else if(buttonIndex==1)
	{
		isAddDeleteScene = YES;
		rightOffset = sceneScrollView.contentOffset;
		rightOffset.x = 0;
		rightOffset.y =0;
		
		[self showLoadingView];
		[[SceneConfiguratorHomeownerService getSharedInstance] removeScene:[NSString stringWithFormat:@"%d",g_selectedSceneId] :self];
	}
}

#pragma mark -
#pragma mark BOTTOM TABS

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
	[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
}
-(IBAction)DeviceConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view];
}
-(IBAction)SceneConfigurator:(id)sender
{
}
-(IBAction)EventConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view];
}
-(IBAction)ScheduleConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
}

-(IBAction)Homeowner:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetHomeownerViewIndex]) {
			
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
			break;
		}
		default:
			break;
	}
}



#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
	[Logout release];
	[RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn release];
	[animateImageView,animationScrollView,animationTitle release];
	[popupView release];
	[ExcludedSceneDevicesArray,SupportedMaskFilterArray release];
	[sceneScrollView release];
	[AddsceneView,EditSceneNameView release];
	[addTextField,EditTextField release];
	[selectedScenesArray release];
	[ActivatedLabel release];
    [super dealloc];
}


@end
