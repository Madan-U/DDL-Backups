-- Object: PROCEDURE dbo.nsecert2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE proc [dbo].[nsecert2]  as

 

SELECT A.FLDUSERNAME, a.fldcategory,a.fldstname, A.PWD_EXPIRY_DATE,a.EMAIL, A.EMP_NAME, A.SENIOR, A.SR_NAME, B.EMAIL AS senioremail  

INTO #temp3  

FROM (  

 SELECT A.FLDUSERNAME, a.fldcategory, a.fldstname,A.PWD_EXPIRY_DATE,b.EMAIL, B.EMP_NAME, B.SENIOR, B.SR_NAME  

 FROM TBLPRADNYAUSERS A, INTRANET.RISK.DBO.EMP_INFO B,tblUserControlMaster c  

 WHERE A.FLDUSERNAME = B.EMP_NO  

 and a.fldauto=c.flduserid and   

 c.fldstatus=0  

  AND A.FLDUSERNAME LIKE 'E%'  

  --AND PWD_EXPIRY_DATE > '2014-07-01'  

 ) A  

left outer JOIN (  

 SELECT *

 FROM INTRANET.RISK.DBO.EMP_INFO B

 where --and a.fldauto=c.flduserid and   

 --c.fldstatus=0  

  b.emp_no LIKE 'E%'  

  --AND PWD_EXPIRY_DATE > '2014-07-01'  

 ) B  

 ON (A.SENIOR = B.emp_no)  

  

  

  --drop table rightsMCDXCDS

  

select   

c.*,b.fldReportName ,B.fldreportcode,'MCDXCDS' AS SEGMENT  

 INTO rightsMCDXCDS

 from #temp3 c  

,tblcatmenu a inner join tblreports b on a.fldreportcode = b.fldreportcode  

Where   

fldcategorycode LIKE '%,' + c.fldcategory + ',%'  

order by 10  

 





--drop table rightsMCDXCDS1

--SELECT * FROM RIGHTSNSE WhERE SENIOREMAIL LIKE 'hetvi%' order by emp_name   



select a.*,b.fldcategoryname into rightsMCDXCDS1 from  RIGHTSMCDXCDS a ,tblcategory b

 where 

 a.fldcategory=b.fldcategorycode





--drop table rightsMCDXCDS2





select distinct a.* ,b.fldgrpname,d.fldmenuname into rightsMCDXCDS2  from  rightsMCDXCDS1 a,tblreportgrp b,tblreports c,tblmenuhead d

where 

a.fldreportcode=c.fldreportcode

and b.fldreportgrp=c.fldreportgrp and 

c.fldmenugrp=d.fldmenucode

order by fldmenuname ,fldgrpname,fldreportname





SELECT distinct A.*,max(B.AddDt) FROM rightsBse2 A with(nolock)

INNER  JOIN   tblreports C with(nolock) ON A.FLDREPORTCODE=C.fldreportcode 

left outer join  V2_REPORT_ACCESS_LOG B  ON b.repPath= '`'+ c.fldpath + '`'

where email  like 'RAJESH.jain%'

group by a.FLDUSERNAME ,a.fldcategory ,a.fldstname, a.PWD_EXPIRY_DATE,a.EMAIL , a.EMP_NAME,a.SENIOR ,a.SR_NAME,a.senioremail,a.fldReportName,a.fldreportcode,

 a.SEGMENT, a.fldcategoryname,a.fldgrpname , a.fldmenuname,a.EMP_NAME

GO
