-- Object: PROCEDURE citrus_usr.pr_onetimedump_reco
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc pr_onetimedump_reco
as
begin

declare @l_dt datetime 
set @l_dt  = dateadd(d,-1,CONVERT(datetime,convert(varchar(11),getdate()-1,103),103))
insert into holdingall_fromstart
exec [pr_get_holding_fix_latest] 3,@l_dt,@l_dt,'0','9999999999999999',''    

end

GO
