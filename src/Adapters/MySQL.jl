module MySQL

include("sql_exports.jl")
include("sql_imports.jl") # Database Structured SubQuery WindowFrame _to_sql _placeholder _placeholders
import .Octo.Queryable: window #
import .Octo: @sql_keywords

const DatabaseID = Database.MySQLDatabase

"""
    to_sql(query::Structured)::String
"""
to_sql(query::Structured)::String = _to_sql(DatabaseID(), query)

"""
    to_sql(subquery::SubQuery)::String
"""
to_sql(subquery::SubQuery)::String = _to_sql(DatabaseID(), subquery)

"""
    to_sql(frame::WindowFrame)::String
"""
to_sql(frame::WindowFrame)::String = _to_sql(DatabaseID(), frame)

placeholder(nth::Int) = _placeholder(DatabaseID(), nth)
placeholders(dims::Int) = _placeholders(DatabaseID(), dims)

export        USE
@sql_keywords USE

end # Octo.Adapters.MySQL
