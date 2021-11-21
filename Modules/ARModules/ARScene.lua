--@class ARScene
--@require Camera
--@require Templater

local mat4 = require("cpml/mat4")
local vec2 = require("cpml/vec2")

ARObject = function(position, rotation, scale) 
    local this = {}
    this.Position = position or vec3(0, 0, 0)
    this.Rotation = rotation or vec3(0, 0, 0)
    this.Scale = scale or vec3(1, 1, 1)
    this.Parent = nil
    this.Children = {}
    this.Content = ""
    this.Style = ""
    this.Color = "red"
    this.IsVisible = false
    this.Up = vec3(0,0,1)
    this.Forward = vec3(0,1,0)
    this.Right = this.Up:cross(this.Forward)

    this.AddChild = function(child)
        if child.Parent ~= nil then
            error("Adding child with existing parent. Reparenting not implemented.")
        end
        if child == this then
            error("Attempting to add self as child.")
        end
        child.Parent = this
        table.insert(this.Children, child)
    end

    this.GetAbsolutePosition = function(camera)
        local pos = this.Position
        if this.Parent ~= nil then
            --if this.Parent.Rotation:len() > 0 then
                local xform = this.Parent.GetRotationMatrix() * {this.Position.x, this.Position.y, this.Position.z, 1}
                pos = vec3(xform[1], xform[2], xform[3])
            --end
            pos = pos + this.Parent.GetAbsolutePosition(camera)
        end
        return pos
    end

    this.GetRotation = function()
        local rot = this.Rotation
        if this.Parent ~= nil then
            rot = rot + this.Parent.GetRotation()
        end
        rot.x = rot.x % 360
        rot.y = rot.y % 360
        rot.z = rot.z % 360
        return rot
    end

    this.GetScreenPosition = function(camera)
        local pos = camera.WorldToScreen(this.GetAbsolutePosition(camera))
        pos.y = camera.ViewportSize.y-pos.y
        this.ScreenPos = pos
        return pos
    end

    local _RotCache = {
        x = {
            Last = 0,
            Mat = mat4()
        },
        y = {
            Last = 0,
            Mat = mat4()
        },
        z = {
            Last = 0,
            Mat = mat4()
        },
        Last = mat4()
    }
    this.GetRotationMatrix = function()
        --system.print("Calculating rotation for "..tostring(this.Rotation).." with "..#this.Children.." children")
        local mat = mat4()
        local isDirty = false
        local rotation = this.Rotation
        --mat = mat:rotate(...)
        if rotation.x ~= _RotCache.x.Last then
            _RotCache.x.Last = rotation.x
            x = mat:rotate(rotation.x, this.Right)
            isDirty = true
        else
            x = _RotCache.x.Mat
        end
        if rotation.y ~= _RotCache.y.Last then
            _RotCache.y.Last = rotation.y
            y = mat:rotate(rotation.y, this.Forward)
            isDirty = true
        else
            y = _RotCache.y.Mat
        end
        if rotation.z ~= _RotCache.z.Last then
            z = mat:rotate(rotation.z, this.Up)
            _RotCache.z.Last = rotation.z
            isDirty = true
        else
            z = _RotCache.z.Mat
        end
        if isDirty then
            _RotCache.Last = x * y * z
        end
        if this.Parent then _RotCache.Last = _RotCache.Last * this.Parent.GetRotationMatrix() end
        return _RotCache.Last
    end

    this.Update = function(deltaTime)
    end

    this.Contains = function(point)
        return false
    end

    this.Render = function(camera, deltaTime)
        this.ScreenPos = this.GetScreenPosition(camera)
        if this.ScreenPos.z >= 0 then
            this.IsVisible = true
        else
            this.IsVisible = false
        end
        local buffer = ""
        for i=1, #this.Children do
            buffer = buffer .. this.Children[i].Render(camera)
        end
        if this.IsVisible then
            buffer = buffer .. Templater.Fill(this.Content, this)
        end
        return buffer
    end

    return this
end

ARPoint2D = function(position, rotation, scale)
    local this = ARObject(position, rotation, scale)
    this.Content = [[<circle cx="$(ScreenPos.x)" cy="$(ScreenPos.y)" r="$(Scale:len())" fill="$(Color)" />]]

    this.Contains = function(point)
        if this.ScreenPos == nil then
            return false
        end

        system.print(tostring(point))
        local dx = math.abs(point.x - this.ScreenPos.x)
        local dy = math.abs(point.y - this.ScreenPos.y)
        if dx > this.Scale:len() or dy > this.Scale:len() then
            return false
        end
        return true
    end
    return this
end


ARGroup = function(...) 
    local this = ARObject(position, rotation, scale)
    local arg = {...}

    for i=1,#arg do
        this.AddChild(arg[i])
    end

    return this
end

ARPolygon = function(...)
    local this = ARObject(position, rotation, scale)
    local arg = {...}
    this.Content = [[<polygon points="$(_PolyBuffer)" style="fill:$(Color);$(Style)" />]]
    
    for i=1,#arg do
        this.AddChild(arg[i])
    end

    this.GetBounding2D = function()
        local min = vec2(2^1024,2^1024)
        local max = vec2(0,0)
        -- TODO: null checks
        for i=1,#this.Children do
            local c = this.Children[i].ScreenPos
            if c then
                if c.x < min.x then
                    min.x = c.x
                end
                if c.x > max.x then
                    max.x = c.x
                end
                if c.y < min.y then
                    min.y = c.y
                end
                if c.y > max.y then
                    max.y = c.y
                end
            end
        end
        return min, max
    end

    this.Contains = function(point)
        if not this.ContainsInBounds(point) then
            return false
        end
        local oddNodes = false
        local j = #this.Children
        for i = 1, #this.Children do
            local iScreen = this.Children[i].ScreenPos
            local jScreen = this.Children[j].ScreenPos
            if (iScreen.y < point.y and jScreen.y >= point.y or jScreen.y < point.y and iScreen.y >= point.y) then
                if (iScreen.x + ( point.y - iScreen.y ) / (jScreen.y - iScreen.y) * (jScreen.x - iScreen.x) < point.x) then
                    oddNodes = not oddNodes;
                end
            end
            j = i;
        end
        return oddNodes
    end

    this.ContainsInBounds = function(point)
        local min, max = this.GetBounding2D()
        if 
            point.x >= min.x and point.x <= max.x and 
            point.y >= min.y and point.y <= max.y 
        then
            return true
        end
        return false
    end

    local baseRender = this.Render
    this.Render = function(camera, deltaTime)
        this._PolyBuffer = ""
        for i=1,#this.Children do
            local c = this.Children[i].GetScreenPosition(camera)
            this._PolyBuffer = this._PolyBuffer .. c.x..","..c.y.." "
        end
        return Templater.Fill(this.Content, this)
    end

    return this
end

ARLine = function(p1, p2)
    local this = ARGroup(position, rotation, scale)
    this.P1 = p1 or ARObject()
    this.P2 = p2 or ARObject(vec3(0,0,1))
    this.Content = [[<line x1="$(P1Pos.x)" y1="$(P1Pos.y)" x2="$(P2Pos.x)" y2="$(P2Pos.y)" style="stroke:rgb(255,0,0);stroke-width:2" />]]
    this.AddChild(this.P1)
    this.AddChild(this.P2)

    this.Render = function(camera, deltaTime)
        this.P1Pos = this.P1.GetScreenPosition(camera)
        this.P2Pos = this.P2.GetScreenPosition(camera)
        local buffer = ""
        for i=1, #this.Children do
            buffer = buffer .. this.Children[i].Render(camera)
        end
        if this.P1.IsVisible and this.P2.IsVisible then
            buffer = buffer .. Templater.Fill(this.Content, this)
        end
        return buffer
    end

    return this
end

-- billboard
-- mesh
-- textured mesh?

ARScene = (function()
    local this = HorizonModule("AR Scene", "Augmented Reality Renderer", "PreUpdate", true, 0)
    this.Tags = "hud,ar"
    this.Config = {
    }
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"
    this.Objects = {}

    local lastTime = system.getTime()
    local static = Horizon.Memory.Static
    local hud = Horizon.GetModule("UI Controller").Displays[1]
    local cursor = Horizon.GetModule("HUD Cursor")
    local resolution = vec2(system.getScreenWidth(), system.getScreenHeight())
    local camera = Camera(resolution, system.getFov())
    camera.ViewportSize = vec2(camera.Resolution.x, camera.Resolution.y)
    camera.UpdateProjection(0.1)

    local layer = UIPanel(0, 0, 100, 100)
    layer.AlwaysDirty = true
    hud.AddWidget(layer)

    -- Test bullshit
    local plr = vec3(Horizon.Controller.getMasterPlayerWorldPosition())
    local offset = static.World.Vertical * -0.625
    local startPos = vec3(-3694.171, 95670.455, -44290.861) - offset
    local endPos = vec3(-3694.119, 95669.155, -44289.342) - offset
    local rightAxis = endPos - startPos
    local forwardAxis = rightAxis:cross(static.World.Vertical):normalize() * 4
    
    this.AddObject = function(object)
        table.insert(this.Objects, object)
    end

    this.RemoveObject = function(object)
        for i = 1, #this.Objects do
            if this.Objects[i] == object then
                table.remove(this.Objects, i)
                return true
            end
        end
        return false
    end

    this.GetMousePosition = function()
        local mousePos = hud.MousePos * 0.01
        if cursor and cursor.Cursor.Enabled then
            mousePos.x = mousePos.x * camera.ViewportSize.x
            mousePos.y = mousePos.y * camera.ViewportSize.y
        else
            mousePos.x = camera.ViewportSize.x * 0.5
            mousePos.y = camera.ViewportSize.y * 0.5
        end
        return mousePos
    end

    local poly = ARPolygon(
        ARObject(),
        ARObject(-static.World.Vertical),
        ARObject(-static.World.Vertical + (-rightAxis * 0.5)),
        ARObject((-static.World.Vertical * 2.5) + (rightAxis * 0.5)),
        ARObject(-static.World.Vertical + (rightAxis * 1.5)),
        ARObject(-static.World.Vertical + rightAxis),
        ARObject(rightAxis)
    )
    poly.Position = startPos
    poly.Style = "opacity:0.5"
    poly.Forward = forwardAxis:normalize()
    poly.Right = rightAxis:normalize()
    poly.Up = poly.Forward:cross(poly.Right)
    poly.Update = function(deltaTime)
        poly.Rotation.z = poly.Rotation.z + deltaTime
        if poly.Contains(this.GetMousePosition()) then
            poly.Color = "green"
        else
            poly.Color = "red"
        end
    end
    this.AddObject(poly)

    this.ObjectFromS3D = function(string)
        local function split(s, delimiter)
            result = {};
            for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                table.insert(result, match);
            end
            return result;
        end
        local group = ARGroup()
        local verts = split(string, ",")
        -- TODO: Group into quads
        for i = 1, #verts, 3 do
            local v1 = vec3(split(verts[i], " "))
            local v2 = vec3(split(verts[i+1], " "))
            local v3 = vec3(split(verts[i+2], " "))
            local polygon = ARPolygon(ARObject(v1),ARObject(v2),ARObject(v3))
            polygon.Style = "opacity:0.3"
            group.AddChild(polygon)
        end
        return group
    end

    local testMesh = [[0.5 0 0.5,0.5 0 0,0.5 0.9 0.5,0.5 0.9 0.5,0.5 0 0,0.5 0.9 0,0.75 0 0.5,0.5 0 0.5,0.75 0.9 0.5,0.75 0.9 0.5,0.5 0 0.5,0.5 0.9 0.5,0.25 0 0.85,0.75 0 0.5,0.25 0.9 0.85,0.25 0.9 0.85,0.75 0 0.5,0.75 0.9 0.5,-0.25 0 0.5,0.25 0 0.85,-0.25 0.9 0.5,-0.25 0.9 0.5,0.25 0 0.85,0.25 0.9 0.85,0 0 0.5,-0.25 0 0.5,0 0.9 0.5,0 0.9 0.5,-0.25 0 0.5,-0.25 0.9 0.5,0 0 0,0 0 0.5,0 0.9 0,0 0.9 0,0 0 0.5,0 0.9 0.5,0.5 0 0,0 0 0,0.5 0.9 0,0.5 0.9 0,0 0 0,0 0.9 0,0.5 0.9 0,0 0.9 0,0.5 0.9 0.5,0.5 0.9 0.5,0 0.9 0,0 0.9 0.5,0.5 0.9 0.5,0 0.9 0.5,0.25 0.9 0.85,0.25 0.9 0.85,0 0.9 0.5,-0.25 0.9 0.5,0.25 0.9 0.85,0.75 0.9 0.5,0.5 0.9 0.5,0 0 0,0.5 0 0,0 0 0.5,0 0 0.5,0.5 0 0,0.5 0 0.5,0 0 0.5,0.5 0 0.5,0.25 0 0.85,0.25 0 0.85,0.5 0 0.5,0.75 0 0.5,0.25 0 0.85,-0.25 0 0.5,0 0 0.5]]
    local herk = this.ObjectFromS3D(testMesh)
    herk.Position = startPos
    --this.AddObject(herk)

    this.Update = function(event, dt)
        local deltaTime = system.getTime() - lastTime
        -- TODO: Actually set it to player position based on interact
        -- TODO: Manage interactivity through lib
        local plr = vec3(Horizon.Controller.getMasterPlayerWorldPosition())
        camera.UpdateView(plr, vec3(Horizon.Controller.getMasterPlayerWorldForward()), vec3(Horizon.Controller.getMasterPlayerWorldUp()))
        table.sort(this.Objects, function(a, b)
            if a.ScreenPos and b.ScreenPos then
                return a.ScreenPos.z > b.ScreenPos.z
            end
        end)


        local buffer = [[<svg viewBox="0 0 ]]..camera.Resolution.x..[[ ]]..camera.Resolution.y..[[">]]
        for i=1,#this.Objects do
            local obj = this.Objects[i]
            if obj ~= nil then
                obj.Update(deltaTime)
            end
            if obj ~= nil then
                buffer = buffer .. obj.Render(camera, deltaTime)
            end
        end
        local buffer = buffer .. [[</svg>]]
        layer.Content = buffer
        lastTime = system.getTime()
    end

    system.print("AR Scene init")
    return this
end)()