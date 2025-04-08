class MacroButton: Settings
{
    uint64 lastPressedTime = 0;

    bool is_hovered;
    vec4 default_c_bg  = vec4(000.0/255.0, 155.0/255.0, 095.0/255.0, 255.0/255.0);
    vec4 default_c_fg  = vec4(110.0/255.0, 250.0/255.0, 160.0/255.0, 255.0/255.0);
    vec4 default_c_bgh = vec4(000.0/255.0, 095.0/255.0, 070.0/255.0, 255.0/255.0);
    vec4 default_c_fgh = vec4(255.0/255.0, 255.0/255.0, 255.0/255.0, 255.0/255.0);
    float pad_x = 0.01; // Padding for the button
    float pad_x_max = 5.0; //px
    float pad_y = 0.2; // Padding for the button
    float pad_y_max = 6.0; //px

    MacroButton()
    {        
        this.SetPosX(0);
        this.SetPosY(0);
        this.SetSizeW(75);
        this.SetSizeH(25);
        this.SetMacroText("");
        this.SetLabelText("Sample");
        this.SetFontSize(14.0);
        this.SetColorBg(this.default_c_bg);
        this.SetColorFg(this.default_c_fg);
        this.SetColorBgHover(this.default_c_bgh);
        this.SetColorFgHover(this.default_c_fgh);
    }

    void SetPosX(float pos_x)
    {
        this.pos_x = pos_x;
    }

    void AdjPosX(float pos_x)
    {
        int window_width = Draw::GetWidth();
        if (this.pos_x + pos_x + this.size_w > window_width) {
            // Figure out how much we can move the button to the edge of the screen
            float max_possible_move = window_width - this.size_w;
            float diff = pos_x + this.pos_x - max_possible_move;
            pos_x -= diff;
        }
        if (this.pos_x + pos_x < 0) {
            // Figure out how much we can move the button to the edge of the screen
            float max_possible_move = 0;
            float diff = pos_x + this.pos_x - max_possible_move;
            pos_x -= diff;
        }
        if (pos_x < 0.01 && pos_x > -0.01) {
            pos_x = 0;
        }

        this.pos_x += pos_x;
    }
    
    float GetPosX()
    {
        return pos_x;
    }

    void SetPosY(float pos_y)
    {
        this.pos_y = pos_y;
    }

    float GetPosY()
    {
        return pos_y;
    }

    void SetPos(float x, float y)
    {
        this.pos_x = x;
        this.pos_y = y;
    }

    void SetPos(vec2 pos)
    {
        this.pos_x = pos.x;
        this.pos_y = pos.y;
    }

    bool IsOverlapping(MacroButton@ button)
    {
        if (this.pos_x < button.GetPosX() + button.GetSizeW() && this.pos_x + this.size_w > button.GetPosX() && this.pos_y < button.GetPosY() + button.GetSizeH() && this.pos_y + this.size_h > button.GetPosY()) {
            return true;
        }
        return false;
    }

    void AdjPosY(float pos_y)
    {
        int window_height = Draw::GetHeight();
        if (this.pos_y + pos_y + this.size_h > window_height) {
            // Figure out how much we can move the button to the edge of the screen
            float max_possible_move = window_height - this.size_h;
            float diff = pos_y + this.pos_y - max_possible_move;
            pos_y -= diff;
        }
        if (this.pos_y + pos_y < 0) {
            // Figure out how much we can move the button to the edge of the screen
            float diff = pos_y + this.pos_y;
            pos_y -= diff;
        }
        if (pos_y < 0.01 && pos_y > -0.01) {
            pos_y = 0;
        }

        this.pos_y += pos_y;
    }

    void SetSizeW(float size_w)
    {
        this.size_w = size_w;
    }

    float GetSizeW()
    {
        return size_w;
    }

    void SetSizeH(float size_h)
    {
        this.size_h = size_h;
    }

    float GetSizeH()
    {
        return size_h;
    }
    
    void SetMacroText(const string &in macro_text)
    {
        this.macro_text = macro_text;
    }

    string GetMacroText()
    {
        return macro_text;
    }

    void SetLabelText(const string &in label_text)
    {
        this.label_text = label_text;
        this.UpdateButtonSize();
    }

    string GetLabelText()
    {
        return label_text;
    }

    void SetColorBg(vec4 color_bg)
    {
        this.color_bg = color_bg;
    }
    
    vec4 GetWindowBg()
    {
        return vec4(0,0,0,0);
    }

    vec4 GetColorBg()
    {
        return color_bg;
    }

    void SetColorFg(vec4 color_fg)
    {
        this.color_fg = color_fg;
    }

    vec4 GetColorFg()
    {
        return color_fg;
    }

    void SetColorBgHover(vec4 color_bg_hover)
    {
        this.color_bg_hover = color_bg_hover;
    }

    vec4 GetColorBgHover()
    {
        return color_bg_hover;
    }

    void SetColorFgHover(vec4 color_fg_hover)
    {
        this.color_fg_hover = color_fg_hover;
    }

    vec4 GetColorFgHover()
    {
        return color_fg_hover;
    }    

    void SetFontSize(float font_size)
    {
        this.label_text_size = font_size;
        // Check if the new font size is bigger than the box
        this.UpdateButtonSize();
    }

    float GetFontSize()
    {
        return label_text_size;
    }

    vec2 GetButtonSize()
    {
        return vec2(this.size_w, this.size_h);
    }

    vec2 GetTextSize()
    {
        nvg::FontSize(this.label_text_size);
        nvg::TextAlign(18);
        nvg::FontFace(3);
        vec2 textSize = nvg::TextBounds(this.label_text);
        
        float pad_height = this.GetPadHeight();
        float pad_width = this.GetPadWidth();

        textSize.x += pad_width * 2;
        textSize.y += pad_height * 2;
        return textSize;
    }

    float GetPadWidth()
    {
        return this.pad_x_max;
        /*
        float pad_width = this.size_w * this.pad_x;
        if (pad_width > this.pad_x_max) {
            pad_width = this.pad_x_max;
        }
        return pad_width;
        */
    }

    float GetPadHeight()
    {
        return this.pad_y_max;
        /*
        float pad_height = this.size_h * this.pad_y;
        if (pad_height > this.pad_y_max) {
            pad_height = this.pad_y_max;
        }
        return pad_height;
        */
    }

    float GetSizeHPadded()
    {
        float pad_height = this.GetPadHeight();
        return this.size_h + pad_height * 2;
    }

    float GetSizeWPadded()
    {
        float pad_width = this.GetPadWidth();
        return this.size_w + pad_width * 2;
    }

    void UpdateButtonSize(){        
        nvg::FontSize(this.label_text_size);
        nvg::TextAlign(18);
        nvg::FontFace(3);
        vec2 textSize = nvg::TextBounds(this.label_text);
        vec2 boxSize = vec2(this.size_w, this.size_h);

        float pad_height = this.GetPadHeight();
        float pad_width = this.GetPadWidth();

        if (textSize.x + pad_width * 2 > boxSize.x) {
            this.size_w = textSize.x + pad_width * 2;
        }
        if (textSize.y + pad_height * 2 > boxSize.y) {
            this.size_h = textSize.y + pad_height * 2;
        }
        if (this.pos_x + this.size_w > window_size.x) {
            this.pos_x = window_size.x - this.size_w;
        }

        if (this.pos_x < 0) {
            this.pos_x = 0;
        }
        if (this.pos_y + this.size_h > window_size.y) {
            this.pos_y = window_size.y - this.size_h;
        }
        if (this.pos_y < 0) {
            this.pos_y = 0;
        }
    }

    bool IsMouseOver(float mouse_x, float mouse_y)
    {
        if (mouse_x > this.pos_x && mouse_x < this.pos_x + this.size_w && mouse_y > this.pos_y && mouse_y < this.pos_y + this.size_h) {
            return true;
        }
        return false;
    }

    void SetEditing(bool is_editing)
    {
        this.is_editing = is_editing;
    }

    void SetHover(bool is_hovered)
    {
        this.is_hovered = is_hovered;
    }

    bool IsHovered()
    {
        return this.is_hovered;
    }

    bool GetHovered()
    {
        return this.is_hovered;
    }
    

    string To_String()
    {
        // Convert the object to a Json string
        string json = "{";
        json += "\"x\": " + this.pos_x + ",";
        json += "\"y\": " + this.pos_y + ",";
        json += "\"w\": " + this.size_w + ",";
        json += "\"h\": " + this.size_h + ",";
        json += "\"l\": \"" + this.label_text + "\",";
        json += "\"m\": \"" + this.macro_text + "\",";
        json += "\"ls\": " + this.label_text_size + ",";
        json += "\"bg\": [" + this.color_bg.x + "," + this.color_bg.y + "," + this.color_bg.z + "," + this.color_bg.w + "],";
        json += "\"fg\": [" + this.color_fg.x + "," + this.color_fg.y + "," + this.color_fg.z + "," + this.color_fg.w + "],";
        json += "\"bg_h\": [" + this.color_bg_hover.x + "," + this.color_bg_hover.y + "," + this.color_bg_hover.z + "," + this.color_bg_hover.w + "],";
        json += "\"fg_h\": [" + this.color_fg_hover.x + "," + this.color_fg_hover.y + "," + this.color_fg_hover.z + "," + this.color_fg_hover.w + "]";
        json += "}";
        return json;
    }

    Json::Value@ To_Json()
    {
        // Convert the object to a Json object
        Json::Value@ data = Json::Object();
        data["x"] = this.pos_x;
        data["y"] = this.pos_y;
        data["w"] = this.size_w;
        data["h"] = this.size_h;
        data["l"] = this.label_text;
        data["m"] = this.macro_text;
        data["ls"] = this.label_text_size;
        Json::Value@ d = Json::Object();
        d["x"] = this.color_bg.x;
        d["y"] = this.color_bg.y;
        d["z"] = this.color_bg.z;
        d["w"] = this.color_bg.w;
        data["bg"] = d;
        d["x"] = this.color_fg.x;
        d["y"] = this.color_fg.y;
        d["z"] = this.color_fg.z;
        d["w"] = this.color_fg.w;
        data["fg"] = d;
        d["x"] = this.color_bg_hover.x;
        d["y"] = this.color_bg_hover.y;
        d["z"] = this.color_bg_hover.z;
        d["w"] = this.color_bg_hover.w;
        data["bg_h"] = d;
        d["x"] = this.color_fg_hover.x;
        d["y"] = this.color_fg_hover.y;
        d["z"] = this.color_fg_hover.z;
        d["w"] = this.color_fg_hover.w;
        data["fg_h"] = d;
        return data;
    }

    void From_String(string json)
    {
        // Convert the Json string to the object
        Json::Value data = Json::Parse(json);        
        this.From_Json(data);
    }

    void From_Json(Json::Value@ data){
        print("Loading Button From_Json: " + Json::Write(data));
        this.pos_x = data["x"];
        this.pos_y = data["y"];
        this.size_w = data["w"];
        this.size_h = data["h"];
        this.label_text = data["l"];
        this.macro_text = data["m"];
        this.label_text_size = data["ls"];
        float x;
        float y;
        float z;
        float w;
        Json::Value d;

        d = data.Get("bg");
        x = d["x"];
        y = d["y"];
        z = d["z"];
        w = d["w"];
        this.color_bg = vec4(x,y,z,w);

        d = data["fg"];
        print(Json::Write(d));
        x = d["x"];
        y = d["y"];
        z = d["z"];
        w = d["w"];
        this.color_fg = vec4(x,y,z,w);

        d = data["bg_h"];
        x = d["x"];
        y = d["y"];
        z = d["z"];
        w = d["w"];       
        this.color_bg_hover = vec4(x,y,z,w);
        
        d = data["fg_h"];
        x = d["x"];
        y = d["y"];
        z = d["z"];
        w = d["w"];
        this.color_fg_hover = vec4(x,y,z,w);
        this.UpdateButtonSize();
    }

    void Render()
    {
        // Handle UI settings
        bool can_click = this.checkIfButtonCanPressed();
        float border_opacity = 0.1;

        vec4 bg_color = 
            can_click 
                ? this.color_bg 
                : vec4(this.color_bg.x * 0.1, this.color_bg.y * 0.1, this.color_bg.z * 0.1, this.color_bg.w * 0.8);
        vec4 bg_border = 
            can_click 
                ? vec4(1 - this.color_bg.x, 1 - this.color_bg.y, 1 - this.color_bg.z, this.color_bg.w * border_opacity) 
                : vec4((1 - this.color_bg.x) * 0.1, (1 - this.color_bg.y) * 0.1, (1 - this.color_bg.z) * 0.1, this.color_bg.w * border_opacity);
        vec4 fg_color = 
            can_click 
                ? this.color_fg 
                : vec4(this.color_fg.x * 0.5, this.color_fg.y * 0.5, this.color_fg.z * 0.5, this.color_fg.w * 0.05);
        vec4 bgh_color = 
            can_click 
                ? this.color_bg_hover 
                : vec4(this.color_bg_hover.x * 0.1, this.color_bg_hover.y * 0.1, this.color_bg_hover.z * 0.1, this.color_bg_hover.w * 0.8);
        vec4 bgh_border = 
            can_click 
                ? vec4(1 - this.color_bg_hover.x, 1 - this.color_bg_hover.y, 1 - this.color_bg_hover.z, this.color_bg_hover.w * border_opacity) 
                : vec4((1 - this.color_bg_hover.x) * 0.1, (1 - this.color_bg_hover.y) * 0.1, (1 - this.color_bg_hover.z) * 0.1, this.color_bg_hover.w * border_opacity);
        vec4 fgh_color =
            can_click 
                ? this.color_fg_hover 
                : vec4(this.color_fg_hover.x * 0.5, this.color_fg_hover.y * 0.5, this.color_fg_hover.z * 0.5, this.color_fg_hover.w * 0.05);

        nvg::FontSize(this.label_text_size);
        nvg::TextAlign(18);
        nvg::FontFace(3);
        vec2 textSize = nvg::TextBounds(this.label_text);

        vec2 boxSize = vec2(this.size_w, this.size_h);

        // Button Background rectangle
        nvg::BeginPath(); 
        nvg::RoundedRect(this.pos_x, this.pos_y, boxSize.x, boxSize.y, 10);
        nvg::FillColor(this.is_hovered ? bgh_color : bg_color);            
        nvg::Fill();
        
        // Button Inner inset Border
        nvg::BeginPath();
        nvg::RoundedRect(this.pos_x + 2, this.pos_y + 2, boxSize.x - 4, boxSize.y - 4, 9);
        nvg::StrokeWidth(1);
        nvg::StrokeColor(this.is_hovered ? bgh_border : bg_border);
        nvg::Stroke();

        // Button Text
        nvg::BeginPath();
        nvg::FillColor(this.is_hovered ? fgh_color : fg_color);
        nvg::Text(this.pos_x + (boxSize.x/2), this.pos_y + (boxSize.y/2)+2, this.label_text);
        nvg::Stroke();
    }

    void HandleMouseClick(int button)
    {
        if (button == 0) { // Left click
            this.OnClick();
        } else if (button == 1) { // Right click
            this.OnRightClick();
        }
    }

    void OnClick()
    {
        if (this.checkIfButtonCanPressed()) {
            print("lastTime: " + this.lastPressedTime);
            this.lastPressedTime = Time::get_Now();
            this.SendMacro();
            print("Button clicked: " + this.label_text + " at " + this.lastPressedTime);
        } else {
            print("Button is on cooldown.");
        }
    }

    void OnRightClick()
    {
        // Handle right click event
        print("Right click on button: " + this.label_text);
        // Drag position of button
    }

    bool checkIfButtonCanPressed()
    {
        if (this.lastPressedTime == 0 || (Time::get_Now() - this.lastPressedTime) > 10000) {            
            return true;
        }
        return false;
    }

    void SendMacro()
    {
        CSmArenaClient@ playground = cast<CSmArenaClient>(cast<CTrackMania>(GetApp()).CurrentPlayground);
        if (playground is null) {
            print("Playground is null");
            return;
        }
        CGamePlaygroundInterface@ playgroundInterface = cast<CGamePlaygroundInterface>(playground.Interface);
        if (playgroundInterface is null) {
            print("PlaygroundInterface is null");
            return;
        }
        string msg = global_commands.ParseCommand(this.macro_text);
        if (msg == "") {
            print("Macro is empty");
            return;
        }
        playgroundInterface.ChatEntry = msg;
        print("Macro sent:\n" + msg);
    }
}