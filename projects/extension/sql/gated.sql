do $gated_by_feature_flag$
declare
    _feature_flag text = {feature_flag_guc};
begin

if _feature_flag is not null then
    select pg_catalog.current_setting(_feature_flag, true) into _feature_flag;
    if _feature_flag is null or _feature_flag != 'true' then
        return;
    end if;
end if;

{code}

end;
$gated_by_feature_flag$;
