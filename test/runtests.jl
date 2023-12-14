using CallGraphExtractor
using Test

@testset "CallGraphExtractor.jl" begin
    # Write your tests here.
    @test greet_your_package_name() == "Hello YourPackageName!"
    @test greet_your_package_name() != "Hello world!"
end

@testset "Visitor" begin
    ast = Meta.parse("function f()
                g()
                return h()
            end")

    called_functions = []
    visit(ast) do arg
        if typeof(arg) == Expr && arg.head == :call
            push!(called_functions, first(ast.args))
        end
    end

    @test length(called_functions) == 3
end

@testset "Extract function names" begin

    def_functions = extract_function_def_names("function f()
            g()
            return h()
        end")
    @test length(def_functions) == 1
end