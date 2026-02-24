-- Object: PROCEDURE dbo.angel_Client_Payment_reco
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc angel_Client_Payment_reco        
as      
 
/*  
truncate table Client_Payment_reco_ACDL    
    
insert into Client_Payment_reco_ACDL    
select l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                     
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),                    
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),                     
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                  
--into #recodet                  
From account.dbo.ledger l  (nolock)  left outer join account.dbo.LEDGER1 L1  (nolock) on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno   where          
cltcode >='A0001' and cltcode <='ZZZZZ' and l.drcr='D'       
--and vdt <=@tdate-@daysbefore       
and clear_mode not in ( 'R', 'C') and l.vtyp  in (3)                    
and reldt ='1900-01-01 00:00:00.000'       
and vdt < getdate() 
*/

select l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                     
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),                    
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),                     
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                  
into #t                  
From account.dbo.ledger l  (nolock)  left outer join account.dbo.LEDGER1 L1  (nolock) on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno   where          
cltcode >='A0001' and cltcode <='ZZZZZ' and l.drcr='D'       
--and vdt <=@tdate-@daysbefore       
and clear_mode not in ( 'R', 'C') and l.vtyp  in (3)                    
and reldt ='1900-01-01 00:00:00.000'       
and vdt < getdate() 

truncate table Client_Payment_reco_ACDL    

insert into Client_Payment_reco_ACDL     

Select l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(l.ddno,'') as ddno, 
isnull(cltcode ,'') cltcode ,                       
isnull( acname ,'') acname, l.drcr, Dramt,                    
Cramt,                       
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                    
from #t L, 
account.dbo.LEDGER1 L1  (nolock)
where l.vno = l1.vno and l.ddno = l1.ddno and l1.vtyp <> 16

GO
