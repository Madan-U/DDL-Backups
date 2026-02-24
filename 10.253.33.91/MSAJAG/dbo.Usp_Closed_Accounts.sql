-- Object: PROCEDURE dbo.Usp_Closed_Accounts
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Usp_Closed_Accounts(@Fromdate as varchar(20),@Todate as varchar(20))
as
set nocount on

set @Fromdate = convert(varchar(11),convert(datetime,@Fromdate,103))+' 00:00:00'                
set @Todate = convert(varchar(11),convert(datetime,@Todate,103))+' 23:59:59' 

select party_code,b.cl_code,long_name,inactive_from,Exchange,Segment from 
(select * from client_details where rtrim(ltrim(long_name)) not like '%CLOSED%' and rtrim(ltrim(long_name)) not like '%(C)%' and rtrim(ltrim(long_name)) not like '%close%')a
inner join
(select * from client_brok_details where inactive_from < getdate() and Inactive_from >= @Fromdate and Inactive_from <= @Todate and Exchange not in ('NCX','MCX'))b
on a.party_code = b.cl_code order by long_name

GO
