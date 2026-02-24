-- Object: PROCEDURE dbo.JV_LedgerBalance
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Proc JV_LedgerBalance        
(        
 @fromcltCode varchar(15),        
 @tocltCode varchar(15)        
-- @currDate varchar(11)        
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
        
        
set transaction isolation level read uncommitted        
        
Select CltCode, AcName=space(10), BalAmt = sum(Case when Drcr = 'C' then -Vamt else Vamt end)        
into #vdt_file      
From        
(        
 select CltCode, l.DrCr, Vamt = sum(l.vamt)      
 from Ledger l (nolock)       
 where l.Vdt >= @StartDate        
 and l.Vdt <= @currDate + ' 23:59:00'        
 and cltcode >='A00001' and cltcode <='ZZZZZZ'      
 Group by CltCode, L.drcr       
) x        
group by CltCode      
      
      
Select CltCode, AcName=space(10), BalAmt = sum(Case when Drcr = 'C' then -Vamt else Vamt end)        
into #edt_file      
From        
(        
 select CltCode, l.DrCr, Vamt = sum(l.vamt)        
 from Ledger l (nolock)      
 where l.edt >= @StartDate        
 and l.edt <= @currDate + ' 23:59:00'        
 and cltcode >='A00001' and cltcode <='ZZZZZZ'      
 Group by CltCode, L.drcr        
) x        
group by CltCode      
      
      
truncate table Angel_JV      
       
insert into Angel_JV      
select a.cltcode,a.acname,      
balamt=(case when a.balamt <= isnull(b.balamt,0) then isnull(b.balamt,0) else a.balamt end)      
from #vdt_file a left outer join #edt_file b on a.cltcode=b.cltcode      
      
        
--drop table #AcMast        
        
set nocount off

GO
