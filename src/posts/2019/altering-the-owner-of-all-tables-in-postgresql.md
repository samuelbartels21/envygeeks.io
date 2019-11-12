---
author: envygeeks
slug: altering-the-owner-of-all-tables-in-postgresql
description: How to alter the Owner of All Tables in PostgreSQL
title: Altering the Owner of All Tables in PostgreSQL
date: 2019-11-12T00:00:00-06:00
tags: [
  postgresql,
  postgresql11
]
---

You can alter the owner of multiple tables at once by scripting PL/pgSQL 

```sql
alter database mydb owner to myowner;
do $$ declare t text; begin
    for t in select table_name
                from information_schema.tables
                where table_schema = 'public'
                    and table_catalog = 'mydb'
    loop
        execute format(
            'alter table mydb.myschema.%s owner to myowner', t
        );
    end loop;
end $$;
```
