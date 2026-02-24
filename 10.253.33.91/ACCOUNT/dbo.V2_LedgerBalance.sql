-- Object: PROCEDURE dbo.V2_LedgerBalance
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Proc V2_LedgerBalance
(
	@fromcltCode varchar(15),
	@tocltCode varchar(15)
--	@currDate varchar(11)
)

as
set nocount on
declare @currDate  as varchar(11)
set @currDate = convert(varchar(11),getdate())

/*
V2_LedgerBalance '0000000000','zzzzzzzzzz','Feb  2 2006'
*/

Declare @StartDate varchar(11)

set transaction isolation level read uncommitted
select 
	@StartDate = left(sdtcur,11) 
from 
	parameter (nolock)
where 
	@currDate between sdtcur and ldtcur


Set Transaction Isolation level Read Uncommitted
Select 
	CltCode, 
	AcName 
into 
	#AcMast
from 
	AcMast (nolock)
where 
	cltcode >= @fromcltcode
	and cltcode <= @tocltcode
	and accat = '4'

Create Clustered Index TempIDx on #Acmast(CltCode)

set transaction isolation level read uncommitted

truncate table Angel_TB

insert into Angel_TB
Select CltCode, AcName, BalAmt = sum(Case when Drcr = 'D' then Vamt else -Vamt end)
--into angel_tb
From
(
	select a.CltCode, a.AcName, l.DrCr, Vamt = sum(l.vamt)
	from Ledger l (nolock), #AcMast a with(index(tempidx),nolock)
	where l.cltcode = a.CltCode
	and l.Vdt >= @StartDate
	and l.Vdt <= @currDate + ' 23:59:00'
	Group by a.CltCode, A.AcName, L.drcr
) x
group by CltCode, AcName 

drop table #AcMast

set nocount off

GO
