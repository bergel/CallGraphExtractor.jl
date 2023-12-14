function greet_your_package_name()
    return "Hello YourPackageName!"
end

function visit(f::Function, expr::Expr)
    f(expr)
    visit(f, expr.args)
end

visit(f::Function, ::Any) = nothing

function visit(f::Function, args::Vector{Any})
    for a in args
        visit(f, a)
    end
end

function extract_function_def_names(ast::Expr)
    result = []
    visit(ast) do arg
        if typeof(arg) in [Expr, Symbol] && (arg.head in [:function, Symbol("=")])
            push!(result, first(arg.args))
        end
    end
    return result
end

extract_function_def_names(code::String) = extract_function_def_names(Meta.parseall(code))
