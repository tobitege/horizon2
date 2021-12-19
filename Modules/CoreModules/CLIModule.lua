--@class CLIModule

--@require HorizonModule
--@require StringExtensions

local function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

CLI = (function()
    local this = HorizonModule("CLI", "Command-Line Interface for running commands from Lua chat.", "Input", true)
    this.Tags = "system,input"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---When not null, redirects all input to the provided function until it returns true.
    ---@type function|nil
    this.Lock = nil
    ---@type table<string,function>
    this.Commands = {}


    local operands = {
        [';'] = function (commands)
            for i=1,#commands do
                this.Run(commands[i])
            end
        end,
        ['|'] = function(commands)
            local oldPrint = system.print
            local outBuff = {}
            system.print = function(str) outBuff[#outBuff+1] = str end
            for i=1,#commands do
                local cmds = commands[i]
                cmds[#cmds+1] = table.concat(outBuff, "\n")
                if i==#commands then
                    system.print = oldPrint
                end
                outBuff = {}
                this.Run(cmds)
            end
        end,
    }

    function this.Run(args)
        if type(args) == string then
            args = args:parseCommand()
        end
        local command = table.remove(args, 1)
        if not command then return end
        --todo: figure out pipes etc
        if this.Commands[command:lower()] then
            ---todo: pcall
            return this.Commands[command:lower()](args)
        else
            system.print(command:lower()..": command not found")
            return
        end
    end

    function this.Update(eventType, deltaTime, string)
        system.print("~# "..string)
        if this.Lock ~= nil then
            if this.Lock(string) then
                this.Lock = nil
            end
            return
        end

        local args = string:parseCommand()
        local commands = {}
        local idx = 1
        for i=1,#args do
            local chunk = args[i]
            local op = nil
            if operands[chunk] ~= nil then
                op = chunk
            end
            if not commands[idx] then
                commands[idx] = {}
            end
            if not op then
                table.insert(commands[idx], chunk)
            else
                commands[idx].op = op
                idx = idx + 1
            end
        end

        local skip = 0
        for i=1,#commands do
            local cmdArr = commands[i]
            if #cmdArr > 0 then
                if skip == 0 then
                    if cmdArr.op ~= nil then
                        local cmdList = {}
                        for j=i,#commands do
                            local c = commands[j]
                            if c.op ~= cmdArr.op and c.op ~= nil then break end
                            ---todo: null check
                            cmdList[#cmdList+1] = c
                        end
                        if #cmdList > 0 then
                            operands[cmdArr.op](cmdList)
                            skip = #cmdList-1
                        end
                    else
                        ---todo: pcall
                        this.Run(cmdArr)
                    end
                else
                    skip = math.max(skip - 1, 0)
                end
            end
        end

        ---todo: load bins from databanks
        ---todo: refactor alla this shit
    end

    return this
end)()

function CommandParser(args)
    local this = {}
    this.Args = {}
    this.Help = {}

    local function findArg(arg)
        for i=1,#args do
            local a = args[i]:lower()
            if a == arg:lower() then
                return i
            end
        end
    end

    local function addHelp(name, aliases, helpText)
        if not this.Help[name] then
            this.Help[name] = {
                Aliases = aliases,
                Help = helpText
            }
        end
    end

    function this.AddFlag(name, aliases, helpText)
        addHelp(name, aliases, helpText)
        if type(aliases) == "string" then aliases = {aliases} end
        this.Args[name] = false
        for i=1,#aliases do
            local pos = findArg(aliases[i])
            if pos then
                table.remove(args, pos)
                this.Args[name] = true
            end
        end
        return this
    end

    function this.PrintHelp()
        local maxLen = 0
        for k,v in pairs(this.Help) do
            local aliases = table.concat(v.Aliases, ', ')
            if #aliases > maxLen then maxLen = #aliases end
        end
        maxLen = maxLen + 4
        for k,v in pairs(this.Help) do
            local aliases = table.concat(v.Aliases, ', ')
            local pad = maxLen - #aliases
            system.print("⠀⠀"..aliases..string.rep("⠀", pad)..v.Help)
        end
    end

    return this
end

---Add default commands
function CLI.Commands.echo(args)
    system.print(table.concat(args, " "))
    return true
end

function CLI.Commands.exit(args)
    Horizon.Controller.exit()
    return true
end

function CLI.Commands.grep(args)
    local pArgs =
        CommandParser(args)
        .AddFlag("IgnoreCase", {"-i","--ignore-case"}, "ignore case distinctions")
        .AddFlag("LineCount", {"-c","--count"}, "print only a count of selected lines per INPUT")
        .AddFlag("Help", {"--help"}, "display this help text and exit")

    if #args < 2 or pArgs.Args.Help then
        system.print("Usage: grep [OPTION]... PATTERNS [INPUT]...")
        system.print("Search for PATTERNS in each INPUT.")
        pArgs.PrintHelp()
        return false
    end
    local pattern = args[1]
    local input = args[2]

    --- Split by newline
    local out = {}
    for s in input:gmatch("[^\n]+") do
        if pArgs.Args.IgnoreCase then
            if s:lower():find(pattern:lower()) then
                table.insert(out, s)
            end
        else
            if s:find(pattern) then
                table.insert(out, s)
            end
        end
    end
    if pArgs.Args.LineCount then
        system.print(#out)
    else
        for i=1,#out do system.print(out[i]) end
    end
    return true
end

function CLI.Commands.sed(args)
    local pattern = split(args[1], '/')
    local input = args[2]

    --yeh yeh
    if #pattern >= 4 then
        table.remove(pattern, 1)
        table.remove(pattern, 3)
    end
    for s in input:gmatch("[^\n]+") do
        local out = s:gsub(pattern[1], pattern[2])
        system.print(out)
    end
end

function CLI.Commands.horizon(args)
    local typeof = types.type
    local first = args[1]
    if first then first = first:lower() end
    if args[1] == "version" or args[1] == "v" then
        system.print(Horizon.Version)
        return
    end
    if args[1] == "module" or args[1] == "mod" then
        local module = args[2]
        if module then
            if module == "ls" then
                local loaded = #Horizon.Modules
                system.print("Loaded modules:")
                for k,v in pairs(Horizon.Modules) do
                    system.print(" - "..k)
                end
                return true
            end
            local hMod = Horizon.GetModule(module)
            if not hMod then
                -- Check globals
                local gMod = _G[module]
                ---todo: case insensitive search
                if gMod then
                    if typeof(gMod) == "HorizonModule" then
                        module = gMod
                    end
                else
                    system.print("Unable to find module ["..module.."]")
                    return false
                end
            else
                module = hMod
            end
            --- What do?
            local subCmd = args[3]
            if subCmd then
                subCmd = subCmd:lower()
                if subCmd == "enable" then
                    module.Enable()
                    system.print("Module ["..module.Name.."] enabled.")
                    return true
                end
                if subCmd == "disable" then
                    module.Disable()
                    system.print("Module ["..module.Name.."] disabled.")
                    return true
                end
            else

            end
        else
            ---???
        end
    end
    return true
end