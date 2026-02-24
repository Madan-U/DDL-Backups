-- Object: PROCEDURE dbo.Angel_FranchiseeFetch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Procedure Angel_FranchiseeFetch(@fydate as varchar(25),@tdate as varchar(25))      
as      
      
Set Nocount On      
      
Set transaction isolation level read uncommitted      
select code into #file      
from mis.remisior.dbo.Franchisee_glcode_Mast       
where segment='ACDLCM' and flag<>'X' union select '520012'      
      
truncate table angel_tempnse      
      
insert into angel_tempnse      
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode      
from dbo.ledger l(nolock)  , dbo.ledger2 l2 (nolock)                                        
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18                     
and l2.cltcode IN( select code from #file)                     
and l.vtyp = l2.vtype                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno       
      
Set Nocount OFF

GO
