-- Object: PROCEDURE dbo.usp_nse_reco1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE PROCEDURE usp_nse_reco1                   
 as                     
set nocount on                     
set transaction isolation level read uncommitted           
          
/*RECO - check reconsiled suspense a/c with unrecosiled client ledger */        
        
select * into #nse_cr from ACCOUNT.DBO.ledger (nolock) where vdt >=getdate()-60 and vtyp=2 and drcr='C' and  cltcode='5100000002'        
        
select * into #nse_dr from ACCOUNT.DBO.ledger (nolock) where vdt >=getdate()-60 and vtyp=3 and drcr='D' and  cltcode='5100000002'        
        
select ddno,vno,lno,reldt into #chqnodr from ACCOUNT.DBO.ledger1 (nolock) where vtyp=3 and vno >='200801010000'          
            
select ddno,vno,lno,reldt into #chqno from ACCOUNT.DBO.ledger1 (nolock) where vtyp=2 and vno >='200801010000'              
        
select a.*,b.ddno,b.reldt into #nse1dr from #nse_dr a, #chqnodr b where a.vno=b.vno and a.lno=b.lno              
        
select a.*,b.ddno,b.reldt into #nse1 from #nse_cr a, #chqno b where a.vno=b.vno and a.lno=b.lno              
        
delete from #nse1 where cltcode+'|'+convert(varchar(25),ddno) in (select cltcode+'|'+convert(varchar(25),ddno)  from #nse1dr)          
        
delete from mis.bse.dbo.nse_reco1         
        
         
select  a.vtyp,a.vno,a.vdt,a.drcr,a.vamt,a.ddno,b.cltcode,b.ddno as ddno1,b.cramt,a.reldt ,a.edt, a.narration into #temp     
        
from        
        
(select * from #nse1  where cltcode='5100000002'  and reldt <> 'Jan  1 1900') a,        
        
ACCOUNT.DBO.angel_client_deposit_recno b where a.ddno=b.ddno and a.vamt=b.cramt        
        
insert into mis.bse.dbo.nse_reco1    
 select  a.*,b.cltcode,b.acname from #temp a inner join ACCOUNT.DBO.ledger b on a.vno=b.vno where b.drcr='d'and b.vtyp='2'               
    
----------------- check for unreconsiled suspense account        
        
--select * from #bse1  where cltcode='5100000001' and reldt ='Jan  1 1900'        
        
        
delete mis.bse.dbo.nse_noreco         
        
select vtyp,vno,edt,acname,drcr,vamt,balamt,cltcode,ddno,vdt,narration into #temp1 from #nse1  where cltcode='5100000002' and reldt ='Jan  1 1900'        
    
insert into  mis.bse.dbo.nse_noreco     
select a.*,b.cltcode,b.acname from #temp1 a inner join ACCOUNT.DBO.ledger b on a.vno=b.vno where b.drcr='d' and b.vtyp='2'

GO
