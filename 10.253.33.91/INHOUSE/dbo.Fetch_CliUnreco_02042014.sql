-- Object: PROCEDURE dbo.Fetch_CliUnreco_02042014
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure Fetch_CliUnreco_02042014  
as  
  
set nocount on  
  
declare @fromdt as datetime,@todate as datetime  
select @fromdt=sdtcur,@todate=ldtcur from account.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()  
  
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
and l.narration not like 'BEING AMT RECD TECH PROCESS%'  
    
/*                              
select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno   
create clustered index co_pcode on BO_client_deposit_recno(cltcode)   
*/  
  
  
delete #recodet from #recodet a inner join MSAJAG.DBO.CLient1 b WITH (NOLOCK) on   
a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')   
  
truncate table BO_client_deposit_recno   
insert into BO_client_deposit_recno select co_code='NSECM',getdate(),* from #recodet (nolock)   
  
set nocount off

GO
