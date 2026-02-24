-- Object: PROCEDURE dbo.RPT_UCCFILEGENERATION_UP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

    --EXEC RPT_UCCFILEGENERATION 'Feb 17 2006','Feb 17 2006','0','ZZZZZZ','S'    
CREATE PROC RPT_UCCFILEGENERATION_UP    
 (    
 @FROMDATE VARCHAR(11),    
 @TODATE VARCHAR(11),    
 @PARTYFROM VARCHAR(10),    
 @PARTYTO VARCHAR(10),    
 @OPTIONVAL VARCHAR(2)    
 )    
    
 AS    
    
 SET NOCOUNT ON    
    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
 IF @PARTYTO='' BEGIN SET @PARTYTO = 'zzzzzz' end    
    
 Create Table #ClientList    
 (Party_Code Varchar(10))    
     
 CREATE INDEX [indxcl2] ON #ClientList ([Party_code])    
    
/*-----------------------------------------------------------------------------    
  Fetching Traded Client List to #ClientLis    
-----------------------------------------------------------------------------*/    
    
 IF @OPTIONVAL = 'T'    
  Begin    
   Insert Into #ClientList    
   Select    
    Distinct Party_Code    
   From    
    Settlement (nolock)    
   Where    
    Sauda_Date Between @FromDate and @TODATE + ' 23:59'    
    And Party_Code Between @PartyFrom and @PartyTo    
     
   Insert Into #ClientList    
   Select    
    Distinct Party_Code    
   From    
    History (nolock)    
   Where    
    Sauda_Date Between @FromDate and @TODATE + ' 23:59'    
    And Party_Code Between @PartyFrom and @PartyTo    
     
   Insert Into #ClientList    
   Select    
    Distinct Party_Code    
   From    
    ISettlement (nolock)    
   Where    
    Sauda_Date Between @FromDate and @TODATE + ' 23:59'    
    And Party_Code Between @PartyFrom and @PartyTo    
     
   Insert Into #ClientList    
   Select    
    Distinct Party_Code    
   From    
    IHistory (nolock)    
   Where    
    Sauda_Date Between @FromDate and @TODATE + ' 23:59'    
    And Party_Code Between @PartyFrom and @PartyTo    
     
  End  
 else if @OPTIONVAL = 'M'  
 begin  
   Insert Into #ClientList    
   Select    
     Party_Code    
   From    
    Client_details C, Client_Brok_Details B   
   Where    
    C.Cl_Code = B.Cl_Code   
    And Exchange = 'NSE' And Segment = 'CAPITAL'  
    And Party_Code Between @PartyFrom and @PartyTo  
    AND C.MODIFIDEDON Between @FromDate and @TODATE + ' 23:59'    
    AND LEFT(SYSTEMDATE,11) <> LEFT(MODIFIDEDON,11)  
 end  
 Else    
  Begin    
   Insert Into #ClientList    
   Select    
     Party_Code    
   From    
    Client2    
   Where    
    Party_Code Between @PartyFrom and @PartyTo    
  End    
     
    
/*-----------------------------------------------------------------------------    
   Fetching Data To #UCC_NSE    
-----------------------------------------------------------------------------*/    
    
    
 SELECT     
  DISTINCT     
  SEGMENT = 'S',    
  CLIENTCODE = c2.party_code,    
  LONGNAME = REPLACE(REPLACE(REPLACE(ISNULL(c1.long_name,''),'.',''),',',''),';',''),    
  --CATEGORY = ISNULL(c1.cl_status, ''),    
  CATEGORY = (CASE WHEN isnull(C1.cl_status,'') in ('NOR','NRI','ROR','PRO','IND')     
    THEN 'IND'     
    ELSE isnull(C1.cl_status,'')     
    END),    
  FULLADDRESS =     
   ISNULL(rtrim(c1.l_address1),'') + ' '     
   + ISNULL(rtrim(c1.l_address2),'') + ' '     
   + ISNULL(rtrim(c1.l_address3),'') + ' '     
   + ISNULL(rtrim(c1.L_city),'') + ' '     
   + ISNULL(rtrim(c1.L_State),''),    
  ZIP = ISNULL(c1.l_zip, ''),    
  PHONE1 = ISNULL(c1.res_phone1, ''),    
  AGGREMENTDATE =       
   (CASE WHEN c5.client_agre_dt IS NULL       
    THEN ''       
    ELSE CASE WHEN (left(convert(varchar,c5.client_agre_dt,109),11) ='Jan 1 1900')       
    THEN ''       
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.client_agre_dt)) < 10)       
    THEN ('0' + DATENAME(day, c5.client_agre_dt))       
    ELSE (DATENAME(day, c5.client_agre_dt))       
    END + '-' + (LEFT(DATENAME(month, c5.client_agre_dt), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.client_agre_dt)))       
    END END),    
  DOB = (CASE WHEN C1.cl_status IN ('HUF', 'CC', 'PSF', 'IC', 'DFI', 'OCB', 'TS', 'SB','BC') THEN '' ELSE  
   (CASE WHEN c5.birthdate IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.birthdate,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.birthdate)) < 10)     
    THEN ('0' + DATENAME(day, c5.birthdate))     
    ELSE (DATENAME(day, c5.birthdate))     
    END + '-' + (LEFT(DATENAME(month, c5.birthdate), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.birthdate)))     
    END END) END),    
  PAN = ISNULL(c1.pan_gir_no, ''),    
  WARD = ISNULL(c1.ward_no, ''),    
  PASSPORTNO = ISNULL(c5.passportdtl, ''),    
  PASSPORTPLACE = ISNULL(c5.passportplaceOfissue, ''),    
  PASSPORTDATE =    
   (CASE WHEN c5.passportdateOfissue IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.passportdateOfissue,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.passportdateOfissue)) < 10)     
    THEN ('0' + DATENAME(day, c5.passportdateOfissue))     
    ELSE (DATENAME(day, c5.passportdateOfissue))     
    END + '-' + (LEFT(DATENAME(month, c5.passportdateOfissue), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.passportdateOfissue)))     
    END END),    
  DRIVINGLICNO = ISNULL(c5.drivelicendtl, ''),    
  DRIVINGLICPLACE = ISNULL(c5.licenceNoplaceOfissue, ''),    
  DRIVINGLICDATE =     
   (CASE WHEN c5.licenceNodateOfissue IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.licenceNodateOfissue,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.licenceNodateOfissue)) < 10)     
    THEN ('0' + DATENAME(day, c5.licenceNodateOfissue))     
    ELSE (DATENAME(day, c5.licenceNodateOfissue))     
    END + '-' + (LEFT(DATENAME(month, c5.licenceNodateOfissue), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.licenceNodateOfissue)))     
    END END),    
  VOTERID = ISNULL(c5.votersiddtl, ''),    
  VOTERIDPLACE = ISNULL(c5.voteridplaceOfissue, ''),    
  VOTERIDDATE =     
   (CASE WHEN c5.voteriddateOfissue IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.voteriddateOfissue,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.voteriddateOfissue)) < 10)     
    THEN ('0' + DATENAME(day, c5.voteriddateOfissue))     
    ELSE (DATENAME(day, c5.voteriddateOfissue))     
    END + '-' + (LEFT(DATENAME(month, c5.voteriddateOfissue), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.voteriddateOfissue)))     
    END END),     
  RATIONCARDID = ISNULL(c5.Rationcarddtl, ''),    
  RATIONCARDIDPLACE = ISNULL(c5.RationCardPlaceOfIssue, ''),    
  RATIONCARDIDDATE =    
   (CASE WHEN c5.RationCardDateOfIssue IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.RationCardDateOfIssue,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.RationCardDateOfIssue)) < 10)     
    THEN ('0' + DATENAME(day, c5.RationCardDateOfIssue))     
    ELSE (DATENAME(day, c5.RationCardDateOfIssue))     
    END + '-' + (LEFT(DATENAME(month, c5.RationCardDateOfIssue), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.RationCardDateOfIssue)))     
    END END),     
  REGNO = ISNULL(c5.regr_no, ''),    
  REGAUTHORITY = ISNULL(c5.regr_auth, ''),    
  REGPALCE = ISNULL(c5.regr_place, ''),    
  REGDATE =     
   (CASE WHEN c5.regr_date IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.regr_date,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.regr_date)) < 10)     
    THEN ('0' + DATENAME(day, c5.regr_date))     
    ELSE (DATENAME(day, c5.regr_date))     
    END + '-' + (LEFT(DATENAME(month, c5.regr_date), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.regr_date)))     
    END END),    
  INTRODUCER = ISNULL(c5.introducer, ''),    
  INTRORELATION = ISNULL(c5.INTROD_RELATION, ''),    
  INTROCLID = ISNULL(c5.INTROD_CLIENT_ID, ''),    
  OTHERACCNO = ISNULL(c5.ANY_OTHER_ACC, ''),    
  SETTMODE = ISNULL(c5.SETT_MODE, ''),    
  OTHERTMCLIENT = ISNULL(c5.DEALING_WITH_OTHRER_TM, ''),    
  UCCCLIENTCODE = ISNULL(UC.PARTY_CODE,''),    
  MAPINID = ISNULL(UC.MAPIDID,''),    
  ENDOFRECDFLAG = ISNULL('E', ''),    
  BANKACCTYPE = Space(2),    
  BANKACCOUNT = Space(16),    
  BENFACCOUNT = Space(16),    
  BANKNAME = Space(50),    
  BANKFULLADDRESS = Space(50),    
  DPBANKNAME = Space(50),    
  DPID = Space(16),    
  DEPOSITORY = Space(8),    
  NSDL_DepositoryName = Space(4),     
  NSDL_DepositoryParticipantId = Space(8),    
  NSDL_DepositoryParticipantName = Space(25),     
  NSDL_BeneficiaryAccountID = Space(8),    
  CDSL_DepositoryName = Space(4),     
  CDSL_DepositoryParticipantId = Space(8),    
  CDSL_DepositoryParticipantName = Space(25),     
  CDSL_BeneficiaryAccountID = Space(8),    
  Cl_AccountNo = Space(25)     
 INTO  #UCC_NSE     
    
 FROM     
  CLIENT1 C1(NOLOCK),    
  CLIENT2 C2(NOLOCK),    
  CLIENT5 C5(NOLOCK),    
  #ClientList CL     
   Left Outer Join     
   Ucc_Client uc     
   on (uc.Party_Code = CL.Party_Code)  
    
 WHERE     
  C1.CL_CODE = C2.CL_CODE    
  AND C1.CL_CODE = C5.CL_CODE    
  AND CL.PARTY_CODE = C2.PARTY_CODE    
  AND C1.CL_TYPE <> 'REM'    
  AND C2.PARTY_CODE IN (SELECT PARENTCODE FROM CLIENT2 C22  
    WHERE C22.PARTY_CODE = C2.PARTY_CODE)    
  
  AND C5.SystumDate Between     
   Case When @optionval = 'A' then @FromDate else 'Jan  1 1900' End    
    And    
   Case When @optionval = 'A' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End    
  AND C5.ActiveFrom Between    
   Case When @optionval = 'S' then @FromDate else 'Jan  1 1900' End    
    And    
   Case When @optionval = 'S' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End    
  AND C5.InActiveFrom Between    
   Case When @optionval = 'I' then @FromDate else 'Jan  1 1900' End    
    And    
   Case When @optionval = 'I' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End    
    
    
    
/*-----------------------------------------------------------------------------    
  Updating #UCC_NSE for Account Details    
-----------------------------------------------------------------------------*/    
    
 Update     
  #UCC_NSE     
  Set bankacctype =     
   (CASE WHEN left(c4.depository,6) = 'SAVING'     
    THEN '10' ELSE CASE WHEN left(c4.depository,7) = 'CURRENT'     
    THEN '11' ELSE '99' END     
    END),    
  bankaccount =     
   (CASE WHEN left(c4.depository,7) IN ('SAVING','CURRENT','NRE','NRO')     
    THEN cltdpid ELSE ''     
    END),    
  Cl_AccountNo=CLTDPID    
 FROM     
  Client4 C4     
 WHERE     
  c4.depository NOT in ('CDSL', 'NSDL')    
  And C4.Party_Code = clientcode    
    
/*-----------------------------------------------------------------------------    
  Updating #UCC_NSE for DP Details    
-----------------------------------------------------------------------------*/    
    
 Update     
  #UCC_NSE     
  Set benfaccount =  ISNULL(cltdpid,''),     
  DpId = IsNull(C4.BankId,''),     
  depository = IsNull(C4.depository,'')    
 FROM     
  Client4 C4    
 WHERE     
  C4.depository in ('CDSL', 'NSDL')       
  And C4.Party_Code = clientcode     
  And defdp = 1    
     
/*-----------------------------------------------------------------------------    
  Updating #UCC_NSE for Bank Name    
-----------------------------------------------------------------------------*/    
    
 Update     
  #UCC_NSE     
  Set bankname = ISNULL(Left(bank_name,50),''),     
  bankfulladdress = ISNULL(Left(branch_name,50),'')    
 FROM     
  (SELECT     
   PARTY_CODE,    
   BANK_NAME,     
   BRANCH_NAME     
  FROM     
   client4 C4,     
   pobank P    
  WHERE     
   Convert(VarChar, p.bankid) = C4.BANKID    
   AND depository NOT IN ('CDSL', 'NSDL')) A    
 WHERE     
  Party_Code = clientcode    
    
/*-----------------------------------------------------------------------------    
  Updating #UCC_NSE Multiple DP Details    
-----------------------------------------------------------------------------*/    
    
 Update     
  #UCC_NSE     
  Set NSDL_DepositoryName = Left(M.DpType,4),    
  NSDL_DepositoryParticipantId = Case When M.DpType ='NSDL' Then Left(M.DPID,8) else '' End ,    
  NSDL_DepositoryParticipantName = Case When M.DpType ='NSDL' Then Left(M.Introducer,25) else '' End ,     
  NSDL_BeneficiaryAccountID = Case When M.DpType ='NSDL' Then Left(M.cltdpno,8) else '' End    
 From     
  MultiCltID M    
 WHERE     
  M.def=1     
  And M.Party_Code = clientcode     
     
     
 Update     
  #UCC_NSE Set Dpbankname = ISNULL(Left(A.bankname,50),'')    
  FROM(     
   SELECT party_code,BankName     
   FROM client4 C4, bank P    
   WHERE Convert(VarChar,  p.bankid) = C4.BANKID    
   AND depository IN ('CDSL', 'NSDL')    
   ) A    
  WHERE Party_Code = clientcode    
    
/*-----------------------------------------------------------------------------    
  Fetching Final OutPut    
-----------------------------------------------------------------------------*/    
    
    
 SELECT *     
 FROM #UCC_NSE     
 ORDER BY ClientCode

GO
