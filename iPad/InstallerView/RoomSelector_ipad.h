//
//  RoomSelector_ipad.h
//  Somfy
//
//  Created by Sempercon on 4/28/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "DeviceSkinChooser.h"

@interface RoomSelector_ipad : UIViewController <ParserCallback,SkinChooserCallback>{
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
	IBOutlet UIView	   *AddView,*EditView;
	IBOutlet UIButton	*EditSubmitBtn,*EditCancelBtn,*AddCreateBtn,*AddCancelBtn;
	IBOutlet UITextField *AddRoomTextField,*EditRoomTextField;
	int g_selectedRoomId;
	NSMutableArray	 *loginArray;
	BOOL	 isRemoveCommand;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
	UIView					*loadingView;
	IBOutlet UIView			*popupView;
	CGPoint					LastOffsetPointScenes;
	int isNewRoomAdded;
    
    IBOutlet UIButton *Logout;
	
}
//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle;

@property(nonatomic,retain) UIView		 *AddView,*EditView;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
@property(nonatomic,retain) UIButton	*EditSubmitBtn,*EditCancelBtn,*AddCreateBtn,*AddCancelBtn;
@property(nonatomic,retain) UITextField *AddRoomTextField,*EditRoomTextField;

@property(nonatomic,retain) UIButton *Logout;

-(IBAction)AddRoom:(id)sender;
-(IBAction)AddRoomCreate:(id)sender;
-(IBAction)AddRoomCancel:(id)sender;
-(IBAction)EditRoomSubmit:(id)sender;
-(IBAction)EditRoomCancel:(id)sender;


//5 Tabs switching items
-(IBAction)RoomSelector:(id)sender;
-(IBAction)DeviceConfigurator:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)EventConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)Homeowner:(id)sender;

-(IBAction)LOGOUT:(id)sender;



@end
