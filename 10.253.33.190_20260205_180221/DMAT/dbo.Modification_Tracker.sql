-- Object: PROCEDURE dbo.Modification_Tracker
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 
--Altered this SP under SRE-34226
CREATE PROCEDURE  [dbo].[Modification_Tracker]
AS

 SET NOCOUNT ON; 
  
SELECT C.CRN_NO,C.BO_PARTYCODE,M.MOD3, DOCUMENT_TYPE = CASE
            WHEN M.MOD4 LIKE '%s%' THEN 'S'
            WHEN M.MOD4 LIKE '%p%' THEN 'P'
            ELSE 'Other'
        END  , C.CREATED_DT,c.CREATED_BY,C.dp_batch_no,C.FAM_DECL,C.FAM_REL INTO #MOD FROM ABVSCITRUS.CRMDB_A.DBO.CLIENT_MASTER C (NOLOCK),  ABVSCITRUS.CRMDB_A.DBO.CLIENT_MOD_DETAILS M (NOLOCK)  
WHERE C.CRN_NO=M.CRN_NO AND STATUS <>5 AND MOD_RMKS <> 'ADDSEG' AND     CONVERT(VARCHAR(11),C.CREATED_DT) = CONVERT(VARCHAR(11),GETDATE()-2)    
/* C.CREATED_DT between '2024-11-01 00:00:00.497'
   and '2024-11-30 23:59:59.497' */
   
  
 /****** CONVERT(VARCHAR(11),GETDATE()-2) ******/  
SELECT MAX(CRN_NO)CRN_NO,BO_PARTYCODE,dp_batch_no,FAM_DECL,FAM_REL,CREATED_BY, DOCUMENT_TYPE    INTO #FIN FROM #MOD  GROUP BY BO_PARTYCODE,dp_batch_no,FAM_DECL,FAM_REL ,CREATED_BY,DOCUMENT_TYPE  
         
SELECT * INTO #FINAL FROM #MOD M WHERE EXISTS (  
SELECT * FROM #FIN F WHERE M.CRN_NO =F.CRN_NO)  
  
   
   
    
  
SELECT DISTINCT CRN_NO,BO_PARTYCODE,CREATED_BY,DOCUMENT_TYPE,dp_batch_no,FAM_DECL,FAM_REL, MOD3='BANK',CREATED_DT,CLIBA_AC_NO INTO #BANK FROM #FINAL F,ABVSCITRUS.CRMDB_A.DBO.CLIENT_BANK_ACCTS D    
WHERE MOD3 LIKE '%BANK%' AND F.CRN_NO=D.CLIBA_CRN_NO AND CLIBA_DELETED_IND ='0'  
   
SELECT DISTINCT CRN_NO,BO_PARTYCODE,CREATED_BY,DOCUMENT_TYPE,dp_batch_no,FAM_DECL,FAM_REL, MOD3='EMAIL_MOB',CREATED_DT,APP_EMAIL,APP_MOB_NO INTO #EMAIL1 FROM #FINAL F,ABVSCITRUS.CRMDB_A.DBO.CLIENT_KYC_DATA D    
WHERE MOD3 LIKE '%CONTACT%' AND F.CRN_NO=D.APP_CRN_NO    
   
   
  
SELECT M.*,APP_EMAIL,APP_MOB_NO,APP_COR_ADD1,APP_COR_ADD2,APP_COR_ADD3,APP_COR_CITY,APP_COR_PINCD INTO #ADDRESS FROM #FINAL M,ABVSCITRUS.CRMDB_A.DBO.CLIENT_KYC_DATA D  WHERE MOD3 LIKE '%ADDRESS%' AND M.CRN_NO=D.APP_CRN_NO    
   
SELECT M.*,APP_NAME,APP_NAME_M,APP_NAME_L,APP_F_NAME INTO #Name FROM #FINAL M,ABVSCITRUS.CRMDB_A.DBO.CLIENT_KYC_DATA D  WHERE MOD3 LIKE '%Name%' AND M.CRN_NO=D.APP_CRN_NO    
    
ALTER TABLE #BANK  
ADD DP_ID VARCHAR(16),BO_UPD VARCHAR(1),DP_UPD VARCHAR(1)  
ALTER TABLE #EMAIL1  
ADD DP_ID VARCHAR(16),BO_UPD VARCHAR(1),DP_UPD VARCHAR(1)  
ALTER TABLE #ADDRESS  
ADD DP_ID VARCHAR(16),BO_UPD VARCHAR(1),DP_UPD VARCHAR(1)  
ALTER TABLE #Name  
ADD DP_ID VARCHAR(16),BO_UPD VARCHAR(1),DP_UPD VARCHAR(1)  
  
CREATE INDEX #C ON #BANK(BO_PARTYCODE)  
CREATE INDEX #C ON #EMAIL1(BO_PARTYCODE)  
CREATE INDEX #C ON #ADDRESS(BO_PARTYCODE)  
CREATE INDEX #C ON #Name(BO_PARTYCODE)  
  
   
   
  
UPDATE B SET DP_ID =CLTDPID FROM #BANK B (NOLOCK) ,ANAND1.MSAJAG.DBO.CLIENT4 C WITH(NOLOCK) WHERE BO_PARTYCODE=CL_CODE AND DEPOSITORY ='CDSL'  
AND BANKID IN ('12033200','12033201','12033202','12033203','12033204') AND DEFDP ='1'  
UPDATE B SET DP_ID =CLTDPID FROM #EMAIL1 B (NOLOCK) ,ANAND1.MSAJAG.DBO.CLIENT4 C WITH(NOLOCK)  WHERE BO_PARTYCODE=CL_CODE AND DEPOSITORY ='CDSL'   
AND BANKID IN ('12033200','12033201','12033202','12033203','12033204') AND DEFDP ='1'  
UPDATE B SET DP_ID =CLTDPID FROM #ADDRESS B,ANAND1.MSAJAG.DBO.CLIENT4 C WITH(NOLOCK) WHERE BO_PARTYCODE=CL_CODE AND DEPOSITORY ='CDSL'   
AND BANKID IN ('12033200','12033201','12033202','12033203','12033204') AND DEFDP ='1'  
UPDATE B SET DP_ID =CLTDPID FROM #Name B,ANAND1.MSAJAG.DBO.CLIENT4 C WITH(NOLOCK) WHERE BO_PARTYCODE=CL_CODE AND DEPOSITORY ='CDSL'   
AND BANKID IN ('12033200','12033201','12033202','12033203','12033204') AND DEFDP ='1'  
  
  
 SELECT DP_ID INTO #DP FROM #BANK  
UNION ALL  
SELECT DP_ID FROM #EMAIL1  
UNION ALL  
SELECT DP_ID FROM #ADDRESS  
UNION ALL  
SELECT DP_ID FROM #Name  
  
  
CREATE INDEX #CD ON #BANK(DP_ID)  
CREATE INDEX #CD ON #EMAIL1(DP_ID)  
CREATE INDEX #CD ON #ADDRESS(DP_ID)  
CREATE INDEX #CD ON #Name(DP_ID)  
CREATE INDEX #CD ON #DP(DP_ID)  
   
SELECT * INTO #DP_MAST  FROM [AGMUBODPL3].DMAT.citrus_usr.dps8_pc1 WHERE  
EXISTS (SELECT DP_ID FROM #DP WHERE DP_ID=BOID)  
  
INSERT INTO #DP_MAST  
SELECT *  FROM  citrus_usr.dps8_pc1 WHERE  
EXISTS (SELECT DP_ID FROM #DP WHERE DP_ID=BOID)  
  
INSERT INTO #DP_MAST  
SELECT *  FROM [ATMUMBODPL03].DMAT.citrus_usr.dps8_pc1 WHERE  
EXISTS (SELECT DP_ID FROM #DP WHERE DP_ID=BOID) 

INSERT INTO #DP_MAST  
SELECT *  FROM [ABVSDP203].DMAT.citrus_usr.dps8_pc1 WHERE  
EXISTS (SELECT DP_ID FROM #DP WHERE DP_ID=BOID)

INSERT INTO #DP_MAST  
SELECT *  FROM [ABVSDP204].DMAT.citrus_usr.dps8_pc1 WHERE  
EXISTS (SELECT DP_ID FROM #DP WHERE DP_ID=BOID)
  
  
CREATE INDEX #CD ON #DP_MAST(BOID)  
   
UPDATE B SET DP_UPD='Y' FROM #BANK B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE B.DP_ID=BOID AND CLIBA_AC_NO = DivBankAcctNo  
      
   
UPDATE B SET DP_UPD='Y' FROM #EMAIL1 B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE B.DP_ID=BOID AND PriPhNum =APP_MOB_NO AND APP_EMAIL =pri_email  
          
  
UPDATE B SET DP_UPD='Y' FROM #ADDRESS B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE B.DP_ID=boid AND ADDR1 =    APP_COR_ADD1  
  
UPDATE B  
SET DP_UPD = 'Y' 
FROM #Name B WITH(NOLOCK)  
JOIN #DP_MAST T WITH(NOLOCK)   
    ON B.DP_ID = T.boid  
WHERE
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        b.APP_NAME + b.APP_NAME_M + b.APP_NAME_L, ' ', ''), '-', ''), '_', ''), ',', ''), '.', ''), '/', '') =
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        T.Name + T.MiddleName + T.SearchName, ' ', ''), '-', ''), '_', ''), ',', ''), '.', ''), '/', '');

  
     
UPDATE B SET BO_UPD='Y' FROM #BANK B  WITH(NOLOCK),ANAND1.MSAJAG.DBO.PARTY_BANK_DETAILS T  WITH(NOLOCK)  
WHERE BO_PARTYCODE=PARTY_CODE  AND CLIBA_AC_NO =ACNUM  
   
UPDATE B SET BO_UPD='Y' FROM #EMAIL1 B  WITH(NOLOCK),ANAND1.MSAJAG.DBO.CLIENT_DETAILS T  WITH(NOLOCK)  
WHERE BO_PARTYCODE=CL_CODE  AND MOBILE_PAGER =APP_MOB_NO AND APP_EMAIL = EMAIL  
  
UPDATE B SET BO_UPD='Y' FROM #ADDRESS B  WITH(NOLOCK),ANAND1.MSAJAG.DBO.CLIENT_DETAILS T  WITH(NOLOCK)  
WHERE BO_PARTYCODE=CL_CODE AND L_ADDRESS1 =APP_COR_ADD1  
  
UPDATE B SET BO_UPD='Y' FROM #Name B  WITH(NOLOCK),ANAND1.MSAJAG.DBO.CLIENT_DETAILS T  WITH(NOLOCK)  
WHERE BO_PARTYCODE=CL_CODE AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    b.APP_NAME + b.APP_NAME_M + b.APP_NAME_L, ' ', ''), '-', ''), '_', ''), ',', ''), '.', ''), '/', '') =
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    T.long_name, ' ', ''), '-', ''), '_', ''), ',', ''), '.', ''), '/', '');
 
  
ALTER TABLE #BANK  
ADD DP_ACTIVE VARCHAR(20)  
ALTER TABLE #EMAIL1  
ADD DP_ACTIVE VARCHAR(20)  
ALTER TABLE #ADDRESS  
ADD DP_ACTIVE VARCHAR(20)  
ALTER TABLE #Name  
ADD DP_ACTIVE VARCHAR(20)  
   
   
  
UPDATE B SET DP_ACTIVE=boactdt FROM #BANK B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE  B.DP_ID=BOID  
  
UPDATE B SET DP_ACTIVE=boactdt FROM #EMAIL1 B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE  B.DP_ID=BOID  
  
UPDATE B SET DP_ACTIVE=boactdt FROM #ADDRESS B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE  B.DP_ID=BOID  
  
UPDATE B SET DP_ACTIVE=boactdt FROM #Name B  WITH(NOLOCK),#DP_MAST T  WITH(NOLOCK)  
WHERE  B.DP_ID=BOID  
   
   
   
 SELECT  DP_ID into #DP_Status   FROM #BANK  
  
 insert  into #DP_Status   
 SELECT  DP_ID     FROM #EMAIL1  
  
 insert  into #DP_Status   
 SELECT  DP_ID     FROM #ADDRESS  
  
 insert  into #DP_Status   
 SELECT  DP_ID     FROM #Name  
  
   
Select client_code,status into #DP_Status_Data from [AGMUBODPL3].DMAT.DBO.tbl_client_master where client_code in   (select DP_ID from  #DP_Status )  
  
insert into #DP_Status_Data Select client_code,status from  tbl_client_master where client_code in   (select DP_ID from  #DP_Status )  
  
insert into #DP_Status_Data Select client_code,status from [ATMUMBODPL03].DMAT.DBO.tbl_client_master where client_code in   (select DP_ID from  #DP_Status )  
  
 insert into #DP_Status_Data Select client_code,status from [ABVSDP203].DMAT.DBO.tbl_client_master where client_code in   (select DP_ID from  #DP_Status )  
  
 insert into #DP_Status_Data Select client_code,status from [ABVSDP204].DMAT.DBO.tbl_client_master where client_code in   (select DP_ID from  #DP_Status )  
  
SELECT  b.*,m.status  into #BANK_ONOFF  FROM #BANK  b left outer join  #DP_Status_Data m WITH(NOLOCK)   on b.DP_ID=m.CLIENT_CODE   
  
  SELECT  b.*,m.status into #EMAIL1_ONOFF FROM #EMAIL1  b left outer join #DP_Status_Data m WITH(NOLOCK)   on b.DP_ID=m.CLIENT_CODE    
     
   SELECT  b.*,m.status into #ADDRESS_ONOFF FROM #ADDRESS  b left outer join  #DP_Status_Data m WITH(NOLOCK)   on b.DP_ID=m.CLIENT_CODE    
     SELECT  b.*,m.status into #Name_ONOFF FROM #Name  b left outer join  #DP_Status_Data m WITH(NOLOCK)   on b.DP_ID=m.CLIENT_CODE   
   
select  BO_PARTYCODE, CREATED_DT = max( CREATED_DT)  into #BANK_ONOFF_F    from #BANK_ONOFF     group by   BO_PARTYCODE  
  
select C.*,Modification_Type = CASE  
                 WHEN c.created_by ='HOONLINE'  
                   THEN 'ONLINE'  
                 ELSE 'OFFLINE'  END,Modification_Status = CASE  
                 WHEN ( ISNULL(BO_UPD,'') ='' OR ISNULL(DP_UPD,'') ='' )
 THEN 'Migration_Failure'  ELSE 'Migration_Successful'  END into #BANK_ONOFF_Final from #BANK_ONOFF c , #BANK_ONOFF_F b  where c.BO_PARTYCODE=b.BO_PARTYCODE and c.CREATED_DT=b.CREATED_DT        ;
  
    
   
select  BO_PARTYCODE, CREATED_DT = max( CREATED_DT)  into #EMAIL1_ONOFF_F    from #EMAIL1_ONOFF     group by   BO_PARTYCODE  
  
select C.*,Modification_Type = CASE  
                 WHEN c.created_by ='HOONLINE'  
                   THEN 'ONLINE'  
                 ELSE 'OFFLINE'  END,Modification_Status = CASE  
                 WHEN ( ISNULL(BO_UPD,'') ='' OR ISNULL(DP_UPD,'') ='' ) THEN 'Migration_Failure'  ELSE 'Migration_Successful'  END into #EMAIL1_ONOFF_Final from #EMAIL1_ONOFF c , #EMAIL1_ONOFF_F b  where c.BO_PARTYCODE=b.BO_PARTYCODE and c.CREATED_DT=b.CREATED_DT;        
  
   
  
  
select  BO_PARTYCODE, CREATED_DT = max( CREATED_DT)  into #ADDRESS_ONOFF_F    from #ADDRESS_ONOFF     group by   BO_PARTYCODE  
  
select C.*,Modification_Type = CASE  
                 WHEN c.created_by ='HOONLINE'  
                   THEN 'ONLINE'  
                 ELSE 'OFFLINE'  END,Modification_Status = CASE  
                 WHEN ( ISNULL(BO_UPD,'') ='' OR ISNULL(DP_UPD,'') ='' )
 THEN 'Migration_Failure'  ELSE 'Migration_Successful'  END into #ADDRESS_ONOFF_Final from #ADDRESS_ONOFF c , #ADDRESS_ONOFF_F b  where c.BO_PARTYCODE=b.BO_PARTYCODE and c.CREATED_DT=b.CREATED_DT;        
  
 select  BO_PARTYCODE, CREATED_DT = max( CREATED_DT)  into #Name_ONOFF_F    from #Name_ONOFF     group by   BO_PARTYCODE  
 select C.*,Modification_Type = CASE  
                 WHEN c.created_by ='HOONLINE'  
                   THEN 'ONLINE'  
                 ELSE 'OFFLINE'  END,Modification_Status = CASE  
                 WHEN ( ISNULL(BO_UPD,'') ='' OR ISNULL(DP_UPD,'') ='' )
    THEN 'Migration_Failure'  ELSE 'Migration_Successful'  END into #Name_ONOFF_Final from #Name_ONOFF c , #Name_ONOFF_F b  where c.BO_PARTYCODE=b.BO_PARTYCODE and 
				 c.CREATED_DT=b.CREATED_DT;
				 
delete from  BANK_ONOFF_Final ; 
delete from  EMAIL1_ONOFF_Final;   
delete from   ADDRESS_ONOFF_Final ;   
delete from  Name_ONOFF_Final;    
  
insert into BANK_ONOFF_Final  
 select CRN_NO,BO_PARTYCODE,dp_batch_no,CREATED_DT,DOCUMENT_TYPE,CLIBA_AC_NO as NEW_AC_NO,DP_ID,BO_UPD,DP_UPD,status as DP_Status,Migration_Status = CASE  
                 WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_OFFLINE'  
     WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_OFFLINE'  
                 ELSE 'OTHER'  END,Create_Date=GETDATE()      from #BANK_ONOFF_Final;  
  
     insert into  EMAIL1_ONOFF_Final  
     select CRN_NO,BO_PARTYCODE,dp_batch_no,CREATED_DT,DOCUMENT_TYPE,APP_EMAIL as NEW_EMAIL,APP_MOB_NO as NEW_MOB_NO,DP_ID,BO_UPD,DP_UPD,status as DP_Status,Migration_Status = CASE  
                 WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_OFFLINE'  
     WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_OFFLINE'  
                 ELSE 'OTHER'  END,Create_Date=GETDATE()      from #EMAIL1_ONOFF_Final;  
   
 insert into   ADDRESS_ONOFF_Final  
      select CRN_NO,BO_PARTYCODE,dp_batch_no,CREATED_DT, DOCUMENT_TYPE,APP_COR_ADD1 as New_COR_ADD1, APP_COR_ADD2 as New_COR_ADD2, APP_COR_ADD3 as New_COR_ADD3, APP_COR_CITY as New_COR_CITY, APP_COR_PINCD  as New_COR_PINCD,DP_ID,BO_UPD,DP_UPD,status as 
	  DP_Status,Migration_Status = CASE  
                WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_OFFLINE'  
     WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_OFFLINE'  
                 ELSE 'OTHER'  END,Create_Date=GETDATE()     from #ADDRESS_ONOFF_Final ; 
  
     insert into Name_ONOFF_Final   
      select  CRN_NO ,BO_PARTYCODE,  CREATED_DT ,DOCUMENT_TYPE,CREATED_BY, dp_batch_no ,APP_NAME as NEW_F_Name, APP_NAME_M as NEW_M_Name, APP_NAME_L as   NEW_L_Name ,APP_F_NAME as Father_Name, DP_ID, BO_UPD, DP_UPD, DP_ACTIVE, status as DP_Status,
	  Modification_Status  
     ,Migration_Status = CASE  
                 WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Failure' THEN 'Migration_Failure_OFFLINE'  
     WHEN Modification_Type ='ONLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_ONLINE'  
     WHEN Modification_Type ='OFFLINE' and Modification_Status='Migration_Successful' THEN 'Migration_Successful_OFFLINE'  
                 ELSE 'OTHER'  END ,Create_Date=GETDATE()     from #Name_ONOFF_Final  ;
   
-- select * from  BANK_ONOFF_Final  
--select * from  EMAIL1_ONOFF_Final   
--select * from   ADDRESS_ONOFF_Final    
--select * from   Name_ONOFF_Final

GO
