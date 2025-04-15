const array<string> medalColors = {"$444","$964","$899","$db4","$071","$0f1","$964","$899","$db4","$0ff"};

string goalCommand(int type){
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

#if TMNEXT && DEPENDENCY_NADEOSERVICES
    // WR Code used from tm-better-chat plugin adjusted to send the message directly to the chat
    // https://github.com/codecat/tm-better-chat
	void RunWorldRecordAsync()
	{
        auto app = cast<CTrackMania>(GetApp());
        
        auto map = app.RootMap;
        string uid = map.IdName;

		const string audience = "NadeoLiveServices";
		while (!NadeoServices::IsAuthenticated(audience)) {
			yield();
		}

		string url = NadeoServices::BaseURLLive() + "/api/token/leaderboard/group/Personal_Best/map/" + uid + "/top";

		auto req = NadeoServices::Get(audience, url);
		req.Start();
		while (!req.Finished()) {
			yield();
		}

		auto res = req.String();
		auto js = Json::Parse(res);
		if (js.GetType() == Json::Type::Null) {
			print("Unable to parse world record response: \"" + res + "\"");
			return;
		}

		auto tops = js["tops"];
		if (tops.Length == 0) {
            print("No leaderboard found for this map.");
			return;
		}

		auto records = tops[0]["top"];
		if (records.Length == 0) {
            print("No world record found for this map.");
			return;
		}

		auto jsWr = records[0];
		string wrAccountId = jsWr["accountId"];
		int wrTime = jsWr["score"];
		string wrDisplayName = NadeoServices::GetDisplayNameAsync(wrAccountId);

		string msg = "$<$db0" + Icons::Bullseye + "$> World Record: $<$bbb" + Time::Format(wrTime) + "$> by $bbb" + wrDisplayName;

        CSmArenaClient@ playground = cast<CSmArenaClient>(cast<CTrackMania>(GetApp()).CurrentPlayground);
        CGamePlaygroundInterface@ playgroundInterface = cast<CGamePlaygroundInterface>(playground.Interface);
        playgroundInterface.ChatEntry = msg;
        print("Macro sent:\n" + msg);
        return;
	}
#endif

string mapInfo(int type){
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