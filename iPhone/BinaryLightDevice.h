//
//  BinaryLightDevice.h
//  Somfy
//
//  Created by Sempercon on 4/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface BinaryLightDevice : UIViewController<ParserCallback> {
	IBOutlet UIImageView	*BinaryImage;
	NSMutableDictionary		*deviceDict;
	NSMutableArray			*selectedRoomDeviceArray;
	NSString				*roomNameString;
	BOOL					isOn,isAnimation;
	UIView					*loadingView;
	IBOutlet UIButton		*binaryButton,*btnBack;
	IBOutlet UIButton		*applyBtn,*applyAllBtn;
	IBOutlet UILabel		*deviceName,*roomName;
	IBOutlet UIImageView	*animatedImageView;
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UIButton		*BinaryDeviceToggleBtn;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
	NSMutableArray			*loginArray;
	
	NSTimer				*QueueTimer;
	ProcessEnum			queueEnum;
	int					deviceIndex;
	NSMutableArray	    *tempDevicesArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UIButton			*applyBtn,*applyAllBtn;
@property(nonatomic,retain) UIImageView			*BinaryImage;
@property(nonatomic,retain) NSMutableDictionary *deviceDict;
@property(nonatomic,retain) NSMutableArray		*selectedRoomDeviceArray;
@property(nonatomic,retain) NSString			*roomNameString;
@property(nonatomic,retain) UIButton			*binaryButton,*btnBack;
@property(nonatomic,retain) UILabel				*deviceName,*roomName;
@property(nonatomic,retain) UIImageView			*animatedImageView;
@property(nonatomic,retain) UIScrollView		*scrollView;
@property(nonatomic,retain) UIButton			*BinaryDeviceToggleBtn;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;

-(IBAction)LOGOUT:(id)sender;
-(IBAction)BinaryDeviceOn:(id)sender;
-(IBAction)ApplyClicked:(id)sender;
-(IBAction)ApplyallClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)BinaryDeviceToggleBtnClicked:(id)sender;

@end
