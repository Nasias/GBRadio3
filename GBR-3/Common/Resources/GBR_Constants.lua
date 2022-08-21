GBR_Constants = 
{
    LIB_ACE_CONSOLE = "AceConsole-3.0",
    LIB_ACE_SERIALISER = "AceSerializer-3.0",
    LIB_ACE_SETTINGS = "AceConfig-3.0",
    LIB_ACE_COMM = "AceComm-3.0",
    LIB_HBD_LOCATION = "HereBeDragons-2.0",
    LIB_ACE_DB = "AceDB-3.0",

    SRV_COMMAND_SERVICE = "CommandService",
    SRV_CONFIG_SERVICE = "ConfigService",
    SRV_HISTORY_SERVICE = "HistoryService",
    SRV_LOCATION_SERVICE = "LocationService",
    SRV_MESSAGE_SERVICE = "MessageService",
    SRV_MRP_SERVICE = "MRPService",
    SRV_PLAYER_SERVICE = "PlayerService",
    SRV_SERIALISER_SERVICE = "SerialiserService",
    SRV_SINGLETON_SERVICE = "SingletonService",
    SRV_ADDON_SERVICE = "AddonService",

    CMD_MAIN = "gbr",
    CMD_DEV_TEST = "gbr3test",
    CMD_SEND_MESSAGE = "bb",
    CMD_SEND_QUIET_MESSAGE = "wbb",
    CMD_TEST_RECEIVE_MESSAGE = "tbb",
    CMD_SEND_EMERGENCY_MESSAGE = "pb",

    ID_PLAYER = "player",
    ID_TARGET = "targer",

    STRING_FORMAT_HEX = "%02x",

    UI_COLOUR_ESCAPE_STRING = "|c",
    UI_COLOUR_ESCAPE_STRING_END = "|r",
    UI_HYPERLINK_ESCAPE_STRING = "|H",

    OPT_ADDON_CHANNEL_PREFIX = "GBR3",
    OPT_ADDON_VERSION = "3.0",
    OPT_COMM_CHANNEL_NAME = "xtensionxtooltip2",
    OPT_COMM_CHANNEL_TARGET = "CHANNEL",
    OPT_ADDON_SETTINGS_DB = "GBRadioSettingsDb",

    MSG_CHAT_FRAME_IDENTITY = "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertOther:16:16:0:-1|t%s [GBRadio - Chatframe Identity] This is chat frame #%d.",
    -- colour, frequency, charactername, displayname, message
    MSG_RADIO_MESSAGE = "|TInterface\\COMMON\\VOICECHAT-SPEAKER:16:16:0:0:16:16:0:16:0:16:0:255:0|t %s[%s] [|Hplayer:%s|h%s|h]: %s",
    -- colour, frequency, charactername, displayname, location, coord-x, coord-y
    MSG_RADIO_EMERGENCY = "|TInterface\\DialogFrame\\DialogAlertIcon:16:16:0:2:64:64:16:46:16:46|t %s[%s] [|Hplayer:%s|h%s|h] [|cFFFF0000EMERGENCY ALERT|r]: Emergency at %s (%.2f, %.2f).",
    -- colour, frequency, charactername, displayname, location
    MSG_RADIO_EMERGENCY_NO_COORDS = "|TInterface\\COMMON\\VOICECHAT-SPEAKER:16:16:8|t|TInterface\\COMMON\\VOICECHAT-ON:16:16:-8|t %s[%s] [|Hplayer:%s|h%s|h] [|cFFFF0000EMERGENCY ALERT|r]: Emergency at %s]",

    -- pronoun, device name
    MSG_EMOTE_SEND_MESSAGE = "speaks into %s %s --",

    -- pronoun, device name
    MSG_EMOTE_SILENT_SEND_MESSAGE = "murmurs something quietly into %s %s.",

    -- pronoun, device name
    MSG_EMOTE_EMERGENCY_SEND_MESSAGE = "presses the emergency button on %s %s.",

    -- device name, audio cue (crackles, buzzes), pronoun
    MSG_EMOTE_RECEIVE_MESSAGE = "'s %s %s as a message is received.",

    MSG_EMOTE_RECEIVE_VERBS =
    {
        "chirps",
        "chimes",
        "beeps"
    }
};