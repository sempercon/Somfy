//
//  DimmerDevice.m
//  Somfy
//
//  Created by Sempercon on 4/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DimmerDevice.h"
#import "AppDelegate_iPhone.h"
#import "DeviceService.h"
#import "DashboardService.h"
#include <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "UserService.h"
#import "DBAccess.h"

@interface DimmerDevice (Private)
- (void)showLoadingView;
-(void)setSliderPosition:(int)value;
- (void)hideLoadingView;
-(UIImage *) getDeviceImageForValue :(int)deviceValue;
@end

extern BOOL  _isLOGOUT;

@implementation DimmerDevice

@synthesize VerticalSliderview,deviceDict;
@synthesize imgView,DimmerDeviceImage;
@synthesize valueLbl,roomNameString;
@synthesize deviceName,roomName;
@synthesize animatedImageView;
@synthesize scrollView;
@synthesize applyBtn,applyAllBtn;
@synthesize selectedRoomDeviceArray;

//Animation
@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle1,animationTitle2;
@synthesize dimmerDeviceBtn;
@synthesize Logout;

//Dimmer device slider constants
float iphone_SLIDER_OFFSET = 1.2;
float iphone_totalOffset = 134;
int iphone_SLIDER_X = 3;


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
	[animatedImageView addSubview:animationTitle1];
	//[animationTitle1 release];
	
	NSString *temp=@"";
	animationTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 44, 300, 30)];
	temp = [deviceDict objectForKey:@"name"];
	temp = [temp stringByAppendingString:@" was updated."];
	animationTitle2.text = temp;
	animationTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	animationTitle2.backgroundColor = [UIColor clearColor];
	[animatedImageView addSubview:animationTitle2];
	//[animationTitle2 release];
	
	self.navigationController.navigationBar.hidden = YES;
	
	//Set DeviceName and RoomName
	roomName.text = roomNameString;
	deviceName.text = [deviceDict objectForKey:@"name"];
	
	[self setSliderPosition:[[deviceDict objectForKey:@"value"]intValue]];
	
    [super viewDidLoad];
}

-(void)setSliderPosition:(int)value
{
	sliderValue = value;
	float sliderPos;
	sliderPos = iphone_totalOffset - (value * iphone_SLIDER_OFFSET);
	lastYPoint = sliderPos;
	imgView.center = CGPointMake(iphone_SLIDER_X+15, sliderPos);
	
	if(value>100)
		value = 100;
	if(value<0)
		value = 0;
	
	valueLbl.text = [NSString stringWithFormat:@"%d",value];
	valueLbl.text = [valueLbl.text stringByAppendingString:@"%"];
	//DimmerDeviceImage.image = [self getDeviceImageForValue:value];
	[dimmerDeviceBtn setBackgroundImage:[self getDeviceImageForValue:value] forState:UIControlStateNormal];
}


-(void)LoadImageView:(float)val
{
	float sliderVal=0.0;
	sliderVal = val ;
	
	//Find value of adjust slider
	float result = (iphone_totalOffset - sliderVal) / 1.2;
	sliderValue = result;
	
	//set slider value label text
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
	sliderVal = iphone_totalOffset - (sliderValue * 1.2);
	
	//Set tracking image as center
	imgView.center = CGPointMake(iphone_SLIDER_X+15, sliderVal);
	
	valueLbl.text = [NSString stringWithFormat:@"%d",sliderValue];
	valueLbl.text = [valueLbl.text stringByAppendingString:@"%"];
	//DimmerDeviceImage.image = [self getDeviceImageForValue:sliderValue];
	[dimmerDeviceBtn setBackgroundImage:[self getDeviceImageForValue:sliderValue] forState:UIControlStateNormal];
	
	applyBtn.enabled = YES;
	applyAllBtn.enabled = YES;
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
	if ([touch view] == VerticalSliderview)
	{
		CGPoint touchPoint = [touch locationInView:VerticalSliderview];
		if(touchPoint.x>0&&touchPoint.x<50&&touchPoint.y>12&&touchPoint.y<=135)
		{
			[self LoadImageView:touchPoint.y];
			lastYPoint = touchPoint.y;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)Increase:(id)sender
{
	lastYPoint-= 12;
	if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 14;
		[self LoadImageView:lastYPoint];
	}
}
-(IBAction)Decrease:(id)sender
{
	lastYPoint+= 12;
	if(lastYPoint>12&&lastYPoint<=135)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 134;
		[self LoadImageView:lastYPoint];
	}
}

-(IBAction)ApplyClicked:(id)sender
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

-(IBAction)ApplyallClicked:(id)sender
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

-(IBAction)dimmerDeviceBtnClicked:(id)sender
{
	[self showLoadingView];
	
	if(sliderValue == 0)
		sliderValue =100;
	else if (sliderValue >0)
		sliderValue = 0;
	
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
	[self setSliderPosition:sliderValue];
}

-(IBAction)btnBackClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
	[tempDevicesArray release];
	[selectedRoomDeviceArray release];
	[dimmerDeviceBtn release];
	[applyBtn,applyAllBtn release];
	[animateImageView,animationScrollView,animationTitle1,animationTitle2 release];
	[deviceName,roomName release];
	[VerticalSliderview release];
	[imgView,DimmerDeviceImage release];
	[valueLbl release];
	[deviceDict,roomNameString release];
    [super dealloc];
}


@end
