local index = {
    red = {255, 0, 0},
    orange = {255, 119, 0},
    yellow = {255, 250, 0},
    green = {0, 255, 0},
    blue = {0, 0, 255},
    purple = {187, 0, 255},
    pink = {255, 0, 187},
    redorange = {255, 46, 0},
    orangeyellow = {255, 157, 0},
    yellowgreen = {221, 255, 0},
    aqua = {0, 255, 153},
    brightblue = {0, 178, 255},
    violetblue = {0, 42, 255},
    darkgreen = {9, 119, 7},
    teal = {7, 119, 117},
    navyblue = {3, 27, 76},
    darkred = {112, 6, 6},
    brown = {94, 18, 4},
    apricot = {229, 127, 66},
    white = {255, 255, 255},
    lightgray = {98, 198, 198},
    grey = {132, 132, 132},
    mediumgrey = {94, 94, 94},
    darkgrey = {53, 53, 53},
    black = {0, 0, 0}
}

Color = function(color)
    if index[color] then
        return index[color]
    else
        return error('This color does not exist!')
    end
end

return Color