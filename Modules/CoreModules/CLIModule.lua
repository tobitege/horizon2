--@class CLIModule

--@require StringExtensions

CLI = (function()
    local this = HorizonModule("CLI", "Command-Line Interface for running commands from Lua chat.", "Input", false)
    this.Tags = "system,input"
    this.Config.Version = "%GIT_FILE_LAST_COMMIT%"

    ---When not null, redirects all input to the provided function until it returns true.
    ---@type function|nil
    this.Lock = nil

    function this.Update(eventType, deltaTime, string)
        if this.Lock ~= nil then
            if this.Lock(string) then
                this.Lock = nil
            end
            return
        end

        local args = string:parseCommand()
        local command = table.remove(args[1], 1)
        Horizon.Emit.Call("System.Command."..command, args)
    end

    return this
end)()