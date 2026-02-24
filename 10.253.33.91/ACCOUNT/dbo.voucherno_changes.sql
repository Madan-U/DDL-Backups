-- Object: PROCEDURE dbo.voucherno_changes
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc voucherno_changes
AS

DECLARE 
@@balcur as cursor,       
@@vno as varchar(12),       
@@vdt as varchar(11),       
@@vtyp as varchar(2),       
@@MaxVno as numeric(12,0)

set @@balcur = cursor for                        
select * from ledger_voucherchanges
order by vno
    
open @@balcur                        
fetch next from @@balcur into  @@vno,@@vdt,@@vtyp
    
while @@fetch_status = 0                        
begin           

							select @@maxvno = isnull(max(convert(NUMERIC,lastvno)),0) from lastvno WITH (TABLOCKX,HOLDLOCK) where vtyp = '4' and booktype = '01' and vdt like @@vdt + '%'

							update ledger set vno = rtrim(convert(varchar,@@maxvno + 1)), vno1 = rtrim(convert(varchar,@@maxvno + 1)) where vno=@@vno and vtyp='4' and booktype='01'
							update ledger2 set vno = rtrim(convert(varchar,@@maxvno + 1)) where vno=@@vno and vtype='4' and booktype='01'
							update ledger3 set vno = rtrim(convert(varchar,@@maxvno + 1)) where vno=@@vno and vtyp='4' and booktype='01'

							update lastvno set lastvno = rtrim(convert(varchar,@@maxvno + 1)) where vdt like @@vdt + '%' and lastvno = rtrim(convert(varchar,@@maxvno)) and vtyp='4' and booktype='01'

           fetch next from @@balcur into  @@vno,@@vdt,@@vtyp
         
end

select distinct vno,left(vdt,11) vdt, vtyp from ledger where vno>= '200502010065' and vno<='200502010157' and vtyp='4' and vdt not like 'Feb  1 2005%'

GO
