//
//  LiveviewDashboard.h
//  Somfy
//
//  Created by Sempercon on 5/3/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "BinaryLightDeviceView.h"
#import "OnewayMotorView.h"
#import "DimmerDeviceView.h"
#import "Constants.h"


@interface LiveviewDashboard : UIViewController <ParserCallback,SkinChooserCallback>{
	IBOutlet UIScrollView	*SceneScrollview,*RoomScrollview;
	IBOutlet UILabel		*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
	IBOutlet UIButton		*DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
	NSMutableArray			*_selectedRoomDevicesList;
	NSTimer					*ProcessTimer,*DateTimeDisplayTimer;
	NSMutableArray			*_openRoomsArray;
	BOOL					isRoomSelect,isSceneSelect;
	CGPoint					LastOffsetPointRooms,LastOffsetPointScenes;
	IBOutlet UIView			*popupView;
	UIView					*loadingView;
	NSMutableArray	 *loginArray;
	
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;
@property(nonatomic,retain) UIButton		*DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
@property(nonatomic,retain) UIScrollView	*SceneScrollview,*RoomScrollview;
@property(nonatomic,retain) UILabel			*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
@property(nonatomic,retain) NSMutableArray	*_selectedRoomDevicesList,*_openRoomsArray;
@property(nonatomic,retain) UIView			*popupView;


//3 Tabs switching items
-(IBAction)LiveViewDashboard:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)InstallerView:(id)sender;
-(IBAction)LOGOUT:(id)sender;


@end
