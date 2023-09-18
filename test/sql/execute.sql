\pset null _null_
\pset format unaligned

SET client_min_messages = warning;

create schema public2;

CREATE OR REPLACE FUNCTION execute(text)
 RETURNS integer
 LANGUAGE plpgsql
 STRICT
AS $function$DECLARE 
   body ALIAS FOR $1; 
   result INT; 
 BEGIN 
   RAISE NOTICE 'Execute: %', body; 
   set search_path=public2;
   EXECUTE body; 
   GET DIAGNOSTICS result = ROW_COUNT; 
   reset search_path;
   RETURN result; 
 END; 
 $function$
;

do $_$
declare ddl text;
begin
  ddl := ddlx_create('test_collation_d'::regtype,'{}');
  perform public.execute(ddl);
  ddl := ddlx_create('test_class_r_a_seq'::regclass,'{}');
  perform public.execute(ddl);
  ddl := ddlx_createonly('test_class_r'::regclass,'{}');
  perform public.execute(ddl);
end
$_$ LANGUAGE plpgsql
