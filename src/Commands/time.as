class tZone{
    string code;
    string name;
    float offset;
    tZone(){
        code = "";
        name = "";
        offset = 0;
    }
    tZone(const string &in code, const string &in name, float offset){
        this.code = code;
        this.name = name;
        this.offset = offset;
    }
    string GetCode(){
        return code;
    }
    string GetName(){
        return name;
    }
    string GetOffset(){
        string offsetString = "";
        if (offset > 0){
            offsetString = "+";
        } else {
            offsetString = "-";
        }
        string hours = tostring(Math::Abs(Math::Floor(offset)));
        string minutes = tostring(Math::Floor((offset - Math::Floor(offset)) * 60));
        offsetString = offsetString + hours + ":" + (minutes.Length == 1 ? "0" : "") + minutes;
        return offsetString;
    }
    Time::Info GetOffsetTimeInfo(){
        Time::Info now = Time::ParseUTC(Time::Stamp);
        int hours = Math::Abs(int(offset));
        int minutes = int((offset - int(offset)) * 60);
        if (this.offset > 0){
            now.Minute += minutes;
            if (now.Minute >= 60){
                now.Hour += 1;
                now.Minute -= 60;
            }
            now.Hour += hours;
            if (now.Hour >= 24){
                now.Hour -= 24;
            }            
        } else {
            now.Minute -= minutes;
            if (now.Minute < 0){
                now.Hour -= 1;
                now.Minute += 60;
            }
            now.Hour -= hours;
            if (now.Hour < 0){
                now.Hour += 24;
            }
        }
        return now;
    }

    string GetOffsetString(){
        Time::Info offsetTime = GetOffsetTimeInfo();
        return  (offsetTime.Hour < 10 ? "0" : "") + offsetTime.Hour + ":" + (offsetTime.Minute < 10 ? "0" : "") + offsetTime.Minute + ":" + (offsetTime.Second < 10 ? "0" : "") + offsetTime.Second + "$> in $2F5" + this.name;
    }

    string GetOffsetFormattedString(){
        return  "00:00:00$> in $2F5" + this.name;
    }
}
class tZones{
    array<tZone> timeZones;
    tZones(){
        addZone("ACDT", "Australian Central Daylight Saving Time", 10.5);
        addZone("ACST", "Australian Central Standard Time", 9.5);
        addZone("ACT", "Acre Time", -5);
        addZone("ACWST", "Australian Central Western Standard Time", 8.75);
        addZone("ADT", "Atlantic Daylight Time", -3);
        addZone("AEDT", "Australian Eastern Daylight Saving Time", 11);
        addZone("AEST", "Australian Eastern Standard Time", 10);
        addZone("AFT", "Afghanistan Time", 4.5);
        addZone("AKDT", "Alaska Daylight Time", -8);
        addZone("AKST", "Alaska Standard Time", -9);
        addZone("ALMT", "Alma-Ata Time", 6);
        addZone("AMST", "Amazon Summer Time", -3);
        addZone("AMT", "Amazon Time", -4);
        addZone("ANAT", "Anadyr Time", 12);
        addZone("AQTT", "Aqtobe Time", 5);
        addZone("ARMT", "Armenia Time", 4);
        addZone("ARST", "Arabia Standard Time", 3);
        addZone("ART", "Argentina Time", -3);
        addZone("ASEAN", "ASEAN Common Time", 8);
        addZone("AST", "Atlantic Standard Time", -4);
        addZone("AWST", "Australian Western Standard Time", 8);
        addZone("AZOST", "Azores Summer Time", 0);
        addZone("AZOT", "Azores Standard Time", -1);
        addZone("AZT", "Azerbaijan Time", 4);
        addZone("BIOT", "British Indian Ocean Time", 6);
        addZone("BIT", "Baker Island Time", -12);
        addZone("BNT", "Brunei Time", 8);
        addZone("BOST", "Bougainville Standard Time", 11);
        addZone("BOT", "Bolivia Time", -4);
        addZone("BRST", "Brasília Summer Time", -2);
        addZone("BRST", "British Summer Time", 1);
        addZone("BRT", "Brasília Time", -3);
        addZone("BST", "Bangladesh Standard Time", 6);
        addZone("BTT", "Bhutan Time", 6);
        addZone("CAT", "Central Africa Time", 2);
        addZone("CCT", "Cocos Islands Time", 6.5);
        addZone("CDT", "Central Daylight Time", -5);
        addZone("CEST", "Central European Summer Time", 2);
        addZone("CET", "Central European Time", 1);
        addZone("CHADT", "Chatham Daylight Time", 13.75);
        addZone("CHAST", "Chatham Standard Time", 12.75);
        addZone("CHMST", "Chamorro Standard Time", 10);
        addZone("CHOST", "Choibalsan Summer Time", 9);
        addZone("CHOT", "Choibalsan Standard Time", 8);
        addZone("CHST", "China Standard Time", 8);
        addZone("CHUT", "Chuuk Time", 10);
        addZone("CIST", "Clipperton Island Standard Time", -8);
        addZone("CKT", "Cook Island Time", -10);
        addZone("CLST", "Chile Summer Time", -3);
        addZone("CLT", "Chile Standard Time", -4);
        addZone("COST", "Colombia Summer Time", -4);
        addZone("COT", "Colombia Time", -5);
        addZone("CST", "Central Standard Time", -6);
        addZone("CUDT", "Cuba Daylight Time", -4);
        addZone("CUST", "Cuba Standard Time", -5);
        addZone("CVT", "Cape Verde Time", -1);
        addZone("CWST", "Central Western Standard Time", 8.75);
        addZone("CXT", "Christmas Island Time", 7);
        addZone("DAVT", "Davis Time", 7);
        addZone("DDUT", "Dumont d'Urville Time", 10);
        addZone("DFT", "AIX Central European Time", 1);
        addZone("EASST", "Easter Island Summer Time", -5);
        addZone("EAST", "Easter Island Standard Time", -6);
        addZone("EAT", "East Africa Time", 3);
        addZone("ECT", "Eastern Caribbean Time", -4);
        addZone("ECUT", "Ecuador Time", -5);
        addZone("EDT", "Eastern Daylight Time", -4);
        addZone("EDT", "Eastern Time", -4);
        addZone("EEST", "Eastern European Summer Time", 3);
        addZone("EET", "Eastern European Time", 2);
        addZone("EGST", "Eastern Greenland Summer Time", 0);
        addZone("EGT", "Eastern Greenland Time", -1);
        addZone("EST", "Eastern Standard Time", -5);
        addZone("FET", "Further-eastern European Time", 3);
        addZone("FJT", "Fiji Time", 12);
        addZone("FKST", "Falkland Islands Summer Time", -3);
        addZone("FKT", "Falkland Islands Time", -4);
        addZone("FNT", "Fernando de Noronha Time", -2);
        addZone("GALT", "Galápagos Time", -6);
        addZone("GAMT", "Gambier Islands Time", -9);
        addZone("GET", "Georgia Standard Time", 4);
        addZone("GFT", "French Guiana Time", -3);
        addZone("GILT", "Gilbert Island Time", 12);
        addZone("GIT", "Gambier Island Time", -9);
        addZone("GMT", "Greenwich Mean Time", 0);
        addZone("GST", "Gulf Standard Time", 4);
        addZone("GYT", "Guyana Time", -4);
        addZone("HAEC", "Heure Avancée d'Europe Centrale", 2);
        addZone("HDT", "Hawaii–Aleutian Daylight Time", -9);
        addZone("HKT", "Hong Kong Time", 8);
        addZone("HMT", "Heard and McDonald Islands", 5);
        addZone("HOVST", "Hovd Summer Time", 8);
        addZone("HOVT", "Hovd Time", 7);
        addZone("HST", "Hawaii–Aleutian Standard Time", -10);
        addZone("ICT", "Indochina Time", 7);
        addZone("IDLW", "International Date Line West", -12);
        addZone("IDT", "Israel Daylight Time", 3);
        addZone("INST", "Indian Standard Time", 5.5);
        addZone("IOT", "Indian Ocean Time", 6);
        addZone("IRDT", "Iran Daylight Time", 4.5);
        addZone("IRKT", "Irkutsk Time", 8);
        addZone("IRST", "Iran Standard Time", 3.5);
        addZone("ISRT", "Israel Standard Time", 2);
        addZone("IST", "Irish Standard Time", 1);
        addZone("JST", "Japan Standard Time", 9);
        addZone("KALT", "Kaliningrad Time", 2);
        addZone("KGT", "Kyrgyzstan Time", 6);
        addZone("KOST", "Kosrae Time", 11);
        addZone("KRAT", "Krasnoyarsk Time", 7);
        addZone("KST", "Korea Standard Time", 9);
        addZone("LHSDT", "Lord Howe Standard Time", 10.5);
        addZone("LHST", "Lord Howe Summer Time", 11);
        addZone("LINT", "Line Islands Time", 14);
        addZone("MAGT", "Magadan Time", 12);
        addZone("MART", "Marquesas Islands Time", -8.5);
        addZone("MAWT", "Mawson Station Time", 5);
        addZone("MDT", "Mountain Daylight Time", -6);
        addZone("MEST", "Middle European Summer Time", 2);
        addZone("MET", "Middle European Time", 1);
        addZone("MHT", "Marshall Islands Time", 12);
        addZone("MIST", "Macquarie Island Station Time", 11);
        addZone("MIT", "Marquesas Islands Time", -8.5);
        addZone("MMT", "Myanmar Standard Time", 6.5);
        addZone("MSK", "Moscow Time", 3);
        addZone("MST", "Malaysian Standard Time", 8);
        addZone("MST", "Mountain Standard Time", -7);
        addZone("MUT", "Mauritius Time", 4);
        addZone("MVT", "Maldives Time", 5);
        addZone("MYT", "Malaysia Time", 8);
        addZone("NCT", "New Caledonia Time", 11);
        addZone("NDT", "Newfoundland Daylight Time", -1.5);
        addZone("NFT", "Norfolk Island Time", 11);
        addZone("NOVT", "Novosibirsk Time", 7);
        addZone("NPT", "Nepal Time", 5.75);
        addZone("NST", "Newfoundland Standard Time", -2.5);
        addZone("NT", "Newfoundland Time", -2.5);
        addZone("NUT", "Niue Time", -11);
        addZone("NZDT", "New Zealand Daylight Time", 13);
        addZone("NZST", "New Zealand Standard Time", 12);
        addZone("OMST", "Omsk Time", 6);
        addZone("ORAT", "Oral Time", 5);
        addZone("PDT", "Pacific Daylight Time", -7);
        addZone("PET", "Peru Time", -5);
        addZone("PETT", "Kamchatka Time", 12);
        addZone("PGT", "Papua New Guinea Time", 10);
        addZone("PHOT", "Phoenix Island Time", 13);
        addZone("PHST", "Philippine Standard Time", 8);
        addZone("PHT", "Philippine Time", 8);
        addZone("PKT", "Pakistan Standard Time", 5);
        addZone("PMDT", "Saint Pierre and Miquelon Daylight Time", -2);
        addZone("PMST", "Saint Pierre and Miquelon Standard Time", -3);
        addZone("PONT", "Pohnpei Standard Time", 11);
        addZone("PST", "Pacific Standard Time", -8);
        addZone("PWT", "Palau Time", 9);
        addZone("PYST", "Paraguay Summer Time", -3);
        addZone("PYT", "Paraguay Time", -4);
        addZone("RET", "Réunion Time", 4);
        addZone("ROTT", "Rothera Research Station Time", -3);
        addZone("SAKT", "Sakhalin Island Time", 11);
        addZone("SAMT", "Samara Time", 4);
        addZone("SAST", "South African Standard Time", 2);
        addZone("SBT", "Solomon Islands Time", 11);
        addZone("SCT", "Seychelles Time", 4);
        addZone("SDT", "Samoa Daylight Time", -10);
        addZone("SGST", "South Georgia and the South Sandwich Islands Time", -2);
        addZone("SGT", "Singapore Time", 8);
        addZone("SLST", "Sri Lanka Standard Time", 5.5);
        addZone("SRET", "Srednekolymsk Time", 11);
        addZone("SRT", "Suriname Time", -3);
        addZone("SST", "Samoa Standard Time", -11);
        addZone("SYOT", "Showa Station Time", 3);
        addZone("TAHT", "Tahiti Time", -10);
        addZone("TFT", "French Southern and Antarctic Time", 5);
        addZone("THA", "Thailand Standard Time", 7);
        addZone("TJT", "Tajikistan Time", 5);
        addZone("TKT", "Tokelau Time", 13);
        addZone("TLT", "Timor Leste Time", 9);
        addZone("TMT", "Turkmenistan Time", 5);
        addZone("TOT", "Tonga Time", 13);
        addZone("TRT", "Turkey Time", 3);
        addZone("TST", "Taiwan Standard Time", 8);
        addZone("TVT", "Tuvalu Time", 12);
        addZone("ULAST", "Ulaanbaatar Summer Time", 9);
        addZone("ULAT", "Ulaanbaatar Standard Time", 8);
        addZone("UTC", "Coordinated Universal Time", 0);
        addZone("UYST", "Uruguay Summer Time", -2);
        addZone("UYT", "Uruguay Standard Time", -3);
        addZone("UZT", "Uzbekistan Time", 5);
        addZone("VET", "Venezuelan Standard Time", -4);
        addZone("VLAT", "Vladivostok Time", 10);
        addZone("VOLT", "Volgograd Time", 3);
        addZone("VOST", "Vostok Station Time", 6);
        addZone("VUT", "Vanuatu Time", 11);
        addZone("WAKT", "Wake Island Time", 12);
        addZone("WAST", "West Africa Summer Time", 2);
        addZone("WAT", "West Africa Time", 1);
        addZone("WEST", "Western European Summer Time", 1);
        addZone("WET", "Western European Time", 0);
        addZone("WGST", "West Greenland Summer Time", -2);
        addZone("WGT", "West Greenland Time", -3);
        addZone("WIB", "Western Indonesian Time", 7);
        addZone("WIT", "Eastern Indonesian Time", 9);
        addZone("WITA", "Central Indonesia Time", 8);
        addZone("WST", "Western Standard Time", 8);
        addZone("YAKT", "Yakutsk Time", 9);
        addZone("YEKT", "Yekaterinburg Time", 5);
    }
    void addZone(string &in code, string &in name, float offset){
        tZone@ zone = tZone(code, name, offset);
        timeZones.InsertLast(zone);
    }

    tZone GetZone(const string &in name){
        for (uint i = 0; i < timeZones.Length; i++){
            if (timeZones[i].code == name.ToUpper().Trim()){
                return timeZones[i];
            }
        }
        return tZone();
    }
    array<tZone> getZones(){
        return timeZones;
    }
}
tZones zones = tZones();

string TimeCommand(int type, const string &in _msg){
    string msg = _msg;
    string t;
    string extra;
    if (type == CommandTypes::TimeCommand::LOCAL) {
        t = Time::FormatString("%H:%M:%S", Time::Stamp) + "$>";
        extra = " for me. $bbb(local time)";
    } else if (type == CommandTypes::TimeCommand::UTC) {
        t = Time::FormatStringUTC("%H:%M:%S", Time::Stamp) + "$>";
        extra = " in $2F5UTC.";
    } else if (type == CommandTypes::TimeCommand::TIMEZONE){
        msg = msg.Replace("/timezone ", "").Trim();
        tZone zone = zones.GetZone(msg);
        if (zone.code == ""){
            print("Unknown timezone: " + msg);
            return "";
        }
        t = zone.GetOffsetString();
        extra = "";
    }
    return "$<$db0" + Icons::ClockO + "$> It's $<$BBB" + t + extra;
}

string FormattedTimeCommand(int type, const string &in _msg){
    string msg = _msg;
    string t;
    string extra;
    if (type == CommandTypes::TimeCommand::LOCAL) {
        t = "00:00:00$>";
        extra = " for me. $bbb(local time)";
    } else if (type == CommandTypes::TimeCommand::UTC) {
        t = "00:00:00$>";
        extra = " in $2F5UTC.";
    } else if (type == CommandTypes::TimeCommand::TIMEZONE){
        msg = msg.Replace("/timezone ", "").Trim();
        tZone zone = zones.GetZone(msg);
        if (zone.code == ""){
            print("Unknown timezone: " + msg);
            return "";
        }
        t = zone.GetOffsetFormattedString();
        extra = "";
    }
    return "$<$db0" + Icons::ClockO + "$> It's $<$BBB" + t + extra;
}