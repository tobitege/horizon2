return (function()
    local this = {}

    function this.ShouldParseQuotes()
        local str = [[I am 'the text' and '' here is "another text in quotes" and this\" \"is "the end"]]
        local parsed = str:parseCommand()
        assert(parsed[1] == "I")
        assert(parsed[2] == "am")
        assert(parsed[3] == "the text")
        assert(parsed[5] == "")
        assert(parsed[8] == "another text in quotes")
        assert(parsed[10] == "this\"")
        assert(parsed[11] == "\"is")
        assert(parsed[12] == "the end")
    end

    return this
end)()