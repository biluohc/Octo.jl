module PostgreSQL

include("sql_exports.jl")
include("sql_imports.jl") # Database Structured SubQuery WindowFrame _to_sql _placeholder _placeholders
import .Octo.Queryable: window #
import .Octo: @sql_keywords, @sql_functions

const DatabaseID = Database.PostgreSQLDatabase

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

_placeholder(db::DatabaseID, nth::Int) = PlaceHolder("\$$nth")
_placeholders(db::DatabaseID, dims::Int) = Enclosed([PlaceHolder("\$$x") for x in 1:dims])

export         FALSE, INTERVAL, LATERAL, TRUE, WINDOW, WITH
@sql_keywords  FALSE  INTERVAL  LATERAL  TRUE  WINDOW  WITH

export         NOW
@sql_functions NOW

import .Octo.AdapterBase: FromClause, SqlPart, sqlrepr, _sqlrepr
function sqlrepr(db::DatabaseID, clause::FromClause)::SqlPart
    _sqlrepr(db, clause; with_as=false)
end

function sqlrepr(db::DatabaseID, d::Octo.Day)::SqlPart
    els = [INTERVAL, string(d)]
    SqlPart(sqlrepr.(Ref(db), els), " ")
end

end # Octo.Adapters.PostgreSQL
