module Queryable # Octo

import ..Octo: Structured, FromClause, SubQuery, WindowFrame, Field, SQLAlias, SQLOver, SQLExtract, SQLFunction, Predicate, Keyword
import Dates: CompoundPeriod
using Dates # DatePeriod, TimePeriod, TimeType

"""
    from(M::Type, as=nothing)::FromClause
"""
function from(M::Type, as=nothing)::FromClause
    FromClause(M, as)
end

function Base.getproperty(clause::FromClause, field::Symbol)
     if field in (:__octo_model, :__octo_as)
         getfield(clause, field)
     else
         Field(clause, field)
     end
end

"""
    from(query::Structured, as=nothing)::SubQuery
"""
function from(query::Structured, as=nothing)::SubQuery
    SubQuery(query, as)
end


"""
    as(field::Union{Field, SQLFunction, Predicate}, alias::Symbol)::SQLAlias
"""
function as(field::Union{Field, SQLFunction, Predicate}, alias::Symbol)::SQLAlias
    SQLAlias(field, alias)
end


"""
    window(query::Structured, as=nothing):WindowFrame
"""
function window(query::Structured, as=nothing)::WindowFrame
    WindowFrame(query, as)
end

function Base.getproperty(clause::Union{SubQuery,WindowFrame}, field::Symbol)
     if field in (:__octo_query, :__octo_as)
         getfield(clause, field)
     else
         Field(clause, field)
     end
end


"""
    over(field::SQLFunction, query::Union{WindowFrame,Structured})::SQLOver
"""
function over(field::SQLFunction, query::Union{WindowFrame,Structured})::SQLOver
    if query isa WindowFrame
        SQLOver(field, query)
    else
        SQLOver(field, vcat(query...))
    end
end

"""
    extract(field::Union{Keyword, Type{DP}, Type{TP}}, from::Union{Dates.DateTime, DP, TP, Dates.CompoundPeriod})::SQLExtract where DP <: Dates.DatePeriod where TP <: Dates.TimePeriod
"""
function extract(field::Union{Keyword, Type{DP}, Type{TP}}, from::Union{DateTime, <:TimeType, DP, TP, CompoundPeriod})::SQLExtract where DP <: DatePeriod where TP <: TimePeriod
    SQLExtract(field, from)
end

end # module Octo.Queryable
