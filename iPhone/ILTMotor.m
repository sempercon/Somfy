//
//  ILTMotor.m
//  Somfy
//
//  Created by mac user on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILTMotor.h"
#import "AppDelegate_iPhone.h"
#import "DashboardService.h"
#import "DeviceService.h"
#include <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "DeviceIconMapper.h"
#import "UserService.h"
#import "DBAccess.h"

@interface ILTMotor (Private)
- (void)hideLoadingView;
- (void)showLoadingView;
-(void)setSliderPosition:(int)value;
-(void)LoadImageView:(float)val;
@end

extern BOOL  _isLOGOUT;

@implementation ILTMotor


@synthesize deviceDict,VerticalSliderview;
@synthesize roomNameString;
@synthesize deviceName,roomName;
@synthesize scrollView,deviceImage;

@synthesize trackView,imgView;
@synthesize trackingImg,trackBottomImg;
@synthesize valueLabel;
@synthesize iltSliderBg;
@synthesize applyBtn,applyAllBtn;
@synthesize selectedRoomDeviceArray;

//Animation
@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize deviceScrollView;
@synthesize animationTitle1,animationTitle2;
@synthesize Logout;

//Dimmer device slider constants
float iphone_SLIDER_OFFSET1 = 1.2;
float iphone_totalOffset1 = 134;
int iphone_SLIDER_X1 = 3;

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
	
	tempDevicesArray = [[NSMutableArray alloc]init];
	
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
	if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SOLAR_SCREEN)
		iltSliderBg.image = [UIImage imageNamed:@"ILT_Solar_Screen_Slider_bg.png"];
	else 
		iltSliderBg.image = [UIImage imageNamed:@"ILT_sliderbg.png"];
	
	if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROMAN_SHADE)
		trackingImg.image = [UIImage imageNamed:@"ILT_RomanShade_Slider.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROLLER_SHADE)
		trackingImg.image = [UIImage imageNamed:@"ILT_RollerShade_Slider.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SOLAR_SCREEN)
		trackingImg.image = [UIImage imageNamed:@"ILT_Solar_Screen_Slider.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SCREEN)
		trackingImg.image = [UIImage imageNamed:@"ILT_Screen_Slider.png"];
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_BLIND)
		trackingImg.image = [UIImage imageNamed:@"ILT_Blind_Slider.png"];
	
	[self setSliderPosition:[[deviceDict objectForKey:@"value"]intValue]];
	//deviceImage.image = [[DeviceIconMapper getSharedInstance]getSomfyDeviceForiPhoneImageBasedOnDeviceType:[[deviceDict objectForKey:@"metaData"]intValue]];
	
	
	UIPanGestureRecognizer *singleTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
	[deviceScrollView addGestureRecognizer:singleTap]; 
	
    [super viewDidLoad];
}

- (void)singleTapGestureCaptured:(UIPanGestureRecognizer *)touch
{ 
	CGPoint touchPoint = [touch locationInView:deviceScrollView];
	if(touchPoint.y>=0&&touchPoint.y<=100)
	{
		//lastSliderValue = sliderValue;
		[self LoadImageView:touchPoint.y];
		lastYPoint = touchPoint.y;
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
	self.view = nil;
}

-(void)setSliderPosition:(int)value
{
	
	sliderValue = value;
	trackBottomImg.frame = CGRectMake(0, 100-value, 114,12 );
	if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROMAN_SHADE)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 87);
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROLLER_SHADE)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 115);
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SCREEN)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 107);
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_BLIND)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 96);
	else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SOLAR_SCREEN)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 96);
	
	lastYPoint = 100-value;
	
	if(sliderValue>100)
		sliderValue = 100;
	if(sliderValue<0)
		sliderValue = 0;
	
	valueLabel.text = [NSString stringWithFormat:@"%d",sliderValue];
	valueLabel.text = [valueLabel.text stringByAppendingString:@"%"];
	
	float sliderPos;
	sliderPos = 135 - ( (value) * 1.2 );
	//lastYPoint = sliderPos;
	imgView.center = CGPointMake(iphone_SLIDER_X1+15, sliderPos);
}

 -(void)LoadImageView:(float)val
 {
	 applyBtn.enabled = YES;
	 applyAllBtn.enabled = YES;
	 
	 lastYPoint = val;
	 trackBottomImg.frame = CGRectMake(0, val, 114,12 );
	  
	 if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROMAN_SHADE)
		 trackingImg.frame = CGRectMake(0, val-100, 112, 87);
	 else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_ROLLER_SHADE)
		 trackingImg.frame = CGRectMake(0, val-100, 112, 115);
	 else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SCREEN)
		 trackingImg.frame = CGRectMake(0, val-100, 112, 107);
	 else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_BLIND)
		 trackingImg.frame = CGRectMake(0, val-100, 112, 96);
	 else if([[deviceDict objectForKey:@"metaData"]intValue] == ILT_SOLAR_SCREEN)
		 trackingImg.frame = CGRectMake(0, val-100, 112, 96);
	 
	 //Find value of adjust slider
	 sliderValue = 100 - val;
	 //set slider value label text
	 
	 if(sliderValue>100)
		 sliderValue = 100;
	 if(sliderValue<0)
		 sliderValue = 0;
	 
	 valueLabel.text = [NSString stringWithFormat:@"%d",sliderValue];
	 valueLabel.text = [valueLabel.text stringByAppendingString:@"%"];
	 
	 float sliderVal=0.0;
	 sliderVal = 135 - ( (100 - val) * 1.2 );
	 
	 //Set tracking image as center
	 imgView.center = CGPointMake(iphone_SLIDER_X1+15, sliderVal);
	
 }


// Moving on image
#pragma mark -
#pragma mark TOUCH DELEGATES

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		CGPoint touchPoint = [touch locationInView:trackView];
		if(touchPoint.y>=0&&touchPoint.y<=100)
		{
			lastSliderValue = sliderValue;
		}
	}
	if ([touch view] == VerticalSliderview)
	{
		CGPoint touchPoint = [touch locationInView:VerticalSliderview];
		if(touchPoint.x>0&&touchPoint.x<50&&touchPoint.y>12&&touchPoint.y<=135)
		{
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
		if(touchPoint.y>=0&&touchPoint.y<=100)
		{
			[self LoadImageView:touchPoint.y];
			lastYPoint = touchPoint.y;
		}
	}
	if ([touch view] == VerticalSliderview)
	{
		CGPoint touchPoint = [touch locationInView:VerticalSliderview];
		if(touchPoint.x>0&&touchPoint.x<50&&touchPoint.y>12&&touchPoint.y<=135)
		{
			float result = (iphone_totalOffset1 - touchPoint.y) / 1.2;
			//[self LoadImageView:touchPoint.y];
			//lastYPoint = touchPoint.y;
			[self LoadImageView:100-result];
			lastYPoint = 100-result;		
		}
	}

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*if(lastSliderValue!=sliderValue)
	{
		[self showLoadingView];
		
		NSString *deviceId = [deviceDict objectForKey:@"id"];
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
	}*/
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)ILTMotorIncreaseClicked:(id)sender
{
	lastYPoint-= 10;
	if(lastYPoint<=0)
		lastYPoint = 0;
	[self LoadImageView:lastYPoint];
	
	
	/*if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 14;
		[self LoadImageView:lastYPoint];
	}*/	
}
-(IBAction)ILTMotorDecreaseClicked:(id)sender
{
	lastYPoint+= 10;
	if(lastYPoint>=100)
		lastYPoint = 100;
	[self LoadImageView:lastYPoint];
	
	/*lastYPoint+= 12;
	if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 134;
		[self LoadImageView:lastYPoint];
	}*/
}
-(IBAction)ILTMotorOpenClicked:(id)sender
{
	[self LoadImageView:0];
}
-(IBAction)ILTMotorCloseClicked:(id)sender
{
	[self LoadImageView:100];
}

-(IBAction)ILTMotorApplyClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
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

-(IBAction)ILTMotorApplyAllClicked:(id)sender
{
	if([tempDevicesArray count]>0)
		[tempDevicesArray removeAllObjects];
	
	if(selectedRoomDeviceArray!=nil)
	{
		for (int i=0; i<[selectedRoomDeviceArray count]; i++) {
			int deviceType = [[[selectedRoomDeviceArray objectAtIndex:i]objectForKey:@"deviceType"] intValue];
			if(deviceType == [[deviceDict objectForKey:@"deviceType"] intValue])
			{
				//Add all same devicetype devices in the tempDevicesArray 
				[tempDevicesArray addObject:[selectedRoomDeviceArray objectAtIndex:i]];
			}
		}
	}
	
	if([tempDevicesArray count]>0)
	{
		[self setApplyAlltoDevices];
	}
}

-(IBAction)btnBackClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TOUCH DELEGATES

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == VerticalSliderview)
	{
		CGPoint touchPoint = [touch locationInView:VerticalSliderview];
		if(touchPoint.x>0&&touchPoint.x<30&&touchPoint.y>12&&touchPoint.y<=135)
		{
			lastSliderValue = sliderValue;
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch *touch = [touches anyObject];
	if ([touch view] == VerticalSliderview)
	{
		CGPoint touchPoint = [touch locationInView:VerticalSliderview];
		if(touchPoint.x>0&&touchPoint.x<30&&touchPoint.y>12&&touchPoint.y<=135)
		{
			[self LoadImageView:touchPoint.y];
			lastYPoint = touchPoint.y;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}*/

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
		
		[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
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
	
	[QueueTimer invalidate];
	QueueTimer=nil;
	queueEnum = NONE;
	
	if([errorMsg isEqualToString:@"SESSION EXPIRED"])
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert setTag:255];
		[errorAlert show];
		[errorAlert release];
		
	/*	[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
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
	[tempDevicesArray release];
	[selectedRoomDeviceArray release];
	[applyBtn,applyAllBtn release];
	[animateImageView,animationScrollView,animationTitle1,animationTitle2 release];
	[trackView,VerticalSliderview,imgView,deviceImage release];
	[trackingImg,trackBottomImg release];
	[valueLabel release];
	[deviceScrollView release];
	[scrollView release];
	[deviceName,roomName release];
	[deviceDict,roomNameString release];
	[iltSliderBg release];
    [super dealloc];
}


@end
