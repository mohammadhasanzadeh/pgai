-------------------------------------------------------------------------------
-- {migration_name}
do $outer_migration_block$ /*{migration_name}*/
declare
    _sql text;
    _feature_flag text = {feature_flag_guc};
    _migration record;
    _migration_name text = $migration_name${migration_name}$migration_name$;
    _migration_body text =
$migration_body$
{migration_body}
$migration_body$;
begin
    if _feature_flag is not null then
        select pg_catalog.current_setting(_feature_flag, true) into _feature_flag;
        if _feature_flag is null or _feature_flag != 'true' then
            return;
        end if;
    end if;

    select * into _migration from ai.migration where "name" operator(pg_catalog.=) _migration_name;
    if _migration is not null then
        raise notice 'migration %s already applied. skipping.', _migration_name;
        if _migration.body operator(pg_catalog.!=) _migration_body then
            raise warning 'the contents of migration "%s" have changed', _migration_name;
        end if;
        return;
    end if;
    _sql = pg_catalog.format(E'do /*%s*/ $migration_body$\nbegin\n%s\nend;\n$migration_body$;', _migration_name, _migration_body);
    execute _sql;
    insert into ai.migration ("name", body, applied_at_version)
    values (_migration_name, _migration_body, $version${version}$version$);
end;
$outer_migration_block$;