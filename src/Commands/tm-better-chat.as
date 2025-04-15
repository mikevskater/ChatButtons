// WR Code used from tm-better-chat plugin adjusted to send the message directly to the chat
// https://github.com/codecat/tm-better-chat
/*
The MIT License (MIT)

Copyright © 2025 Melissa Geels <miss@openplanet.dev>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
#if TMNEXT && DEPENDENCY_NADEOSERVICES
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