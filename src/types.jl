# module Octo

struct FromClause
    __octo_model::Type
    __octo_as::Union{Symbol, Nothing}
end

struct Field
    clause::FromClause
    name::Symbol
end

struct AggregateFunction
    name::Symbol
    field
    as::Union{Symbol, Nothing}
end

struct Predicate
    func::Function
    left::Union{Bool, Number, String, Symbol, Field, AggregateFunction, Predicate}
    right::Union{Bool, Number, String, Symbol, Field, AggregateFunction, Predicate}
end
