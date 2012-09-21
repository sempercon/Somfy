//
//  MJPEGViewer_iPad.m
//  Somfy
//
//  Created by Karuppiah Annamalai on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPEGViewer_iPad.h"
#import "AppDelegate_iPad.h"
#import "LoginScreen_iPad.h"
#import "RoomSelector_ipad.h"

@implementation MJPEGViewer_iPad

@synthesize imgView,delegate;
@synthesize cameraName;
@synthesize deviceDict;
@synthesize loadingLbl;
@synthesize loadingActivity;

NSString * const PIC_1 = @"Pic1";
NSString * const PIC_2 = @"Pic2";

#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
	// @"http://office.slamm.com:8090/img/mjpeg.cgi"
}

- (void)drawRect:(CGRect)rect {
    // start Mjpeg stream videos to start here
	
	[imgView setBackgroundColor:[UIColor clearColor]];
   
    BOOL isFoundID = NO;
	NSString *liveCamUrl = @"";
	for (int i=0; i<[[AppDelegate_iPad  sharedAppDelegate].g_ip_camera_list_Array count]; i++) 
	{
        if(!isFoundID)
        {
            NSString *ipCameraID = [[[AppDelegate_iPad  sharedAppDelegate].g_ip_camera_list_Array objectAtIndex:i] objectForKey:@"id"];
            if([[deviceDict objectForKey:@"id"] isEqualToString:ipCameraID])
                isFoundID = YES;
        }
        else
        {
            if([[[[AppDelegate_iPad  sharedAppDelegate].g_ip_camera_list_Array objectAtIndex:i] objectForKey:@"commandName"] isEqualToString:@"get_video"])
            {
                liveCamUrl = [[[AppDelegate_iPad  sharedAppDelegate].g_ip_camera_list_Array objectAtIndex:i] objectForKey:@"url"];
                //liveCamUrl = @"office.slamm.com:8090/img/mjpeg.cgi";
                
				if([liveCamUrl length]>5)
				{
					if(![[liveCamUrl substringToIndex:5] isEqualToString:@"http:"])
						liveCamUrl = [@"http://" stringByAppendingString:liveCamUrl];
					break;
				}
            }
        }
	}
    
	loadingActivity.hidden = NO;
    [loadingActivity startAnimating];
    loadingLbl.text = @"";
    mjpegClient = [[MJPEGClient alloc] initWithURL:liveCamUrl delegate:self timeout:6.0];
    mjpegClient.user = @"";
    mjpegClient.password =@"";
    mjpegClient.name =PIC_1;
    [mjpegClient start]; 
}


//Load SceneThermostatview from nib file
+ (MJPEGViewer_iPad*) MJPEGViewer_iPadView
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"MJPEGViewer_iPad" owner:self options:nil];
	return [array objectAtIndex:0]; 
}

//Set maindelegate to get back to MainViewControllers
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback
{
	delegate = callback;
	[delegate retain];
}

-(void)setDeviceDict:(NSMutableDictionary*)dict
{
	deviceDict = dict;
	[deviceDict retain];
	if([deviceDict objectForKey:@"name"]!=nil)
		cameraName.text = [deviceDict objectForKey:@"name"];
}

-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr
{
}

-(IBAction) stop:(id) sender
{
    [mjpegClient stop];
    [delegate removePopup];
}

- (void) mjpegClient:(MJPEGClient*) client didReceiveImage:(UIImage*) image
{
    loadingActivity.hidden = YES;
    loadingLbl.text = @"";
    NSString * clientName = client.name;
    if ([clientName isEqualToString:PIC_1])
    {
        imgView.image = image;
        
    }
}


- (void) mjpegClient:(MJPEGClient *)client didReceiveError:(NSError *)error
{
    loadingActivity.hidden = YES;
    loadingLbl.text = @"Failed to load video. Please try again...";
	//[imgView setBackgroundColor:[UIColor grayColor]];
	imgView.image = [UIImage imageNamed:@"bg_failToload.png"];
    if ([client.name isEqualToString:PIC_1]) {
        NSLog(@"Mjpeg stream error = %@",[error localizedDescription]);
    }
}


- (void)dealloc
{
    [loadingLbl release];
    [loadingActivity release];
	[deviceDict release];
	[cameraName release];
    [delegate release];
    [imgView release];
    [super dealloc];
}


@end
