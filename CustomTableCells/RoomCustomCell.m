//
//  RoomCustomCell.m
//  Somfy
//
//  Created by macuser on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoomCustomCell.h"


@implementation RoomCustomCell

@synthesize lblRoomName;
@synthesize img,imgBg,backgroundImg;
@synthesize delegate;
@synthesize lblDeviceName,lblDeviceSubTitle1,lblDeviceSubTitle2,lblDeviceSubValue1,lblDeviceSubValue2,lblDeviceSubValue1Deg,lblDeviceSubValue2Deg;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier]) 
    {		
		/*btnScene = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnScene.frame=CGRectMake(5, 5, 32, 33);
		[btnScene addTarget:self action:@selector(Onclick:)  forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:btnScene];*/
		
		backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 45)];
		backgroundImg.backgroundColor = [UIColor clearColor];
		backgroundImg.contentMode = UIViewContentModeScaleToFill;
		[self.contentView addSubview:backgroundImg];
		
		imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 45)];
		imgBg.backgroundColor = [UIColor clearColor];
		imgBg.contentMode = UIViewContentModeScaleToFill;
		//imgBg.image = [UIImage imageNamed:@"iP_Room_Expand_Bg.png"];
		[self.contentView addSubview:imgBg];
		
		img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 32, 32)];
		img.backgroundColor = [UIColor clearColor];
		img.contentMode = UIViewContentModeScaleToFill;
		[self.contentView addSubview:img];
		
		
		lblRoomName = [[[UILabel alloc]initWithFrame:CGRectMake(52, 7, 230, 30)]autorelease];
		lblRoomName.textColor=[UIColor blackColor];
		lblRoomName.backgroundColor=[UIColor clearColor];
		lblRoomName.lineBreakMode= UILineBreakModeTailTruncation;
		lblRoomName.contentMode = UIViewContentModeScaleToFill;
		lblRoomName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		lblRoomName.numberOfLines=0;
		[self.contentView addSubview:lblRoomName];
		
		
		lblDeviceName = [[[UILabel alloc]initWithFrame:CGRectMake(52,-1	, 230, 30)]autorelease];
		lblDeviceName.textColor=[UIColor blackColor];
		lblDeviceName.backgroundColor=[UIColor clearColor];
		lblDeviceName.lineBreakMode= UILineBreakModeTailTruncation;
		lblDeviceName.contentMode = UIViewContentModeScaleToFill;
		lblDeviceName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
		lblDeviceName.numberOfLines=0;
		[self.contentView addSubview:lblDeviceName];
		
		lblDeviceSubTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(52, 16, 60, 30)]autorelease];
		lblDeviceSubTitle1.textColor=[UIColor blackColor ];
		lblDeviceSubTitle1.backgroundColor=[UIColor clearColor];
		lblDeviceSubTitle1.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubTitle1.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubTitle1.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		lblDeviceSubTitle1.numberOfLines=0;
		[self.contentView addSubview:lblDeviceSubTitle1];
		
		lblDeviceSubValue1 = [[[UILabel alloc]initWithFrame:CGRectMake(70, 16, 50, 30)]autorelease];
		lblDeviceSubValue1.textColor=[UIColor colorWithRed:(float)65/255 green:(float)107/255 blue:(float)121/255 alpha:1.0 ];
		lblDeviceSubValue1.backgroundColor=[UIColor clearColor];
		lblDeviceSubValue1.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubValue1.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubValue1.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		lblDeviceSubValue1.textAlignment = UITextAlignmentRight;
		lblDeviceSubValue1.numberOfLines=0;
		[self.contentView addSubview:lblDeviceSubValue1];
				
		lblDeviceSubValue1Deg = [[[UILabel alloc]initWithFrame:CGRectMake(120, 12, 50, 30)]autorelease];
		lblDeviceSubValue1Deg.textColor=[UIColor colorWithRed:(float)65/255 green:(float)107/255 blue:(float)121/255 alpha:1.0 ];
		lblDeviceSubValue1Deg.backgroundColor=[UIColor clearColor];
		lblDeviceSubValue1Deg.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubValue1Deg.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubValue1Deg.font = [UIFont fontWithName:@"Helvetica-Bold" size:8.0];
		lblDeviceSubValue1Deg.textAlignment = UITextAlignmentLeft;
		lblDeviceSubValue1Deg.numberOfLines=0;
		lblDeviceSubValue1Deg.text = @"o";
		[self.contentView addSubview:lblDeviceSubValue1Deg];
		
		
		lblDeviceSubTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(155, 16, 30, 30)]autorelease];
		lblDeviceSubTitle2.textColor=[UIColor blackColor ];
		lblDeviceSubTitle2.backgroundColor=[UIColor clearColor];
		lblDeviceSubTitle2.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubTitle2.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		lblDeviceSubTitle2.numberOfLines=0;
		[self.contentView addSubview:lblDeviceSubTitle2];
		
		// Hint
		//lblDeviceSubValue2 = [[[UILabel alloc]initWithFrame:CGRectMake(167, 16, 30, 30)]autorelease];
		lblDeviceSubValue2 = [[[UILabel alloc]initWithFrame:CGRectMake(185, 16, 50, 30)]autorelease];
		lblDeviceSubValue2.textColor=[UIColor colorWithRed:(float)65/255 green:(float)107/255 blue:(float)121/255 alpha:1.0 ];
		lblDeviceSubValue2.backgroundColor=[UIColor clearColor];
		lblDeviceSubValue2.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubValue2.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubValue2.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		lblDeviceSubValue2.textAlignment = UITextAlignmentLeft;
		lblDeviceSubValue2.numberOfLines=0;
		[self.contentView addSubview:lblDeviceSubValue2];
		
		lblDeviceSubValue2Deg = [[[UILabel alloc]initWithFrame:CGRectMake(198,12, 50, 30)]autorelease];
		lblDeviceSubValue2Deg.textColor=[UIColor colorWithRed:(float)65/255 green:(float)107/255 blue:(float)121/255 alpha:1.0 ];
		lblDeviceSubValue2Deg.backgroundColor=[UIColor clearColor];
		lblDeviceSubValue2Deg.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceSubValue2Deg.contentMode = UIViewContentModeScaleToFill;
		lblDeviceSubValue2Deg.font = [UIFont fontWithName:@"Helvetica-Bold" size:8.0];
		lblDeviceSubValue2Deg.textAlignment = UITextAlignmentLeft;
		lblDeviceSubValue2Deg.numberOfLines=0;
		lblDeviceSubValue2Deg.text = @"o";
		[self.contentView addSubview:lblDeviceSubValue2Deg];
		
		
		/*imageIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(250, 25, 11, 11)];
        imageIndicator.contentMode = UIViewContentModeScaleToFill;
        imageIndicator.clipsToBounds = YES;
		imageIndicator.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:imageIndicator];*/
		
	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

-(void)Onclick:(id)sender
{
	if ([delegate respondsToSelector:@selector(RoomSelected:)])
    {
        [delegate RoomSelected:self];
    }
}


- (void)dealloc {
	[img,imgBg,backgroundImg release];
	[delegate release];
	[lblDeviceName,lblDeviceSubTitle1,lblDeviceSubTitle2,lblDeviceSubValue1,lblDeviceSubValue2,lblDeviceSubValue1Deg,lblDeviceSubValue2Deg release];
    [super dealloc];
}


@end
