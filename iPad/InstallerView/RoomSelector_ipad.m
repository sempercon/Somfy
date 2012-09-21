//
//  RoomSelector_ipad.m
//  Somfy
//
//  Created by Sempercon on 4/28/11.
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
#include <QuartzCore/QuartzCore.h>
#import "RoomService.h"
#import "RoomIconMapper.h"
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "RRSGlowLabel.h"
#import "MJPEGViewer_iPad.h"

@interface RoomSelector_ipad (Private)
-(void)showLoadingView;
-(void)hideLoadingView;
@end

extern BOOL  isLOGOUT;

@implementation RoomSelector_ipad
@synthesize scrollView;
@synthesize AddView,EditView;
@synthesize RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn;
@synthesize EditSubmitBtn,EditCancelBtn,AddCreateBtn,AddCancelBtn;
@synthesize AddRoomTextField,EditRoomTextField;


//Animation
@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle;

@synthesize Logout;

extern BOOL  isAddRoom;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

-(void)LoadRooms:(NSMutableArray*)roomListArr
{
	UIImage *RoomImage;
	int nRoomCount =0;
	int x=0,y=0;
	int isSelectedRoom = 0;
	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [scrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	
	
	for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];i++)
	{
		isSelectedRoom = 0;
		
		UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x, y, 115, 115);
		[customBtn setTag:i];
		
		// Check for room selection
		for(int h=0;h<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];h++)
		{
			NSString *roomKey = [[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:h] objectForKey:@"roomKey"];
			if([roomKey isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]objectForKey:@"id"]])
			{
				RoomImage = [[RoomIconMapper getSharedInstance]getRoomImageBasedOnRoomId:[[[roomListArr objectAtIndex:i]objectForKey:@"id"]intValue]:1];
				[customBtn setBackgroundImage:RoomImage forState:UIControlStateNormal];
				customBtn.alpha = 1.0;
				isSelectedRoom = 1;
				break;
			}
		}
	
		if(isSelectedRoom == 0) 
		{
			RoomImage = [[RoomIconMapper getSharedInstance]getRoomImageBasedOnRoomId:[[[roomListArr objectAtIndex:i]objectForKey:@"id"]intValue]:0];
			[customBtn setBackgroundImage:RoomImage forState:UIControlStateNormal];
			customBtn.alpha = 0.7;
		}
		
		//NSUInteger index = [[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray ] indexOfObject:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:i]objectForKey:@"id"]];
		//if(index!=NSNotFound)
			//customBtn.alpha = 1.0;
		
		[customBtn addTarget:self action:@selector(RoomSelect:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:customBtn];
		[customBtn release];
		
		RRSGlowLabel *lbl3 = [[RRSGlowLabel alloc]initWithFrame:CGRectMake(x-10, y+105, 135, 55)];
		if(isSelectedRoom == 1)
		{
			lbl3.textColor = [UIColor colorWithRed:(float)27/255 green:(float)54/255 blue:(float)66/255 alpha:1.0 ];
			lbl3.glowColor = lbl3.textColor;
		}
		else
		{
			lbl3.textColor = [UIColor whiteColor];
			lbl3.glowColor = [UIColor colorWithRed:157/255 green:163/255 blue:167/255 alpha:1.0 ];
		}
		
		
		//lbl3.glowColor = [UIColor colorWithRed:1.0 green:0.70 blue:1.0 alpha:1.0];
		lbl3.glowOffset = CGSizeMake(0.0, 0.0);
		lbl3.glowAmount = 10.0;

		
		lbl3.backgroundColor = [UIColor clearColor];
		lbl3.textAlignment = UITextAlignmentCenter;
		lbl3.lineBreakMode = UILineBreakModeWordWrap;
		lbl3.numberOfLines = 0;
		
		lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		
		lbl3.text = [[roomListArr objectAtIndex:i]objectForKey:@"name"];
		[scrollView addSubview:lbl3];
		[lbl3 release];
		
		x = x+100+10;
		
		UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn1.frame = CGRectMake(x+8, y, 40, 40);
		[customBtn1 setTag:i];
		[customBtn1 setBackgroundImage:[UIImage imageNamed:@"edit_over.png"] forState:UIControlStateNormal];
		[customBtn1 addTarget:self action:@selector(RoomEdit:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:customBtn1];
		[customBtn1 release];
		
		if([[[roomListArr objectAtIndex:i]objectForKey:@"id"]intValue]>28)
		{
			UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			customBtn1.frame = CGRectMake(x+8, y+50, 40, 40);
			[customBtn1 setTag:i];
			[customBtn1 setBackgroundImage:[UIImage imageNamed:@"delete_up.png"] forState:UIControlStateNormal];
			[customBtn1 addTarget:self action:@selector(RoomDelete:) forControlEvents:UIControlEventTouchUpInside];
			[scrollView addSubview:customBtn1];
			[customBtn1 release];
		}
		
		x = x+40+10;
		nRoomCount++;
		if(nRoomCount == 5 || i == [roomListArr count]-1)
		{
			nRoomCount = 0;
			x=0;
			y=y+170;
			[scrollView setContentSize:CGSizeMake(840, y)];
		}
	}
	if(isNewRoomAdded)
	{
		isNewRoomAdded = 0;
		if([scrollView contentSize].height > 800)
		{
			LastOffsetPointScenes =  CGPointMake(0,[scrollView contentSize].height - 400);
		}
		[scrollView setContentOffset:LastOffsetPointScenes animated:YES];
	}
	else 
		[scrollView setContentOffset:LastOffsetPointScenes animated:NO];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    if (isLocal == 1)
        self.Logout.hidden = YES;
        
	isNewRoomAdded = 0;
	//Animation
	animationScrollView.hidden = YES;
	isRemoveCommand = NO;
	animationTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 350, 70)];
	animationTitle.lineBreakMode = UILineBreakModeWordWrap;
	animationTitle.numberOfLines = 0;
	animationTitle.textAlignment = UITextAlignmentCenter;
	animationTitle.font = [UIFont systemFontOfSize:13];
	animationTitle.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle];
	
	[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_roomsArray];
	//[[RoomService getSharedInstance] GetSelectedRoom:self];
	// set the content size so it can be scrollable
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	AddRoomTextField.leftView = paddingView;
	AddRoomTextField.leftViewMode = UITextFieldViewModeAlways;
	AddRoomTextField.placeholder= @"New Room Name";
	[paddingView release];

	UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	EditRoomTextField.leftView = paddingView1;
	EditRoomTextField.leftViewMode = UITextFieldViewModeAlways;
	[paddingView1 release];
	
    [super viewDidLoad];
}

-(IBAction)AddRoom:(id)sender
{
	isAddRoom = YES;
	[self.view addSubview:AddView];
}

-(IBAction)AddRoomCreate:(id)sender
{
	isNewRoomAdded = 1;
	[self showLoadingView];
	if([AddRoomTextField.text isEqualToString:@""])
		[[RoomService getSharedInstance] addRoom: @"New Room Name" :self];
	else {
			[[RoomService getSharedInstance] addRoom:AddRoomTextField.text :self];
		}

	AddRoomTextField.text = @"";
	animationTitle.text = @"Successfully created a new room";
	LastOffsetPointScenes =  [scrollView contentOffset];
	[AddView removeFromSuperview];
}
-(IBAction)AddRoomCancel:(id)sender
{
	[AddView removeFromSuperview];
}
-(IBAction)EditRoomSubmit:(id)sender
{
	LastOffsetPointScenes =  [scrollView contentOffset];
	animationTitle.text = @"Successfully changed the name of the room";
	[self showLoadingView];
	[[RoomService getSharedInstance] changeRoomName:EditRoomTextField.text :[NSString stringWithFormat:@"%d",g_selectedRoomId] :self];
	EditRoomTextField.text =@"";
	[EditView removeFromSuperview];
}
-(IBAction)EditRoomCancel:(id)sender
{
	[EditView removeFromSuperview];
}


-(void)RoomSelect:(id)sender
{
	NSString *selectedRooms=@"";
	UIButton *btn = (UIButton*)sender;
	[self showLoadingView];
	// Check for room selection
	
	// Check for room selection
	BOOL isExists = NO;
	int index = 0;
	for(int h=0;h<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];h++)
	{
		NSString *roomKey = [[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:h] objectForKey:@"roomKey"];
		if([roomKey isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"]])
		{
			isExists = YES;	
			index = h;
			break;
		}
		
	}
	
	if(isExists)
	{
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:index];
	}
	else
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
		[dict setValue:[NSNumber numberWithInt:[[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"]intValue]] forKey:@"sortingKey"];
		[dict setObject:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"] forKey:@"roomKey"];
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray addObject:dict];
		[dict release];
	}
	
	
	
	/*NSUInteger index = [[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray indexOfObject:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"]];
	if(index==NSNotFound)
	{
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray addObject:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"]];
	}
	else 
	{
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:index];
	}*/
	
	for (int i=0; i < [[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count]; i++) 
	{
		selectedRooms = [selectedRooms stringByAppendingString:[NSString stringWithFormat:@".%@",[[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i] objectForKey:@"roomKey"]]];
	}
	//selectedRooms =@".27.28.46.24";
	animationTitle.text = @"Updated the selected room list";
	[[RoomService getSharedInstance] SetSelectedRoom:selectedRooms :self];
	LastOffsetPointScenes =  [scrollView contentOffset];
}

-(void)RoomEdit:(id)sender
{
	isAddRoom = YES;
	UIButton *btn = (UIButton*)sender;
	[self.view addSubview:EditView];
	g_selectedRoomId = [[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"]intValue ];
	EditRoomTextField.text	= [[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"name"];
}

-(void)RoomDelete:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	g_selectedRoomId = [[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:btn.tag]objectForKey:@"id"] intValue];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" 
												   message:@"Do you really want to delete this room ?" 
												  delegate:self 
										 cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
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
}


-(IBAction)DeviceConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view];
}
-(IBAction)SceneConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view];
}
-(IBAction)EventConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view];
}
-(IBAction)ScheduleConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
}
-(IBAction)Homeowner:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetHomeownerViewIndex]) {
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].viewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
			break;
		}
		default:
			break;
	}
}

-(void)viewWillAppear:(BOOL)animated
{
	[[AppDelegate_iPad sharedAppDelegate]SetInstallerViewIndex:1];
	[RoomSelectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
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
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==SELECTED_ROOM_COMMAND)
	{
		BOOL isExist;
		NSArray * array =[[[resultArray objectAtIndex:0]objectForKey:@"dataString"]componentsSeparatedByString:@"."];
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeAllObjects];
		for(int i=0;i<[array count];i++)
		{
			if([array objectAtIndex:i]!=nil&&![[array objectAtIndex:i] isEqualToString:@""])
			{
				NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
				[dict setValue:[NSNumber numberWithInt:[[array objectAtIndex:i]intValue]] forKey:@"sortingKey"];
				[dict setObject:[array objectAtIndex:i] forKey:@"roomKey"];
				[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray addObject:dict];
				[dict release];
			}
		}
		
		NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"sortingKey" ascending:YES];
		[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
		[lastNameSorter1 release];
		
		//Check if all selectedroomlist id's in the getrorom list
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];i++)
		{
			isExist = NO;
			for(int j=0;j<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];j++)
			{
				if([[[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i]objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
				{
					isExist = YES;
					break;
				}
			}
			if(!isExist)
				[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:i];
		}
		
		[[RoomService getSharedInstance] getRooms:self];
	}
	else if(strCommand==GET_ROOMS_COMMAND)
	{
		[AppDelegate_iPad  sharedAppDelegate].g_roomsArray = [resultArray mutableCopy];
		if(isRemoveCommand)
		{
			isRemoveCommand = NO;
			//Check if all selectedroomlist id's in the getrorom list
			for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray count];i++)
			{
				BOOL isExist = NO;
				for(int j=0;j<[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray count];j++)
				{
					if([[[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i]objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPad  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
					{
						isExist = YES;
						break;
					}
				}
				if(!isExist)
					[[AppDelegate_iPad  sharedAppDelegate].g_selectedRoomsArray removeObjectAtIndex:i];
			}
		}
		
		[self hideLoadingView];
		[self LoadRooms:[AppDelegate_iPad  sharedAppDelegate].g_roomsArray];
		[self OpenWindow];
	}
	
	else if(strCommand==SET_SELECTED_ROOM_COMMAND)
	{
		[[RoomService getSharedInstance] GetSelectedRoom:self];
	}
	else if(strCommand==ADD_ROOMS_COMMAND||strCommand==CHANGE_ROOM_NAME||strCommand==REMOVE_ROOM_COMMAND)
	{
		if(strCommand == REMOVE_ROOM_COMMAND)
		{
			isRemoveCommand = YES;
		}
		
		[[RoomService getSharedInstance] getRooms:self];
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
		[self showLoadingView];
		LastOffsetPointScenes =  [scrollView contentOffset];
		animationTitle.text = @"Successfully removed the room from the controller";
		[[RoomService getSharedInstance] removeRoom:[NSString stringWithFormat:@"%d",g_selectedRoomId] :self];
	}
}


- (void)dealloc {
    [Logout release];
	[animateImageView,animationScrollView,animationTitle release];
	[scrollView release];
	[AddView,EditView release];
	[AddRoomTextField,EditRoomTextField release];
	[EditSubmitBtn,EditCancelBtn,AddCreateBtn,AddCancelBtn release];
	[RoomSelectBtn,DeviceConfigBtn,SceneConfigBtn,EventConfigBtn,ScheduleConfigBtn,HomeownerBtn release];
    [super dealloc];
}

@end
	
