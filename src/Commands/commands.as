namespace CommandTypes{
    enum CommandType
    {
          GOAL = 0
        , TIME = 1
        , MAPINFO = 2
        , ROLL = 3
    }

    enum GoalCommand{
        BRONZE = 0,
        SILVER = 1,
        GOLD = 2,
        AUTHOR = 3,
        WR = 4,
        PB = 5
    }

    enum TimeCommand{
        LOCAL = 0,
        UTC = 1, 
        TIMEZONE = 2
    }

    enum MapInfo{
        ID = 0,
        NAME = 1,
        AUTHOR = 2,
        MAP = 3,
        TMIO = 4
    }
}

class commands
{    
    array<Json::Value@> availableCommands;
    

    commands()
    {
        addCommand("/bronze", "Tell the Map Bronze Time to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::BRONZE);
        addCommand("/silver", "Tell the Map Silver Time to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::SILVER);
        addCommand("/gold", "Tell the Map Gold Time to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::GOLD);
        addCommand("/at", "Tell the Map Author Time to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::AUTHOR);
        addCommand("/wr", "Tell the Map World Record to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::WR);
        addCommand("/pb", "Tell your Map Personal Best to the room.", CommandTypes::CommandType::GOAL, CommandTypes::GoalCommand::PB);
        addCommand("/roll", "Roll a number between 1 and the number following the command. (/roll 34 -> 1-34)", CommandTypes::CommandType::ROLL, 0);
        addCommand("/timeutc", "Tell the time in UTC time zone to the room.", CommandTypes::CommandType::TIME, CommandTypes::TimeCommand::UTC);
        addCommand("/timezone", "Tell the time in a time zone to the room. (Check Timezone Tab for more info!)", CommandTypes::CommandType::TIME, CommandTypes::TimeCommand::TIMEZONE);
        addCommand("/time", "Tell your local time to the room.", CommandTypes::CommandType::TIME, CommandTypes::TimeCommand::LOCAL);
        addCommand("/mapid", "Tell the Map ID to the room.", CommandTypes::CommandType::MAPINFO, CommandTypes::MapInfo::ID);
        addCommand("/mapname", "Tell the Map Name to the room.", CommandTypes::CommandType::MAPINFO, CommandTypes::MapInfo::NAME);
        addCommand("/mapauthor", "Tell the Map Author to the room.", CommandTypes::CommandType::MAPINFO, CommandTypes::MapInfo::AUTHOR);
        addCommand("/map", "Tell the Map Name and ID to the room.", CommandTypes::CommandType::MAPINFO, CommandTypes::MapInfo::MAP);
        addCommand("/tmio", "Tell the Map TMIO link to the room.", CommandTypes::CommandType::MAPINFO, CommandTypes::MapInfo::TMIO);
        
    }

    void addCommand(const string &in name, const string &in description, const string &in  type, const string &in  value)
    {
        Json::Value@ command = Json::Object();
        command["name"] = name;
        command["description"] = description;
        command["type"] = type;
        command["value"] = value;
        availableCommands.InsertLast(command);
    }

    void addCommand(const string &in  name, const string &in  description, const string &in  type, int value)
    {
        Json::Value@ command = Json::Object();
        command["name"] = name;
        command["description"] = description;
        command["type"] = type;
        command["value"] = value;
        availableCommands.InsertLast(command);
    }

    void addCommand(const string &in  name, const string &in  description, int type, const string &in  value)
    {
        Json::Value@ command = Json::Object();
        command["name"] = name;
        command["description"] = description;
        command["type"] = type;
        command["value"] = value;
        availableCommands.InsertLast(command);
    }

    void addCommand(const string &in  name, const string &in  description, int type, int value)
    {
        Json::Value@ command = Json::Object();
        command["name"] = name;
        command["description"] = description;
        command["type"] = type;
        command["value"] = value;
        availableCommands.InsertLast(command);
    }


    array<Json::Value@> getCommands()
    {
        return availableCommands;
    }

    string ParseCommand(const string &in  msg)
    {
        //print("ParseCommand: " + msg);
        for (uint i = 0; i < availableCommands.Length; i++)
        {
            string cmd = availableCommands[i]["name"];
            //print("Command: " + cmd);
            if (msg.StartsWith(cmd))
            {
                int acmd = availableCommands[i]["type"];
                int value = availableCommands[i]["value"];
                switch (acmd)
                {
                    case CommandTypes::CommandType::GOAL:
                        return GoalCommand(value);
                    case CommandTypes::CommandType::TIME:
                        return TimeCommand(value, msg);
                    case CommandTypes::CommandType::MAPINFO:
                        return MapInfo(value);
                    case CommandTypes::CommandType::ROLL:
                        return RollCommand(msg);
                }
            }
        }
        return msg;
    }

    string FormatCommand(const string &in  msg)
    {
        string formattedMessage = msg;
        bool isCommand = false;
        for (uint i = 0; i < availableCommands.Length; i++)
        {
            string cmd = availableCommands[i]["name"];
            if (msg.StartsWith(cmd))
            {
                int acmd = availableCommands[i]["type"];
                int value = availableCommands[i]["value"];
                switch (acmd)
                {
                    case CommandTypes::CommandType::GOAL:
                        formattedMessage = FormattedGoalCommand(value);
                        break;
                    case CommandTypes::CommandType::TIME:
                        formattedMessage = FormattedTimeCommand(value, msg);
                        break;
                    case CommandTypes::CommandType::MAPINFO:
                        formattedMessage = FormattedMapInfo(value);
                        break;
                    case CommandTypes::CommandType::ROLL:
                        formattedMessage = FormattedRollCommand(msg);
                        break;
                }
                isCommand = true;
                break;
            }
        }
        if (!isCommand)
        {
            formattedMessage = msg;
        }
        return formattedMessage.Replace("$", "\\$");
    }

    bool IsCommand(const string &in  msg)
    {
        for (uint i = 0; i < availableCommands.Length; i++)
        {
            string cmd = availableCommands[i]["name"];
            if (msg.StartsWith(cmd))
            {
                return true;
            }
        }
        return false;
    }
}

commands global_commands = commands();
