[Setting name="Button Storage" hidden]
string button_dictionary = "[]";


namespace UI_Settings{
    int current_editting_button = -1;
    float current_button_x = 0;
    float current_button_y = 0;
    float current_button_w = 0;
    float current_button_h = 0;
    string current_button_label_text = "";
    string current_button_macro_text = "";
    float current_button_label_text_size = 0.0;
    vec4 current_button_color_bg = vec4(0.0, 1.0, 0.0, 1.0);
    vec4 current_button_color_fg = vec4(1.0, 0.0, 0.0, 1.0);
    vec4 current_button_color_bg_hover = vec4(1.0, 0.0, 0.0, 1.0);
    vec4 current_button_color_fg_hover = vec4(0.0, 0.0, 0.0, 1.0);   

    bool is_button_settings_open = false; 
    UI::Font@ bold = UI::LoadFont("DroidSans-Bold.ttf", 16.f);
    
    int color_picker_r_value = 8; // Start with middle values
    int color_picker_g_value = 8;
    int color_picker_b_value = 8;

    array<string> keys = colors.GetColorCharacters();

    void SettingsRenderButtons(){
        CSmArenaClient@ playground = cast<CSmArenaClient>(cast<CTrackMania>(GetApp()).CurrentPlayground);
        if (playground is null) {
            buttons.RenderButtons(); // Render buttons
        }
    }

    [SettingsTab name="Button Settings" icon="Th" category="Button Settings" order="0"]
    void RenderButtonSettings()
    {   
        SettingsRenderButtons();
        int color_width = 300; // Width of the color picker
        int input_width = 200; // Width of the input box

        is_button_settings_open = true;
        // Get the window size
        window_size.x = Draw::GetWidth();
        window_size.y = Draw::GetHeight();        

        bool have_buttons = true;
        if (buttons.Length == 0) {
            have_buttons = false;
        }

        MacroButton curButton; // Initialize curButton to null

        if (have_buttons) {
            if (current_editting_button < 0) {            
                current_editting_button = 0;                
            }
            if (buttons.dragging_index >= 0) {
                current_editting_button = buttons.dragging_index;
            }
            if (buttons.last_clicked_index >= 0) {
                current_editting_button = buttons.last_clicked_index;
                buttons.last_clicked_index = -1; // Reset last clicked index
            }
            curButton = buttons.getButton(current_editting_button);
        }

        // Highlight the selected button with a green border
        if (have_buttons) {            
            nvg::BeginPath();
            nvg::StrokeWidth(5);
            nvg::StrokeColor(vec4(0.0, 1.0, 0.0, 1.0));
            nvg::RoundedRect(curButton.GetPosX() - 5, curButton.GetPosY() - 5, curButton.GetSizeW() + 10, curButton.GetSizeH() + 10, 10.0);                        
            nvg::Stroke();
        } 

        //Button settings group
        UI::BeginGroup();
        if (UI::BeginTable("Button Settings", 5, UI::TableFlags::SizingStretchProp))
        {
            UI::BeginDisabled(buttons.Length == 0);
            // Add the labels for each setting
            UI::TableNextColumn();

            UI::AlignTextToFramePadding();
            UI::Text("Position X:");
            UI::SetItemTooltip("Left/Right position of the top left corner of the button");
            
            UI::AlignTextToFramePadding();
            UI::Text("Position Y:");
            UI::SetItemTooltip("Up/Down position of the top left corner of the button");

            UI::AlignTextToFramePadding();
            UI::Text("Width:");
            UI::SetItemTooltip("Width of the button");

            UI::AlignTextToFramePadding();
            UI::Text("Height:");
            UI::SetItemTooltip("Height of the button");

            UI::AlignTextToFramePadding();
            UI::Text("Font Size:     ");
            UI::SetItemTooltip("Size of the label text displayed on the button");

            
            UI::TableNextColumn();
            // Add buttons to adjust each setting by 1
            if (UI::Button(Icons::Kenney::StepBackward+"##pos_x_back")) {
                buttons.getButton(current_editting_button).SetPosX(current_button_x-1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Decrease the x position by 1");
            if (UI::Button(Icons::Kenney::StepBackward+"##pos_y_back")) {
                buttons.getButton(current_editting_button).SetPosY(current_button_y-1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Decrease the y position by 1");
            if (UI::Button(Icons::Kenney::StepBackward+"##size_w_back")) {
                buttons.getButton(current_editting_button).SetSizeW(current_button_w-1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Decrease the width by 1");
            if (UI::Button(Icons::Kenney::StepBackward+"##size_h_back")) {
                buttons.getButton(current_editting_button).SetSizeH(current_button_h-1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Decrease the height by 1");
            if (UI::Button(Icons::Kenney::StepBackward+"##label_text_size_back")) {
                buttons.getButton(current_editting_button).SetFontSize(current_button_label_text_size-1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Decrease the font by 1");            

            // Add the input fields for each setting in the first column
            UI::TableNextColumn();
            
            UI::SetNextItemWidth(input_width);
            current_button_x = UI::SliderFloat("##pos_x_", have_buttons ? curButton.GetPosX() : 0, 0, have_buttons ? window_size.x - curButton.GetSizeW() : 0, "%.0f");
            UI::SetItemTooltip("Left/Right position of the top left corner of the button");

            UI::SetNextItemWidth(input_width);
            current_button_y = UI::SliderFloat("##pos_y_", have_buttons ? curButton.GetPosY() : 0, 0, have_buttons ? window_size.y - curButton.GetSizeH() : 0, "%.0f");
            UI::SetItemTooltip("Up/Down position of the top left corner of the button");
            
            UI::SetNextItemWidth(input_width);
            current_button_w = UI::SliderFloat(
                "##size_w_"
                , have_buttons ? curButton.GetSizeW() : 0
                , have_buttons ? curButton.GetTextSize().x : 0
                , have_buttons ? window_size.x - curButton.GetPosX() : 0
                , "%.0f");
            UI::SetItemTooltip("Width of the button");

            UI::SetNextItemWidth(input_width);
            current_button_h = UI::SliderFloat(
                "##size_h_"
                , have_buttons ? curButton.GetSizeH() : 0
                , have_buttons ? curButton.GetTextSize().y : 0
                , have_buttons ? window_size.y - curButton.GetPosY() : 0
                , "%.0f");
            UI::SetItemTooltip("Height of the button");

            UI::SetNextItemWidth(input_width);
            current_button_label_text_size = UI::SliderFloat(
                "##label_text_size_"
                , have_buttons ? curButton.GetFontSize() : 0
                , have_buttons ? 9.0 : 0
                , have_buttons ? 200.0 : 0
                , "%.0f");
            UI::SetItemTooltip("Font Size of the text displayed on the button");

            UI::TableNextColumn();
            // Add buttons to adjust each setting by 1
            if (UI::Button(Icons::Kenney::StepForward+"##pos_x_back")) {
                buttons.getButton(current_editting_button).SetPosX(current_button_x+1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Increase the x position by 1");
            if (UI::Button(Icons::Kenney::StepForward+"##pos_y_back")) {
                buttons.getButton(current_editting_button).SetPosY(current_button_y+1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Increase the y position by 1");
            if (UI::Button(Icons::Kenney::StepForward+"##size_w_back")) {
                buttons.getButton(current_editting_button).SetSizeW(current_button_w+1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Increase the width by 1");
            if (UI::Button(Icons::Kenney::StepForward+"##size_h_back")) {
                buttons.getButton(current_editting_button).SetSizeH(current_button_h+1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Increase the height by 1");
            if (UI::Button(Icons::Kenney::StepForward+"##label_text_size_back")) {
                buttons.getButton(current_editting_button).SetFontSize(current_button_label_text_size+1);
                buttons.SaveButtons();
            }
            UI::SetItemTooltip("Increase the font by 1");  
            // Add the input fields for each setting in the third column
            UI::TableNextColumn();


            UI::SetNextItemWidth(color_width);
            current_button_color_bg = UI::InputColor4(" : Background Color", have_buttons ? curButton.GetColorBg() : vec4(0.0, 0.0, 0.0, 1.0));
            UI::SetItemTooltip("Background color of the button");

            UI::SetNextItemWidth(color_width);
            current_button_color_fg = UI::InputColor4(" : Text Color", have_buttons ? curButton.GetColorFg() : vec4(0.0, 0.0, 0.0, 1.0));
            UI::SetItemTooltip("Text color of the button");
            
            UI::SetNextItemWidth(color_width);
            current_button_color_bg_hover = UI::InputColor4(" : Background Color Hover", have_buttons ? curButton.GetColorBgHover() : vec4(0.0, 0.0, 0.0, 1.0));
            UI::SetItemTooltip("Background color of the button when hovered");

            UI::SetNextItemWidth(color_width);
            current_button_color_fg_hover = UI::InputColor4(" : Text Color Hover", have_buttons ? curButton.GetColorFgHover() : vec4(0.0, 0.0, 0.0, 1.0));
            UI::SetItemTooltip("Text color of the button when hovered");

            UI::EndDisabled();
            
            UI::EndTable();
        }        
        UI::EndGroup();
        UI::Separator();

        if (UI::BeginTable("Text Settings", 2, UI::TableFlags::SizingFixedFit))
        {
            UI::BeginDisabled(buttons.Length == 0);
            
            UI::TableNextColumn();
            UI::AlignTextToFramePadding();
            UI::Text("Label Text: ");
            UI::SetItemTooltip("Text displayed on the button");        
            
            UI::AlignTextToFramePadding();
            UI::Text("Macro Text: ");        
            UI::SetItemTooltip("See the 'Nadeo Chat Formats' tab for more information on text formatting.\nTo send a command, refrence the table below.");     

            UI::TableNextColumn();
            
            UI::SetNextItemWidth(480);
            current_button_label_text = UI::InputText("##label_text", have_buttons ? curButton.GetLabelText() : "Create a Button to edit");  
            UI::SetItemTooltip("Text displayed on the button");                                      
            
            UI::SetNextItemWidth(480);
            current_button_macro_text = UI::InputText("##macro_text", have_buttons ? curButton.GetMacroText() : "Please press the + button.");  
            UI::SetItemTooltip("See the 'Nadeo Chat Formats' tab for more information on text formatting.\nTo send a command, refrence the table below.");     
            
            UI::EndDisabled();
            UI::EndTable();
        }
            
        // Create the controls to cycle through the buttons
        // Should have: skip to first, skip previous, skip next, skip last
        // Have a inputbox for the current button index next to a label with text " / <number of buttons>"
        
        // Fill the space to center the buttons
        //UI::Dummy(vec2(250, 10));
        
        //UI::SameLine();

        if (UI::BeginTable("ButtonCycle", 8, UI::TableFlags::SizingFixedFit))
        {
        
            UI::TableNextColumn();
            PushButtonStyles();    
            UI::BeginDisabled(buttons.Length == 0);    
            UI::PushFont(bold);
            UI::PushStyleColor(UI::Col::Text, vec4(1.0, 0.0, 0.0, 1.0));        
            if (UI::Button(Icons::Kenney::Times)) {
                // Delete the current button
                if (current_editting_button >= 0 && current_editting_button < buttons.Length) {
                    // Delete the button
                    DeleteButton(current_editting_button);
                    current_editting_button--;
                    if (current_editting_button < 0 && buttons.Length > 0) {
                        current_editting_button = buttons.Length - 1;
                    }
                    buttons.SaveButtons();
                }
            }            
            UI::PopStyleColor();
            UI::PopFont();
            if (have_buttons) {
                UI::SetItemTooltip("Delete the current button");
            }
            
            UI::TableNextColumn();
            PushButtonStyles();
            if (UI::Button(Icons::Kenney::Backward)) {
                current_editting_button = 0;
            }    
            if (have_buttons) {
                UI::SetItemTooltip("Skip to the first button");
            }

            UI::TableNextColumn();
            PushButtonStyles();
            UI::PushFont(bold);
            if (UI::Button(Icons::Kenney::StepBackward)) {
                current_editting_button--;
                if (current_editting_button < 0) {
                    current_editting_button = buttons.Length - 1;
                }
            }
            UI::PopFont();
            if (have_buttons) {
                UI::SetItemTooltip("Skip to the previous button");
            }

            UI::TableNextColumn();
            UI::AlignTextToFramePadding();
            PushButtonStyles();
            UI::PushFont(bold);
            UI::Text(tostring(current_editting_button + 1));
            UI::SetItemTooltip("Current editing button index");
            UI::PopFont();

            UI::TableNextColumn();
            UI::AlignTextToFramePadding();
            PushButtonStyles();
            UI::PushFont(bold);
            UI::Text("/  " + buttons.Length);
            UI::PopFont();

            UI::TableNextColumn();
            PushButtonStyles();
            UI::PushFont(bold);
            if (UI::Button(Icons::Kenney::StepForward)) {
                current_editting_button++;
                if (current_editting_button >= buttons.Length) {
                    current_editting_button = 0;
                }
            }
            UI::PopFont();
            if (have_buttons) {
                UI::SetItemTooltip("Skip to the next button");
            }

            UI::TableNextColumn();
            PushButtonStyles();
            UI::PushFont(bold);
            if (UI::Button(Icons::Kenney::Forward)) {
                current_editting_button = buttons.Length - 1;
            }
            UI::PopFont();
            if (have_buttons) {
                UI::SetItemTooltip("Skip to the last button");
            }

            UI::EndDisabled();
            UI::TableNextColumn();
            PushButtonStyles();
            UI::PushFont(bold);
            UI::PushStyleColor(UI::Col::Text, vec4(0.0, 1.0, 0.0, 1.0));
            if (UI::Button(Icons::Kenney::Plus)) {
                // Create a new button
                CreateNewButton();
                current_editting_button = buttons.Length - 1;
                buttons.SaveButtons();
            }
            UI::PopStyleColor();
            UI::PopFont();
            UI::SetItemTooltip("Create a new button");
            
            UI::EndTable();
        }

        UI::SeparatorText("Available Commands");
        UI::TextWrapped("To use a command below, start a button macro with the text in the command column.\nExamples:");

        if (UI::BeginTable("Command Examples", 2, UI::TableFlags::SizingStretchProp))
        {
            UI::TableNextColumn();
            UI::TextWrapped("\\$888/at");
            UI::TableNextColumn();
            UI::TextWrapped("\\$888Send the map Author Time to the chat");
            UI::TableNextColumn();
            UI::TextWrapped("\\$888/time");
            UI::TableNextColumn();
            UI::TextWrapped("\\$888Send the current time to the chat");
            UI::TableNextColumn();
            UI::TextWrapped("\\$888/roll 100");
            UI::TableNextColumn();
            UI::TextWrapped("\\$888Send a random number between 1 and 100 to the chat");
            UI::EndTable();
        }

        array<Json::Value@> commands = global_commands.getCommands();
        if (UI::BeginTable("Command List", 2, UI::TableFlags::BordersInnerH))
        {
            UI::TableSetupColumn("Command", UI::TableColumnFlags::WidthFixed | UI::TableColumnFlags::NoSort | UI::TableColumnFlags::IndentEnable, 80.);
            UI::TableSetupColumn("Description");
            UI::TableHeadersRow();
            for (uint i = 0; i < commands.Length; i++)
            {
                UI::TableNextColumn();
                string command_name = commands[i].Get("name", "");
                UI::TextWrapped(command_name);
                UI::TableNextColumn();
                string command_description = commands[i].Get("description", "");            
                UI::TextWrapped(command_description);
            }
            UI::EndTable();
        }

        if (have_buttons){
            // Check if any of the settings have changed
            if (current_button_x != curButton.GetPosX()){
                buttons.getButton(current_editting_button).SetPosX(current_button_x);
                buttons.SaveButtons();
            } 
            if (current_button_y != curButton.GetPosY()){
                buttons.getButton(current_editting_button).SetPosY(current_button_y);
                buttons.SaveButtons();
            }
            if (current_button_w != curButton.GetSizeW()){
                buttons.getButton(current_editting_button).SetSizeW(current_button_w);
                buttons.SaveButtons();
            }
            if (current_button_h != curButton.GetSizeH()){
                buttons.getButton(current_editting_button).SetSizeH(current_button_h);
                buttons.SaveButtons();
            }
            if (current_button_label_text != curButton.GetLabelText()){
                buttons.getButton(current_editting_button).SetLabelText(current_button_label_text);
                buttons.SaveButtons();
            }
            if (current_button_macro_text != curButton.GetMacroText()){
                buttons.getButton(current_editting_button).SetMacroText(current_button_macro_text);
                buttons.SaveButtons();
            }
            if (current_button_label_text_size != curButton.GetFontSize()){
                buttons.getButton(current_editting_button).SetFontSize(current_button_label_text_size);
                buttons.SaveButtons();
            }
            if (current_button_color_bg != curButton.GetColorBg()){
                buttons.getButton(current_editting_button).SetColorBg(current_button_color_bg);
                buttons.SaveButtons();
            }
            if (current_button_color_fg != curButton.GetColorFg()){
                buttons.getButton(current_editting_button).SetColorFg(current_button_color_fg);
                buttons.SaveButtons();
            }
            if (current_button_color_bg_hover != curButton.GetColorBgHover()){
                buttons.getButton(current_editting_button).SetColorBgHover(current_button_color_bg_hover);
                buttons.SaveButtons();
            }
            if (current_button_color_fg_hover != curButton.GetColorFgHover()){
                buttons.getButton(current_editting_button).SetColorFgHover(current_button_color_fg_hover);
                buttons.SaveButtons();
            }                
        }
        is_button_settings_open = false;
    }

    void PushButtonStyles(){
        UI::SetNextItemWidth(50);        
    }

    
    [SettingsTab name="  Nadeo Chat Formats" icon="TrackmaniaT" category="Nadeo Chat Formats" order="1"]
    void RenderFormattingInfo()
    {
        SettingsRenderButtons();
        array<NadeoCode@> _codes = codes.getNadeoCodes();
        UI::BeginGroup();
        UI::TextWrapped(
            "All styling is represented in the form of of special control characters that determine the style of the succeeding text.\n"
            "For text formatting like bold or italic text, they have one control character, whereas colors have 3 (see below). Each control character must have a $ in before it.\n"
            "To give you a few examples, the control character o will format the text as bold and the control character i would format the text in italic. So you would write $o for \\$obold\\$z and $i for \\$iitalic\\$z and then the text to be formatted.\n"
            "\n"
            "Example:\n"
            "$oTrackmania would become \\$oTrackmania\\$z\n"
            "$iTrackmania would become \\$iTrackmania\\$z\n"
            "\n"
            "You can also combine them, so $o$iTrackmania would be bold and italic: \\$o\\$iTrackmania\\$z\n"
            "A more complex example of using them at multiple places in the text for different formatting at different places would be:\n"
            "$oThis$z is $o$iTrackmania! would become: \\$oThis\\$z is \\$o\\$iTrackmania!\\$z\n"
        );
        UI::SeparatorText("Font Formatting");
        if (UI::BeginTable("Font Formatting", 3, UI::TableFlags::BordersInnerH | UI::TableFlags::SizingStretchProp))
        {
            
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2.5, 0.));
            UI::TableSetupColumn("Code");
            UI::PopStyleVar();
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2.5, 0.));
            UI::TableSetupColumn("Formatting");
            UI::PopStyleVar();
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(5., 0.));
            UI::TableSetupColumn("Example");
            UI::PopStyleVar();

            UI::TableHeadersRow();
            for (uint i = 0; i < _codes.Length; i++)
            {
                UI::TableNextColumn();
                string command_name = _codes[i].GetCode();
                UI::TextWrapped(command_name);
                UI::TableNextColumn();
                string command_description =  _codes[i].GetName();            
                UI::TextWrapped(command_description);
                UI::TableNextColumn();
                string command_offset = _codes[i].GetDescription();
                UI::TextWrapped(command_offset);
            }
            UI::EndTable();
        }
        UI::SeparatorText("Nadeo Color Codes");
        UI::TextWrapped(
            "If you have never heard about the hexadecimal number system (hex for short), you may be wondering what on earth Im talking about.\nYou are normally used to the decimal number system, where each digit is from 0 to 9 and any other number is a compound of these digits.\nBut in hexadecimal you have 15 digits instead of 10. In hex each digit is from 0 to F (0123456789ABCDEF) with F representing 15.\n"
            "\n"
            "In Trackmania each color is represented by three hexadecimal digits RGB with R being the \\$F00red\\$z channel, G is the \\$0F0green\\$z channel and B is the \\$00Fblue\\$z channel.\nSo the hexadecimal digit would then represent the strength of its color channel.\n"
            "\n"
            "For example, in the color code F00, \\$F00Red\\$z would be strength F (15) and \\$0F0green\\$z and \\$00Fblue\\$z would be 0. This would be a perfect \\$F00red\\$z color.\nBut in the color code 0F0 \\$F00red\\$z would be 0, and \\$0F0green\\$z would be F(15) and \\$00Fblue\\$z 0. This would be a perfect \\$0F0green\\$z.\n"
            "Another example would be FF0, here we have a perfect \\$F00red\\$z and a perfect \\$0F0green\\$z combined. Mixing these two colors, \\$F00red\\$z and \\$0F0green\\$z, would become \\$FF0yellow\\$z.\nYou can also reduce the strength of the channels, for example 660 would become a \\$660dark green\\$z color.\n"
        );
        UI::SeparatorText("Color Picker");

        UI::TextWrapped("Adjust sliders to select a color. Click on the preview to copy the color code.");
        if (UI::BeginTable("Color Sliders Holder", 2))// | UI::TableFlags::SizingStretchProp))
        {
            UI::TableSetupColumn("a", UI::TableColumnFlags::WidthFixed | UI::TableColumnFlags::NoSort, 250.);
            UI::TableSetupColumn("b", UI::TableColumnFlags::WidthFixed | UI::TableColumnFlags::NoSort, 600.);
            UI::TableNextColumn();

            // Preview color
            string code = "$" + colors.color_characters[color_picker_r_value] + colors.color_characters[color_picker_g_value] + colors.color_characters[color_picker_b_value];
            vec4 color = vec4(float(color_picker_r_value)/15., float(color_picker_g_value)/15., float(color_picker_b_value)/15., 1.);
            vec4 font_color = color_picker_r_value + color_picker_g_value + color_picker_b_value > 22 ? vec4(0,0,0,1) : vec4(1,1,1,1); // Dynamic text color for contrast

            UI::PushStyleColor(UI::Col::Button, color);
            UI::PushStyleColor(UI::Col::ButtonHovered, color);
            UI::PushStyleColor(UI::Col::ButtonActive, color);
            UI::PushStyleColor(UI::Col::Text, font_color);

            if(UI::Button(code + "##preview", vec2(250, 80))) {
                IO::SetClipboard(code);
            }
            UI::PopStyleColor(4);
            UI::SetItemTooltip("Click to copy the color code: " + code);

            UI::TableNextColumn();
            if (UI::BeginTable("Color Sliders", 2, UI::TableFlags::SizingStretchProp))// | UI::TableFlags::SizingStretchProp))
            {
                UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2., 0.));
                UI::TableSetupColumn("text");
                UI::PopStyleVar();
                UI::TableSetupColumn("code");

                UI::TableNextColumn();
                UI::AlignTextToFramePadding();
                UI::Text("R: " + keys[color_picker_r_value]);
                UI::TableNextColumn();
                color_picker_r_value = UI::SliderInt("##Red", color_picker_r_value, 0, 15);
                
                UI::TableNextColumn();
                UI::AlignTextToFramePadding();
                UI::Text("G: " + keys[color_picker_g_value]);
                UI::TableNextColumn();
                color_picker_g_value = UI::SliderInt("##Green", color_picker_g_value, 0, 15);

                UI::TableNextColumn();
                UI::AlignTextToFramePadding();
                UI::Text("B: " + keys[color_picker_b_value]);
                UI::TableNextColumn();
                color_picker_b_value = UI::SliderInt("##Blue", color_picker_b_value, 0, 15);

                UI::EndTable();
            }
            
            UI::EndTable();
        }

        UI::NewLine();
        UI::TextWrapped("You can also click on a color below to copy the color code to use in a button macro output.");
        if (UI::BeginTable("Color Picker", 16, UI::TableFlags::BordersInner | UI::TableFlags::SizingFixedFit))// | UI::TableFlags::SizingStretchProp))
        {
            for(uint y = 0; y < colors.GetGridHeight(); y++){
                for(uint x = 0; x < colors.GetGridWidth(); x++){
                    UI::TableNextColumn();
                    string code = colors.GetColorCode(x, y);
                    if (code != "-1"){
                        vec4 color = colors.GetColor(x, y);
                        vec4 font_color = colors.GetFontColor(x, y);
                        UI::PushStyleColor(UI::Col::Button, color);
                        UI::PushStyleColor(UI::Col::ButtonHovered, color);
                        UI::PushStyleColor(UI::Col::ButtonActive, color);
                        UI::PushStyleColor(UI::Col::Text, font_color);
                        if (UI::Button(code)) {
                            // Copy the color code to the clipboard
                            IO::SetClipboard(code);
                        }
                        UI::PopStyleColor(4);
                    }                    
                }
            }
            UI::EndTable();
        }


        UI::EndGroup();
    }
    
    [SettingsTab name="Icon List" icon="QuestionCircleO" category="Icon List" order="2"]
    void RenderIconInfo()
    {
        SettingsRenderButtons();
        UI::TextWrapped(
            "You can use the icons below in your button macros and labels.\n To use them, just click the icon button below and paste it into your macro text.\n"
            "\n"
            "You can also use the icons in combination with other formatting codes.\n"
            "\\$888(EXPAND SETTINGS WINDOW TO SEE THE ICONS)\n"
        );
        UI::BeginGroup();
        if (UI::BeginTable("Icon List", 18, UI::TableFlags::BordersInner))
        {
            for (uint i = 0; i < icons.ascii_icons.Length; i++)
            {
                UI::TableNextColumn();
                if (UI::Button(icons.ascii_icons[i] + "##" + i, vec2(35, 35)))
                {
                    // Copy the icon to the clipboard
                    IO::SetClipboard(icons.ascii_icons[i]);
                }
                UI::SetItemTooltip("Click to copy the icon: " + icons.ascii_icons[i]);
            }
            UI::EndTable();
        }
        UI::EndGroup();
    }

    [SettingsTab name="Time Zones" icon="ClockO" category="Time Zones" order="3"]
    void RenderTimeZoneInfo()
    {
        SettingsRenderButtons();
        array<tZone> _zones = zones.getZones();
        UI::BeginGroup();
        UI::Text("You can send the time in any time zone by using the command /timezone <zone>");
        UI::Text("Examples: /timezone GMT    |    /timezone EST    |    /timezone NZDT");
        UI::Separator();
        UI::Text("Available Time Zones:");
        if (UI::BeginTable("Time Zones", 3, UI::TableFlags::BordersInnerH | UI::TableFlags::SizingStretchProp))
        {
            
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2.5, 0.));
            UI::TableSetupColumn("Zone");
            UI::PopStyleVar();
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(5.0, 0.));
            UI::TableSetupColumn("Name");
            UI::PopStyleVar();
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2.5, 0.));
            UI::TableSetupColumn("Offset");
            UI::PopStyleVar();

            UI::TableHeadersRow();
            for (uint i = 0; i < _zones.Length; i++)
            {
                UI::TableNextColumn();
                string command_name = _zones[i].GetCode();
                UI::TextWrapped(command_name);
                UI::TableNextColumn();
                string command_description =  _zones[i].GetName();            
                UI::TextWrapped(command_description);
                UI::TableNextColumn();
                string command_offset = _zones[i].GetOffset();
                UI::TextWrapped(command_offset);
            }
            UI::EndTable();
        }
        UI::EndGroup();
    }
    
}




