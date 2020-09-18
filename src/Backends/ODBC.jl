module ODBCLoader

using Octo.Repo: SQLKeyword, ExecuteResult

# https://github.com/JuliaDatabases/ODBC.jl
using ODBC # 1.0
using .ODBC.DBInterface
using .ODBC.Tables

# db_dbname
function db_dbname(nt::NamedTuple)::String
    ""
end

# db_connect
function db_connect(; kwargs...)
    if !isempty(kwargs)
        dsn = get(kwargs, :dsn, "")
        DBInterface.connect(ODBC.Connection, dsn)
    end 
end

# db_disconnect
function db_disconnect(conn)
    DBInterface.close!(conn)
end

# query
function query(conn, sql::String)
    (Tables.rowtable ∘ DBInterface.execute)(conn, sql)
end

function query(conn, prepared::String, vals::Vector)
    stmt = DBInterface.prepare(conn, prepared)
    (Tables.rowtable ∘ DBInterface.execute)(stmt, vals)
end

# execute
function execute(conn, sql::String)::ExecuteResult
    DBInterface.execute(conn, sql)
    ExecuteResult()
end

function execute(conn, prepared::String, vals::Vector)::ExecuteResult
    stmt = DBInterface.prepare(conn, prepared)
    DBInterface.execute(stmt, vals)
    ExecuteResult()
end

function execute(conn, prepared::String, nts::Vector{<:NamedTuple})::ExecuteResult
    stmt = DBInterface.prepare(conn, prepared)
    for nt in nts
        DBInterface.execute(stmt, values(nt))
    end
    ExecuteResult()
end

# execute_result
function execute_result(conn, command::SQLKeyword)::ExecuteResult
    ExecuteResult()
end

end # module Octo.Backends.ODBCLoader
