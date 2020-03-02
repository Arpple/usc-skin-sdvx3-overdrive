local selectedAction = 0

local buttonWidth = 250
local buttonHeight = 75
local buttonBorder = 2

local label = gfx.CreateLabel("unnamed_sdvx_clone", 120, 0)

gfx.GradientColors(0,128,255,255,0,128,255,0)
local gradient = gfx.LinearGradient(0,0,0,1)

local buttons = {
    "Start",
    "Multiplayer",
    "DLScreen",
    "Settings",
    "Exit",
}

function _is_selected(x, y, w, h)
    local mousePosX, mousePosY = game.GetMousePos()
    return mousePosX > x and mousePosY > y and mousePosX < x + w and mousePosY < y + h
end


function _draw_button(name, x, y)
    local rx = x - (buttonWidth / 2)
    local ty = y - (buttonHeight / 2)

    gfx.BeginPath()
    gfx.FillColor(0,128,255)

    if _is_selected(rx,ty, buttonWidth, buttonHeight) then
       selectedAction = Menu[name]
       gfx.FillColor(255,128,0)
    end

    gfx.Rect(
        rx - buttonBorder,
        ty - buttonBorder,
        buttonWidth + (buttonBorder * 2),
        buttonHeight + (buttonBorder * 2)
    )

    gfx.Fill()
    gfx.BeginPath()
    gfx.FillColor(40,40,40)
    gfx.Rect(rx, ty, buttonWidth, buttonHeight)
    gfx.Fill()
    gfx.BeginPath()
    gfx.FillColor(255,255,255)
    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_MIDDLE)
    gfx.FontSize(40)
    gfx.Text(name, x, y)
end


function _draw_title(resX, resY)
    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_MIDDLE)
    gfx.DrawLabel(label, resX / 2, resY / 2 - 200, resX - 40)
end


function _draw_buttons(resX, resY)
    local y = resY / 2
    selectedAction = nil

    gfx.LoadSkinFont("segoeui.ttf")

    for i = 1, # buttons do
        local button = buttons[i]
        _draw_button(button, resX / 2, y)
        y = y + 100
    end
end


function render(deltaTime)
    local resx, resy = game.GetResolution()

    gfx.Scale(resx, resy / 3)
    gfx.Rect(0,0,1,1)
    gfx.FillPaint(gradient)
    gfx.Fill()
    gfx.ResetTransform()
    gfx.BeginPath()
    
    _draw_buttons(resx, resy)

    gfx.BeginPath()
    gfx.FillColor(255,255,255)
    gfx.FontSize(120)

    _draw_title(resx, resy)
end


function mouse_pressed(button)
    if selectedAction then
        selectedAction()
    end

    return 0
end
