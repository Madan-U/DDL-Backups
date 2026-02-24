-- Object: PROCEDURE dbo.Angel_checkSuspFundsTrfClient
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create procedure Angel_checkSuspFundsTrfClient(@fdate as varchar(11))
as

SET NOCOUNT ON

declare @fvno as varchar(12)
--set @fdate = 'Jan 25 2008'
select @fvno=replace(convert(varchar(11),convert(Datetime,@fdate),111),'/','')+'0000'


select * into #bse_cr from ledger (nolock) where vdt >=@fdate+' 00:00' and vtyp=2 and drcr='C' and  cltcode='5100000002'
select * into #bse_dr from ledger (nolock) where vdt >=@fdate+' 00:00' and vtyp=3 and drcr='D' and  cltcode='5100000002'

select ddno,vno,lno,refno into #chqno from ledger1 (nolock) where vtyp=2 and vno >=@fvno  
select ddno,vno,lno,refno into #chqnodr from ledger1 (nolock) where vtyp=3 and vno >=@fvno      


select a.*,b.ddno,crn=b.refno into #bse1 from #bse_cr a, #chqno b where a.vno=b.vno and a.lno=b.lno      
select a.*,b.ddno,crn=b.refno into #bse1dr from #bse_dr a, #chqnodr b where a.vno=b.vno and a.lno=b.lno      


delete from #bse1       
where cltcode+'|'+convert(varchar(25),ddno)       
in (select cltcode+'|'+convert(varchar(25),ddno)  from #bse1dr)      


select Accno=reverse(substring(reverse(description),1,charindex('-',reverse(description))-1)),crossreferenceno,
BankCode=Cltcode,valueDate,chqno=referenceno,status,amount,drcr
into #file1
from bankreco (nolock) where description like 'FUNDS TRAN%'
and crossreferenceno in (select crn from #bse1)


select * into #file2 from 
(select * from #file1  where isnumeric(accno)=1) a, 
(
select branch_cd,Sub_broker,party_Code,long_name,AC_num from intranet.risk.dbo.client_Details 
where isnumeric(ac_num)=1 and ac_num <> '0'
)
b where convert(float,a.accno)=convert(float,b.ac_num)

select BankCode,Chqno,Status,BankAmt=a.amount,CliAccno=a.accno,
party_code,party_name=Long_name,Vno,vdt,vamt,narration,ddno,Crn
from #file2 a, #bse1 b where b.crn=a.crossreferenceno


SET NOCOUNT OFF

GO
