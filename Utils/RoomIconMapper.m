//
//  RoomIconMapper.m
//  Somfy
//
//  Created by Sempercon user on 5/6/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "RoomIconMapper.h"


@implementation RoomIconMapper

/**
 * Accepts the room id and returns the image that is going to 
 * be displayed.
 * @param roomId Integer associated with the room list
 * @return Image that represents the room
 */
-(UIImage *) getRoomImageBasedOnRoomId : (int) roomId :(int)selected
{
	NSString *roomImageName;
	UIImage *roomImage;
	if (selected == 1)
		roomImageName = @"generic";
	else 
		roomImageName = @"genericGray";
	
	
	//Determine the correct room image based on the integer that is based in
	switch ( roomId )
	{
		case UNASSIGNED:
			if (selected == 1)
				roomImageName = @"generic";
			else 
				roomImageName = @"genericGray";
			break;
		case MASTER_BEDROOM:
			if (selected == 1)
				roomImageName = @"masterbedRoom";
			else 
				roomImageName = @"masterbedRoomGray";
			break;
		case KIDS_ROOM:
			if (selected == 1)
				roomImageName = @"kidsRoom";
			else 
				roomImageName = @"kidsRoomGray";
			break;
		case BABYS_ROOM:
			if (selected == 1)
				roomImageName = @"babysRoom";
			else 
				roomImageName = @"babysRoomGray";
			break;
		case HOME_THEATER:
			if (selected == 1)
				roomImageName = @"homeTheater";
			else 
				roomImageName = @"homeTheaterGray";
			break;
		case LIBRARY:
			if (selected == 1)
				roomImageName = @"library";
			else 
				roomImageName = @"libraryGray";
			break;
		case BATHROOM:
			if (selected == 1)
				roomImageName = @"bathRoom";
			else 
				roomImageName = @"bathRoomGray";
			break;
		case KITCHEN:
			if (selected == 1)
				roomImageName = @"kitchen";
			else 
				roomImageName = @"kitchenGray";
			break;
		case PATIO:
			if (selected == 1)
				roomImageName = @"patio";
			else 
				roomImageName = @"patioGray";
			break;
		case DECK:
			if (selected == 1)
				roomImageName = @"deck";
			else 
				roomImageName = @"deckGray";
			break;
		case DRIVEWAY:
			if (selected == 1)
				roomImageName = @"driveway";
			else 
				roomImageName = @"drivewayGray";
			break;
		case GARAGE:
			if (selected == 1)
				roomImageName = @"garage";
			else 
				roomImageName = @"garageGray";
			break;
		case STAIRWAY:
			if (selected == 1)
				roomImageName = @"stairway";
			else 
				roomImageName = @"stairwayGray";
			break;
		case HALLWAY:
			if (selected == 1)
				roomImageName = @"hallway";
			else 
				roomImageName = @"hallwayGray";
			break;
		case GARDEN:
			if (selected == 1)
				roomImageName = @"garden";
			else 
				roomImageName = @"gardenGray";
			break;
		case LIVING_ROOM:
			if (selected == 1)
				roomImageName = @"livingRoom";
			else 
				roomImageName = @"livingRoomGray";
			break;
		case OFFICE:
			if (selected == 1)
				roomImageName = @"office";
			else 
				roomImageName = @"officeGray";
			break;
		case CONFERENCE_ROOM:
			if (selected == 1)
				roomImageName = @"conferenceRoom";
			else 
				roomImageName = @"conferenceRoomGray";
			break;
		case DINING_ROOM:
			if (selected == 1)
				roomImageName = @"diningRoom";
			else 
				roomImageName = @"diningRoomGray";
			break;
		case LAUNDRY_ROOM:
			if (selected == 1)
				roomImageName = @"laundryRoom";
			else 
				roomImageName = @"laundryRoomGray";
			break;
		case LANAI:
			if (selected == 1)
				roomImageName = @"lanai";
			else 
				roomImageName = @"lanaiGray";
			break;
		case CINEMA:
			if (selected == 1)
				roomImageName = @"cinema";
			else 
				roomImageName = @"cinemaGray";
			break;
		case STUDY_ROOM:
			if (selected == 1)
				roomImageName = @"study";
			else 
				roomImageName = @"studyGray";
			break;
		case COMPUTER_ROOM:
			if (selected == 1)
				roomImageName = @"computerRoom";
			else 
				roomImageName = @"computerRoomGray";
			break;
		case GUEST_ROOM:
			if (selected == 1)
				roomImageName = @"guestRoom";
			else 
				roomImageName = @"guestRoomGray";
			break;
		case TRAINING_ROOM:
			if (selected == 1)
				roomImageName = @"trainingRoom";
			else 
				roomImageName = @"trainingRoomGray";
			break;
		case FAMILY_ROOM:
			if (selected == 1)
				roomImageName = @"familyRoom";
			else 
				roomImageName = @"familyRoomGray";
			break;
		case BALL_ROOM:
			if (selected == 1)
				roomImageName = @"ballRoom";
			else 
				roomImageName = @"ballRoomGray";
			break;
	}
	//get the room image with the room name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
	
}

-(UIImage *) getRoomImageBasedOnRoomId : (int) roomId
{
	NSString *roomImageName;
	UIImage *roomImage;
	
	roomImageName = @"genericBlack";
	
	
	//Determine the correct room image based on the integer that is based in
	switch ( roomId )
	{
		case UNASSIGNED:
			roomImageName = @"genericBlack";
			break;
		case MASTER_BEDROOM:
			roomImageName = @"masterbedRoomBlack";
			break;
		case KIDS_ROOM:
			roomImageName = @"kidsRoomBlack";
			break;
		case BABYS_ROOM:
			roomImageName = @"babysRoomBlack";
			break;
		case HOME_THEATER:
			roomImageName = @"homeTheaterBlack";
			break;
		case LIBRARY:
			roomImageName = @"libraryBlack";
			break;
		case BATHROOM:
			roomImageName = @"bathRoomBlack";
			break;
		case KITCHEN:
			roomImageName = @"kitchenBlack";
			break;
		case PATIO:
			roomImageName = @"patioBlack";
			break;
		case DECK:
			roomImageName = @"deckBlack";
			break;
		case DRIVEWAY:
			roomImageName = @"drivewayBlack";
			break;
		case GARAGE:
			roomImageName = @"garageBlack";
			break;
		case STAIRWAY:
			roomImageName = @"stairwayBlack";
			break;
		case HALLWAY:
			roomImageName = @"hallwayBlack";
			break;
		case GARDEN:
			roomImageName = @"gardenBlack";
			break;
		case LIVING_ROOM:
			roomImageName = @"livingRoomBlack";
			break;
		case OFFICE:
			roomImageName = @"officeBlack";
			break;
		case CONFERENCE_ROOM:
			roomImageName = @"conferenceRoomBlack";
			break;
		case DINING_ROOM:
			roomImageName = @"diningRoomBlack";
			break;
		case LAUNDRY_ROOM:
			roomImageName = @"laundryRoomBlack";
			break;
		case LANAI:
			roomImageName = @"lanaiBlack";
			break;
		case CINEMA:
			roomImageName = @"cinemaBlack";
			break;
		case STUDY_ROOM:
			roomImageName = @"studyBlack";
			break;
		case COMPUTER_ROOM:
			roomImageName = @"computerRoomBlack";
			break;
		case GUEST_ROOM:
			roomImageName = @"guestRoomBlack";
			break;
		case TRAINING_ROOM:
			roomImageName = @"trainingRoomBlack";
			break;
		case FAMILY_ROOM:
			roomImageName = @"familyRoomBlack";
			break;
		case BALL_ROOM:
			roomImageName = @"ballRoomBlack";
			break;
	}
	//get the room image with the room name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
	
}

-(UIImage *) getRoomImageBasedOnRoomIdForIphone : (int) roomId
{
	NSString *roomImageName;
	UIImage *roomImage;
	
	roomImageName = @"iP_Room_genericBlack";
	
	
	//Determine the correct room image based on the integer that is based in
	switch ( roomId )
	{
		case UNASSIGNED:
			roomImageName = @"iP_Room_genericBlack";
			break;
		case MASTER_BEDROOM:
			roomImageName = @"iP_Room_masterbedRoomBlack";
			break;
		case KIDS_ROOM:
			roomImageName = @"iP_Room_kidsRoomBlack";
			break;
		case BABYS_ROOM:
			roomImageName = @"iP_Room_babysRoomBlack";
			break;
		case HOME_THEATER:
			roomImageName = @"iP_Room_homeTheaterBlack";
			break;
		case LIBRARY:
			roomImageName = @"iP_Room_libraryBlack";
			break;
		case BATHROOM:
			roomImageName = @"iP_Room_bathRoomBlack";
			break;
		case KITCHEN:
			roomImageName = @"iP_Room_kitchenBlack";
			break;
		case PATIO:
			roomImageName = @"iP_Room_patioBlack";
			break;
		case DECK:
			roomImageName = @"iP_Room_deckBlack";
			break;
		case DRIVEWAY:
			roomImageName = @"iP_Room_drivewayBlack";
			break;
		case GARAGE:
			roomImageName = @"iP_Room_garageBlack";
			break;
		case STAIRWAY:
			roomImageName = @"iP_Room_stairwayBlack";
			break;
		case HALLWAY:
			roomImageName = @"iP_Room_hallwayBlack";
			break;
		case GARDEN:
			roomImageName = @"iP_Room_gardenBlack";
			break;
		case LIVING_ROOM:
			roomImageName = @"iP_Room_livingRoomBlack";
			break;
		case OFFICE:
			roomImageName = @"iP_Room_officeBlack";
			break;
		case CONFERENCE_ROOM:
			roomImageName = @"iP_Room_conferenceRoomBlack";
			break;
		case DINING_ROOM:
			roomImageName = @"iP_Room_diningRoomBlack";
			break;
		case LAUNDRY_ROOM:
			roomImageName = @"iP_Room_laundryRoomBlack";
			break;
		case LANAI:
			roomImageName = @"iP_Room_lanaiBlack";
			break;
		case CINEMA:
			roomImageName = @"iP_Room_cinemaBlack";
			break;
		case STUDY_ROOM:
			roomImageName = @"iP_Room_studyBlack";
			break;
		case COMPUTER_ROOM:
			roomImageName = @"iP_Room_computerRoomBlack";
			break;
		case GUEST_ROOM:
			roomImageName = @"iP_Room_guestRoomBlack";
			break;
		case TRAINING_ROOM:
			roomImageName = @"iP_Room_trainingRoomBlack";
			break;
		case FAMILY_ROOM:
			roomImageName = @"iP_Room_familyRoomBlack";
			break;
		case BALL_ROOM:
			roomImageName = @"iP_Room_ballRoomBlack";
			break;
	}
	//get the room image with the room name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
	
}

#pragma mark -
#pragma mark Initialization & Deallocation
static RoomIconMapper *sharedInstance = nil;

+(RoomIconMapper *)getSharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
}

-(void)release { }

-(id)autorelease {
	return self;
}

-(id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void) dealloc {
	[super dealloc];
}



@end
