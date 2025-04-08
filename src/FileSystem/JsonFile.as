class JsonFile {
    private string folder = IO::FromStorageFolder("ButtonStorage");
    protected string file = folder + "\\ButtonData.json";

    JsonFile() {}

    JsonFile(const string &in file) {
        if (!IO::FolderExists(folder)) {
            IO::CreateFolder(folder);
        }
        this.file = folder + "\\" + file + ".json";
    }

    Json::Value@ Load() {
        if (!IO::FileExists(this.file)) {
            print("File does not exist: " + this.file);
            return Json::Array();
        }
        try {
            print("Loading file: " + this.file);
            return Json::FromFile(this.file);
        } catch {
            print("Error loading file: " + this.file);
            return "";
        }
    }

    void Save(Json::Value@ data) {
        try {
            if (!IO::FolderExists(this.folder)) {
                print("Creating folder: " + this.folder);
                IO::CreateFolder(this.folder);
            }       
        } catch {
            print("Error creating folder: " + this.folder);
        }

        try {
            print("Saving file: " + this.file);
            print(Json::Write(data));
            Json::ToFile(this.file, data);
        } catch {
            print("Error saving file: " + this.file);
        }
    }
}