-- Object: PROCEDURE dbo.non_ecn_list
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc  [dbo].[non_ecn_list] @dt datetime
as
truncate table nonecn

insert into nonecn
select distinct ltrim(rtrim(party_code))party_code from (
select distinct party_code from AngelNSECM.msajag.dbo.nse_bulk_process where sno =1
union all
select distinct party_code from AngelNSECM.msajag.dbo.cur_bulk_process where sno =1
union all
select distinct party_code  from angelcommodity.mcdx.dbo.comm_bill_process
union all 
select distinct party_code from AngelNSECM.msajag.dbo.Margin_process)a
where not exists (select cl_Code from client_brok_details where cl_Code =party_code 
and isnull(Print_Options,0)=2)

declare @NSEQUERY varchar(max)
set @NSEQUERY = ' bcp " select party_code'
set @NSEQUERY = @NSEQUERY + ' from anand1.msajag.dbo.nonecn " queryout j:\Contract_Note\ContractNote_nonecn_'+replace(convert(varchar,@dt,103),'/','')+'.txt -c -t"," -Sanand1 -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'
set @NSEQUERY = '''' + @NSEQUERY + ''''
set @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY
print @NSEQUERY 
exec (@NSEQUERY)

GO
