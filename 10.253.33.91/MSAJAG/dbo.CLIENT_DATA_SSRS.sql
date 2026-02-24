-- Object: PROCEDURE dbo.CLIENT_DATA_SSRS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[CLIENT_DATA_SSRS]    
AS BEGIN     
TRUNCATE TABLE SSRS_CLIENT_DATA    
    
INSERT INTO SSRS_CLIENT_DATA    
select      
cl_code,    
LONG_NAME,    
 [L_ADDRESS1]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(L_ADDRESS1)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''),  
  
   
   [L_ADDRESS2]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(L_ADDRESS2)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''),
  
     
     [L_ADDRESS3]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(L_ADDRESS3)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''
  
)    
     , L_CITY,L_STATE,L_ZIP,L_NATION,pan_gir_no,branch_cd,sub_broker,region--,(CASE WHEN B2C='Y' THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C    
     ----into SSRS_CLIENT_DATA
 from CLIENT_DETAILS    
where CL_CODE in (select * from  SSRS_CL_Code)    
    
SELECT A.*,(CASE WHEN B2C='Y' THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C FROM SSRS_CLIENT_DATA A    
LEFT OUTER JOIN    
INTRANET.RISK.DBO.CLIENT_DETAILS B    
ON A.CL_cODE=B.CL_cODE    
    
END

GO
