//
//  OnewayMotor.h
//  Somfy
//
//  Created by Sempercon on 4/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface OnewayMotor : UIViewController <ParserCallback> {
	NSMutableDictionary *deviceDict;
	IBOutlet UILabel *lbl;
	IBOutlet UILabel	*deviceName,*roomName;
	IBOutlet UIScrollView *scrollView;
	UILabel  *label1,*label2;
	NSString *roomNameString;
	BOOL	 isAnimation;
	UIView   *loadingView;
	IBOutlet UIImageView *imgDevice;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIButton		*applyBtn,*applyAllBtn;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
	int curSelection;
	IBOutlet UIButton *btnOpen,*btnClose,*btnMy;
	NSMutableArray  *loginArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UIButton	 *applyBtn,*applyAllBtn;
@property(nonatomic,retain) NSMutableDictionary *deviceDict;
@property(nonatomic,retain) UILabel *lbl;
@property(nonatomic,retain) UILabel		*deviceName,*roomName;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) NSString *roomNameString;
@property(nonatomic,retain) UIImageView *imgDevice;
@property(nonatomic,retain) UIButton *btnOpen,*btnClose,*btnMy;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;

-(IBAction)LOGOUT:(id)sender;
-(IBAction)btnRTSOpenClicked:(id)sender;
-(IBAction)btnRTSCloseClicked:(id)sender;
-(IBAction)btnRTSmyClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)ApplyClicked:(id)sender;
-(IBAction)ApplyallClicked:(id)sender;
-(void)startAnimateImage;
@end
