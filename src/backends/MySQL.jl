module MySQLLoader

# https://github.com/JuliaDatabases/MySQL.jl
import MySQL
import Octo.Backends: UnsupportedError

const current = Dict{Symbol, Any}(
    :conn => nothing,
    :sink => Vector{<:NamedTuple}, # DataFrames.DataFrame
)

current_conn() = current[:conn]
current_sink() = current[:sink]

# sink
function sink(T::Type)
   current[:sink] = T
end

# connect
function connect(; kwargs...)
    args = (:hostname, :username, :password)
    (hostname, username, password) = getindex.(Ref(kwargs), args)
    options = filter(kv -> !(kv.first in args), kwargs)
    conn = MySQL.connect(hostname, username, password; options...)
    current[:conn] = conn
end

# disconnect
function disconnect()
    conn = current_conn()
    MySQL.disconnect(conn)
    current[:conn] = nothing
end

# query
function query(sql::String)
    conn = current_conn()
    sink = current_sink()
    MySQL.query(conn, sql, sink)
end

function query(prepared::String, vals::Vector) # throw UnsupportedError
    throw(UnsupportedError("needs to be implemented"))
end

# execute
function execute(sql::String)::Nothing
    conn = current_conn()
    MySQL.execute!(conn, sql)
    nothing
end

function execute(prepared::String, vals::Vector)::Nothing
    conn = current_conn()
    stmt = MySQL.Stmt(conn, prepared)
    MySQL.execute!(stmt, vals)
    nothing
end

function execute(prepared::String, nts::Vector{<:NamedTuple})::Nothing
    conn = current_conn()
    stmt = MySQL.Stmt(conn, prepared)
    MySQL.Data.stream!(nts, stmt)
    nothing
end

end # module Octo.Backends.MySQLLoader
