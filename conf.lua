function love.conf(t)
    t.window.title = "The Terrestrial Extra"
    t.version = "11.5"
    t.window.width = 800
    t.window.height = 600

    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.image = false
    t.modules.mouse = false
    t.modules.system = false
    t.modules.thread = false
    t.modules.touch = false
    t.modules.video = false

    t.console = false
end
