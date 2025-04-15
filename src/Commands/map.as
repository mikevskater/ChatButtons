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
            msg = "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb" + Time::Format(pbtime) + "$> (No Finish)";
        } else {
            msg = "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb" + Time::Format(pbtime) + "$> ($<" + medalColors[pbmedal] + Icons::Circle + "$>)";
        }
        return msg;
    }
#endif

    switch (type) {
        case 0: msg = "$<$964" + Icons::Trophy + "$> Bronze Medal: $bbb" + Time::Format(map.TMObjective_BronzeTime); break;
        case 1: msg = "$<$899" + Icons::Trophy + "$> Silver Medal: $bbb" + Time::Format(map.TMObjective_SilverTime); break;
        case 2: msg = "$<$db4" + Icons::Trophy + "$> Gold Medal: $bbb"   + Time::Format(map.TMObjective_GoldTime); break;
        case 3: msg = "$<$071" + Icons::Trophy + "$> Author Medal: $bbb" + Time::Format(map.TMObjective_AuthorTime); break;
    }

    return msg;
}

string MapInfo(int type){
	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);
    
    auto map = app.RootMap;
    string uid = map.IdName;


    switch (type) {
        case 0: return "$<$db0" + Icons::Map + "$> Map ID: $bbb" + uid;
        case 1: return "$<$db0" + Icons::Map + "$> Map Name: $bbb" + map.MapInfo.Name;
        case 2: return "$<$db0" + Icons::Map + "$> Map Author: $bbb" + Text::StripFormatCodes(map.MapInfo.AuthorNickName);
        case 3: return "$<$db0" + Icons::Map + "$> Map Name and ID: $bbb" + map.MapInfo.Name + " ("+ uid+ ")";
        case 4: return "$<$db0" + Icons::Map + "$> TMIO Link: $l[https://trackmania.io/#/leaderboard/" + uid + "]" + Text::StripFormatCodes(map.MapInfo.Name) + "$l";        
    }
    return "";
}

string FormattedGoalCommand(int type){
    switch (type) {
        case 0: return "$<$964" + Icons::Trophy + "$> Bronze Medal: $bbb00:00.000";
        case 1: return "$<$899" + Icons::Trophy + "$> Silver Medal: $bbb00:00.000";
        case 2: return "$<$db4" + Icons::Trophy + "$> Gold Medal: $bbb00:00.000";
        case 3: return "$<$071" + Icons::Trophy + "$> Author Medal: $bbb00:00.000";
        case 4: return "$<$db0" + Icons::Bullseye + "$> World Record: $<$bbb00:00.000$> by $bbbPlayerName";
        case 5: return "$<$db0" + Icons::Bullseye + "$> Personal Best: $<$bbb00:00.000$> (No Finish)";
    }
    return "";
}

string FormattedMapInfo(int type){
    switch (type) {
        case 0: return "$<$db0" + Icons::Map + "$> Map ID: $bbb00000000";
        case 1: return "$<$db0" + Icons::Map + "$> Map Name: $bbbMapName";
        case 2: return "$<$db0" + Icons::Map + "$> Map Author: $bbbAuthorName";
        case 3: return "$<$db0" + Icons::Map + "$> Map Name and ID: $bbbMapName (0000000000)";
        case 4: return "$<$db0" + Icons::Map + "$> TMIO Link: $l[https://trackmania.io/#/leaderboard/0000000000]$l";
    }
    return "";
}