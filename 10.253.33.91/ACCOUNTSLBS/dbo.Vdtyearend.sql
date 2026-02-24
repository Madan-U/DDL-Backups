-- Object: PROCEDURE dbo.Vdtyearend
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Procedure Vdtyearend  
@sdtcur varchar(11),  
@ldtcur varchar(11),  
@vtyp   smallint,  
@vno varchar(12),  
@BookType char(2),  
@vdt    datetime,  
@msg1   varchar(234)  
AS  
declare  
@@cltcode as varchar(10),  
@@acname  as varchar(100),  
@@vdtbal  as money,  
@@lno     as int,  
@@cdt     as datetime,  
@@netdiff as money,  
@@plcount as int,  
@@plbal   as money,  
@@rcursor as cursor,
@@FixCode Varchar(10) 

Select @@FixCode = '999999'

select @@cdt = ( select getdate() )  
  
set @@rcursor = cursor for  
select l.cltcode,l.acname , balance=isnull(sum( case when upper(drcr) = 'D' then vamt else -vamt end),0)  
from ledger l left outer join acmast a on l.cltcode = a.cltcode  
where l.vdt > = @sdtcur + ' 00:00:00' and l.vdt <= @ldtcur + ' 23:59:59'  
and (a.actyp like 'ASS%' or a.actyp like 'LIAB%') and l.cltcode <> @@FixCode  
group by l.cltcode,l.acname  
order by l.cltcode,l.acname  
  
open @@rcursor  
fetch next from @@rcursor   
into @@cltcode, @@acname, @@vdtbal  
  
select @@lno = 0  
select @@netdiff = 0  
while @@fetch_status = 0  
begin  
   select @@lno = @@lno + 1  
   select @@netdiff = @@netdiff + @@vdtbal  
  
   Insert into ledger(vtyp,vno,drcr,vamt,vdt,refno,cltcode,  
                      EnteredBy,lno,balamt,Vno1,booktype,edt,cdt,pdt,NoDays,actnodays,CheckedBy,acname,narration)   
               values (@vtyp,@vno,(case when @@vdtbal >= 0 then 'D' else 'C' end),isnull(abs(@@vdtbal),0),@vdt,'',upper(@@cltcode),  
                       'System',@@lno,0,@Vno,@booktype,@vdt,@@cdt,@@cdt,0,0,'System',@@acname,@msg1)  
  
  
   Insert into ledger3(naratno,narr,refno,vtyp,vno,BookType)   
                values(@@lno,@msg1,'',@vtyp,@vno,@BookType)  
  
   fetch next from @@rcursor   
   into @@cltcode, @@acname, @@vdtbal  
end  
  
close @@rcursor  
deallocate @@rcursor  
  
select @@lno = @@lno + 1  
select @@acname = ( select acname from acmast where cltcode = @@FixCode)  
Insert into ledger(vtyp,vno,drcr,vamt,vdt,refno,cltcode,  
                   EnteredBy,lno,balamt,Vno1,booktype,edt,cdt,pdt,NoDays,actnodays,CheckedBy,acname,narration)   
            values (@vtyp,@vno,(case when @@netdiff >= 0 then 'C' else 'D' end),abs(@@netdiff),@vdt,'',@@FixCode,  
                    'System',@@lno,0,@Vno,@booktype,@vdt,@@cdt,@@cdt,0,0,'System',@@acname,@msg1)  
  
  
Insert into ledger3  
select lno, narration, refno, vtyp, vno, BookType  
from ledger  
where vtyp = @vtyp and booktype = @booktype and vno = @vno and  cltcode=@@FixCode  
  
Insert into ledger3  
select 0, narration, refno, vtyp, vno, BookType  
from ledger  
where vtyp = @vtyp and booktype = @booktype and vno = @vno and lno = 1

GO
