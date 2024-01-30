using CallGraphExtractor
using Test


const code1 = """function f()
                 g()
                 return h()
             end"""

@testset "code1" begin
    ast = Meta.parse(code1)
    @test extract_function_name(ast) == :f
    @test extract_dep(ast) == [:g, :h]
end

# @testset "Visitor" begin
#     ast = Meta.parse("function f()
#                 g()
#                 return h()
#             end")

#     called_functions = []
#     visit(ast) do arg
#         if typeof(arg) == Expr && arg.head == :call
#             push!(called_functions, first(ast.args))
#         end
#     end

#     @test length(called_functions) == 3
# end

# @testset "Extract function names" begin
#     @testset "1 function" begin
#         def_functions = extract_function_def_names("function f()
#                 g()
#                 return h()
#             end")
#         @test length(def_functions) == 1
#     end

#     @testset "3 functions" begin
#         def_functions = extract_function_def_names("function visit(f::Function, expr::Expr)
#         f(expr)
#         visit(f, expr.args)
#     end

#     visit(f::Function, ::Any) = nothing

#     function visit(f::Function, args::Vector{Any})
#         for a in args
#             visit(f, a)
#         end
#     end")
#         @test length(def_functions) == 1
#     end
# end