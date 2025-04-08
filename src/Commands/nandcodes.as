class NadeoCode{
    string code;
    string name;
    string description;

    NadeoCode(){}

    NadeoCode(const string &in code, const string &in name, const string &in description){
        this.code = code;
        this.name = name;
        this.description = description;
    }

    string GetCode(){
        return code;
    }

    string GetName(){
        return name;
    }

    string GetDescription(){
        return description;
    }
}
class NadeoCodes{
    array<NadeoCode@> codes;

    NadeoCodes(){
        addNadeoCode("$o", "Bold.", "$oTrackmania becomes \\$oTrackmania\\$z");
        addNadeoCode("$i", "Italic.", "$iTrackmania becomes \\$iTrackmania\\$z");
        addNadeoCode("$w", "Wide text.", "$wTrackmania becomes \\$wTrackmania\\$z");
        addNadeoCode("$n", "Narrow Text", "$nTrackmania becomes \\$nTrackmania\\$z");
        addNadeoCode("$m", "Resets text width.", "$wTrackmania$m2020 becomes \\$wTrackmania\\$m2020\\$z");
        addNadeoCode("$t", "Force uppercase.", "$tTrackmania becomes \\$tTrackmania\\$z");
        addNadeoCode("$s", "Drop shadow.", "$sTrackmania becomes \\$sTrackmania\\$z");
        addNadeoCode("$L", "Clickable link.", "$lhttps://trackmania.com/ would become https://trackmania.com/ and $l[https://trackmania.com/]Trackmania would become Trackmania\\$z");
        addNadeoCode("$RGB", "Color text.", "$F00Red $0F0Green $00FBlue becomes \\$F00Red \\$0F0Green \\$00FBlue\\$z (see below for breakdown)");
        addNadeoCode("$g", "Reset color to default.", "$f00Hello$g Trackmania! becomes \\$f00Hello\\$g Trackmania!\\$z");
        addNadeoCode("$z", "Reset all styling to default.", "$o$0ffHello$z Trackmania! becomes \\$o\\$0ffHello\\$z Trackmania!\\$z");
        addNadeoCode("$$", "Escape the $ symbol.", "Give me some $$ becomes Give me some $");
    }

    void addNadeoCode(const string &in code, const string &in name, const string &in description){
        NadeoCode newCode = NadeoCode(code, name, description);
        codes.InsertLast(newCode);
    }

    array<NadeoCode@> getNadeoCodes(){
        return codes;
    }
}

NadeoCodes codes = NadeoCodes();