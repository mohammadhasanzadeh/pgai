
do $feature_flag_warning$
declare
    _feature_flags text[] = array[{feature_flag_gucs}];
    _feature_flag text;
    _enabled text;
    _warning text;
begin
    foreach _feature_flag in array _feature_flags
    loop
        select pg_catalog.current_setting(_feature_flag, true)
        into _enabled;
        if _enabled is not null and _enabled = 'true' then
            _warning = pg_catalog.concat_ws
            ( ' '
            , pg_catalog.format('Feature flag "%s" has been enabled.', _feature_flag)
            , 'Pre-release software will be installed.'
            , 'This code is not production-grade, is not guaranteed to work, and is not supported in any way.'
            , 'Extension upgrades are not supported once pre-release software has been installed.'
            );
            raise warning '%', _warning;
        end if;
    end loop;
end
$feature_flag_warning$;
