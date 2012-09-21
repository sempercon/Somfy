//
//  ILTMotor.h
//  Somfy
//
//  Created by mac user on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface ILTMotor : UIViewController<ParserCallback> {
	
	IBOutlet UIView			*VerticalSliderview;
	IBOutlet UIView			*trackView;
	IBOutlet UIImageView	*trackingImg,*trackBottomImg,*iltSliderBg;
	IBOutlet UILabel		*valueLabel;
	
	float	lastYPoint;
	int sliderValue,lastSliderValue;
	
	
	NSMutableDictionary		*deviceDict;
	NSMutableArray			*selectedRoomDeviceArray;
	IBOutlet UILabel		*deviceName,*roomName;
	IBOutlet UIScrollView	*scrollView,*deviceScrollView;
	UILabel					*label1,*label2;
	IBOutlet UIButton		*applyBtn,*applyAllBtn;
	NSString				*roomNameString;
	BOOL					isAnimation;
	UIView					*loadingView;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
	NSMutableArray  *loginArray;
	
	IBOutlet UIImageView	*imgView,*deviceImage;
	
	NSTimer				*QueueTimer;
	ProcessEnum			queueEnum;
	int					deviceIndex;
	NSMutableArray	    *tempDevicesArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UIButton		*applyBtn,*applyAllBtn;
@property(nonatomic,retain) UIView			*VerticalSliderview;
@property(nonatomic,retain) UIView			*trackView;
@property(nonatomic,retain) UIImageView		*trackingImg,*trackBottomImg,*imgView,*deviceImage,*iltSliderBg;
@property(nonatomic,retain) UILabel			*valueLabel;

@property(nonatomic,retain) NSMutableDictionary		*deviceDict;
@property(nonatomic,retain) NSMutableArray			*selectedRoomDeviceArray;
@property(nonatomic,retain) UILabel					*deviceName,*roomName;
@property(nonatomic,retain) UIScrollView			*scrollView,*deviceScrollView;
@property(nonatomic,retain) NSString				*roomNameString;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;

-(IBAction)LOGOUT:(id)sender;
-(IBAction)ILTMotorIncreaseClicked:(id)sender;
-(IBAction)ILTMotorDecreaseClicked:(id)sender;
-(IBAction)ILTMotorOpenClicked:(id)sender;
-(IBAction)ILTMotorCloseClicked:(id)sender;
-(IBAction)ILTMotorApplyClicked:(id)sender;
-(IBAction)ILTMotorApplyAllClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;


@end
