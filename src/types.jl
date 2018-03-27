# module Octo

# SQLElement
abstract type SQLElement end

const Structured = Array # Union{<:SQLElement, Any}

struct FromClause <: SQLElement
    __octo_model::Type
    __octo_as::Union{Symbol, Nothing}
end

struct SubQuery <: SQLElement
    __octo_query::Structured
    __octo_as::Union{Symbol, Nothing}
end

struct Field <: SQLElement
    clause::FromClause
    name::Symbol
end

struct SQLAlias <: SQLElement
    field
    alias::Symbol
end

struct AggregateFunction <: SQLElement
    name::Symbol
    field
end

struct PlaceHolder <: SQLElement
    body::String
end

struct Predicate <: SQLElement
    func::Function
    left::Union{Bool, Number, String, Symbol, <: SQLElement}
    right::Union{Bool, Number, String, Symbol, <: SQLElement, Type{PlaceHolder}}
end

struct Raw <: SQLElement
    string::String
end

struct Enclosed <: SQLElement
    values::Vector
end

struct Keyword <: SQLElement
    name::Symbol
end

struct KeywordAllKeyword <: SQLElement
    left::Keyword
    right::Keyword
end

struct Aggregate
    name::Symbol
end
(a::Aggregate)(field) = AggregateFunction(a.name, field)


# @keywords

macro keywords(args...)
    esc(keywords(args))
end
keywords(s) = :(($(s...),) = $(map(Keyword, s)))


# @aggregates

macro aggregates(args...)
    esc(aggregates(args))
end
aggregates(s) = :(($(s...),) = $(map(Aggregate, s)))

function Base.:*(left::Keyword, right::Keyword)
    KeywordAllKeyword(left, right)
end
