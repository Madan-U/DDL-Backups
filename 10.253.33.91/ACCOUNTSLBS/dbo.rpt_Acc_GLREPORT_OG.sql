-- Object: PROCEDURE dbo.rpt_Acc_GLREPORT_OG
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Proc [dbo].[rpt_Acc_GLREPORT_OG]    
 @sdate varchar(11),            /* As mmm dd yyyy */    
 @edate varchar(11),            /* As mmm dd yyyy */    
 @fdate varchar(11),            /* As mmm dd yyyy */    
 @tdate varchar(11),            /* As mmm dd yyyy */    
 @fcode varchar(10),    
 @tcode varchar(10),    
 @statusId varchar(30),    
 @statusname varchar(30),    
 @branch varchar(10),    
 @selectionby varchar(3),    
 @GroupBy varchar(10),    
 @Sortby varchar(50),    
 @reportname varchar(30),    
 @reportopt varchar(10)    
    
AS    
    
declare    
 @@opendate as varchar(11)    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
Select @@opendate = convert(varchar(11),max(vdt),109) from ledger where vtyp='18' and vdt <= @fdate     
    
    
Select cltcode,vamt as opbal into #opbal from ledger  where 1 =2    
    
Select    
 l.booktype,    
 voudt1=l.vdt,    
 effdt1=l.edt,    
 isnull(shortdesc,'') shortdesc,    
 dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),    
 cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end),    
 l.vno,    
 Replace( l.narration,'"','') narration,    
 ddno=isnull((select top 1 ddno from ledger1 where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''),    
 l.cltcode,    
 a.longname,    
 vdt,    
 l.vtyp,    
 accat,    
 Vamt as opbal,    
 crosac=l.cltcode,    
 isnull(a.acname,'') acname,    
 isnull(a.branchcode,'') branchcode,    
 lno    
into    
 #temptable_gl    
From    
 Ledger l,    
 Acmast a,    
 Vmast v    
where    
 1 = 2    
    
    
if @selectionby = 'vdt'    
 BEGIN    
  if rtrim(@branch) = '' or rtrim(@branch) = '%'    
   BEGIN    
    If @@opendate = @fdate    
    begin    
     Insert into #opbal    
     Select    
      cltcode,    
      sum(case drcr when 'D' then vamt else -vamt end) as opbal    
     from    
      ledger    
     where    
      cltcode between @fcode and @tcode    
      and vdt like @@opendate + '%' and vtyp = 18    
     Group by cltcode    
     Order by cltcode    
    end    
    else    
    begin    
     Insert into #opbal    
     Select    
      cltcode,    
      sum(case drcr when 'D' then vamt else -vamt end) as opbal    
     from    
      ledger    
     where    
      cltcode between @fcode and @tcode    
      and vdt >= @@opendate and vdt < @fdate    
     Group by cltcode    
     Order by cltcode    
    end    
    
    Insert into #temptable_gl    
    Select    
     l.booktype,    
     voudt1=l.vdt,    
     effdt1=l.edt,    
     isnull(shortdesc,'') shortdesc,    
     dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),    
     cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end),    
     l.vno,    
     Replace( l.narration,'"','') narration,    
     ddno=isnull((select top 1 ddno from ledger1 where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''),    
     l.cltcode,    
     a.longname,    
     vdt,    
     l.vtyp,    
     accat,    
     opbal=0,    
     crosac='',    
     a.acname,    
     a.branchcode,    
     l.lno    
    from    
     Ledger l,    
     Acmast a,    
     Vmast v    
    Where    
     l.vdt between @fdate and @tdate + ' 23:59:59'    
     And vtyp = vtype    
     and l.cltcode = a.cltcode    
     and l.cltcode between @fcode and @tcode    
     and (a.accat LIKE '3%'  or a.accat like '14%'  or a.accat LIKE '103%')    
    Order by    
     l.cltcode,    
     voudt1,    
     l.vtyp desc,    
     l.vno    
   END    
  ELSE    
   BEGIN    
    insert into #opbal    
    Select    
     l2.cltcode,    
     sum(case l2.drcr when 'D' then camt else -camt end) as opbal    
    from    
     ledger2 l2,    
     ledger l    
    where    
     l2.cltcode between @fcode and @tcode    
     and l.vtyp=l2.vtype    
     and l.booktype=l2.booktype    
  and l.vno=l2.vno    
     and l.lno=l2.lno    
     and vdt between @@opendate and @fdate    
    Group by l2.cltcode    
    Order by l2.cltcode    
    
    insert into #temptable_gl    
    Select    
     l.booktype,    
     voudt1=l.vdt,    
     effdt1=l.edt,    
     isnull(shortdesc,'') shortdesc,    
     dramt=(case when upper(l2.drcr) = 'D' then camt else 0 end),    
     cramt=(case when upper(l2.drcr) = 'C' then camt else 0 end),    
     l.vno,    
     Replace( l.narration,'"','') narration,    
     ddno=isnull((select top 1 ddno from ledger1 where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''),    
     l2.cltcode,    
     a.longname,    
     vdt,    
     l.vtyp,    
     accat,    
     opbal=0,    
     crosac='',    
     a.acname,    
     a.branchcode,    
     l.lno    
    from    
     ledger l,    
     vmast v,    
     ledger2 l2,    
     acmast a,    
     costmast c    
    Where    
     l.vdt between @fdate and @tdate + ' 23:59:59'    
     and l.vtyp = l2.vtype    
     and  l.vno = l2.vno    
     and l.lno = l2.lno    
     and l.booktype = l2.booktype    
     and l2.cltcode=a.cltcode    
     and l.vtyp = v.vtype    
     and l2.cltcode between @fcode and  @tcode    
     and a.accat <> '4'    
     and costname = rtrim(@branch)    
     and l2.costcode = c.costcode    
     and  l2.vtype <> 18    
    order by    
     l2.cltcode,    
     voudt1,    
     l.vtyp desc,    
     l.vno    
   END    
 END    
ELSE    
 BEGIN    
  if rtrim(@branch) = '' or rtrim(@branch) = '%'    
   BEGIN    
   If @@opendate = @fdate    
   begin    
    insert into #opbal    
    Select    
     cltcode,    
     sum(opbal) opbal    
    from    
     (    
      Select    
       Cltcode,    
       sum(case drcr when 'D' then vamt else -vamt end) as opbal    
      from    
       ledger    
      where    
       Cltcode between @fcode and @tcode    
       and vdt like @@opendate + '%' and vtyp = 18    
      Group by    
       Cltcode    
     union ALL    
      Select    
       cltcode,    
       sum(case drcr when 'C' then vamt else -vamt end) as opbal    
      from    
       ledger    
      Where    
       cltcode between  @fcode and  @tcode    
       and vdt < @@opendate    
       and edt >= @@opendate    
       Group by cltcode    
     ) t    
    Group by cltcode    
    Order by cltcode    
   end    
   else    
   begin    
    insert into #opbal    
    Select    
     cltcode,    
     sum(opbal) opbal    
    from    
     (    
      Select    
       Cltcode,    
       sum(case drcr when 'D' then vamt else -vamt end) as opbal    
      from    
       ledger    
      where    
       Cltcode between @fcode and @tcode    
       and edt >= @@opendate and edt < @fdate    
      Group by    
       Cltcode    
     union ALL    
      Select    
       cltcode,    
       sum(case drcr when 'C' then vamt else -vamt end) as opbal    
      from    
       ledger    
      Where    
       cltcode between  @fcode and  @tcode    
       and vdt < @@opendate    
       and edt >= @@opendate    
       Group by cltcode    
     ) t    
    Group by cltcode    
    Order by cltcode    
   end    
    
    insert into #temptable_gl    
    Select    
     l.booktype,    
     voudt1=l.vdt,    
     effdt1=l.edt,    
     isnull(shortdesc,'') shortdesc,    
     dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),    
     cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end),    
     l.vno,    
     Replace( l.narration,'"','') narration,    
     ddno=isnull((select top 1 ddno from ledger1 where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''),    
     l.cltcode,    
     a.longname,    
     vdt,    
     l.vtyp,    
     accat,    
     opbal=0,    
     crosac='',    
     a.acname,    
     a.branchcode,    
     l.lno    
    from    
     Ledger l,    
     acmast a,    
     vmast v    
    Where    
     vtyp = vtype    
     and a.cltcode = l.cltcode    
     and l.cltcode between @fcode and @tcode    
     and  l.edt between @fdate and @tdate + ' 23:59:59'    
     and l.vtyp <> 18    
     and (a.accat LIKE '3%'  or a.accat like '14%'  or a.accat LIKE '103%')    
    order by    
     l.cltcode,    
     voudt1,    
     l.vtyp desc,    
     l.vno    
   END    
  ELSE    
   BEGIN    
    insert into #opbal    
    Select    
     cltcode,    
     sum(opbal) opbal    
    from    
     (    
      Select    
       l2.cltcode,    
       sum(case l2.drcr when 'D' then camt else -camt end) as opbal    
      from    
       ledger2 l2,    
       ledger l    
      where    
       vdt between @@opendate and @fdate    
       and l.vno=l2.vno    
       and l.vtyp=l2.vtype    
       and l.booktype=l2.booktype    
       and l.lno=l2.lno    
       and l2.cltcode between @fcode and @tcode    
      Group by    
       l2.cltcode    
      union ALL    
       Select    
        l2.cltcode,    
        sum(case l2.drcr when 'C' then camt else -camt end) as opbal    
       from    
        ledger2 l2,    
        ledger l    
       where    
        l.vno=l2.vno    
        and l.vtyp=l2.vtype    
        and l.booktype=l2.booktype    
        and l.lno=l2.lno    
        and vdt < @@opendate    
        and edt >= @@opendate    
        and l2.cltcode between @fcode and @tcode    
       Group by    
        l2.cltcode    
     ) t    
    Group by    
     cltcode    
    Order by    
     cltcode    
    insert into #temptable_gl    
    Select    
     l.booktype,    
     voudt1=l.vdt,    
     effdt1=l.edt,    
     isnull(shortdesc,'') shortdesc,    
     dramt=(case when upper(l2.drcr) = 'D' then camt else 0 end),    
     cramt=(case when upper(l2.drcr) = 'C' then camt else 0 end),    
     l.vno,    
     Replace(l.narration,'"','') narration,    
     ddno=isnull((select top 1 ddno from ledger1 where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''),    
     l2.cltcode,    
     a.longname,    
     vdt,    
     l.vtyp,    
     accat,    
     opbal=0,    
     crosac='',    
     a.acname,    
     a.branchcode,    
     l.lno    
    from    
     ledger l,    
     vmast v,    
     ledger2 l2,    
     acmast a,    
     costmast c    
    Where    
     l.vno = l2.vno    
     and l.vtyp = l2.vtype    
     and l.booktype = l2.booktype    
     and l.lno = l2.lno    
     and a.cltcode = l2.cltcode    
     and l2.cltcode between @fcode and @tcode    
     And l.vtyp = v.vtype    
     and a.accat <> '4'    
     and l2.cltcode=a.cltcode    
     and costname = rtrim(@branch)    
     and l2.vtype <> 18    
     and l2.costcode = c.costcode    
     and  l.edt between @fdate and @tdate + ' 23:59:59'    
    order by    
     l2.cltcode,    
     voudt1,    
     l.vtyp desc,    
     l.vno    
   END    
 END    
    
Update    
 #temptable_gl    
set    
 opbal = l.opbal    
from    
 #opbal l    
where    
 #temptable_gl.cltcode = l.cltcode    
    
Update    
 #temptable_gl    
set    
 crosac = l.cltcode    
from    
 ledger l    
where    
 l.vtyp not in('15','21')    
 and #temptable_gl.vtyp = l.vtyp    
 and #temptable_gl.booktype = l.booktype    
 and #temptable_gl.vno = l.vno    
 and #temptable_gl.cltcode <> l.cltcode    
    
update    
 #temptable_gl    
set    
 branchcode = costname    
from    
 ledger2 l2,    
 costmast c    
where    
 #temptable_gl.vno = l2.vno    
 and #temptable_gl.vtyp = l2.vtype    
 and #temptable_gl.booktype = l2.booktype    
 and #temptable_gl.lno = l2.lno    
 and #temptable_gl.cltcode = l2.cltcode    
 and l2.costcode = c.costcode    
 
Select    
 booktype,    
 voudt = convert(varchar(11), voudt1, 103),    
 effdt = convert(varchar(11), effdt1, 103),    
 shortdesc,    
 dramt,    
 cramt,    
 vno,    
 narration,    
 ddno,    
 cltcode,    
 longname,    
 vdt,    
 vtyp,    
 accat,    
 opbal,    
 crosac,    
 acname,    
 branchcode,    
 lno    
from    
 #temptable_gl    
where     
 vtyp <> 18    
Order By    
 CltCode

GO
