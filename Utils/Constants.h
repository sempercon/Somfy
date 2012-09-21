/*
 *  Constants.h
 *  Somfy
 *
 *  Created by Sempercon on 5/6/11.
 *  Copyright 2011 __Sempercon__. All rights reserved.
 *
 */

//RoomID enums declared as constant
#ifndef __CONSTANTS_H
#define __CONSTANTS_H

typedef enum RoomIDEnums
{
	UNASSIGNED = 1,
	MASTER_BEDROOM = 2,
	KIDS_ROOM = 3,
	BABYS_ROOM = 4,
	HOME_THEATER = 5,
	LIBRARY = 6,
	BATHROOM = 7,
	KITCHEN = 8,
	PATIO = 9,
	DECK = 10,
	DRIVEWAY = 11,
	GARAGE = 12,
	STAIRWAY = 13,
	HALLWAY = 14,
	GARDEN = 15,
	LIVING_ROOM = 16,
	OFFICE = 17,
	CONFERENCE_ROOM = 18,
	DINING_ROOM = 19,
	LAUNDRY_ROOM = 20,
	LANAI = 21,
	CINEMA = 22,
	STUDY_ROOM = 23,
	COMPUTER_ROOM = 24,
	GUEST_ROOM = 25,
	TRAINING_ROOM = 26,
	FAMILY_ROOM = 27,
	BALL_ROOM = 28
}RoomIDEnums;

//RoomID enums declared as constant
typedef enum DeviceTypeEnum
{
	UNKNOWN=0,
	CONTROLLER=1,
	MULTILEVEL_SWITCH=2,
	BINARY_SWITCH=3,
	UNDEFINED=4,
	THERMOSTAT=5,
	THERMOSTATV2=6,
	SETBACK_THERMOSTAT=7,
	GARAGE_DOOR=8,
	SATELLITE_RADIO=9,
	BINARY_SENSOR=10,
	BINARY_SENSOR_TWO=11,
	//public static const UNDEFINED:int=12;
	//public static const UNDEFINED:int=13;
	//public static const UNDEFINED:int=14;
	//public static const UNDEFINED:int=15;
	PC_CONTROLLER=16,
	STATIC_CONTROLLER=17,
	SCENE_CONTROLLER=18,
	SCENE_CONTROLLER_PORTABLE=19,
	SCENE_CONTROLLER_TWO=20,
	INSTALLER_TOOL=21,
	INSTALLER_TOOL_PORTABLE=22,
	REMOTE_CONTROLLER_PORTABLE=23,
	METER_GENERIC=24,
	REMOTE_SWITCH=25,
	MULTILEVEL_SENSOR=26,
	ENTRY_CONTROL=27,
	SECURE_KEYPAD_ENTRY_CONTROL_DOOR_LOCK=28,
	ADVANCED_ENTRY_CONTROL_DOOR_LOCK=29,
	BULOGICS_USB_SHUTDOWN_STICK=30,
	ZIGBEE_METER=31,
	THERMOSTAT_RCS=32,
	SCENE_CONTROLLER_THREE=33,
	ZONE_CONTROLLER=34,
	MOTOR_GENERIC=35,
	SOMFY_RTS=36,
	SOMFY_ILT= 37,
	BULOGICS_CORE= 39,
	SOMFY_DRAPERY= 40,
	IP_CAMERA_DEVICE_TYPE = 10008
}DeviceTypeEnum;

typedef enum SomfyDeviceTypesEnums
{
	RTS_AWNING = 1,
	RTS_BLIND = 2,
	RTS_DRAPERY = 3,
	RTS_ROLLER_SHADE = 4,
	RTS_SOLAR_SCREEN = 5,
	RTS_ROLLER_SHUTTER = 6,
	RTS_SCREEN_SHADE = 7,
	RTS_PLANTATION_SHUTTER = 8,
	RTS_ROMAN_SHADE = 9,
	RTS_CELLULAR_SHADE = 10,
	ILT_SCREEN = 11,
	ILT_ROMAN_SHADE = 12,
	ILT_ROLLER_SHADE = 13,
	ILT_SOLAR_SCREEN = 14,
	ILT_BLIND = 15
}SomfyDeviceTypesEnums;

typedef enum ConstantEnum
{
	FE_REDISCOVERY = 4,
	FE_ZW_LISTENING=1,
	FE_ZW_FOUND_DEVICE=2,
	FE_ADD_REM_IN_PROG=3,
	FE_JOIN_IN_PROG = 4,
	FE_IN_WIZARD = 6,
	FE_SUCCESS_PARTIAL = 10,
	FE_WAIT = 11,
	FE_NODE_IN_FAILED_LIST = 20,
	FE_NODE_NOT_IN_FAILED_LIST = 21,
	FE_STARTED_REPLACE_FAILED = 22,
	FE_REDISCOVERY_STATUS_START = 250,
	FE_REDISCOVERY_STATUS_END = 251,
	FE_FAILURE = -1,
	FE_FAIL_DB = -2,
	FE_FAIL_ZW = -3,
	FE_FAIL_MEM = -4,
	FE_FAIL_EMPTY_STRING = -5,
	FE_FAIL_THREAD = -6,
	FE_FAIL_RANGE = -7,
	FE_FAIL_TYPE = -8,
	FE_FAIL_TIMEOUT = -9,
	FE_FAIL_CANCEL = -10,
	FE_FAIL_ZW_DEV_RESET = -11,
	FE_FAIL_ZW_DEV_EXISTS = -12,
	FE_FAIL_ZW_CNTRLR_TYPE = -13,
	FE_FAIL_ZW_BUSY = -14,
	FE_FAIL_ZW_UNKNOWN_NODE = -15,
	FE_FAIL_ZW_UNSUPPORTED = -16,
	FE_FAIL_BC_UNSUPPORTED = -17,
	FE_FAIL_OUT_OF_SPACE = -18,
	FE_FAIL_ZW_ASSOC_GRP_0_NODES_ALLOWED = -19,
	FE_FAIL_DB_BAD_INPUT = -20,
	FE_FAIL_DB_UNAFFECTED = -21,
	FE_FAIL_PROTECTED = -22,
	FE_FAIL_NOT_LISTENING = -23,
	FE_FAIL_COULDNT_COMMUNICATE = -24,
	FE_FAIL_COULDNT_START_REDISCOVERY = -25,
	FE_FAIL_DB_NO_DATA= -26,
	FE_FAIL_SECURITY_SETUP = -27
}ConstantEnum;


typedef enum ProcessEnum
{
	NONE=0,
	RELOGIN,
	GETSCENES,
	GETSCENES_DONE,
	GETSCENE_INFO,
	GETSCENE_INFO_DONE,
	SET_DEVICE_VALUE,
	SET_DEVICE_VALUE_DONE,
	GET_ALL_DEVICE_INFO,
	APPLYTO_ALLDONE,
	GETROOMS,
	GETROOMS_DONE,
	GETSELECTEDROOMS,
	GETSELECTEDROOMS_DONE,
	GETDEVICES,
	GETDEVICES_DONE,
	GETIP_CAMERAS,
	GETIP_CAMERAS_DONE,
	GET_THERMO_STATS,
	GET_THERMO_STATS_DONE,
	GET_THERMOSTATUS,
	GET_THERMOSTATUS_DONE,
	GET_THERMOSTAT_DESIRED_TEMP,
	GET_THERMOSTAT_DESIRED_TEMP_DONE,
	GET_TIMER,
	GET_TIMER_DONE,
	GETCONTROLLER,
	GETCONTROLLER_DONE,
	TIMER_GET_INFO,
	TIMER_GET_INFO_DONE,
	GET_EVENT,
	GET_EVENT_DONE,
	SETBUTTON,
	SETBUTTON_DONE,
	EVENT_INFO,
	EVENT_INFO_DONE,
	ENUM_SCENE_ADD,
	ENUM_SCENE_ADD_DONE,
	GET_TRIGGER_DEVICE_LIST,
	GET_TRIGGER_DEVICE_LIST_DONE,
	GET_TRIGGERREASONLISTBYID,
	GET_TRIGGERREASONLISTBYID_DONE,
	TRIGGERDEVICE_ON,
	TRIGGERDEVICE_ON_PROCESSING,
	TRIGGERDEVICE_ON_DONE,
	TRIGGERDEVICE_OFF,
	TRIGGERDEVICE_OFF_PROCESSING,
	TRIGGERDEVICE_OFF_DONE,
	SET_TRIGGERDEVICE_ON,
	SET_TRIGGERDEVICE_ON_PROCESSING,
	SET_TRIGGERDEVICE_ON_DONE,
	SET_TRIGGERDEVICE_OFF,
	SET_TRIGGERDEVICE_OFF_PROCESSING,
	SET_TRIGGERDEVICE_OFF_DONE,
	SET_TRIGGERDEVICE_REASON_ON,
	SET_TRIGGERDEVICE_REASON_ON_PROCESSING,
	SET_TRIGGERDEVICE_REASON_ON_DONE,
	SET_TRIGGERDEVICE_REASON_OFF,
	SET_TRIGGERDEVICE_REASON_OFF_PROCESSING,
	SET_TRIGGERDEVICE_REASON_OFF_DONE,
	BULOGICS_EVENT_ADD,
	BULOGICS_EVENT_ADD_PROCESSING,
	BULOGICS_EVENT_ADD_DONE,
	SET_TRIGGERDEVICE,
	SET_TRIGGERDEVICE_PROCESSING,
	SET_TRIGGERDEVICE_DONE,
	SET_TRIGGERDEVICE_REASON,
	SET_TRIGGERDEVICE_REASON_PROCESSING,
	SET_TRIGGERDEVICE_REASON_DONE,
	SCENE_CTRLR_GET,
	SCENE_CTRLR_GET_DONE,
	PROCESSING,
	ENUM_ADD_TIMER,
	ENUM_EVENT_ADD,
	ENUM_EVENT_SET_TRIGGER_DEVICE,
	ENUM_EVENT_SET_TRIGGER_REASON,
	ENUM_EVENT_SET_TIME,
	ENUM_SET_METADATA,
	ENUM_ADD_TIMER_DONE,
	ENUM_EVENT_ADD_DONE,
	ENUM_EVENT_SET_TRIGGER_DEVICE_DONE,
	ENUM_EVENT_SET_TRIGGER_REASON_DONE,
	ENUM_EVENT_SET_TIME_DONE,
	ENUM_SET_METADATA_DONE,
	DELETE_SCHEDULE_EVENT_REMOVE,
	DELETE_SCHEDULE_TIMER_REMOVE,
	ENUM_AUTHENTICATE_USER,
	ENUM_EVENT_SET_DAYS_MASK,
	ENUM_SET_DAYS_MASK,
	ENUM_TIMER_RANDOMIZE,
	ENUM_SET_TIME,
	ENUM_INCLUDE_SCENE,
	ENUM_EVENT_SCENE_INCLUDE,
	ERROR,
	SET_SCENE_MEMBER_SETTING,
	SET_SCENE_MEMBER_SETTING_DONE,
	SCH_CHECK_TIMER_EVENT_CHANGE,
	SCH_REMOVE_SCHUDLE,
	SCH_ADD_SCHUDLE,
	SCH_EXCLUDE_SCHUDLE_FROM_SCENE,
	SCH_INCLUDE_SCHUDLE_TO_SCENE,
	SCH_SET_DAYS_MASK,
	SCH_SET_METADATA,
	SCH_TIMER_RANDOMIZE,
	SCH_START_CHANGE,
	SCH_ASSOCIATED_SCENE_CHANGE,
	SCH_SUNRISE_SUNSET_OFFSET_CHANGE,
	SCH_SUNRISE_SUNSET_TIME_CHANGE,
	PROCESSING_SCH_EXCLUDE_SCHUDLE_FROM_SCENE,
	PROCESSING_SCH_INCLUDE_SCHUDLE_TO_SCENE,
	SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE,
	SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE,
	PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE,
	PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE,
	SCH_CHECK_SCENE_CHANGE,
	PROCESSING_SCH_CHECK_SCENE_CHANGE,
	SCH_INCLUDE_SCHUDLE_TO_SCENE_TIME_EVENT,
	SCH_EVENT_TRIG_DEVICE,
	SCH_SET_TIME_TYPE,
	EXCLUDE_SCENE_EVENT,
	INCLUDE_SCENE_EVENT,
	ENUM_EVENT_REMOVE,
	ENUM_EVENT_REMOVE_DONE,
	FAN_MODE,
	SCHEDULE_MODE,
	ENERGY_SAVING_MODE,
	SET_TEMPERATURE,
	SET_ES_TEMPERATURE,
	THERMOSTAT_MODE,
	HOME_OCCUPANCY,
	HOME_OCCUPANCY_DONE,
	DONE
}ProcessEnum;

typedef enum ServiceStatusEnums
{
	//Success Values
	FE_SUCCESS	= 0,
	FE_ZW_COMPLETED = 5,
    FE_INVALID_SERVER_URL = 555,
	
	//Failure Values
	/*FE_FAILURE	=	-1,
	FE_FAIL_DB	=	-2,
	FE_FAIL_RANGE = -7,
	FE_FAIL_TYPE = -8,
	FE_FAIL_TIMEOUT = -9,
	FE_FAIL_ZW_BUSY = -14,
	FE_FAIL_ZW = -3,
	FE_FAIL_CANCEL = -10,
	FE_FAIL_ZW_DEV_RESET = -11,
	FE_FAIL_ZW_DEV_EXISTS = -12,
	AUTHENTICATION_ERROR = -13*/
}ServiceStatusEnums;

/**
 * ScheduleChangeMaskEnum as bit values
 */
typedef enum ScheduleChangeMaskEnum
{
	DAY_MASK_CHANGE 					= 1 << 0,
	METADATA_CHANGE 					= 1 << 1,
	RANDOMIZE_CHANGE 					= 1 << 2,
	START_CHANGE 						= 1 << 3,
	SUNRISE_SUNSET_OFFSET_CHANGE 		= 1 << 4,
	ASSOCIATED_SCENE_CHANGE 			= 1 << 5,
	SUNRISE_SUNSET_TIME_CHANGE			= 1 << 6,
	SUNRISE_SUNSET_ADD					= 1 << 7,
	SUNRISE_SUNSET_REMOVE				= 1 << 8
}ScheduleChangeMaskEnum;


//MetaDataTypeEnum
typedef enum MetaDataTypeEnum
{
	METAENUM_DEVICE=0,
	METAENUM_EVENT=2,
	METAENUM_NOTIFICATION=4,
	METAENUM_SCENE=1,
	METAENUM_TIMER=3,
	METAENUM_USER=5
}MetaDataTypeEnum;	

typedef enum SceneSettingTypeEnum
{
	ZWAVE_DEVICE =1,
	EVENT=2,
	TIMER=3,
	NOTIFICATION=4
}SceneSettingTypeEnum;



/**
 * Enumerates the days of the week as bit values
 */

typedef enum DaysOfWeekEnum
{
	/*
	 @default
	 */
	/*public static const ALL:int=SUNDAY | MONDAY | TUESDAY | WEDNESDAY | THURSDAY | FRIDAY | SATURDAY;*/
	ALL = 127,
	MONDAY = 1 << 0,
	TUESDAY= 1 << 1,
	WEDNESDAY = 1 << 2,
	THURSDAY = 1 << 3,
	FRIDAY = 1 << 4,
	SATURDAY = 1 << 5,
	SUNDAY = 1 << 6
}DaysOfWeekEnum;

typedef enum EventInfoChangeMaskEnum
{
	DAY_MASK   = 1 << 0,
	TIME_TYPE  = 1 << 1,
	TIME_START = 1 << 2,
	TIME_END   = 1 << 3,
	SUNRISE_SUNSET = 1 << 4,
	SUNRISE_SUNSET_OFFSET = 1 << 5
}EventInfoChangeMaskEnum;


//Sunrise or sunset enum
typedef enum SunriseSunsetTimeEnum
{
	SUNRISE = 1,
	SUNSET  = 2
}SunriseSunsetTimeEnum;

//EventTriggerConditionTypeEnum
typedef enum EventTriggerConditionTypeEnum
{
	ANY_TIME = 0,
	BEFORE_TIME = 1,
	AFTER_A_TIME = 2,
	BETWEEN_TWO_TIMES = 3,
	DEVICE = 4,
	IR_COMMAND = 5,
	TIME_OFFSET = 7
}EventTriggerConditionTypeEnum;

typedef enum ThermostateModeEnum
{
	OFF = 0,
	HEAT,
	COOL
}ThermostateModeEnum;

typedef enum FanModeEnum
{
	FAN_AUTO_LOW = 0,
	FAN_LOW,
	FAN_AUTO_HIGH,
	FAN_HIGH
}FanModeEnum;

typedef enum ThermostatScheduleBypassEnums
{
	USE_SCHEDULE = 0,
	BYPASS_SCHEDULE
}ThermostatScheduleBypassEnums;

typedef enum ThermostatEnergySaveModeEnum
{
	ENERGY_SAVINGS_MODE = 0,
	NORMAL_MODE = 100
}ThermostatEnergySaveModeEnum;


//ApplicationConfigurationProperties
static NSString* const sceneproductTypeList = @"21591,21314,21330";
static NSString* const dashboardExcludedDeviceTypeList = @"10,11,17,18,19,20,21,22,23,26,30,33,34,39";
static NSString* const sceneExcludedDeviceList = @"10,11,17,18,19,20,21,22,23,26,30,33,34,39";
static NSString* const eventTriggerExcludedDeviceList = @"0,1,2,3,4,5,6,7,8,9,16,21,22,23,24,25,26,27,28,29,30,31,32,35,36,37,39,40";
static NSString* const sessionid = @"";
//static NSString* const sessionid = @"2332423";
//static NSString* const sessionid = @"hoh5qpftrski9dem5q0ru42877";


//RoomService Constants
static NSString* const CHANGE_ROOM_NAME = @"bulogics_room_change_name";
static NSString* const GET_ROOMS_COMMAND =@"bulogics_get_rooms";
static NSString* const ADD_ROOMS_COMMAND =@"bulogics_room_add";
static NSString* const REMOVE_ROOM_COMMAND = @"bulogics_room_remove";
static NSString* const SELECTED_ROOM_COMMAND = @"bulogics_interface_custom_data_get";
static NSString* const SET_SELECTED_ROOM_COMMAND = @"bulogics_interface_custom_data_set";

//DeviceService Constants
static NSString* const CHANGE_NAME = @"bulogics_device_change_name";
static NSString* const CHANGE_ROOM = @"bulogics_device_change_room";
static NSString* const GET_ALL = @"bulogics_get_devices";
static NSString* const GET_DEVICE = @"bulogics_get_device";
static NSString* const GET_DEVICE_NAME = @"bulogics_device_get_name";
static NSString* const GET_PROTECTION = @"bulogics_get_protection";
static NSString* const SET_AS_SHORTCUT = @"bulogics_set_as_shortcut";
static NSString* const SET_CONTROLLED_WATTS=@"bulogics_set_controlled_watts";
static NSString* const SET_PROTECTION = @"bulogics_set_protection";
static NSString* const SET_VALUE = @"bulogics_device_set_value";
static NSString* const SET_SOMFY_MY_POSITION = @"bulogics_somfy_set_my_position";

//LiveView Dashboard Constants
static NSString* const GET_SCENES = @"bulogics_get_scenes";
static NSString* const ACTIVATE_SCENES = @"bulogics_activate_scene";
static NSString* const DEVICE_SETVALUE = @"bulogics_device_set_value";
static NSString* const THERMOSTAT_GET_STATUS = @"bulogics_thermostat_get_status";
static NSString* const THERMOSTAT_GET_DESIRED_TEMP = @"bulogics_thermostat_get_es_desired_temp";
static NSString* const SET_THERMOSTAT_ENERGY_SAVE_MODE = @"bulogics_thermostat_set_energy_save_mode";
static NSString* const SET_THERMOSTAT_TEMP_UP = @"bulogics_thermostat_temp_up";
static NSString* const SET_THERMOSTAT_TEMP_DOWN = @"bulogics_thermostat_temp_down";
static NSString* const THERMOSTAT_TOGGLE_MODE = @"bulogics_thermostat_toggle_mode";
static NSString* const THERMOSTAT_TOGGLE_FAN_MODE = @"bulogics_thermostat_toggle_fan_mode";
static NSString* const THERMOSTAT_TOGGLE_SCHEDULE_HOLD = @"bulogics_thermostat_toggle_schedule_hold";

//Thermostat Device Constants
static NSString* const GET_THERMOSTATS = @"bulogics_get_thermostats";
static NSString* const GET_STATUS = @"bulogics_thermostat_get_status";
static NSString* const TOGGLE_MODE = @"bulogics_thermostat_toggle_mode";
static NSString* const TOGGLE_SCHEDULE_HOLD = @"bulogics_thermostat_toggle_schedule_hold";
static NSString* const TOGGLE_FAN_MODE = @"bulogics_thermostat_toggle_fan_mode";
static NSString* const TEMP_UP = @"bulogics_thermostat_temp_up";
static NSString* const TEMP_DOWN = @"bulogics_thermostat_temp_down";
static NSString* const SET_TEMP = @"bulogics_thermostat_set_temp";
static NSString* const SET_ES_DESIRED_TEMP = @"bulogics_thermostat_set_es_desired_temp";
static NSString* const GET_ES_DESIRED_TEMP = @"bulogics_thermostat_get_es_desired_temp";
static NSString* const SET_ENERGY_SAVE_MODE = @"bulogics_thermostat_set_energy_save_mode";
static NSString* const CHANGE_THERMOSTAT_NAME = @"bulogics_thermostat_change_name";

//TimerService Constants
static NSString* const GET_TIMERS = @"bulogics_get_timers";
static NSString* const GET_INFO = @"bulogics_timer_get_info";
static NSString* const ADD_TIMER = @"bulogics_timer_add";
static NSString* const GET_NAME = @"bulogics_timer_get_name";
static NSString* const TIMER_CHANGE_NAME = @"bulogics_timer_change_name";
static NSString* const ENABLE = @"bulogics_timer_enable";
static NSString* const SET_DAYS_MASK = @"bulogics_timer_set_days_mask";
static NSString* const SET_TIME = @"bulogics_timer_set_time";
static NSString* const TIMER_RANDOMIZE = @"bulogics_timer_randomize";
static NSString* const INCLUDE_SCENE = @"bulogics_timer_include_scene";
static NSString* const REMOVE = @"bulogics_timer_remove";
static NSString* const CHANGE_ORDER = @"bulogics_timer_change_order";

//EventService Constants
static NSString* const GET_EVENTS = @"bulogics_get_events";
static NSString* const EVENT_CHANGE_ORDER = @"bulogics_event_change_order";
static NSString* const EVENT_ADD = @"bulogics_event_add";
static NSString* const EVENT_GET_INFO = @"bulogics_event_get_info";
static NSString* const EVENT_CHANGE_NAME = @"bulogics_event_change_name";
static NSString* const EVENT_GET_NAME = @"bulogics_event_get_name";
static NSString* const EVENT_ENABLE = @"bulogics_event_enable";
static NSString* const EVENT_SET_DAYS_MASK = @"bulogics_event_set_days_mask";
static NSString* const EVENT_SET_TIME_TYPE = @"bulogics_event_set_time_type";
static NSString* const EVENT_SET_TIME = @"bulogics_event_set_time";
static NSString* const EVENT_SET_TRIGGER_DEVICE = @"bulogics_event_set_trig_device";
static NSString* const EVENT_SET_TRIGGER_REASON = @"bulogics_event_set_trig_reason";
static NSString* const EVENT_SCENE_INCLUDE = @"bulogics_event_scene_include";
static NSString* const EVENT_GET_TRIGGER_DEVICES_LIST = @"bulogics_event_get_trig_devices_list";
static NSString* const EVENT_GET_TRIGGER_REASON_LIST = @"bulogics_event_get_trig_reason_list";
static NSString* const EVENT_GET_TRIGGER_REASON_LIST_BY_ID = @"bulogics_event_get_trig_reason_list_by_devid";
static NSString* const EVENT_REMOVE = @"bulogics_event_remove";


//Scene configurator home owner constants
static NSString* const ADD_SCENE = @"bulogics_scene_add";
static NSString* const REMOVE_SCENE = @"bulogics_scene_remove";
static NSString* const CHANGE_SCENE_NAME = @"bulogics_scene_change_name";
static NSString* const GET_SCENE_INFO = @"bulogics_scene_get_info";
static NSString* const INCLUDE_MEMBER = @"bulogics_scene_member_inclusion";
static NSString* const SET_MEMBER_SETTINGS= @"bulogics_scene_set_member_setting";

//Scene ConfigurationService Constants
static NSString* const DEVICE_SETUP_WIZARD_RUN=@"bulogics_device_setup_wiz_run";
static NSString* const DEVICE_SETUP_WIZARD_STATUS=@"bulogics_device_setup_wiz_get_status";
static NSString* const GET_SYSTEM_INFORMATION=@"bulogics_get_system_information";
static NSString* const SET_METADATA=@"bulogics_set_meta_data";
static NSString* const ZWAVE_ADD=@"bulogics_zwave_add";
static NSString* const ZWAVE_BROADCAST_NODE_INFO=@"bulogics_zwave_bcast_node_info";
static NSString* const ZWAVE_CANCEL=@"bulogics_zwave_cancel";
static NSString* const ZWAVE_DB_RESET=@"bulogics_zwave_db_reset";
static NSString* const ZWAVE_GET_STATUS=@"bulogics_zwave_get_status";
static NSString* const ZWAVE_LEARN=@"bulogics_zwave_learn";
static NSString* const ZWAVE_REDISCOVER_NODES=@"bulogics_zwave_rediscover_nodes";
static NSString* const ZWAVE_REMOVE=@"bulogics_zwave_remove";
static NSString* const ZWAVE_REMOVE_FAILED_NODE=@"bulogics_zwave_remove_failed_node";
static NSString* const ZWAVE_REPLACE_FAILED_NODE=@"bulogics_zwave_replace_failed_node";

//Scenecontroller service
static NSString* const GET_LIST = @"bulogics_scene_ctrlr_get_list";
static NSString* const GET_CONTROLLER = @"bulogics_scene_ctrlr_get";
static NSString* const SET_BUTTON = @"bulogics_scene_ctrlr_set_button";
static NSString* const CLEAR_BUTTON = @"bulogics_scene_ctrlr_clear_button";

//Tahoma controller service
static NSString* const SELECT_CONTROLLER = @"bulogics_select_controller";

//User Contants
static NSString* const AUTHENTICATE_USER=@"bulogics_authenticate";
static NSString* const LOGOUT=@"bulogics_close_session";

//Home occupancy INFO & Enable and disable home occupancy
static NSString* const HOME_OCCUPANCY_INFO_GET	=	@"bulogics_home_occupancy_info_get";
static NSString* const HOME_OCCUPANCY_ENABLE	=	@"bulogics_home_occupancy_enable_disable";
static NSString* const HOME_OCCUPANCY_STATE_GROUP_DEVICE_ADD	=	@"bulogics_home_occupancy_state_group_device_add";

//You need to make a call to zonoff_ip_camera_get_list to get camera specific information.
static NSString* const ZONOFF_IP_CAMERA_GET_LIST =	@"zonoff_ip_camera_get_list";

static int const MY_POSITION_VALUE=255;
static int const DEVICE_MY_POSITION_DEFAULT_VALUE=1;
static int const PresenceDetectorTriggerReasons_ON = 1;
static int const PresenceDetectorTriggerReasons_OFF = 2;



#define TRANSITION_DURATION 0.1
#define isLocal 0

#endif

