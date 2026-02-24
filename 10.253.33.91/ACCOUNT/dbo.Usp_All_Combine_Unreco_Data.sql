-- Object: PROCEDURE dbo.Usp_All_Combine_Unreco_Data
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

      
--exec Usp_All_Combine_Unreco_Data      
CREATE Proc [dbo].[Usp_All_Combine_Unreco_Data]      
As      
BEGIN       
      
--drop table Tbl_unreco_Data      
/*--------------------------------(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%' AND l.narration not like 'AMOUNT RECEIVED%' AND l.narration not like 'Amount Received%')         
added by rahul shah 25-07-2022*/      
      
      
declare @fromdt as datetime,@todate as datetime                
select @fromdt=sdtcur from account.dbo.parameter with (nolock) where sdtnxt = (select sdtcur  from account.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())                
select @todate=ldtcur from account.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate()       
      
select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet              
from account.dbo.LEDGER b with (nolock)               
where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1              
      
select               
bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo              
into #ANAND1_196    --2 50 583          
from INHOUSE.dbo.ledger1 with (nolock)              
where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )           
      
select t.*,l.accno into #ledger1 from #vdet l join #ANAND1_196 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype      
      
select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,               
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),               
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),               
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()               
into #recodet_196               
From account.dbo.LEDGER l with (nolock)              
join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno              
and vdt <= getdate()               
and             
(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%' AND l.narration not like 'AMOUNT RECEIVED%' AND l.narration not like 'Amount Received%')         
      
      
      
      
      
      
--declare @fromdt as datetime,@todate as datetime                
select @fromdt=sdtcur from [AngelFO].accountfo.dbo.parameter with (nolock)  where sdtnxt = (select sdtcur        
from [AngelFO].accountfo.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())                
select @todate=ldtcur from [AngelFO].accountfo.dbo.parameter with (nolock)  where sdtcur <= getdate() and ldtcur >=getdate()                
            
        
                       
select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet_accountfo              
from [AngelFO].accountfo.dbo.ledger b with (nolock)               
where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1              
               
select               
bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo              
into #ACCOUNTFO_200              
from [AngelFO].ACCOUNTFO.dbo.ledger1 with (nolock)              
where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )               
               
select t.*,l.accno into #ACCOUNTFO_ledger1 from #vdet_accountfo l join #ACCOUNTFO_200 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype               
               
               
select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,               
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),               
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),               
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()               
into #recodet_200              
From [AngelFO].ACCOUNTFO.dbo.LEDGER l with (nolock)              
join #ACCOUNTFO_ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno              
and vdt <= getdate()  AND             
(l.narration not like 'BEING AMT RECD TECH PROCESS%' AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%' AND l.narration not like 'AMOUNT RECEIVED%' AND l.narration not like 'Amount Received%')      
/*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')       */       
      
      
      
      
      
--declare @fromdt as datetime,@todate as datetime                  
select @fromdt=sdtcur from [AngelBSECM].account_ab.dbo.parameter with (nolock)   where sdtnxt = (select sdtcur  from [AngelBSECM].account_ab.dbo.parameter  with (nolock)   where sdtcur <= getdate() and ldtcur >=getdate())                  
select @todate=ldtcur from [AngelBSECM].account_ab.dbo.parameter  with (nolock)  where sdtcur <= getdate() and ldtcur >=getdate()                  
         
                
select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet_Anand                
from [AngelBSECM].account_ab.dbo.ledger b with (nolock)                 
where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1                
                 
select                 
bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo                
into #Anand_201                
from [AngelBSECM].account_ab.dbo.ledger1 with (nolock)                
where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )                 
                 
select t.*,l.accno into #ledger1_201 from #vdet_Anand l join #Anand_201 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype                 
                            
select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                 
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),                 
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),                 
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                 
into #recodet_201                 
From [AngelBSECM].account_ab.dbo.LEDGER l with (nolock)                
join #ledger1_201 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno                
and vdt <= getdate() AND                
(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%' AND l.narration not like 'AMOUNT RECEIVED%' AND l.narration not like 'Amount Received%')         
      
       
       
      
      
      
--declare @fromdt as datetime,@todate as datetime                  
--select @fromdt=sdtcur from [AngelCommodity].account_ab.dbo.parameter with (nolock)   where sdtnxt = (select sdtcur  from [AngelCommodity].account_ab.dbo.parameter  with (nolock)   where sdtcur <= getdate() and ldtcur >=getdate())                  
--select @todate=ldtcur from [AngelCommodity].account_ab.dbo.parameter  with (nolock)  where sdtcur <= getdate() and ldtcur >=getdate()                  
         
                
--select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet                
--from [AngelCommodity].account_ab.dbo.ledger b with (nolock)                 
--where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1   
                 
--select                 
--bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo                
--into #ANGELCOMMODITY_204                
--from [AngelCommodity].account_ab.dbo.ledger1 with (nolock)                
--where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )                 
                 
--select t.*,l.accno into #ledger1 from #vdet l join #ANGELCOMMODITY_204 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype                 
                 
                 
--select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                 
--isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),                 
--Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),                 
--treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                 
--into #recodet                 
--From [AngelCommodity].account_ab.dbo.LEDGER l with (nolock)                
--join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno                
--and vdt <= getdate() AND                
--(l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%' AND l.narration not like 'AMOUNT RECEIVED%')         
      
--into Tbl_unreco_Data      
      
select  *  from #recodet_196--2202      
union all      
select  * from #recodet_201--95      
union all      
select  * from #recodet_200--36      
      
      
END

GO
