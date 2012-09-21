//
//  SceneConfigurator_iPad.h
//  Somfy
//
//  Created by Sempercon on 4/30/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"


@interface SceneConfigurator_iPad : UIViewController <ParserCallback,SkinChooserCallback>{
	IBOutlet UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
	
	IBOutlet UIScrollView	*sceneScrollView;
	IBOutlet UITextField	*addTextField,*EditTextField;
	IBOutlet UIView			*AddsceneView,*EditSceneNameView;
	IBOutlet UILabel		*ActivatedLabel;
	NSTimer					*ProcessTimer,*QueueTimer;
	CGPoint					LastOffsetPointScenes;
	ProcessEnum				sceneEnum,queueEnum;
	NSMutableArray			*selectedScenesArray;
	NSMutableArray			*ExcludedSceneDevicesArray,*SupportedMaskFilterArray;
	BOOL   issceneSelect,isSceneEdit;
	int    g_selectedSceneId,g_selectedsceneIndex,SceneInfoId;
	int    curSceneEditToggle,deleteSceneIndex,currDeviceMetaData;
	NSMutableArray	 *loginArray;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition,xposition;
	UIView					*loadingView;
	IBOutlet UIView			*popupView;
	CGPoint rightOffset;
	CGPoint editOffSetPoint;
	BOOL isAddDeleteScene;
	int currentSceneEditIndex;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;

@property(nonatomic,retain) UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle;

@property(nonatomic,retain) UIScrollView	*sceneScrollView;
@property(nonatomic,retain) UIView			*AddsceneView,*EditSceneNameView;
@property(nonatomic,retain) UITextField		*addTextField,*EditTextField;
@property(nonatomic,retain) UILabel			*ActivatedLabel;
@property(nonatomic,retain) UIView			*popupView;


//Add and refreshbutton click
-(IBAction)SceneAddBtnClicked:(id)sender;
-(IBAction)SceneRefreshBtnClicked:(id)sender;
//scene create and cancelbtn click
-(IBAction)SceneCreateBtnClicked:(id)sender;
-(IBAction)SceneCancelBtnClicked:(id)sender;
//scene edit save and cancel btn click
-(IBAction)SceneEditSaveBtnClicked:(id)sender;
-(IBAction)SceneEditCancelBtnClicked:(id)sender;

-(IBAction)LOGOUT:(id)sender;

//5 Tabs switching items
-(IBAction)RoomSelector:(id)sender;
-(IBAction)DeviceConfigurator:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)EventConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)Homeowner:(id)sender;

@end
