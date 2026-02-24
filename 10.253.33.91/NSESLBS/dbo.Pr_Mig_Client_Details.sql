-- Object: PROCEDURE dbo.Pr_Mig_Client_Details
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE Pr_Mig_Client_Details              
(              
  @pa_CanAddData AS Bit,              
  @pa_CanModifyData AS Bit,              
  @pa_CanDeleteData AS Bit,              
  @pa_err AS VarChar(250) OUTPUT               
)              
AS              
BEGIN              
    
 DECLARE    
  @strPayLocation VARCHAR(100),    
  @intLocationCode INT,    
  @strPayBank VARCHAR(50)    
      
 SET @strPayBank = 'HDFC'    
            
 --- Validate BRANCH_CD              
 UPDATE #CLIENT_DETAILS SET VALID_BRANCH_CD = 'Y'               
  FROM #CLIENT_DETAILS AS A, BRANCH AS B               
  WHERE A.BRANCH_CD = B.BRANCH_CODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate SUB_BROKER              
 UPDATE #CLIENT_DETAILS SET VALID_SUB_BROKER = 'Y'               
  FROM #CLIENT_DETAILS AS A, SUBBROKERS AS B               
  WHERE A.SUB_BROKER = B.SUB_BROKER              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate TRADER              
 UPDATE #CLIENT_DETAILS SET VALID_TRADER = 'Y'               
  FROM #CLIENT_DETAILS AS A, BRANCHES AS B               
  WHERE A.TRADER = B.SHORT_NAME              
  AND A.BRANCH_CD = B.BRANCH_CD              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate L_STATE              
 UPDATE #CLIENT_DETAILS SET VALID_L_STATE = 'Y'               
  FROM #CLIENT_DETAILS AS A, STATE_MASTER AS B               
  WHERE A.L_STATE = B.STATE                
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate CL_TYPE              
 UPDATE #CLIENT_DETAILS SET VALID_CL_TYPE = 'Y'               
  FROM #CLIENT_DETAILS AS A, CLIENTTYPE AS B               
  WHERE A.CL_TYPE = B.CL_TYPE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate CL_STATUS              
 UPDATE #CLIENT_DETAILS SET VALID_CL_STATUS = 'Y'               
  FROM #CLIENT_DETAILS AS A, CLIENTSTATUS AS B               
  WHERE A.CL_STATUS = B.CL_STATUS              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate FAMILY              
 UPDATE #CLIENT_DETAILS SET VALID_FAMILY = 'Y'               
  FROM #CLIENT_DETAILS AS A, CLIENT_DETAILS AS B               
  WHERE A.FAMILY = B.PARTY_CODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
            
 if exists(select 1 from tempdb.dbo.sysobjects where name = '#CLIENT_DETAILS1' and xtype = 'u')            
 drop table #CLIENT_DETAILS1            
             
 select * into #CLIENT_DETAILS1 from #CLIENT_DETAILS            
            
 --- Validate FAMILY              
 UPDATE #CLIENT_DETAILS SET VALID_FAMILY = 'Y'               
  FROM #CLIENT_DETAILS AS A, #CLIENT_DETAILS1 AS B               
  WHERE A.FAMILY = B.PARTY_CODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
            
 --- Validate FAMILY              
 UPDATE #CLIENT_DETAILS SET VALID_FAMILY = 'Y'               
  FROM #CLIENT_DETAILS AS A WHERE A.FAMILY = A.PARTY_CODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate REGION              
 UPDATE #CLIENT_DETAILS SET VALID_REGION = 'Y'           
  FROM #CLIENT_DETAILS AS A, REGION AS B               
  WHERE A.REGION = B.REGIONCODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate AREA              
 UPDATE #CLIENT_DETAILS SET VALID_AREA = 'Y'               
  FROM #CLIENT_DETAILS AS A, AREA AS B               
  WHERE A.AREA = B.AREACODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate REL_MGR              
 UPDATE #CLIENT_DETAILS SET VALID_REL_MGR = 'Y'               
  FROM #CLIENT_DETAILS AS A, SBU_MASTER AS B               
  WHERE A.REL_MGR = B.SBU_CODE AND B.SBU_TYPE = 'RELMGR'              
                 
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate C_GROUP              
 UPDATE #CLIENT_DETAILS SET VALID_C_GROUP = 'Y'               
  FROM #CLIENT_DETAILS AS A, SBU_MASTER AS B               
  WHERE A.C_GROUP = B.SBU_CODE AND B.SBU_TYPE = 'GROUP'              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
/*              
 --- VALIDATE INTERACTMODE, SETT_MODE, AC_TYPE, SEX              
 UPDATE #CLIENT_DETAILS SET              
  VALID_INTERACTMODE = CASE WHEN INTERACTMODE IN (0,1,2,3,4,5) THEN 'Y' ELSE 'N' END,              
  VALID_SETT_MODE = CASE WHEN SETT_MODE IN (0,1) THEN 'Y' ELSE 'N' END,              
  VALID_AC_TYPE = CASE WHEN AC_TYPE IN ('S','C') THEN 'Y' ELSE 'N' END,              
  VALID_SEX = CASE WHEN SEX IN ('M', 'F') THEN 'Y' ELSE 'N' END               
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate DPID1 & CLTDPID1              
 UPDATE #CLIENT_DETAILS SET VALID_DPID1 = 'Y', VALID_DEPOSITORY1 = 'Y'               
  FROM #CLIENT_DETAILS AS A, BANK AS B               
  WHERE (A.DEPOSITORY1 = B.BANKTYPE AND A.DPID1 = B.BANKID)              
  OR (ISNULL(A.DEPOSITORY1, '') = '' AND ISNULL(A.DPID1, '') = '' AND ISNULL(A.CLTDPID1, '') = '')              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate DPID2 & CLTDPID2              
 UPDATE #CLIENT_DETAILS SET VALID_DPID2 = 'Y', VALID_DEPOSITORY2 = 'Y'               
  FROM #CLIENT_DETAILS AS A, BANK AS B               
  WHERE (A.DEPOSITORY2 = B.BANKTYPE AND A.DPID2 = B.BANKID)              
  OR (ISNULL(A.DEPOSITORY2, '') = '' AND ISNULL(A.DPID2, '') = '' AND ISNULL(A.CLTDPID2, '') = '')              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- Validate DPID3 & CLTDPID3              
 UPDATE #CLIENT_DETAILS SET VALID_DPID3 = 'Y', VALID_DEPOSITORY3 = 'Y'               
  FROM #CLIENT_DETAILS AS A, BANK AS B               
  WHERE (A.DEPOSITORY3 = B.BANKTYPE AND A.DPID3 = B.BANKID)              
  OR (ISNULL(A.DEPOSITORY3, '') = '' AND ISNULL(A.DPID3, '') = '' AND ISNULL(A.CLTDPID3, '') = '')              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
*/              
        
 --- Validate OLD DATA              
  UPDATE #CLIENT_DETAILS SET RECORD_FOUND = 'Y'               
  FROM CLIENT_DETAILS AS A        
  WHERE A.Cl_CODE = #CLIENT_DETAILS.CL_CODE        
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END        
              
 --- Update whether the record is valid or not              
 UPDATE #CLIENT_DETAILS SET             
  VALID_RECORD = CASE WHEN MODIFIED = 'N' AND RECORD_FOUND = 'N' THEN 'Y'   --- Record Addition              
          WHEN MODIFIED = 'M' AND RECORD_FOUND = 'Y' THEN 'Y'   --- Record Modification              
          WHEN MODIFIED = 'D' AND RECORD_FOUND = 'Y' THEN 'Y'   --- Record Deletion              
          ELSE 'N'               
       END              
 WHERE VALID_BRANCH_CD = 'Y'              
    AND VALID_SUB_BROKER = 'Y'              
    AND VALID_TRADER = 'Y'              
    AND VALID_L_STATE = 'Y'              
    AND VALID_CL_TYPE = 'Y'              
    AND VALID_CL_STATUS = 'Y'              
    AND VALID_FAMILY = 'Y'              
    AND VALID_REGION = 'Y'              
    AND VALID_AREA = 'Y'              
    AND VALID_REL_MGR = 'Y'              
    AND VALID_C_GROUP = 'Y'              
-- --     AND VALID_INTERACTMODE = 'Y'              
-- --     AND VALID_SETT_MODE = 'Y'              
-- --     AND VALID_AC_TYPE = 'Y'              
-- --     AND VALID_SEX = 'Y'              
-- --     AND VALID_DEPOSITORY1 = 'Y'              
-- --     AND VALID_DPID1 = 'Y'              
-- --     AND VALID_CLTDPID1 = 'Y'              
-- --     AND VALID_DEPOSITORY2 = 'Y'              
-- --     AND VALID_DPID2 = 'Y'              
-- --     AND VALID_CLTDPID2 = 'Y'              
-- --     AND VALID_DEPOSITORY3 = 'Y'              
-- --     AND VALID_DPID3 = 'Y'              
-- --     AND VALID_CLTDPID3 = 'Y'              
      
--SELECT * INTO CLIENT_DETAILS_TEMP FROM  #CLIENT_DETAILS      
    
 DECLARE curPayLocation CURSOR FOR SELECT PayLocation FROM #CLIENT_DETAILS WHERE PayLocation NOT IN (    
  SELECT Location_Name FROM Location_Master) AND ISNULL(PayLocation, '') <> ''    
    
 OPEN curPayLocation    
    
 FETCH curPayLocation INTO @strPayLocation    
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
  SELECT @intLocationCode = MAX(Location_Code) FROM Location_Master    
    
  SET @intLocationCode = ISNULL(@intLocationCode, 0) + 1    
    
  INSERT INTO Location_Master(Location_Code, Location_Name, Location_Bank)    
   VALUES(@intLocationCode, @strPayLocation, @strPayBank)    
    
  FETCH curPayLocation INTO @strPayLocation    
 END    
 CLOSE curPayLocation    
 DEALLOCATE curPayLocation     
    
 --- Update Location Code Instead of Name    
 UPDATE #CLIENT_DETAILS SET PayLocation = Location_Code     
  FROM #CLIENT_DETAILS A, Location_Master B    
  WHERE A.PayLocation = B.Location_Name    
               
 --- INSERT THE RECORD INTO CLIENT_DETAILS              
 IF @pa_CanAddData = 1              
  INSERT INTO CLIENT_DETAILS              
  (              
   AC_NUM,              
   AC_TYPE,              
   ADDEMAILID,              
   APPROVER,              
   AREA,              
   BANK_ID,              
   BANK_NAME,              
   BRANCH_CD,              
   BRANCH_NAME,              
   C_GROUP,              
   CHK_ANNUAL_REPORT,              
   CHK_BANK_CERTIFICATE,              
   CHK_CORP_DTLS_RECD,              
   CHK_CORPORATE_DEED,              
   CHK_KYC_FORM,              
   CHK_NETWORTH_CERT,              
   CL_CODE,              
   CL_STATUS,              
   CL_TYPE,              
   CLIENT_AGREEMENT_ON,              
   CLTDPID1,              
   CLTDPID2,              
   CLTDPID3,              
   DEALING_WITH_OTHER_TM,              
   DEPOSITORY1,              
   DEPOSITORY2,              
   DEPOSITORY3,              
   DIRECTOR_NAME,              
   DOB,              
   DPID1,              
   DPID2,              
   DPID3,              
   EMAIL,              
   FAMILY,              
   FAX,              
   FMCODE,              
   IMP_STATUS,              
   INTERACTMODE,              
   INTRODUCER,              
   INTRODUCER_ID,              
   INTRODUCER_RELATION,              
   IT_RETURN_FILED_ON,              
   IT_RETURN_YR,              
   L_ADDRESS1,              
   L_ADDRESS2,              
   L_ADDRESS3,              
   L_CITY,              
   L_NATION,              
   L_STATE,              
   L_ZIP,              
   LICENCE_EXPIRES_ON,              
   LICENCE_ISSUED_AT,              
   LICENCE_ISSUED_ON,              
   LICENCE_NO,              
   LONG_NAME,              
   MAPIN_ID,              
   MICR_NO,              
   MOBILE_PAGER,              
   MODIFIDEDBY,              
   MODIFIDEDON,              
   OFF_PHONE1,              
   OFF_PHONE2,              
   OTHER_AC_NO,              
   P_ADDRESS1,              
   P_ADDRESS2,              
   P_ADDRESS3,              
   P_CITY,              
   P_NATION,              
   P_PHONE,              
   P_STATE,              
   P_ZIP,              
   PAN_GIR_NO,              
   PARTY_CODE,              
   PASSPORT_EXPIRES_ON,              
   PASSPORT_ISSUED_AT,              
   PASSPORT_ISSUED_ON,              
   PASSPORT_NO,              
   PAYLOCATION,              
   POA1,              
   POA2,              
   POA3,              
   RAT_CARD_ISSUED_AT,              
   RAT_CARD_ISSUED_ON,              
   RAT_CARD_NO,              
   REGION,              
   REGR_AT,              
   REGR_AUTHORITY,              
   REGR_NO,              
   REGR_ON,              
   REL_MGR,              
   REPATRIAT_BANK,              
   REPATRIAT_BANK_AC_NO,              
   RES_PHONE1,              
   RES_PHONE2,              
   SBU,              
   SEBI_REGN_NO,              
   SETT_MODE,              
   SEX,              
   SHORT_NAME,              
   STATUS,              
   SUB_BROKER,              
   TRADER,              
   UCC_CODE,              
   VOTERSID_ISSUED_AT,              
   VOTERSID_ISSUED_ON,              
   VOTERSID_NO,              
   WARD_NO              
  )              
  SELECT              
   AC_NUM,              
   AC_TYPE,              
   ADDEMAILID,              
   APPROVER,              
   AREA,              
   BANK_ID,              
   BANK_NAME,              
   BRANCH_CD,              
   BRANCH_NAME,              
   C_GROUP,              
   CHK_ANNUAL_REPORT,              
   CHK_BANK_CERTIFICATE,              
   CHK_CORP_DTLS_RECD,              
   CHK_CORPORATE_DEED,              
   CHK_KYC_FORM,              
   CHK_NETWORTH_CERT,              
   CL_CODE,              
   CL_STATUS,              
   CL_TYPE,              
   CLIENT_AGREEMENT_ON,              
   CLTDPID1,              
   CLTDPID2,              
   CLTDPID3,              
   DEALING_WITH_OTHER_TM,              
   DEPOSITORY1,              
   DEPOSITORY2,              
   DEPOSITORY3,              
   DIRECTOR_NAME,              
   DOB,              
   DPID1,              
   DPID2,              
   DPID3,              
   EMAIL,              
   FAMILY,              
   FAX,              
   FMCODE,              
   IMP_STATUS,              
   INTERACTMODE,              
   INTRODUCER,              
   INTRODUCER_ID,              
   INTRODUCER_RELATION,              
   IT_RETURN_FILED_ON,              
   IT_RETURN_YR,              
   L_ADDRESS1,              
   L_ADDRESS2,              
   L_ADDRESS3,              
   L_CITY,              
   L_NATION,              
   L_STATE,              
   L_ZIP,              
   LICENCE_EXPIRES_ON,              
   LICENCE_ISSUED_AT,              
   LICENCE_ISSUED_ON,              
   LICENCE_NO,              
   LONG_NAME,              
   MAPIN_ID,              
   MICR_NO,              
   MOBILE_PAGER,              
   MODIFIDEDBY,              
   MODIFIDEDON,              
   OFF_PHONE1,              
   OFF_PHONE2,              
   OTHER_AC_NO,              
   P_ADDRESS1,              
   P_ADDRESS2,              
   P_ADDRESS3,              
   P_CITY,              
   P_NATION,              
   P_PHONE,              
   P_STATE,              
   P_ZIP,              
   PAN_GIR_NO,              
   PARTY_CODE,              
   PASSPORT_EXPIRES_ON,              
   PASSPORT_ISSUED_AT,              
   PASSPORT_ISSUED_ON,              
   PASSPORT_NO,              
   PAYLOCATION,              
   POA1,              
   POA2,              
   POA3,              
   RAT_CARD_ISSUED_AT,              
   RAT_CARD_ISSUED_ON,              
RAT_CARD_NO,              
   REGION,              
   REGR_AT,              
   REGR_AUTHORITY,              
   REGR_NO,              
   REGR_ON,              
   REL_MGR,              
   REPATRIAT_BANK,              
   REPATRIAT_BANK_AC_NO,              
   RES_PHONE1,              
   RES_PHONE2,              
   SBU,              
   SEBI_REGN_NO,              
   SETT_MODE,              
   SEX,              
   SHORT_NAME,              
   STATUS,              
   SUB_BROKER,              
   TRADER,              
   UCC_CODE,              
   VOTERSID_ISSUED_AT,              
   VOTERSID_ISSUED_ON,              
   VOTERSID_NO,              
   WARD_NO              
  FROM #CLIENT_DETAILS              
   WHERE VALID_RECORD = 'Y' AND MODIFIED = 'N'             
  AND CL_CODE NOT IN (SELECT CL_CODE FROM CLIENT_DETAILS )          
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
              
 --- MODIFY THE EXISTING RECORD              
 IF @pa_CanModifyData =  1              
  UPDATE CLIENT_DETAILS SET               
   AC_NUM = B.AC_NUM,               
   AC_TYPE = B.AC_TYPE,               
   ADDEMAILID = B.ADDEMAILID,               
--   APPROVER = B.APPROVER,           
   AREA = B.AREA,               
   BANK_ID = B.BANK_ID,               
   BANK_NAME = B.BANK_NAME,               
--   BRANCH_CD = B.BRANCH_CD,               
   BRANCH_NAME = B.BRANCH_NAME,               
   C_GROUP = B.C_GROUP,               
   CHK_ANNUAL_REPORT = B.CHK_ANNUAL_REPORT,               
   CHK_BANK_CERTIFICATE = B.CHK_BANK_CERTIFICATE,               
   CHK_CORP_DTLS_RECD = B.CHK_CORP_DTLS_RECD,               
   CHK_CORPORATE_DEED = B.CHK_CORPORATE_DEED,               
   CHK_KYC_FORM = B.CHK_KYC_FORM,               
   CHK_NETWORTH_CERT = B.CHK_NETWORTH_CERT,               
--   CL_CODE = B.CL_CODE,               
   CL_STATUS = B.CL_STATUS,               
   CL_TYPE = B.CL_TYPE,               
   CLIENT_AGREEMENT_ON = B.CLIENT_AGREEMENT_ON,               
   CLTDPID1 = B.CLTDPID1,               
   CLTDPID2 = B.CLTDPID2,               
   CLTDPID3 = B.CLTDPID3,               
   DEALING_WITH_OTHER_TM = B.DEALING_WITH_OTHER_TM,               
   DEPOSITORY1 = B.DEPOSITORY1,               
   DEPOSITORY2 = B.DEPOSITORY2,               
   DEPOSITORY3 = B.DEPOSITORY3,               
   DIRECTOR_NAME = B.DIRECTOR_NAME,               
   DOB = B.DOB,               
   DPID1 = B.DPID1,               
   DPID2 = B.DPID2,               
   DPID3 = B.DPID3,               
   EMAIL = B.EMAIL,               
   FAMILY = B.FAMILY,               
   FAX = B.FAX,               
   FMCODE = B.FMCODE,               
   IMP_STATUS = 0,               
   INTERACTMODE = B.INTERACTMODE,               
   INTRODUCER = B.INTRODUCER,               
   INTRODUCER_ID = B.INTRODUCER_ID,               
   INTRODUCER_RELATION = B.INTRODUCER_RELATION,               
   IT_RETURN_FILED_ON = B.IT_RETURN_FILED_ON,               
   IT_RETURN_YR = B.IT_RETURN_YR,               
   L_ADDRESS1 = B.L_ADDRESS1,               
   L_ADDRESS2 = B.L_ADDRESS2,               
   L_ADDRESS3 = B.L_ADDRESS3,               
   L_CITY = B.L_CITY,               
   L_NATION = B.L_NATION,               
   L_STATE = B.L_STATE,               
   L_ZIP = B.L_ZIP,               
   LICENCE_EXPIRES_ON = B.LICENCE_EXPIRES_ON,               
   LICENCE_ISSUED_AT = B.LICENCE_ISSUED_AT,               
   LICENCE_ISSUED_ON = B.LICENCE_ISSUED_ON,               
   LICENCE_NO = B.LICENCE_NO,               
   LONG_NAME = B.LONG_NAME,               
   MAPIN_ID = B.MAPIN_ID,               
   MICR_NO = B.MICR_NO,               
   MOBILE_PAGER = B.MOBILE_PAGER,               
   MODIFIDEDBY = B.MODIFIDEDBY,               
   MODIFIDEDON = B.MODIFIDEDON,               
   OFF_PHONE1 = B.OFF_PHONE1,               
   OFF_PHONE2 = B.OFF_PHONE2,               
   OTHER_AC_NO = B.OTHER_AC_NO,               
   P_ADDRESS1 = B.P_ADDRESS1,               
   P_ADDRESS2 = B.P_ADDRESS2,    
   P_ADDRESS3 = B.P_ADDRESS3,               
   P_CITY = B.P_CITY,               
   P_NATION = B.P_NATION,               
   P_PHONE = B.P_PHONE,               
   P_STATE = B.P_STATE,               
   P_ZIP = B.P_ZIP,               
   PAN_GIR_NO = B.PAN_GIR_NO,               
--   PARTY_CODE = B.PARTY_CODE,               
   PASSPORT_EXPIRES_ON = B.PASSPORT_EXPIRES_ON,               
   PASSPORT_ISSUED_AT = B.PASSPORT_ISSUED_AT,               
   PASSPORT_ISSUED_ON = B.PASSPORT_ISSUED_ON,               
   PASSPORT_NO = B.PASSPORT_NO,               
   PAYLOCATION = B.PAYLOCATION,               
   POA1 = B.POA1,               
   POA2 = B.POA2,               
   POA3 = B.POA3,               
   RAT_CARD_ISSUED_AT = B.RAT_CARD_ISSUED_AT,               
   RAT_CARD_ISSUED_ON = B.RAT_CARD_ISSUED_ON,               
   RAT_CARD_NO = B.RAT_CARD_NO,               
   REGION = B.REGION,               
   REGR_AT = B.REGR_AT,               
   REGR_AUTHORITY = B.REGR_AUTHORITY,               
   REGR_NO = B.REGR_NO,               
   REGR_ON = B.REGR_ON,               
   REL_MGR = B.REL_MGR,               
   REPATRIAT_BANK = B.REPATRIAT_BANK,               
   REPATRIAT_BANK_AC_NO = B.REPATRIAT_BANK_AC_NO,               
   RES_PHONE1 = B.RES_PHONE1,               
   RES_PHONE2 = B.RES_PHONE2,               
   SBU = B.SBU,               
   SEBI_REGN_NO = B.SEBI_REGN_NO,               
   SETT_MODE = B.SETT_MODE,               
   SEX = B.SEX,               
   SHORT_NAME = B.SHORT_NAME,               
   STATUS = B.STATUS,               
   SUB_BROKER = B.SUB_BROKER,               
   TRADER = B.TRADER,               
   UCC_CODE = B.UCC_CODE,               
   VOTERSID_ISSUED_AT = B.VOTERSID_ISSUED_AT,               
   VOTERSID_ISSUED_ON = B.VOTERSID_ISSUED_ON,               
   VOTERSID_NO = B.VOTERSID_NO,               
   WARD_NO = B.WARD_NO               
  FROM CLIENT_DETAILS AS A, #CLIENT_DETAILS AS B               
  WHERE B.VALID_RECORD = 'Y' AND B.MODIFIED = 'M'              
  AND A.CL_CODE = B.CL_CODE AND A.PARTY_CODE = B.PARTY_CODE              
              
 IF @@ERROR <> 0               
 BEGIN              
  SET @pa_err = @@ERROR              
  RETURN              
 END              
               
 IF @pa_CanDeleteData = 1              
  --- REMOVE BROK DETAILS RECORDS              
  DELETE CLIENT_DETAILS               
   FROM CLIENT_DETAILS AS A, #CLIENT_DETAILS AS B               
   WHERE B.VALID_RECORD = 'Y' AND B.MODIFIED = 'D'              
   AND A.CL_CODE = B.CL_CODE AND A.PARTY_CODE = B.PARTY_CODE              
              
 IF @@ERROR = 0               
  SET @pa_err = ''              
 ELSE              
  SET @pa_err = @@ERROR              
              
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'N' ---- VALID INSERT              
-- -- VALID_RECORD = 'N' AND MODIFIED = 'N' ---- INVALID INSERT              
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'M' ---- VALID MODIFY              
-- -- VALID_RECORD = 'N' AND MODIFIED = 'M' ---- INVALID MODIFY              
-- -- VALID_RECORD = 'Y' AND MODIFIED = 'D' ---- VALID DELETE              
-- -- VALID_RECORD = 'N' AND MODIFIED = 'D' ---- INVALID DELETE              
              
END              
              
/*              
              
DECLARE              
 @CanAddData AS Bit,              
 @CanModifyData AS Bit,              
 @CanDeleteData AS Bit,             
 @pa_err AS VarChar(250)               
              
SET @CanAddData = 1              
SET @CanModifyData = 1              
SET @CanDeleteData = 1              
              
EXEC Pr_Mig_Client_Details @CanAddData, @CanModifyData, @CanDeleteData, @pa_err OUTPUT              
PRINT @pa_err              
              
              
SELECT * FROM #CLIENT_DETAILS              
              
SELECT * FROM #CLIENT_DETAILS WHERE MODIFIEDBY = 'CITRUS-MIG'                  
*/

GO
