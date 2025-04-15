

string rollCommand(const string &in msg)
{
    string cmd = msg.Replace("/roll ", "").Trim();
    print("RollCommand: " + cmd);
    int roll;
    bool isValid = Text::TryParseInt(cmd, roll);
    if (!isValid)
    {
        print("Invalid roll command: " + cmd);
        return "";
    }
    int output = Math::Rand(1, roll);
    // Color the output from red to green based on the perfect roll of the max value.
    string R = colors.color_characters[Math::Clamp(int(Math::Round((1 - (float(output) / float(roll)))) * 15), 0, 15)];
    string G = colors.color_characters[Math::Clamp(int(Math::Round((float(output) / float(roll)) * 15)), 0, 15)];
    string B = "0";
    if (output == roll)
    {
        R = "F";
        G = "F";
        B = "0";
    }

    return "$bbbRolling a number between 1 and " + tostring(roll) + ": $" + R + G + B + output;
}


    