const array<string> medalColors = {"$444","$964","$899","$db4","$071","$0f1","$964","$899","$db4","$0ff"};

string GoalCommand(int type){
	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);
    
    auto map = app.RootMap;
    string uid = map.IdName;

    if (map is null || map.MapInfo.MapUid == "" || app.Editor !is null) {
        return "";
    }

    string msg;

#if TMNEXT && DEPENDENCY_NADEOSERVICES
    if (type == 4) {
        startnew(CoroutineFunc(RunWorldRecordAsync));
        return "";
    }
#endif

#if TMNEXT
    if (type == 5) {
        msg = "";
        int pbtime;
        uint pbmedal;
        if(network.ClientManiaAppPlayground !is null) {
            auto userMgr = network.ClientManiaAppPlayground.UserMgr;
            auto scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
            MwId userId;
            if (userMgr.Users.Length > 0) {
                userId = userMgr.Users[0].Id;
            } else {
                userId.Value = uint(-1);
            }            
            pbtime = scoreMgr.Map_GetRecord_v2(userId, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
            pbmedal = scoreMgr.Map_GetMedal(userId, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
        }
        if (pbmedal == 0) {
            msg = "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb" + Time::Format(pbtime) + "$> (No " + (pbtime <= 0 ? "Finish" : "Medal") + ")";
        } else {
            msg = "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb" + Time::Format(pbtime) + "$> ($<" + medalColors[pbmedal] + Icons::Circle + "$>)";
        }
        return msg;
    }
#endif

    switch (type) {
        case CommandTypes::GoalCommand::BRONZE: msg = "$<$964" + Icons::Trophy + "$> Bronze Medal: $bbb" + Time::Format(map.TMObjective_BronzeTime); break;
        case CommandTypes::GoalCommand::SILVER: msg = "$<$899" + Icons::Trophy + "$> Silver Medal: $bbb" + Time::Format(map.TMObjective_SilverTime); break;
        case CommandTypes::GoalCommand::GOLD: msg = "$<$db4" + Icons::Trophy + "$> Gold Medal: $bbb"   + Time::Format(map.TMObjective_GoldTime); break;
        case CommandTypes::GoalCommand::AUTHOR: msg = "$<$071" + Icons::Trophy + "$> Author Medal: $bbb" + Time::Format(map.TMObjective_AuthorTime); break;
    }

    return msg;
}

string MapInfo(int type){
	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);
    
    auto map = app.RootMap;
    string uid = map.IdName;

    switch (type) {
        case CommandTypes::MapInfo::ID: return "$<$db0" + Icons::Map + "$> Map ID: $bbb" + uid;
        case CommandTypes::MapInfo::NAME: return "$<$db0" + Icons::Map + "$> Map Name: $bbb" + map.MapInfo.Name;
        case CommandTypes::MapInfo::AUTHOR: return "$<$db0" + Icons::Map + "$> Map Author: $bbb" + Text::StripFormatCodes(map.MapInfo.AuthorNickName);
        case CommandTypes::MapInfo::MAP: return "$<$db0" + Icons::Map + "$> Map Name and ID: $bbb" + map.MapInfo.Name + " ("+ uid+ ")";
        case CommandTypes::MapInfo::TMIO: return "$<$db0" + Icons::Map + "$> TMIO Link: $l[https://trackmania.io/#/leaderboard/" + uid + "]" + Text::StripFormatCodes(map.MapInfo.Name) + "$l";        
    }
    return "";
}

string FormattedGoalCommand(int type){
    switch (type) {
        case CommandTypes::GoalCommand::BRONZE: return "$<$964" + Icons::Trophy + "$> Bronze Medal: $bbb00:00.000";
        case CommandTypes::GoalCommand::SILVER: return "$<$899" + Icons::Trophy + "$> Silver Medal: $bbb00:00.000";
        case CommandTypes::GoalCommand::GOLD: return "$<$db4" + Icons::Trophy + "$> Gold Medal: $bbb00:00.000";
        case CommandTypes::GoalCommand::AUTHOR: return "$<$071" + Icons::Trophy + "$> Author Medal: $bbb00:00.000";
        case CommandTypes::GoalCommand::WR: return "$<$db0" + Icons::Bullseye + "$> World Record: $<$bbb00:00.000$> by $bbbPlayerName";
        case CommandTypes::GoalCommand::PB: return "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb00:00.000$> (No Finish)";
    }
    return "";
}

string FormattedMapInfo(int type){
    switch (type) {
        case CommandTypes::MapInfo::ID: return "$<$db0" + Icons::Map + "$> Map ID: $bbb00000000";
        case CommandTypes::MapInfo::NAME: return "$<$db0" + Icons::Map + "$> Map Name: $bbbMapName";
        case CommandTypes::MapInfo::AUTHOR: return "$<$db0" + Icons::Map + "$> Map Author: $bbbAuthorName";
        case CommandTypes::MapInfo::MAP: return "$<$db0" + Icons::Map + "$> Map Name and ID: $bbbMapName (0000000000)";
        case CommandTypes::MapInfo::TMIO: return "$<$db0" + Icons::Map + "$> TMIO Link: $l[https://trackmania.io/#/leaderboard/0000000000]$l";
    }
    return "";
}


// Map Control Command Functions
string MapControlCommand(int type)
{
    auto app = cast<CTrackMania>(GetApp());
    auto network = cast<CTrackManiaNetwork>(app.Network);
    
    if (network is null) {
        print("Network is null - cannot execute map control command");
        return "";
    }
    
    auto playgroundClientAPI = network.PlaygroundClientScriptAPI;
    if (playgroundClientAPI is null) {
        print("PlaygroundClientScriptAPI is null - cannot execute map control command");
        return "";
    }
    
    string msg = "";
    
    switch (type) {
        case CommandTypes::MapControlCommand::RESTART:        
            if (playgroundClientAPI.Vote_CanVote){
                print("Cannot restart map - voting is currently going");
                return "";
            }
            playgroundClientAPI.RequestRestartMap();
            msg = FormattedMapControlCommand(CommandTypes::MapControlCommand::RESTART);
            print("Map restart requested");
            break;
        case CommandTypes::MapControlCommand::NEXT:        
            if (playgroundClientAPI.Vote_CanVote){
                print("Cannot skip map - voting is currently going");
                return "";
            }
            playgroundClientAPI.RequestNextMap();
            msg = FormattedMapControlCommand(CommandTypes::MapControlCommand::NEXT);
            print("Next map requested");
            break;
        case CommandTypes::MapControlCommand::VOTEYES:        
            if (!playgroundClientAPI.Vote_CanVote){
                print("Cannot Send Vote - voting is not available");
                return "";
            }
            playgroundClientAPI.Vote_Cast(true);
            msg = "";
            print("Sent yes vote");
            break;
        case CommandTypes::MapControlCommand::VOTENO:
            if (!playgroundClientAPI.Vote_CanVote){
                print("Cannot Send Vote - voting is not available");
                return "";
            }
            playgroundClientAPI.Vote_Cast(false);
            msg = "";
            print("Sent no vote");
            break;
    }
    
    return msg;
}

string FormattedMapControlCommand(int type)
{
    switch (type) {
        case CommandTypes::MapControlCommand::RESTART:
            return "$<$db0" + Icons::Refresh + "$> Map restart requested";
        case CommandTypes::MapControlCommand::NEXT:
            return "$<$db0" + Icons::Forward + "$> Next map requested";
    }
    return "";
}