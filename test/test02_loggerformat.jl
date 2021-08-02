module LoggerFormatTest

using MiniLoggers
using ReTest

conts(s, sub) = match(Regex(sub), s) !== nothing

@testset "basic format" begin
    io = IOBuffer()
    logger = MiniLogger(io = io, minlevel = MiniLoggers.Debug,
                        format = "{datetime}:{level}:{module}:{basename}:{filepath}:{line}:{group}:{module}:{id}:{message}")
    with_logger(logger) do
        @info "foo"
        s = String(take!(io))
        @test !conts(s, "datetime")
        @test !conts(s, "level")
        @test !conts(s, "module")
        @test !conts(s, "basename")
        @test !conts(s, "filepath")
        @test !conts(s, "line")
        @test !conts(s, "group")
        @test !conts(s, "module")
        @test !conts(s, "id")
        @test conts(s, "foo")
        @test conts(s, "Info")
    end
end

@testset "squashing" begin
    io = IOBuffer()
    logger = MiniLogger(io = io, format = "{message}")
    with_logger(logger) do
        @info "foo\nbar"

        s = String(take!(io))
        @test s == "foo bar\n"
    end

    logger = MiniLogger(io = io, format = "{message}", squash_message = false)
    with_logger(logger) do
        @info "foo\nbar"

        s = String(take!(io))
        @test s == "foo\nbar\n"
    end
end

@testset "badcaret" begin
    io = IOBuffer()
    logger = MiniLogger(io = io, format = "{message}")
    with_logger(logger) do
        @info "foo\r\nbar"
        
        s = String(take!(io))
        @test s == "foo bar\n"
    end
end

end # module
