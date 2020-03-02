local selectedAction = 0

local buttonWidth = 250
local buttonHeight = 75
local buttonBorder = 2

local label = -1

gfx.GradientColors(0,128,255,255,0,128,255,0)
local gradient = gfx.LinearGradient(0,0,0,1)

function is_selected(x, y, w, h)
    local mousePosX, mousePosY = game.GetMousePos()
    return mousePosX > x and mousePosY > y and mousePosX < x + w and mousePosY < y + h
end

function draw_button(name, x, y, onSelected)
    local rx = x - (buttonWidth / 2)
    local ty = y - (buttonHeight / 2)

    gfx.BeginPath()
    gfx.FillColor(0,128,255)

    if is_selected(rx,ty, buttonWidth, buttonHeight) then
       selectedAction = onSelected
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

 function render(deltaTime)
    local resx, resy = game.GetResolution()

    gfx.Scale(resx, resy / 3)
    gfx.Rect(0,0,1,1)
    gfx.FillPaint(gradient)
    gfx.Fill()
    gfx.ResetTransform()
    gfx.BeginPath()
    buttonY = resy / 2
    selectedAction = nil

    gfx.LoadSkinFont("segoeui.ttf")

    draw_button("Start", resx / 2, buttonY, Menu.Start)
    buttonY = buttonY + 100
    draw_button("Multiplayer", resx / 2, buttonY, Menu.Multiplayer)
    buttonY = buttonY + 100
    draw_button("Settings", resx / 2, buttonY, Menu.Settings)
    buttonY = buttonY + 100
    draw_button("Exit", resx / 2, buttonY, Menu.Exit)

    gfx.BeginPath()
    gfx.FillColor(255,255,255)
    gfx.FontSize(120)

    if label == -1 then
        label = gfx.CreateLabel("unnamed_sdvx_clone", 120, 0)
    end

    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_MIDDLE)
    gfx.DrawLabel(label, resx / 2, resy / 2 - 200, resx-40)
end

function mouse_pressed(button)
    if selectedAction then
        selectedAction()
    end

    return 0
end
