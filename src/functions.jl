extract_function_name(_, obj) = nothing
function extract_function_name(e::Expr)
    result = []
    extract_function_name(result, e)
    return first(result)
end
function extract_function_name(result, e::Expr)
    @match e begin
        Expr(:type,      [_, name, _])     => push!(result, name)
        Expr(:typealias, [name, _])        => push!(result, name)
        Expr(:call,      [name, _...])     => push!(result, name)
        Expr(:function,  [sig, _...])      => extract_function_name(result, sig)
        Expr(:const,     [assn, _...])     => extract_function_name(result, assn)
        Expr(:(=),       [fn, body, _...]) => extract_function_name(result, fn)
        expr_type                          => error("Can't extract name from ",
                                                     expr_type, " expression:\n",
                                                     "    $e\n")
    end
end

extract_dep(_, obj) = nothing
function extract_dep(e::Expr)
    result = []
    extract_dep(result, e)
    return result
end
function extract_dep(result, e::Expr)
    @match e begin
        Expr(:call,      [name, _...])     => push!(result, name)
        Expr(:function,  [sig, _...])      => extract_dep(result, sig)
        Expr(:const,     [assn, _...])     => extract_dep(result, assn)
        Expr(:(=),       [fn, body, _...]) => extract_dep(result, fn)
        expr_type                          => error("Can't extract dependency from ",
                                                     expr_type, " expression:\n",
                                                     "    $e\n")
    end
end

function analyze(ast::Expr)
    f_name = extract_function_name(ast)
    deps = extract_dep(ast)
    return f_name => deps
end


# function greet_your_package_name()
#     return "Hello YourPackageName!"
# end

# function visit(f::Function, expr::Expr)
#     f(expr)
#     visit(f, expr.args)
# end

# visit(f::Function, ::Any) = nothing

# function visit(f::Function, args::Vector{Any})
#     for a in args
#         visit(f, a)
#     end
# end

# function extract_function_def_names(ast::Expr)
#     result = []
#     visit(ast) do arg
#         if typeof(arg) in [Expr, Symbol] && (arg.head in [:function, Symbol("=")])
#             push!(result, first(arg.args))
#         end
#     end
#     return result
# end

# extract_function_def_names(code::String) = extract_function_def_names(Meta.parseall(code))
