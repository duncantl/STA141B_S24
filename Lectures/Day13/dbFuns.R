Head =
function(tableName, n = 6, db = bb)
{
    qry = sprintf("SELECT * FROM %s LIMIT %d", tableName, n)
    dbGetQuery(db, qry)
}

go = function(qry) dbGetQuery(bb, qry)
