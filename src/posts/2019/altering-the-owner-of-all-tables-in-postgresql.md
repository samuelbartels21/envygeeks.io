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
alter database :database owner to :owner;
do $$ declare t text; begin
    for t in select table_name
                from information_schema.tables
                where table_schema = :schema
                    and table_catalog = :database
    loop
        execute format(
            (
                'alter table ' || :database || '.' || :schema 
                    || '.%s owner to ' || :owner
            ), t
        );
    end loop;
end $$;
```
