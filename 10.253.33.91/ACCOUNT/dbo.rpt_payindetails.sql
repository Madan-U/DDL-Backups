-- Object: PROCEDURE dbo.rpt_payindetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_payindetails    Script Date: 12/29/01 12:14:48 PM ******/
/****** Object:  Stored Procedure dbo.rpt_payindetails    Script Date: 12/11/01 9:43:45 PM ******/
CREATE procedure rpt_payindetails
@dt varchar(12),
@branchcd varchar(10)

as

if @branchcd = ''

begin

select ledger.cltcode,ledger.acname,ledger.drcr,vamt = (case when drcr = 'c' then vamt * -1 else vamt end),edt,left(convert(varchar,edt,109),11),
a.accat,c2.cl_code,c1.branch_cd,b.branch,ledger.vdt,c1.sub_broker
from ledger,acmast a,msajag.dbo.client1 c1,msajag.dbo.client2 c2,msajag.dbo.branch b
where /*ledger.vtyp = 15 
and*/ edt >= left(convert(varchar,@dt,109),11) 
and vdt <= @dt + ' 23:59:59'
and ltrim(ledger.cltcode) = ltrim(a.cltcode)
and ltrim(ledger.cltcode) = ltrim(c2.party_code)
and ltrim(c2.cl_code) = ltrim(c1.cl_code)
and ltrim(c1.branch_cd) = ltrim(b.branch_code)

order by b.branch,c1.sub_broker,ledger.cltcode,ledger.edt

end 

if @branchcd <>''
begin

select ledger.cltcode,ledger.acname,ledger.drcr,vamt = (case when drcr = 'c' then vamt * -1 else vamt end),edt,left(convert(varchar,edt,109),11),
a.accat,c2.cl_code,c1.branch_cd,b.branch,ledger.vdt,c1.sub_broker
from ledger,acmast a,msajag.dbo.client1 c1,msajag.dbo.client2 c2,msajag.dbo.branch b
where /*ledger.vtyp = 15 
and*/ edt >= left(convert(varchar,@dt,109),11) 
and vdt <= @dt + ' 23:59:59'
and ltrim(ledger.cltcode) = ltrim(a.cltcode)
and ltrim(ledger.cltcode) = ltrim(c2.party_code)
and ltrim(c2.cl_code) = ltrim(c1.cl_code)
and ltrim(c1.branch_cd) = ltrim(b.branch_code)
and ltrim(c1.branch_cd) like @branchcd
order by b.branch,c1.sub_broker,ledger.cltcode,ledger.edt

end

GO
