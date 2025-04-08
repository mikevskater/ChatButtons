class ButtonManager{
    // class to hold and manager buttons
    array<MacroButton@> buttons; // Array of buttons
    int Length;
    int hovered_index;
    int dragging_index = -1;
    int last_clicked_index = -1; // Last clicked button index
    float startspot_x = 0.05; // Starting x percent position for buttons
    float startspot_y = 0.95; // Starting y percent position for buttons

    ButtonManager(){
        // Constructor        
    }
    
    MacroButton@ button(uint index){
        // Get button from array
        if(index < buttons.Length){
            return @buttons[index];
        }
        return null;
    }
    
    MacroButton@ button(int index){
        // Get button from array
        uint i = uint(index);
        if(i < buttons.Length){
            return @buttons[i];
        }
        return null;
    }

    void CreateButton(){
        // Create new button
        MacroButton@ button = MacroButton();  
        this.PlaceButton(button); // Place button on screen
        AddButton(button);
    }
    
    void AddButton(MacroButton@ button){
        // Add button to array
        buttons.InsertLast(button);
        Length++;
    }

    void PlaceButton(MacroButton@ button){
        // Place button on screen
        float x = Draw::GetWidth() * startspot_x; // Get x position
        float y = Draw::GetHeight() * startspot_y; // Get y position
        button.SetPos(x, y); // Set button position
        bool button_overlap = true;
        while(button_overlap){
            button_overlap = false; // Reset overlap flag
            for(uint i = 0; i < buttons.Length; i++){
                if(buttons[i].IsOverlapping(button)){
                    button_overlap = true; // Set overlap flag if button overlaps
                    x = (buttons[i].GetPosX() + buttons[i].GetSizeW()) + 10; // Get new x position
                    if (x + button.GetSizeW() > Draw::GetWidth()){ // Check if button goes out of bounds
                        x = Draw::GetWidth() * startspot_x; // Reset x position
                        y -= button.GetSizeH() + 10; // Get new y position                    
                    }
                    button.SetPos(x, y); // Set new button position
                    break; // Break out of loop if button overlaps
                }
            }
        }
    }
/*
    void RemoveButton(MacroButton@ button){
        // Remove button from array
        for(uint64 i = 0; i < buttons.Length; i++){
            if(button(i).equals(button)){
                buttons.RemoveAt(i);
                Length--;
                break;
            }
        }
    }
    */
    void RemoveButton(uint index){
        // Remove button from array
        if(index < buttons.Length){
            buttons.RemoveAt(index);
            Length--;
        }
    }
    void RemoveButton(int index){
        // Remove button from array
        uint i = uint(index);
        if(i < buttons.Length){
            buttons.RemoveAt(i);
            Length--;
        }
    }
    /*
    void RemoveButton(string name){
        // Remove button from array
        for(uint64 i = 0; i < buttons.Length; i++){
            if(button(i).GetName() == name){
                buttons.RemoveAt(i);
                Length--;
                break;
            }
        }
    }
    */
    Json::Value@ to_Json(){
        // Save buttons to json
        Json::Value data = Json::Array();
        for (uint i = 0; i < buttons.Length; i++){
            // Save each button to json
            Json::Value button_data = buttons[i].To_Json();
            data.Add(button_data);
        }
        return data;
    }

    MacroButton@ getButton(uint index){
        // Get button from array
        if(index < buttons.Length){
            return button(index);
        }
        return null;
    }

    MacroButton@ getButton(int index){
        uint i = uint(index);
        // Get button from array
        if(i < buttons.Length){
            return button(i);
        }
        return null;
    }
    void From_Json(Json::Value@ data){
        // Load buttons from json        
        if (data.Length == 0){
            print("No buttons to load");
            return;
        }
        
        for (uint i = 0; i < data.Length; i++){
            // Load each button from json
            MacroButton@ button = MacroButton();
            button.From_Json(data[i]);
            AddButton(button);
        }

    }
    bool HandleMouseMove(int x, int y){
        // Handle mouse move for buttons
        bool is_hovering = false;
        hovered_index = -1; // Reset hovered index
        for(uint i = buttons.Length; i > 0; i--){
            //print("Button " + i + " is hovering: " + button(i-1).IsMouseOver(x, y));
            if(button(i-1).IsMouseOver(x, y) && !is_hovering){
                button(i-1).SetHover(true);       
                hovered_index = i-1; // Set hovered index         
                is_hovering = true; // Return true if mouse is over button
            } else {
                button(i-1).SetHover(false);                
            }
        }
        return is_hovering; // Return false if mouse is not over any button
    }
    void MainRenderButtons(){
        CSmArenaClient@ playground = cast<CSmArenaClient>(cast<CTrackMania>(GetApp()).CurrentPlayground);
        if (playground is null) {
            //print("Playground is null");
            return;
        }
        RenderButtons(); // Render buttons
    }
    void RenderButtons(){
        // Render buttons
        for(uint i = 0; i < buttons.Length; i++){
            button(i).Render();
        }
    }
    
    void HandleMouseDrag(vec2 diff){        
        button(hovered_index).AdjPosX(diff.x);
        button(hovered_index).AdjPosY(diff.y);
        this.dragging_index = hovered_index; // Set dragging index to hovered index
    }

    void HandleMouseRelease(){
        this.dragging_index = -1; // Reset dragging index
    }

    void HandleMouseClick(int b_index){
        button(hovered_index).HandleMouseClick(b_index); // Handle mouse click for button        
        this.last_clicked_index = hovered_index; // Set last clicked index to hovered index
    }

    void SaveButtons(){
        // Save buttons to file
        Json::Value@ data = to_Json();
        print("Saving buttons to file:");
        BUTTON_STORAGE_FILE.Save(data);
        
    }

    void LoadButtons(){
        // Load buttons from file
        Json::Value@ data = BUTTON_STORAGE_FILE.Load();
        //print("Loading buttons from file: " + BUTTON_STORAGE_FILE.file);     
        
        if (data.Length == 0){
            print("Json load Nothing!");
            return;
        }

        for(uint i = 0; i < data.Length; i++){
            MacroButton@ button = MacroButton();
            button.From_Json(data[i]);
            AddButton(button);
        }
    }
}

ButtonManager buttons;