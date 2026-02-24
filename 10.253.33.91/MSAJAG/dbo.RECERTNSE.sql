-- Object: PROCEDURE dbo.RECERTNSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 


 
  
CREATE PROCEDURE RECERTNSE AS    
  
SELECT A.FLDUSERNAME, a.fldcategory,a.fldstname, A.PWD_EXPIRY_DATE,a.EMAIL, A.EMP_NAME, A.SENIOR, A.SR_NAME, B.EMAIL AS senioremail  
INTO #temp3  
FROM (  
 SELECT A.FLDUSERNAME, a.fldcategory, a.fldstname,A.PWD_EXPIRY_DATE,b.EMAIL, B.EMP_NAME, B.SENIOR, B.SR_NAME  
 FROM TBLPRADNYAUSERS A, [196.1.115.132].RISK.DBO.EMP_INFO B,tblUserControlMaster c  
 WHERE A.FLDUSERNAME = B.EMP_NO  
 and a.fldauto=c.flduserid and   
 c.fldstatus=0  
  AND A.FLDUSERNAME LIKE 'E%'  
  --AND PWD_EXPIRY_DATE > '2014-07-01'  
 ) A  
left outer JOIN (  
 SELECT *
 FROM [196.1.115.132].RISK.DBO.EMP_INFO B
 where --and a.fldauto=c.flduserid and   
 --c.fldstatus=0  
  b.emp_no LIKE 'E%'  
  --AND PWD_EXPIRY_DATE > '2014-07-01'  
 ) B  
 ON (A.SENIOR = B.emp_no)  
  

  
select   
c.*,b.fldReportName ,'NSE' AS SEGMENT  
 INTO RIGHTSSE   
 from #temp3 c  
,tblcatmenu a inner join tblreports b on a.fldreportcode = b.fldreportcode  
Where   
fldcategorycode LIKE '%' + c.fldcategory + '%'  
order by 10  
  
  
--SELECT * FROM RIGHTSNSE WhERE SENIOREMAIL LIKE 'hetvi%' order by emp_name   


select a.*,b.fldcategoryname into rightsmcdxcds1 from  RIGHTSmcdxcds a ,tblcategory b
 where 
 a.fldcategory=b.fldcategorycode
 
  
  
SELECT DISTINCT  A.FLDUSERNAME,A.EMP_NAME,B.UserStatusId,B.VTYP,C.VDESC, B.NODAYS ,A.SENIOR,A.SR_NAME,A.SENIOREMAIL,'mcdxcds' AS SEGMENT   
INTO ACCOUNTmcdxcds
  FROM rightsmcdxcds1 A ,ACCOUNTmcdxcds..USERRIGHTS  B,ACCOUNTmcdxcds..VMAST C  
WHERE   
A.FLDCATEGORY=B.USERCATEGORY AND   
B.VTYP=C.VTYPE   
ORDER BY  2 DESC  







SELECT distinct  FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT,fldcategoryname  into finalreportrights  FROM RIGHTsnSE1
 union all   
SELECT  distinct FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT, fldcategoryname  FROM [196.1.115.201].bsedb_ab.dbo.RIGHTsbSE1   
union all   
SELECT distinct  FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT,fldcategoryname  FROM [196.1.115.200].nsefo.dbo.RIGHTsnsefo1
union all   
SELECT  distinct FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT, fldcategoryname  FROM [196.1.115.200].nsecurfo.dbo.RIGHTsnsecurrfo1   
union all   
SELECT distinct  FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT,fldcategoryname  FROM [196.1.115.204].ncdx.dbo.RIGHTsncdx1   
 union all   
SELECT  distinct FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT, fldcategoryname  FROM [196.1.115.204].mcdx.dbo.RIGHTsmcdx1  
union all 
SELECT distinct  FLDUSERNAME ,fldcategory ,fldstname PWD_EXPIRY_DATE ,EMAIL,EMP_NAME,  SENIOR ,SR_NAME, senioremail,fldReportName,  
sEGMENT,fldcategoryname  FROM [196.1.115.204].mcdxcds.dbo.RIGHTsmcdxcds1   
 
 
 
 
select * into finalvoucherrights from  ACCOUNTNSE  
union all  
select * from  [196.1.115.201].bsedb_ab.dbo.ACCOUNTbSE  
union all  
select * from  [196.1.115.200].nsefo.dbo.ACCOUNTnsefo  
union all  
select * from  [196.1.115.200].nsecurfo.dbo.ACCOUNTnsecurrfo
union all  
select * from  [196.1.115.204].ncdx.dbo.ACCOUNTncdx  
union all  
select * from  [196.1.115.204].mcdx.dbo.ACCOUNTmcdx  
union all  
select * from  [196.1.115.204].mcdxcds.dbo.ACCOUNTmcdxcds  



order by emp_name

GO
