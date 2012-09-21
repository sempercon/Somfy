//
//  RoomsViewController.m
//  Somfy
//
//  Created by Sempercon on 4/24/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "RoomsViewController.h"
#import "AppDelegate_iPhone.h"
#import "RoomService.h"
#import "Constants.h"
#import "DeviceService.h"
#import "RoomCustomCell.h"
#import "RoomIconMapper.h"
#import "ThermostatDevice.h"
#import "DeviceIconMapper.h"
#import "BinaryLightDevice.h"
#import "DimmerDevice.h"
#import "OnewayMotor.h"
#import "ILTMotor.h"
#import "UserService.h"
#import "DBAccess.h"

extern BOOL  _isLOGOUT;

@interface RoomsViewController (Private)
-(void)LoadDevicesForRooms;
-(void) getDeviceSkinBasedOnDeviceType :(int)deviceType :(NSMutableDictionary *)dict :(NSString *)sRoomName :(NSMutableArray*)mutArray;
-(NSString*)getDeviceNameAndValue:(NSString*)strValue :(int)deviceType;
@end


@implementation RoomsViewController

@synthesize RoomsTable;
@synthesize _selectedRoomDevicesList;
@synthesize scrollView;
@synthesize Logout;

BOOL mybooleans[2048];


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

	memset(mybooleans,0,sizeof(mybooleans));
	_selectedRoomDevicesList = [[NSMutableArray alloc] init];
	self.navigationController.navigationBarHidden = YES;
	//[self LoadDevicesForRooms];
	//[self startTimer];
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[self LoadDevicesForRooms];
	
	/*TotalNoofRowsCount = 0;

	for (int i=0; i<[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count]; i++) {
		NSMutableArray *deviceArr = [_selectedRoomDevicesList objectAtIndex:i];
		TotalNoofRowsCount+= [deviceArr count];
	}
	
	TotalNoofRowsCount+= [[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count];
	
	int height = TotalNoofRowsCount * 45;
	[self.RoomsTable setFrame:CGRectMake(10, 72, 300, height)];
	[scrollView setContentSize:CGSizeMake(320, height+72)];*/
	
	[self.RoomsTable reloadData];
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


#pragma mark -
#pragma mark INITIAL LOAD

-(void)LoadDevicesForRooms
{
	if([_selectedRoomDevicesList count]>0)
		[_selectedRoomDevicesList removeAllObjects];
	
	
	NSMutableArray *excludeDeviceList = [[NSMutableArray arrayWithArray:[dashboardExcludedDeviceTypeList componentsSeparatedByString:@","]]retain];
	for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count];i++)
	{
		int roomid = [[[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:i] objectForKey:@"roomKey"] intValue];
		NSMutableArray *arr = [[NSMutableArray alloc]init];
		for(int j=0;j<[[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray count];j++)
		{
			if(roomid==[[[[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray objectAtIndex:j] objectForKey:@"roomID"] intValue])
			{
				// Check excludedevicelist in dashboard selection
				NSUInteger index = [excludeDeviceList indexOfObject:[[[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray objectAtIndex:j]objectForKey:@"deviceType"]];
				if(index==NSNotFound)
				{
					[arr addObject:[[AppDelegate_iPhone  sharedAppDelegate].g_DevicesArray objectAtIndex:j]];
				}
			}
		}
		[_selectedRoomDevicesList addObject:arr];
		[arr release];
	}
}


#pragma mark -
#pragma mark TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	TotalNoofRowsCount = 0;
	
	for (int i=0; i<[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count]; i++) {
		if (mybooleans[i])
		{
			NSMutableArray *deviceArr = [_selectedRoomDevicesList objectAtIndex:i];
			TotalNoofRowsCount+= [deviceArr count];
		}
	}
	TotalNoofRowsCount+= [[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count];
	int height = TotalNoofRowsCount * 45;
	[self performSelector:@selector(setTableViewHeight:) withObject:[NSString stringWithFormat:@"%d",height] afterDelay:0];
	
    return [[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
	if (mybooleans[section]) {
		NSMutableArray *deviceArr = [_selectedRoomDevicesList objectAtIndex:section];
		///we want the number of people plus the header cell
		return [deviceArr count]+1;
	} else {
		///we just want the header cell
		return 1;
	}
	return 1;
	
	//NSMutableArray *deviceArr = [_selectedRoomDevicesList objectAtIndex:section];
	//return [deviceArr count]+1;
	
}

-(void)setTableViewHeight:(NSString*)strHeight
{
	int height = [strHeight intValue];
	[self.RoomsTable setFrame:CGRectMake(10, 72, 300, height)];
	[scrollView setContentSize:CGSizeMake(320, height+92)];
}


- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UIImage *DeviceImage,*RoomImage;
	static NSString *identifier = @"RoomCustomCell";
    RoomCustomCell *cell = (RoomCustomCell *)[self.RoomsTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 304, 45);
        cell = [[[RoomCustomCell alloc] initWithFrame:rect reuseIdentifier:identifier] retain];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.delegate = self;
    } 
	cell.imgBg.hidden = YES;
	cell.lblDeviceName.hidden = YES;
	cell.lblDeviceSubTitle1.hidden = YES;
	cell.lblDeviceSubTitle2.hidden = YES;
	cell.lblDeviceSubValue1.hidden = YES;
	cell.lblDeviceSubValue2.hidden = YES;
	cell.lblDeviceSubValue1Deg.hidden = YES;
	cell.lblDeviceSubValue2Deg.hidden = YES;

	
	if(indexPath.section == 0 && indexPath.row == 0)
		cell.backgroundImg.image = [UIImage imageNamed:@"top_bg.png"];
	else if(indexPath.section ==[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count]-1)
	{
		if(!mybooleans[indexPath.section])
			cell.backgroundImg.image = [UIImage imageNamed:@"bottom-bg.png"];
		else
			cell.backgroundImg.image = [UIImage imageNamed:@"top2_bg.png"];
	}
	else if(indexPath.row == 0)
		cell.backgroundImg.image = [UIImage imageNamed:@"top2_bg.png"];
	
	
	
	//cell.lblActivated.hidden = YES;
	if(indexPath.row==0)
	{
		cell.backgroundImg.hidden = NO;
		cell.lblRoomName.hidden = NO;
		for(int j=0;j<[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray count];j++)
		{
			if([[[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:indexPath.section] objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
			{
				//[cell.lblSceneName setTitle:[[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"name"] forState:UIControlStateNormal];
				cell.lblRoomName.text = [[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"name"];
				break;
			}
		}
		RoomImage = [[RoomIconMapper getSharedInstance]getRoomImageBasedOnRoomIdForIphone:[[[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:indexPath.section] objectForKey:@"roomKey"]intValue]];
		cell.img.hidden = NO;
		cell.img.image = RoomImage;
		//[cell.btnScene setBackgroundImage:RoomImage forState:UIControlStateNormal];
		
		/*if (mybooleans[indexPath.section])
			cell.imageIndicator.image = [UIImage imageNamed:@"carat-open.png"];
		else
			cell.imageIndicator.image = [UIImage imageNamed:@"carat.png"];*/
		cell.accessoryType = UITableViewCellSelectionStyleNone;
	}
	else
	{
		NSMutableArray *DeviceArr = [_selectedRoomDevicesList objectAtIndex:indexPath.section];
		cell.backgroundImg.hidden = YES;
		cell.imgBg.hidden = NO;
		if(indexPath.row == 1)
			cell.imgBg.image = [UIImage imageNamed:@"iP_Room_Expand_Bg.png"];
		else if(indexPath.row == [DeviceArr count] && indexPath.section == [[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray count]-1)
			cell.imgBg.image = [UIImage imageNamed:@"iP_Device_bottom-bg.png"];
		else 
		{
			cell.imgBg.image = [UIImage imageNamed:@"iP_Room_Expand_Bg2.png"];
		}

			
		cell.lblRoomName.hidden = YES;
		
		
		DeviceImage = [[DeviceIconMapper getSharedInstance]getDeviceForiPhoneImageBasedOnDeviceType:[[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"deviceType"]intValue] :[[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"metaData"]intValue]:[[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"value"]intValue]];
		//[cell.btnScene setBackgroundImage:DeviceImage forState:UIControlStateNormal];
		cell.img.hidden = NO;
		cell.img.image = DeviceImage;
		
		cell.lblDeviceName.hidden = NO;
		cell.lblDeviceName.text = [[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"name"];
		
		if([[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"deviceType"]intValue] ==  THERMOSTATV2 || [[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"deviceType"]intValue] == THERMOSTAT_RCS)
		{
			
			NSString *devId = [[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"zwaveID"];
			NSMutableDictionary *curThermostatInfo;
			for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray count];i++)
			{
				if([devId isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]] )
				{
					curThermostatInfo = [[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i];
					break;
				}
			}
			
			cell.lblDeviceSubTitle1.hidden = NO;
			cell.lblDeviceSubTitle1.text = @"Ambient: ";
			cell.lblDeviceSubValue1.hidden = NO;
			cell.lblDeviceSubValue1.text = [curThermostatInfo objectForKey:@"ambientTemp"];
			cell.lblDeviceSubValue1Deg.hidden = NO;
			cell.lblDeviceSubTitle2.hidden = NO;
			cell.lblDeviceSubTitle2.text = @"Set: ";
			cell.lblDeviceSubValue2.hidden = NO;
			cell.lblDeviceSubValue2.text = [curThermostatInfo objectForKey:@"setTemp"];
			cell.lblDeviceSubValue2Deg.hidden = NO;
			
			//  Hint Showing ThermoState Off
			NSString *DeviceStatus=@"";
			if([[curThermostatInfo objectForKey:@"setTemp"] isEqualToString:@"0"])
			{
				cell.lblDeviceSubValue2.text= [DeviceStatus stringByAppendingString:@"OFF"];
				cell.lblDeviceSubValue2Deg.hidden = YES;
			}
			else
			{
				cell.lblDeviceSubValue2.text = [curThermostatInfo objectForKey:@"setTemp"];
			    cell.lblDeviceSubValue2Deg.hidden = NO;
			}
			
		}
		else 
		{
			NSString *tempValue = [self getDeviceNameAndValue :[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"value"] :[[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"deviceType"]intValue]];
			
			if(![tempValue isEqualToString:@""])	
			{
				cell.lblDeviceSubTitle1.hidden = NO;
				cell.lblDeviceSubTitle1.text = @"Level: ";
				cell.lblDeviceSubValue1.hidden = NO;
				cell.lblDeviceSubValue1.text = tempValue;
			}
			
		}
		//cell.backgroundColor = [UIColor colorWithRed:(float)248/255 green:(float)248/255 blue:(float)248/255 alpha:1.0 ];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.imageIndicator.image = [UIImage imageNamed:@""];
		//[cell.lblSceneName setTitle:[[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"name"] forState:UIControlStateNormal];
		//cell.lblSceneName.text = [[DeviceArr objectAtIndex:indexPath.row-1]objectForKey:@"name"];
	}
	
    return cell;
}

-(NSString*)getDeviceNameAndValue:(NSString*)strValue :(int)deviceType
{
	NSString *str=@"";
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
		{
			str = [str stringByAppendingString:strValue];
			str = [str stringByAppendingString:@"%"];
			break;
		}
		case SOMFY_RTS:
		{
			
			break;
		}
		case SOMFY_ILT:
		{
			str = [str stringByAppendingString:strValue];
			str = [str stringByAppendingString:@"%"];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*if(indexPath.row!=0)
		cell.backgroundColor = [UIColor colorWithRed:(float)248/255 green:(float)248/255 blue:(float)248/255 alpha:1.0 ];*/
	
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.row==0)
	{
		mybooleans[indexPath.section] = !mybooleans[indexPath.section];
		
		[self.RoomsTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
	}
	else
	{
		NSString *roomName;
		for(int j=0;j<[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray count];j++)
		{
			if([[[[AppDelegate_iPhone  sharedAppDelegate].g_selectedRoomsArray objectAtIndex:indexPath.section] objectForKey:@"roomKey"] isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"id"]])
			{
				roomName = [[[AppDelegate_iPhone  sharedAppDelegate].g_roomsArray objectAtIndex:j]objectForKey:@"name"];
				break;
			}
		}
		
		NSMutableDictionary *selectedDeviceDict;
		NSMutableArray *DeviceArr = [_selectedRoomDevicesList objectAtIndex:indexPath.section];
		selectedDeviceDict = [DeviceArr objectAtIndex:indexPath.row-1];
		[self getDeviceSkinBasedOnDeviceType:[[selectedDeviceDict objectForKey:@"deviceType"]intValue] :selectedDeviceDict :roomName :DeviceArr];
	}
}

-(void)RoomSelected:(RoomCustomCell*)cell
{
}


-(void) getDeviceSkinBasedOnDeviceType :(int)deviceType :(NSMutableDictionary *)dict :(NSString *)sRoomName :(NSMutableArray*)mutArray
{
	switch ( deviceType )
	{
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
		{
			ThermostatDevice *thermostatDevice = [[ThermostatDevice alloc]initWithNibName:@"ThermostatDevice" bundle:nil];
			thermostatDevice.deviceDict = dict;
			thermostatDevice.roomNameString = sRoomName;
			[self.navigationController pushViewController:thermostatDevice animated:YES];
			[thermostatDevice release];
			break;
		}
		case MULTILEVEL_SWITCH:
		{
			DimmerDevice *dimmerDevice = [[DimmerDevice alloc]initWithNibName:@"DimmerDevice" bundle:nil];
			dimmerDevice.deviceDict = dict;
			dimmerDevice.roomNameString = sRoomName;
			dimmerDevice.selectedRoomDeviceArray = mutArray;
			[self.navigationController pushViewController:dimmerDevice animated:YES];
			[dimmerDevice release];
			break;
		}
		case BINARY_SWITCH:
		{
			BinaryLightDevice *binaryLightDevice = [[BinaryLightDevice alloc]initWithNibName:@"BinaryLightDevice" bundle:nil];
			binaryLightDevice.deviceDict = dict;
			binaryLightDevice.roomNameString = sRoomName;
			binaryLightDevice.selectedRoomDeviceArray = mutArray;
			[self.navigationController pushViewController:binaryLightDevice animated:YES];
			[binaryLightDevice release];
			break;
		}
		case MOTOR_GENERIC:
		case SOMFY_RTS:
		{
			
			OnewayMotor *onewayMotor = [[OnewayMotor alloc]initWithNibName:@"OnewayMotor" bundle:nil];
			onewayMotor.deviceDict = dict;
			onewayMotor.roomNameString = sRoomName;
			[self.navigationController pushViewController:onewayMotor animated:YES];
			[onewayMotor release];
			break;
		}
		case SOMFY_ILT:
		{
			ILTMotor *iLTMotor = [[ILTMotor alloc]initWithNibName:@"ILTMotor" bundle:nil];
			iLTMotor.deviceDict = dict;
			iLTMotor.roomNameString = sRoomName;
			iLTMotor.selectedRoomDeviceArray = mutArray;
			[self.navigationController pushViewController:iLTMotor animated:YES];
			[iLTMotor release];
			break;
		}
		default:
			break;
	}
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
	if(strCommand == LOGOUT)
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
			
			[self.RoomsTable reloadData];
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}
		else 
		{
			[self.RoomsTable reloadData];
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}*/
		[self.RoomsTable reloadData];
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	
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
	[RoomsTable release];
	[scrollView release];
	[_selectedRoomDevicesList release];
    [super dealloc];
}


@end
