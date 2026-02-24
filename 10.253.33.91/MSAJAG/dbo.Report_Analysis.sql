-- Object: PROCEDURE dbo.Report_Analysis
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure Report_Analysis
as  
set nocount on  
  
/* Created by MAnesh Mukherjee on 01/04/2016 as instructed by Ketan Sir */

select fldstname,fldusername,username=fldfirstname+' '+fldmiddlename+' '+fldlastname,fldcategory,a.fldadminauto,b.fldcategoryname,b.flddesc   
into #user  
from tblPradnyausers a (nolock), tblcategory  b (nolock) where   
a.fldcategory = b.fldcategorycode and a.fldadminauto=b.fldadminauto   
and pwd_expiry_date >= getdate()  
and a.fldadminauto in  
(select fldauto_admin from tbladmin (nolock) 
)  
and a.fldadminauto in  
(  
select fldadminauto from tblcatmenu (nolock) where fldreportcode in   
(select fldreportcode from tblreports (nolock) 
)  
)

select * into #access from V2_Report_Access_Log with (nolock) where AddDt>='Apr  1 2015' and StatusName <> 'Broker'

select username,RepPath,convert(datetime,CONVERT(varchar(11),adddt)) as AccessDate,COUNT(1) as NoOfLogins,statusNAme
into #login  
from #access (nolock) where 
username in (select fldusername from #user)  
group by username,RepPath,convert(datetime,CONVERT(varchar(11),adddt)),statusNAme
   
UPDATE #login SET rEPpATH=REPLACE(REPPATH,'`','')

select A.username,
RepPath,
AccessDate,
NoOfLogins,
statusNAme,
fldstname,
fldusername,
--username,
fldcategory,
fldadminauto,
fldcategoryname,
flddesc,
FLDREPORTCODE,
FLDPATH,
REPORTCODE,
REPORTNAME,
REPORTMENU,
REPORTMENUGRP
INTO #SFINAL
from #login a join #user b on a.username=b.fldusername 
join (SELECT MAX(FLDREPORTCODE) AS FLDREPORTCODE,FLDPATH FROM tblreports GROUP BY FLDPATH) c on c.fldpath=a.RepPath 
LEFT OUTER JOIN (SELECT REPORTCODE,REPORTNAME,REPORTMENU,REPORTMENUGRP FROM MENULIST1 GROUP BY REPORTCODE,REPORTNAME,REPORTMENU,REPORTMENUGRP) D
ON D.REPORTCODE=C.fldreportcode


SELECT STATUSNAME,count(distinct fldstname) as ClientCount,SUM(NOOFLOGINS) AS NOOFLOGINS,MAX(AccessDate) as AccessDate,  
isnull(REPORTNAME,reppath) as REPORTNAME,isnull(REPORTMENUGRP,'ReportCode:'+convert(varchar(5),Fldreportcode)) as REPORTMENUGRP,REPORTMENU,FLDDESC 
FROM #SFINAL
where STATUSNAME <> ''
GROUP BY STATUSNAME,isnull(REPORTNAME,reppath),isnull(REPORTMENUGRP,'ReportCode:'+convert(varchar(5),Fldreportcode)),REPORTMENU,FLDDESC
ORDER BY STATUSNAME,NOOFLOGINS DESC

set nocount off

GO
