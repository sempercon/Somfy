//
//  DimmerDevice.h
//  Somfy
//
//  Created by Sempercon on 4/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface DimmerDevice : UIViewController <ParserCallback>{
	IBOutlet UIView			*VerticalSliderview;
	IBOutlet UIImageView	*imgView,*DimmerDeviceImage;
	IBOutlet UILabel		*valueLbl;
	NSMutableDictionary		*deviceDict;
	NSMutableArray			*selectedRoomDeviceArray;
	NSString				*roomNameString;
	IBOutlet UILabel		*deviceName,*roomName;
	float	lastYPoint;
	UIView	*loadingView;
	int		sliderValue,lastSliderValue;
	
	IBOutlet UIImageView *animatedImageView;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton	*applyBtn,*applyAllBtn;
	IBOutlet UIButton	*dimmerDeviceBtn;
	UILabel  *label1,*label2;
	BOOL	 isAnimation;
	
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


@property(nonatomic,retain) UIButton	*applyBtn,*applyAllBtn;
@property(nonatomic,retain) UIView					*VerticalSliderview;
@property(nonatomic,retain) UIImageView				*imgView,*DimmerDeviceImage;
@property(nonatomic,retain) UILabel					*valueLbl;
@property(nonatomic,retain) NSMutableDictionary		*deviceDict;
@property(nonatomic,retain) NSMutableArray			*selectedRoomDeviceArray;
@property(nonatomic,retain)	NSString				*roomNameString;
@property(nonatomic,retain) UILabel					*deviceName,*roomName;
@property(nonatomic,retain) UIImageView				*animatedImageView;
@property(nonatomic,retain) UIScrollView			*scrollView;
@property(nonatomic,retain) UIButton				*dimmerDeviceBtn;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;

-(IBAction)LOGOUT:(id)sender;
-(IBAction)Increase:(id)sender;
-(IBAction)Decrease:(id)sender;
-(void)LoadImageView:(float)val;
-(IBAction)ApplyClicked:(id)sender;
-(IBAction)ApplyallClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)dimmerDeviceBtnClicked:(id)sender;

@end
