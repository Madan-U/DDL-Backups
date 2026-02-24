-- Object: PROCEDURE dbo.Fetch_CliUnreco_bond
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure [dbo].[Fetch_CliUnreco_bond](@pcode as varchar(10) = null)        
as        
        
set nocount on        
        
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/        
declare @fromdt as datetime,@todate as datetime          
select @fromdt=sdtcur from account.dbo.parameter where sdtnxt = (select sdtcur  from account.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())          
select @todate=ldtcur from account.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()          
--------END-----------         
  
IF @pcode is null  
BEGIN  
         
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet        
 from account.dbo.LEDGER b with (nolock)         
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1        
         
 select         
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo        
 into #led1        
 from account.dbo.ledger1 with (nolock)        
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         
         
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype         
         
         
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
 into #recodet         
 From account.dbo.LEDGER l with (nolock)        
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and vdt <= getdate()         
 and       
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%') 
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
     
       
 delete #recodet from #recodet a inner join MSAJAG.DBO.CLient1 b WITH (NOLOCK) on         
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
         
 truncate table BO_client_deposit_recno_bond         
 insert into BO_client_deposit_recno_bond select co_code='NSECM',getdate(),* from #recodet (nolock)         
END  
ELSE  
BEGIN  
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet        
 from account.dbo.LEDGER b with (nolock)         
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode  
  
 select         
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,  
 accno=space(10)        
 into #ledger1c        
 from account.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype       
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc        
 from account.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp  
 /* where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1 */  
 where  a.lno=1  and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') 
 
  
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype  
  
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
 into #recodetc         
 From account.dbo.LEDGER l with (nolock)        
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and vdt <= getdate()         
 and       
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')  
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
    
       
 delete #recodetc from #recodetc a inner join MSAJAG.DBO.CLient1 b WITH (NOLOCK) on         
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
         
 delete from BO_client_deposit_recno_bond where cltcode=@pcode        
 insert into BO_client_deposit_recno_bond select co_code='NSECM',getdate(),* from #recodetc (nolock)         
  
END  
  
set nocount off

GO
