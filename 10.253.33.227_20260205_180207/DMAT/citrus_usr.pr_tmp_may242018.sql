-- Object: PROCEDURE citrus_usr.pr_tmp_may242018
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--exec  pr_tmp_may242018 ''
CREATE procedure pr_tmp_may242018
(
@pa_login varchar(50)
)
as
begin
declare @l_error varchar(100)
begin transaction
insert into tmp_may242018

select '1','b'
set @l_error=@@error

if @l_error>0
begin
select '1'
rollback transaction

end

select '2'
end

GO
