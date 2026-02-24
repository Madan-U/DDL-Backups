-- Object: PROCEDURE dbo.rpt_voucherreport
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/*execute rpt_voucherreport 'Apr 11 2006','Apr 28 2006','8','%'


select * from ledger where vtyp = 8 and vdt between 'Apr 11 2006' and 'Apr 30 2006 23:59'
*/
/****** Object:  Stored Procedure dbo.rpt_voucherreport    Script Date: 10/11/2001 12:34:54 PM ******/  
CREATE PROCEDURE rpt_voucherreport  
@fromdt varchar(15),  
@todt varchar(15),  
@typ int,  
@vno varchar(15)  
  
as  
  
if @vno = '%'  
begin  
  
  
if @typ in ('2','3','5','6','7','15','16','17','19','20','21')   
begin  
select distinct l.cltcode,ltrim(rtrim(l.acname)) as acname ,l.vno,l.vtyp,  
left(convert(varchar,l.vdt,109),11) as vdt ,l1.ddno,  
cramt=case when l.drcr='C' then vamt else 0 end,  
dramt=case when l.drcr='D' then vamt else 0 end,  
left(convert(varchar,l.edt,109),11) as edt,l.lno, narration  
from ledger l,ledger1 l1  
where l.vdt >= @fromdt   
and l.vdt <= @todt+' 23:59:59'   
and l.vtyp=@typ   
and l1.vtyp=l.vtyp   
and l.vno=l1.vno  
order by l.vtyp,l.vno  
end  
  
if @typ not in ('2','3','5','6','7','15','16','17','19','20','21')   
begin  
select distinct l.cltcode,ltrim(rtrim(l.acname)) as acname ,l.vno,l.vtyp,  
left(convert(varchar,l.vdt,109),11) as vdt ,ddno=0,  
cramt=case when l.drcr='C' then vamt else 0 end,  
dramt=case when l.drcr='D' then vamt else 0 end,  
left(convert(varchar,l.edt,109),11) as edt,l.lno, narration  
from ledger l  
where l.vdt >= @fromdt   
and l.vdt <= @todt+' 23:59:59'   
and l.vtyp=@typ   
order by l.vtyp,l.vno  
end  
  
end  
  
  
  
  
  
if @vno <> '%'  
begin  
if @typ in ('2','3','5','6','7','15','16','17','19','20','21')   
begin  
select distinct l.cltcode,ltrim(rtrim(l.acname)) as acname ,l.vno,l.vtyp,  
left(convert(varchar,l.vdt,109),11) as vdt ,l1.ddno,  
cramt=case when l.drcr='C' then vamt else 0 end,  
dramt=case when l.drcr='D' then vamt else 0 end,  
left(convert(varchar,l.edt,109),11) as edt,l.lno, narration  
from ledger l,ledger1 l1  
where l.vdt >= @fromdt   
and l.vdt <= @todt+' 23:59:59'   
and l.vtyp=@typ   
and l.vno=@vno   
and l1.vtyp=l.vtyp   
and l.vno=l1.vno  
order by l.vtyp,l.vno  
end  
  
if @typ not in ('2','3','5','6','7','15','16','17','19','20','21')   
begin  
select distinct l.cltcode,ltrim(rtrim(l.acname)) as acname ,l.vno,l.vtyp,  
left(convert(varchar,l.vdt,109),11) as vdt ,ddno=0,  
cramt=case when l.drcr='C' then vamt else 0 end,  
dramt=case when l.drcr='D' then vamt else 0 end,  
left(convert(varchar,l.edt,109),11) as edt,l.lno, narration  
from ledger l  
where l.vdt >= @fromdt   
and l.vdt <= @todt+' 23:59:59'   
and l.vtyp=@typ   
and l.vno=@vno   
order by l.vtyp,l.vno  
end  
  
  
end

GO
