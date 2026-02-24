-- Object: PROCEDURE dbo.acc_valansum
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROC acc_valansum
@branchcd as varchar(10),
@opendate as varchar(11),
@closdate as varchar(11),
@vtyp as varchar(2),
@booktype varchar(2),
@vno  varchar(12),
@reportoption char(1),
@baloption char(1),
@sortby varchar(10)
as

declare 
@@opbaldt as varchar(11),
@@wherepart as varchar(200),
@@frompart  as varchar(300),
@@selectpart as varchar(1000),
@@clbalpart  as varchar(1000),
@@addwhere   as varchar(100),
@@orderbypart as varchar(100)

select @@opbaldt = (select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger l 
                    where vtyp = 18 and vdt <= @opendate)

if @reportoption = 'P'
   begin
      select @@addwhere = " and a.accat in ( '4', '104')"
   end
else if @reportoption = 'O'
   begin
      select @@addwhere = " and a.accat not in ( '4', '104')"
   end
else
   begin
      select @@addwhere = " "
   end

if rtrim(@branchcd) = '%' 
   begin
	select @@selectpart = "select l.cltcode, a.acname, dramt = isnull((case when upper(drcr) = 'D' then vamt else 0 end ),0), cramt = isnull((case when upper(drcr) = 'C' then vamt else 0 end ),0), left(convert(varchar,vdt,103),10) vdt, "
	select @@clbalpart = " clbal =  ( select sum( case when upper(drcr) = 'D' then vamt else -vamt end) from ledger where vdt >= '" + rtrim(@@opbaldt) + " 00:00:00' and vdt <= '" + rtrim(@closdate) + " 23:59:59' and cltcode = l.cltcode )"
	select @@frompart = " from ledger l left outer join acmast a on l.cltcode = a.cltcode "
	select @@wherepart = " where l.vtyp = " + @vtyp + " and l.booktype = '" + @booktype + "' and l.vno = '" + @vno + "'"
        if upper(rtrim(@sortby)) = 'ACCODE'
	      select @@orderbypart = " Order by l.cltcode "
        else if upper(rtrim(@sortby)) = 'ACNAME'
		      select @@orderbypart = " Order by a.acname "
             else if upper(rtrim(@sortby)) = 'DRCR'
		      select @@orderbypart = " Order by l.drcr "
   end
else
   begin
	select @@selectpart = "	select l2.cltcode, a.acname, dramt = isnull((case when upper(drcr) = 'D' then camt else 0 end ),0),cramt = isnull((case when upper(drcr) = 'C' then camt else 0 end ),0), "
	select @@clbalpart = " clbal =  ( select sum( case when upper(ll2.drcr) = 'D' then camt else -camt end) from ledger2 ll2 left outer join ledger l on ll2.vtype = l.vtyp and ll2.booktype = l.booktype and ll2.vno = l.vno and ll2.lno = l.lno where l.vdt >= '" + rtrim(@@opbaldt) + " 00:00:00' and l.vdt <= '" + rtrim(@closdate) + " 23:59:59' and ll2.cltcode = l2.cltcode )"
	select @@frompart = " from ledger2 l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c "
	select @@wherepart = " where l2.vtype = " + @vtyp + " and l2.booktype = '" + @booktype + "' and l2.vno = '" + @vno + "'"
	select @@addwhere = @@addwhere + " and l2.costcode = c.costcode and c.costname = '" + rtrim(@branchcd) + "' "
        if upper(rtrim(@sortby)) = 'ACCODE'
	      select @@orderbypart = " Order by l2.cltcode "
        else if upper(rtrim(@sortby)) = 'ACNAME'
		      select @@orderbypart = " Order by a.acname "
             else if upper(rtrim(@sortby)) = 'DRCR'
		      select @@orderbypart = " Order by l2.drcr "
   end

print @@selectpart + @@clbalpart + @@frompart + @@wherepart + @@addwhere + @@orderbypart

exec ( @@selectpart + @@clbalpart + @@frompart + @@wherepart + @@addwhere + @@orderbypart )

GO
