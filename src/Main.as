JsonFile BUTTON_STORAGE_FILE = JsonFile("ButtonStorage"); // File to store button data
vec2 window_size = vec2(Draw::GetWidth(), Draw::GetHeight()); // Window size

//MacroButton @current_hovered_button; // Currently hovered button
bool is_hovering_button = false; // Flag to check if mouse is hovering over a button

void Main(){
    // Do nothing
    buttons.LoadButtons(); // Load buttons from file
}

void Render(){
    // Render buttons
    buttons.MainRenderButtons();
}

vec2 starting_mouse_pos = vec2(0, 0); // Mouse position
bool is_dragging = false; // Flag to check if button is being dragged

UI::InputBlocking OnMouseButton(bool down, int button, int x, int y) {
    starting_mouse_pos = vec2(x, y); // Update mouse position
    
    if (down) {
        if (is_hovering_button) {  
            is_dragging = button == 1 ? true : false; // Set dragging flag based on button pressed
            return UI::InputBlocking::Block; // Block input
        } else {
            is_dragging = false; // Set dragging flag to false
        }
    } else {      
        if (is_hovering_button) {                  
            if (button == 1) //Right click drag
            {
                buttons.SaveButtons(); // Save buttons position
            }
            buttons.HandleMouseClick(button);    
            buttons.HandleMouseRelease(); // Handle mouse release for button  
            is_dragging = false; // Set dragging flag to false    
            return UI::InputBlocking::Block;
        }
    }

    return UI::InputBlocking::DoNothing;
}

void OnMouseMove(int x, int y) {
    if (is_dragging) {
        vec2 diff = vec2(x, y) - starting_mouse_pos; // Calculate difference in mouse position
        buttons.HandleMouseDrag(diff);            
        starting_mouse_pos = vec2(x, y); // Update starting mouse position
    } else {        
        is_hovering_button = false;
        is_hovering_button = buttons.HandleMouseMove(x, y); // Handle mouse move for buttons        
    }
        
}

void CreateNewButton(){
    buttons.CreateButton();
}

void DeleteButton(int index){
    buttons.RemoveButton(index);  
}