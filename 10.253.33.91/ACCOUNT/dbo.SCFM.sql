-- Object: PROCEDURE dbo.SCFM
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
CREATE  proc [dbo].[SCFM]  (    
    
@TODATE  VARCHAR (11)    
)AS    

---SCFM 'MAR 29 2019'
BEGIN     

DECLARE @FROMDATE DATETIME 
 
SELECT @FROMDATE =sdtcur FROM PARAMETER WHERE @TODATE BETWEEN SDTCUR AND ldtcur 

select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #Nsecm 
from  ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE    
and cltcode between 'a' and 'zzzz9999'   
group by cltcode  


select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)      
   into #bsecm 
from AngelBSECM.account_ab.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE    
and cltcode between 'a' and 'zzzz9999'    
group by cltcode  
  
  
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #nsefo    
from angelfo.accountfo.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE    
and cltcode between 'a' and 'zzzz9999'    
group by cltcode   

 
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #nsx    
from angelfo.accountcurfo.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE   --   AND VNO <>'201700000001' AND VTYP <>'18'
and cltcode between 'a' and 'zzzz9999'    
group by cltcode    

 
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #mcd    
from angelcommodity.accountmcdxcds.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE     --- AND VNO <>'201700000001' AND VTYP <>'18'
and cltcode between 'a' and 'zzzz9999'    
group by cltcode    

select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #mtf    
from MTFTRADE.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE     --- AND VNO <>'201700000001' AND VTYP <>'18'
and cltcode between 'a' and 'zzzz9999'    
group by cltcode    

select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)     
into #bsx    
from ANGELCOMMODITY.ACCOUNTCURBFO.dbo.ledger with(nolock) where vdt >='mar 31 2018 23:59:59:000'  
and edt <@TODATE     --- AND VNO <>'201700000001' AND VTYP <>'18'
and cltcode between 'a' and 'zzzz9999'    
group by cltcode      
     
  
select * into #ab from (    
select * from #nsecm    WHERE RIGHT(CLTCODE,3)<> 'GST'
union all    
select * from #bsecm    WHERE RIGHT(CLTCODE,3) <> 'GST'
union all    
select * from #nsefo    WHERE RIGHT(CLTCODE,3)<> 'GST'
union all    
select * from #nsx  WHERE RIGHT(CLTCODE,3)<> 'GST'
union all    
select * from #mcd WHERE RIGHT(CLTCODE,3)<> 'GST'
union all    
select * from #mTF WHERE RIGHT(CLTCODE,3)<> 'GST' 
union all    
select * from #BSX WHERE RIGHT(CLTCODE,3)<> 'GST'  )x        
 
select cltcode,sum(netamt) as Balance  into #cc from #ab group by cltcode    
 
select * into #dd from #cc where balance <> 0    
    
  
select sum(balance)/10000000 AS CREDITOR from #dd where balance >0    
  union all  
select sum(balance)/10000000 AS DEBITOR from #dd where balance <0    
  
END

GO
