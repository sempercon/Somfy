//
//  OnewayMotor.m
//  Somfy
//
//  Created by Sempercon on 4/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "OnewayMotor.h"
#import "AppDelegate_iPhone.h"
#import "DeviceService.h"
#import "DashboardService.h"
#import "DeviceIconMapper.h"
#include <QuartzCore/QuartzCore.h>
#import "UserService.h"
#import "DBAccess.h"

@interface OnewayMotor (Private)
- (void)hideLoadingView;
- (void)showLoadingView;
-(void)setSelectionImage;
@end

extern BOOL  _isLOGOUT;

@implementation OnewayMotor
@synthesize lbl;


@synthesize deviceDict;
@synthesize roomNameString;
@synthesize deviceName,roomName;
@synthesize scrollView;
@synthesize imgDevice;
@synthesize btnOpen,btnClose,btnMy;
@synthesize applyBtn,applyAllBtn;
@synthesize Logout;

//Animation
@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle1,animationTitle2;

#pragma mark -
#pragma mark VIEW DELEGATES
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
    
	//Added for animation 
	isAnimation = YES;
	scrollView.hidden = YES;
	
	applyBtn.enabled = NO;
	applyAllBtn.enabled = NO;
	
	animationTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 300, 24)];
	animationTitle1.text = @"myTaHomA Message";
	animationTitle1.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	animationTitle1.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle1];
	//[animationTitle1 release];
	
	NSString *temp=@"";
	animationTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 44, 300, 30)];
	temp = [deviceDict objectForKey:@"name"];
	temp = [temp stringByAppendingString:@" was updated."];
	animationTitle2.text = temp;
	animationTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	animationTitle2.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle2];
	//[animationTitle2 release];

	
	self.navigationController.navigationBarHidden = YES;
	//Set DeviceName and RoomName
	roomName.text = roomNameString;
	deviceName.text = [deviceDict objectForKey:@"name"];
	
	//imgDevice.image = [[DeviceIconMapper getSharedInstance]getSomfyDeviceForiPhoneImageBasedOnDeviceType:[[deviceDict objectForKey:@"metaData"]intValue]];
	if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_AWNING)
		imgDevice.image = [UIImage imageNamed:@"Awning_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_BLIND)
		imgDevice.image = [UIImage imageNamed:@"Blind_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_CELLULAR_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_DRAPERY)
		imgDevice.image = [UIImage imageNamed:@"DraPery_Animation6.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROLLER_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Rollar_Shade_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROLLER_SHUTTER)
		imgDevice.image = [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROMAN_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Roman_Shade_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_SCREEN_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Screen_Animation1.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_SOLAR_SCREEN)
		imgDevice.image = [UIImage imageNamed:@"Solar_Screen_Animation1.png"];



	
	
	if([[deviceDict objectForKey:@"value"]intValue] == 100)
		curSelection =1;
	else if([[deviceDict objectForKey:@"value"]intValue] == 0)
		curSelection =0;
	else 
		curSelection =2;
	[self setSelectionImage];
    [super viewDidLoad];
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

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)btnRTSOpenClicked:(id)sender
{
	curSelection =1;
	[self setSelectionImage];
	[self startAnimateImage];
	applyBtn.enabled = YES;
	applyAllBtn.enabled = YES;
	/*[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];*/
}
-(IBAction)btnRTSCloseClicked:(id)sender
{
	curSelection = 0;
	[self setSelectionImage];
	[self startAnimateImage];
	applyBtn.enabled = YES;
	applyAllBtn.enabled = YES;
	/*[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];*/
}
-(IBAction)btnRTSmyClicked:(id)sender
{
	curSelection = 2;
	[self setSelectionImage];
	[self startAnimateImage];
	applyBtn.enabled = YES;
	applyAllBtn.enabled = YES;
	/*[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	[[DeviceService getSharedInstance]setSomfyMyPosition:deviceId :self];*/
}
-(IBAction)btnBackClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ApplyClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(curSelection == 0)
	{
		[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];
	}
	else if(curSelection == 1)
	{
		[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];
	}
	else if(curSelection == 2)
	{
		[[DeviceService getSharedInstance]setSomfyMyPosition:deviceId :self];
	}
	applyBtn.enabled = NO;
	applyAllBtn.enabled = NO;
}
-(IBAction)ApplyallClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(curSelection == 0)
	{
		[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];
	}
	else if(curSelection == 1)
	{
		[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];
	}
	else if(curSelection == 2)
	{
		[[DeviceService getSharedInstance]setSomfyMyPosition:deviceId :self];
	}
	applyBtn.enabled = NO;
	applyAllBtn.enabled = NO;
}

-(void)setSelectionImage
{
	if(curSelection == 0)
	{
		[btnClose setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Down-Arrow"] forState:UIControlStateNormal];
		[btnOpen setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Up-Arrow_grey"] forState:UIControlStateNormal];
		[btnMy setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_my_grey"] forState:UIControlStateNormal];
	}
	else if(curSelection == 1)
	{
		[btnClose setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Down-Arrow_grey"] forState:UIControlStateNormal];
		[btnOpen setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Up-Arrow"] forState:UIControlStateNormal];
		[btnMy setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_my_grey"] forState:UIControlStateNormal];
	}
	else if(curSelection == 2)
	{
		[btnClose setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Down-Arrow_grey"] forState:UIControlStateNormal];
		[btnOpen setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_Up-Arrow_grey"] forState:UIControlStateNormal];
		[btnMy setBackgroundImage:[UIImage imageNamed:@"iP_Room_RTS_my"] forState:UIControlStateNormal];
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
        loadingView.alpha = 0.4;
		
		//ActivityIndicator shows in the middle of loadingView
		UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
        loadingLabel.text = @"";
		loadingLabel.textAlignment=UITextAlignmentCenter;
		loadingLabel.font = [UIFont fontWithName:@"Arial Bold" size:20];
		loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingLabel];
		[loadingLabel release];
		
		UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 280, 20.0, 20.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
		
    }
    
	[self.tabBarController.view addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
}

#pragma mark -
#pragma mark ANIMATION 

-(void)startAnimateImage
{
	if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_AWNING)
	{
		
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Awning_Animation6.png"],
										 [UIImage imageNamed:@"Awning_Animation5.png"],
										 [UIImage imageNamed:@"Awning_Animation4.png"],
										 [UIImage imageNamed:@"Awning_Animation3.png"],
										 [UIImage imageNamed:@"Awning_Animation2.png"],
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 nil];
		}
		else
		{
			
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 [UIImage imageNamed:@"Awning_Animation2.png"],
										 [UIImage imageNamed:@"Awning_Animation3.png"],
										 [UIImage imageNamed:@"Awning_Animation4.png"],
										 [UIImage imageNamed:@"Awning_Animation5.png"],
										 [UIImage imageNamed:@"Awning_Animation6.png"],
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_BLIND)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 [UIImage imageNamed:@"Blind_Animation2.png"],
										 [UIImage imageNamed:@"Blind_Animation3.png"],
										 [UIImage imageNamed:@"Blind_Animation4.png"],
										 [UIImage imageNamed:@"Blind_Animation5.png"],
										 [UIImage imageNamed:@"Blind_Animation6.png"],
										 [UIImage imageNamed:@"Blind_Animation7.png"],
										 [UIImage imageNamed:@"Blind_Animation8.png"],
										 [UIImage imageNamed:@"Blind_Animation9.png"],
										 [UIImage imageNamed:@"Blind_Animation10.png"],
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Blind_Animation10.png"],
										 [UIImage imageNamed:@"Blind_Animation9.png"],
										 [UIImage imageNamed:@"Blind_Animation8.png"],
										 [UIImage imageNamed:@"Blind_Animation7.png"],
										 [UIImage imageNamed:@"Blind_Animation6.png"],
										 [UIImage imageNamed:@"Blind_Animation5.png"],
										 [UIImage imageNamed:@"Blind_Animation4.png"],
										 [UIImage imageNamed:@"Blind_Animation3.png"],
										 [UIImage imageNamed:@"Blind_Animation2.png"],
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_CELLULAR_SHADE)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion2.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion3.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion4.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion5.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion6.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion7.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion8.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion9.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion10.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion11.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion12.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion13.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion14.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion15.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion16.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion17.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion17.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion16.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion15.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion14.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion13.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion12.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion11.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion10.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion9.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion8.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion7.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion6.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion5.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion4.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion3.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion2.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_DRAPERY)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"DraPery_Animation1.png"],
										 [UIImage imageNamed:@"DraPery_Animation2.png"],
										 [UIImage imageNamed:@"DraPery_Animation3.png"],
										 [UIImage imageNamed:@"DraPery_Animation4.png"],
										 [UIImage imageNamed:@"DraPery_Animation5.png"],
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 [UIImage imageNamed:@"DraPery_Animation5.png"],
										 [UIImage imageNamed:@"DraPery_Animation4.png"],
										 [UIImage imageNamed:@"DraPery_Animation3.png"],
										 [UIImage imageNamed:@"DraPery_Animation2.png"],
										 [UIImage imageNamed:@"DraPery_Animation1.png"],
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROLLER_SHADE)
	{
		
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Rollar_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROLLER_SHUTTER)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation11.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation12.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation13.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation14.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation15.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation16.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation17.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation18.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation19.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation20.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation21.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation22.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation23.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Rollar_Shutter_Animation23.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation22.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation21.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation20.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation19.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation18.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation17.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation16.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation15.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation14.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation13.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation12.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation11.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_ROMAN_SHADE)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation11.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Roman_Shade_Animation11.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation2.png"],
										  [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_SCREEN_SHADE)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 [UIImage imageNamed:@"Screen_Animation2.png"],
										 [UIImage imageNamed:@"Screen_Animation3.png"],
										 [UIImage imageNamed:@"Screen_Animation4.png"],
										 [UIImage imageNamed:@"Screen_Animation5.png"],
										 [UIImage imageNamed:@"Screen_Animation6.png"],
										 [UIImage imageNamed:@"Screen_Animation7.png"],
										 [UIImage imageNamed:@"Screen_Animation8.png"],
										 [UIImage imageNamed:@"Screen_Animation9.png"],
										 [UIImage imageNamed:@"Screen_Animation10.png"],
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Screen_Animation10.png"],
										 [UIImage imageNamed:@"Screen_Animation9.png"],
										 [UIImage imageNamed:@"Screen_Animation8.png"],
										 [UIImage imageNamed:@"Screen_Animation7.png"],
										 [UIImage imageNamed:@"Screen_Animation6.png"],
										 [UIImage imageNamed:@"Screen_Animation5.png"],
										 [UIImage imageNamed:@"Screen_Animation4.png"],
										 [UIImage imageNamed:@"Screen_Animation3.png"],
										 [UIImage imageNamed:@"Screen_Animation2.png"],
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 nil];
		}
	}
	else if([[deviceDict objectForKey:@"metaData"]intValue] == RTS_SOLAR_SCREEN)
	{
		if(curSelection==1 || curSelection==2)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation2.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation3.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation4.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation5.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation6.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation7.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Solar_Screen_Animation7.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation6.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation5.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation4.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation3.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation2.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 nil];
		}
	}
	imgDevice.animationDuration = 1.2;
	// repeat the annimation forever
	imgDevice.animationRepeatCount = 1;
	// start animating
	[imgDevice startAnimating];
}

-(void)OpenWindow
{
	animationScrollView.hidden = NO;
	animateImageView.frame = CGRectMake(0, 85, 320, 100);
	yPosition = 85;
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
	animateImageView.frame = CGRectMake(0, yPosition, 320, 100);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=0)
	{
		yPosition = 0;
		[openTimer invalidate];
		openTimer = nil;
		[self performSelector:@selector(CloseWindow) withObject:nil afterDelay:2];
	}
}

-(void)CloseDisplayTask
{
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(0, yPosition, 320, 100);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=85)
	{
		yPosition = 85;
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
	if(strCommand == DEVICE_SETVALUE)
	{
		[[DeviceService getSharedInstance] getAll:self];
	}
	else if (strCommand == GET_ALL)
	{
		[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		[self hideLoadingView];
		scrollView.hidden = NO;
		[self OpenWindow];
		isAnimation = YES;
	}
	else if(strCommand == SET_SOMFY_MY_POSITION)
	{
		[self hideLoadingView];
		scrollView.hidden = NO;
		[self OpenWindow];
		isAnimation = YES;
	}
	else if(strCommand == LOGOUT)
	{
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		
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
	[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	[self hideLoadingView];
	applyBtn.enabled = YES;
	applyAllBtn.enabled = YES;
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
	[applyBtn,applyAllBtn release];
	[btnOpen,btnClose,btnMy release];
	[animateImageView,animationScrollView,animationTitle1,animationTitle2 release];
	[imgDevice release];
	[scrollView release];
	[deviceName,roomName release];
	[deviceDict,roomNameString release];
    [super dealloc];
}


@end
