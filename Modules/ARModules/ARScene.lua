--@class ARScene
--@require Camera
--@require Templater

local mat4 = require("cpml/mat4")
local vec2 = require("cpml/vec2")
local quat = require("cpml/quat")

ARObject = function(position, rotation, scale) 
    local this = {}
    this.Position = position or vec3(0, 0, 0)
    this.Rotation = rotation or vec3(0, 0, 0)
    this.Scale = scale or vec3(1, 1, 1)
    this.Name = ""
    this.Parent = nil
    this.Children = {}
    this.Content = ""
    this.Style = ""
    this.Color = "red"
    this.IsVisible = false
    this.Up = vec3(0,0,1)
    this.Forward = vec3(0,1,0)
    this.Right = vec3(1,0,0)
    this.Quaternion = quat(0,0,0,1)
    --this.Quaternion = quat.unit

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

    this.GetScreenPosition = function(camera)
        local transform = this.GetModel() * {this.Position.x, this.Position.y, this.Position.z, 1}
        --local tmp = vec3(transform[1], transform[2], transform[3])
        --system.print(tostring(tmp))
        local pos = camera.TransformToViewport(camera.GetMatrix() * transform)
        pos.y = camera.ViewportSize.y-pos.y
        this.ScreenPos = pos
        return pos
    end

    local EulerToQuat = function()
        local cy = math.cos(this.Rotation.z * constants.deg2rad * 0.5);
        local sy = math.sin(this.Rotation.z * constants.deg2rad * 0.5);
        local cp = math.cos(this.Rotation.y * constants.deg2rad * 0.5);
        local sp = math.sin(this.Rotation.y * constants.deg2rad * 0.5);
        local cr = math.cos(this.Rotation.x * constants.deg2rad * 0.5);
        local sr = math.sin(this.Rotation.x * constants.deg2rad * 0.5);
    
        local w = cr * cp * cy + sr * sp * sy;
        local x = sr * cp * cy - cr * sp * sy;
        local y = cr * sp * cy + sr * cp * sy;
        local z = cr * cp * sy - sr * sp * cy;
    
        return quat(x,y,z,w);
    end

    this.LookAt = function(destination)
        local forwardVector = (-destination):normalize();

        local dot = vec3(0,1,0):dot(forwardVector)

        if math.abs(dot - (-1.0)) < 0.000001 then
            return quat(0, 0, 1, 3.1415926535897932)
        end
        if math.abs(dot - (1.0)) < 0.000001 then
            return quat.unit;
        end

        local rotAngle = math.acos(dot);
        local rotAxis = vec3(0,1,0):cross(forwardVector):normalize()
        this.Quaternion = quat.rotate(rotAngle, rotAxis) * this.Quaternion
    end

    this.RotateAround = function(axis, angle)
        this.Quaternion = quat.rotate(angle * constants.deg2rad, axis) * this.Quaternion
    end

    local function from_transform(t, rot, scale)
        local angle, axis = rot:to_axis_angle()
        local l = axis:len()
        if l == 0 then
            return mat4({
                scale.x, 0, 0, 0,
                0, scale.y, 0, 0,
                0, 0, scale.z, 0,
                t.x, t.y, t.z, 1
            })
        end
        local x, y, z = axis.x / l, axis.y / l, axis.z / l
        local c = math.cos(angle)
        local s = math.sin(angle)
        local m = {
            (x*x*(1-c)+c)*scale.x, (y*x*(1-c)+z*s)*scale.x, (x*z*(1-c)-y*s)*scale.x, 0,
            (x*y*(1-c)-z*s)*scale.y, (y*y*(1-c)+c)*scale.y, (y*z*(1-c)+x*s)*scale.y, 0,
            (x*z*(1-c)+y*s)*scale.z, (y*z*(1-c)-x*s)*scale.z, (z*z*(1-c)+c)*scale.z, 0,
            t.x, t.y, t.z, 1
        }
        return mat4(m)
    end

    local mat = mat4()
    local _XformCache = {
        T = {
            Last = this.Position:clone(),
            Mat = mat
        },
        R = {
            Last = this.Rotation:clone(),
            Mat = mat
        },
        S = {
            Last = this.Scale:clone(),
            Mat = mat
        },
        Total = nil
    }
    this.GetModel = function()
        system.print("Pass "..renderCount .. " obj: "..this.Name)
        if 
            this.Position.x == 0 and this.Position.y == 0 and this.Position.z == 0 and
            this.Scale.x == 1 and this.Scale.y == 1 and this.Scale.z == 1 and
            this.Quaternion.x == 0 and this.Quaternion.y == 0 and this.Quaternion.z == 0 and this.Quaternion.w == 1
            then
                if this.Parent then
                    return this.Parent.GetModel()
                end
                return mat
        end
        
        renderCount = renderCount + 1
        local xf = from_transform(this.Position, this.Quaternion, this.Scale)
        if this.Parent then
            xf = xf * this.Parent.GetModel()
        end
        return xf 
        
        --[[
        local isDirty = false
        if _XformCache.Total == nil then
            isDirty = true
        end

        local t = _XformCache.T.Mat
        if (this.Position - _XformCache.T.Last):len2() ~= 0 then
            t = mat:translate(this.Position)
            _XformCache.T.Mat = t
            _XformCache.T.Last = this.Position:clone()
            isDirty = true
        end

        -- TODO: rotations bork af
        local r = _XformCache.R.Mat
        --if (this.Rotation - _XformCache.R.Last):len2() ~= 0 then
            --r = mat:rotate(this.Rotation.x * constants.deg2rad, this.Right):rotate(this.Rotation.y * constants.deg2rad, this.Forward):rotate(this.Rotation.z * constants.deg2rad, this.Up)
            r = mat:rotate(this.Quaternion)
            
            _XformCache.R.Mat = r
            _XformCache.R.Last = this.Rotation:clone()
            isDirty = true
        --end

        local s = _XformCache.S.Mat
        if (this.Scale - _XformCache.S.Last):len2() ~= 0 then
            s = mat:scale(this.Scale)
            _XformCache.S.Mat = s
            _XformCache.S.Last = this.Scale:clone()
            isDirty = true
        end

        if isDirty then
            local out = t * r * s
            if this.Parent then
                out = out * this.Parent.GetModel()
            end
            _XformCache.Total = out
        end
        return _XformCache.Total
        ]]
    end

    this.Update = function(deltaTime)
        for i=1,#this.Children do
            this.Children[i].Update(deltaTime)
        end
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

ARVertex = function(position, rotation, scale)
    local this = ARObject(position, rotation, scale)

    local mat = mat4()
    this.GetModel = function()
        system.print("Pass "..renderCount .. " obj: "..this.Name)
        if this.Parent then
            return this.Parent.GetModel()
        end
        return mat
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
        ARVertex(),
        ARVertex(vec3(0,0,1)),
        ARVertex(vec3(0,0,1) + (-vec3(1,0,0) * 0.5)),
        ARVertex((vec3(0,0,1) * 2.5) + (vec3(1,0,0) * 0.5)),
        ARVertex(vec3(0,0,1) + (vec3(1,0,0) * 1.5)),
        ARVertex(vec3(0,0,1) + vec3(1,0,0)),
        ARVertex(vec3(1,0,0))
    )
    poly.Position = vec3(-0.5,0,0)
    poly.RotateAround(vec3(0,0,1), 90)
    poly.Scale = poly.Scale * rightAxis:len()
    poly.Style = "opacity:0.5"
    --poly.Quaternion = poly.Quaternion * quat.from_direction(forwardAxis:normalize(), -static.World.Vertical)
    poly.LookAt(rightAxis:normalize())
    poly.Update = function(deltaTime)
        poly.RotateAround(static.World.Vertical, deltaTime * 90)
        --poly.Rotation.z = (poly.Rotation.z + (deltaTime * 90)) % 360
        --poly.Scale.z = (poly.Scale.z + (deltaTime * 2)) % 3
        if poly.Contains(this.GetMousePosition()) then
            poly.Color = "green"
        else
            poly.Color = "red"
        end
    end
    local grp = ARGroup(poly)
    grp.Position = startPos + (rightAxis * 0.5)
    --this.AddObject(grp)

    this.ObjectFromS3D = function(string)
        local function split(s, delimiter)
            result = {};
            for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                table.insert(result, match);
            end
            return result;
        end
        local group = ARGroup()
        group.Name = "Mesh"
        local verts = split(string, ",")
        -- TODO: Group into quads
        for i = 1, #verts, 3 do
            local v1 = ARVertex(vec3(split(verts[i], " ")))
            v1.Name = "Vertex "..i
            local v2 = ARVertex(vec3(split(verts[i+1], " ")))
            v2.Name = "Vertex "..i+1
            local v3 = ARVertex(vec3(split(verts[i+2], " ")))
            v3.Name = "Vertex "..i+2
            --[[
            local v1 = vec3(split(verts[i], " "))
            local v2 = vec3(split(verts[i+2], " "))
            local v3 = vec3(split(verts[i+5], " "))
            local v4 = vec3(split(verts[i+4], " "))
            ]]
            local polygon = ARPolygon(v1,v2,v3)
            polygon.Name = "Poly "..(i//3)+1

            polygon.Style = "opacity:0.3"
            group.AddChild(polygon)
        end
        return group
    end

    local testMesh = [[0 0 1,0.89 0 0.45,0.28 0.85 0.45,0 0 1,0.28 0.85 0.45,-0.72 0.53 0.45,0 0 1,-0.72 0.53 0.45,-0.72 -0.53 0.45,0 0 1,-0.72 -0.53 0.45,0.28 -0.85 0.45,0 0 1,0.28 -0.85 0.45,0.89 0 0.45,0.89 0 0.45,0.72 -0.53 -0.45,0.72 0.53 -0.45,0.28 0.85 0.45,0.72 0.53 -0.45,-0.28 0.85 -0.45,-0.72 0.53 0.45,-0.28 0.85 -0.45,-0.89 0 -0.45,-0.72 -0.53 0.45,-0.89 0 -0.45,-0.28 -0.85 -0.45,0.28 -0.85 0.45,-0.28 -0.85 -0.45,0.72 -0.53 -0.45,0.72 0.53 -0.45,0.28 0.85 0.45,0.89 0 0.45,-0.28 0.85 -0.45,-0.72 0.53 0.45,0.28 0.85 0.45,-0.89 0 -0.45,-0.72 -0.53 0.45,-0.72 0.53 0.45,-0.28 -0.85 -0.45,0.28 -0.85 0.45,-0.72 -0.53 0.45,0.72 -0.53 -0.45,0.89 0 0.45,0.28 -0.85 0.45,0 0 -1,-0.28 0.85 -0.45,0.72 0.53 -0.45,0 0 -1,-0.89 0 -0.45,-0.28 0.85 -0.45,0 0 -1,-0.28 -0.85 -0.45,-0.89 0 -0.45,0 0 -1,0.72 -0.53 -0.45,-0.28 -0.85 -0.45,0 0 -1,0.72 0.53 -0.45,0.72 -0.53 -0.45]]
    local mesh = this.ObjectFromS3D(testMesh)
    local herk = ARGroup(mesh)
    herk.Name = "Mesh Wrapper"
    herk.Position = startPos
    --herk.LookAt(rightAxis:normalize())
    this.AddObject(herk)

    this.Update = function(event, dt)
        renderCount = 1
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