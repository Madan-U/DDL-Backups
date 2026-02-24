-- Object: PROCEDURE citrus_usr.pr_bulk_binary
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_bulk_binary]
(@pa_id numeric,@pa_path varchar(800),@pa_imagepath1 varbinary(max),@pa_imagepath2 varbinary(max),@pa_imagepath3 varbinary(max),@pa_error varchar(800) output)
as
begin
insert into mosl_bulk_binary
select @pa_id,@pa_path,@pa_imagepath1,@pa_imagepath2,@pa_imagepath3
where not exists (select id from mosl_bulk_binary where id=@pa_id)
end

GO
