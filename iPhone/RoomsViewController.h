//
//  RoomsViewController.h
//  Somfy
//
//  Created by Sempercon on 4/24/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"
#import "RoomCustomCell.h"

@interface RoomsViewController : UIViewController<ParserCallback,RoomCustomCellDelegate> {
	IBOutlet UITableView	*RoomsTable;
	IBOutlet UIScrollView   *scrollView;
	NSMutableArray			*_selectedRoomDevicesList;
	NSTimer					*processTimer;
	ProcessEnum				stateEnum;
	int						TotalNoofRowsCount;
	NSMutableArray  *loginArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UITableView		*RoomsTable;
@property(nonatomic,retain) UIScrollView	*scrollView;
@property(nonatomic,retain) NSMutableArray	*_selectedRoomDevicesList;

-(IBAction)LOGOUT:(id)sender;

@end
