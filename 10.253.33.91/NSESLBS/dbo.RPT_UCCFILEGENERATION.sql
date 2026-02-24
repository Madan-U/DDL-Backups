-- Object: PROCEDURE dbo.RPT_UCCFILEGENERATION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--EXEC RPT_UCCFILEGENERATION 'JUL 20 2000','OCT  1 2011','0','ZZZZZZ','A','','ZZZZZZZ',''

CREATE  PROC [dbo].[RPT_UCCFILEGENERATION]  
 (  
 @FROMDATE VARCHAR(11),  
 @TODATE VARCHAR(11),  
 @PARTYFROM VARCHAR(10),  
 @PARTYTO VARCHAR(10),  
 @OPTIONVAL VARCHAR(2),
 @FROMBRANCH VARCHAR(15),  
 @TOBRANCH VARCHAR(15),  
 @CLTYPE VARCHAR(2) 
 )  
  
 AS  
  
 SET NOCOUNT ON  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 IF @PARTYTO='' BEGIN SET @PARTYTO = 'zzzzzz' END
 IF @TOBRANCH='' BEGIN SET @TOBRANCH ='zzzzzz' END
  
 Create Table #ClientList  
 (Party_Code Varchar(10))  
   
 CREATE INDEX [indxcl2] ON #ClientList ([Party_code])  
  
 Create Table #ClientList1  
 (Party_Code Varchar(10))  
   
 CREATE INDEX [indxcl2] ON #ClientList1 ([Party_code])  

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
    MSAJAG.DBO.Client_details C (NOLOCK), 
    MSAJAG.DBO.Client_Brok_Details B (NOLOCK)
   Where  
    C.Cl_Code = B.Cl_Code 
    And Exchange = 'NSE' And Segment = 'CAPITAL'
    And Party_Code Between @PartyFrom and @PartyTo
	And BRANCH_CD Between @FROMBRANCH and @TOBRANCH
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
   		
  UPDATE #CLIENTLIST SET PARTY_CODE = PARENTCODE  
  FROM CLIENT2 C2 (NOLOCK) 
  WHERE C2.PARTY_CODE = #CLIENTLIST.PARTY_CODE  
     
  INSERT INTO #CLIENTLIST1  
  SELECT DISTINCT PARTY_CODE FROM #CLIENTLIST
    
/*-----------------------------------------------------------------------------  
   Fetching Data To #UCC_NSE  
-----------------------------------------------------------------------------*/  

   
 SELECT   
  DISTINCT   
  SEGMENT = 'S',  
  CLIENTCODE = C2.party_code,
  LONGNAME = (CASE WHEN ISNULL(ADDEMAILID,'') <> '' AND ADDEMAILID NOT LIKE '%@%' 
			THEN LEFT(REPLACE(REPLACE(REPLACE(ISNULL(ADDEMAILID,''),'.',''),',',''),';',''),150)
			ELSE LEFT(REPLACE(REPLACE(REPLACE(ISNULL(C1.LONG_NAME,''),'.',''),',',''),';',''),150)
		END),
  CATEGORY = (CASE WHEN isnull(C1.cl_status,'') in ('NOR','NRI','ROR','PRO','IND','IN')   
    THEN 'IND'   
    ELSE isnull(C1.cl_status,'')   
    END),  
  ADDRESS1 = L_ADDRESS1, ---(Case When Len(L_ADDRESS1) < 5 Then L_ADDRESS1 + ' ' + L_ADDRESS2 ELSE L_ADDRESS1 END),
  ADDRESS2 = L_ADDRESS2,
  ADDRESS3 = L_ADDRESS3,
  FULLADDRESS =   
	   ISNULL(rtrim(L_ADDRESS1),'') + ' '   
	   + ISNULL(rtrim(L_ADDRESS2),'') + ' '   
	   + ISNULL(rtrim(L_ADDRESS3),''),   
  CITY = L_CITY,
  STATE = L_STATE,
  ZIP = ISNULL(L_ZIP,''),  
  NATION = L_NATION,
  ISDCODE = ' ',
  STDCODE = ' ',
  PHONE1 = (Case When isnull(C1.res_phone1,'') <> ''   
		  Then Replace(Replace(Replace(Replace(Replace(Replace(C1.res_phone1,'/',''),'(',''),')',''),'-',''),':',''),';','')  
		  When isnull(C1.res_phone2,'') <> ''   
		  Then Replace(Replace(Replace(Replace(Replace(Replace(C1.res_phone2,'/',''),'(',''),')',''),'-',''),':',''),';','')  
		  When isnull(C1.Off_phone1,'') <> ''   
		  Then Replace(Replace(Replace(Replace(Replace(Replace(C1.Off_phone1,'/',''),'(',''),')',''),'-',''),':',''),';','')  
		  When isnull(C1.Off_phone2,'') <> ''   
		  Then Replace(Replace(Replace(Replace(Replace(Replace(C1.Off_phone2,'/',''),'(',''),')',''),'-',''),':',''),';','')  
		  Else ''  
    		End),
  MOBILENO = ISNULL(C1.MOBILE_PAGER,''), 
  EMAIL = C1.EMAIL,
  AGGREMENTDATE = (
  CASE
	WHEN c5.client_agre_dt IS NULL OR convert(varchar(11),c5.client_agre_dt,109) = 'Jan  1 1900' THEN ''
	ELSE REPLACE(CONVERT(VARCHAR,c5.client_agre_dt,106),' ','-')
  END),
   /*(CASE WHEN c5.client_agre_dt IS NULL     
    THEN ''     
    ELSE CASE WHEN (left(convert(varchar,c5.client_agre_dt,109),11) ='Jan 1 1900')     
    THEN ''     
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.client_agre_dt)) < 10)     
    THEN ('0' + DATENAME(day, c5.client_agre_dt))     
    ELSE (DATENAME(day, c5.client_agre_dt))     
    END + '-' + (LEFT(DATENAME(month, c5.client_agre_dt), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.client_agre_dt)))     
    END END),*/  
  DOB = (
  CASE
	WHEN c5.birthdate IS NULL OR convert(varchar(11),c5.birthdate,109) = 'Jan  1 1900' THEN ''
	ELSE REPLACE(CONVERT(VARCHAR,c5.birthdate,106),' ','-')
  END),
  /*
  (CASE WHEN C1.cl_status IN ('HUF', 'CC', 'PSF', 'IC', 'MF', 'DFI', 'OCB', 'TS', 'SB','BC') THEN '' ELSE
   (CASE WHEN c5.birthdate IS NULL   
    THEN ''   
    ELSE CASE WHEN (left(convert(varchar,c5.birthdate,109),11) ='Jan 1 1900')   
    THEN ''   
    ELSE CASE WHEN (CONVERT(Int, DATENAME(day, c5.birthdate)) < 10)   
    THEN ('0' + DATENAME(day, c5.birthdate))   
    ELSE (DATENAME(day, c5.birthdate))   
    END + '-' + (LEFT(DATENAME(month, c5.birthdate), 3)) + '-' + (CONVERT(VarChar, YEAR(c5.birthdate)))   
    END END) END),*/  
  PAN = ISNULL(PAN_GIR_NO, ''),  
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
  UCCCLIENTCODE = SPACE(15),  
  MAPINID = SPACE(20),  
  ENDOFRECDFLAG = ISNULL('E', ''),  
  BANKACCTYPE = Space(2),  
  BANKACCOUNT = Space(20),  
  BENFACCOUNT = Space(20),  
  BANKNAME = Space(60),  
  BANKFULLADDRESS = Space(255),  
  DPBANKNAME = Space(50),  
  DPID = Space(20),  
  DEPOSITORY = Space(8),  
  NSDL_DepositoryName = Space(4),   
  NSDL_DepositoryParticipantId = Space(8),  
  NSDL_DepositoryParticipantName = Space(25),   
  NSDL_BeneficiaryAccountID = Space(8),  
  CDSL_DepositoryName = Space(4),   
  CDSL_DepositoryParticipantId = Space(8),  
  CDSL_DepositoryParticipantName = Space(25),   
  CDSL_BeneficiaryAccountID = Space(16),  
  Cl_AccountNo = Space(25),
  PROOFTYPE = ' ',
  PROOFNO = ' ',
  PROOFISSUEPLACE = ' ',
  PROOFISSUEDATE = ' ',
  CONTACTPERSON1 = SPACE(100),
  DESIGNATIONCONTACTPERSON1 = SPACE(60),
  PANCONTACTPERSON1 = SPACE(10),
  ADDCONTRACTPERSON1 = SPACE(255),
  CONTACTNOCONTACTPERSON1 = SPACE(60),
  EMAILCONTACTPERSON1 = SPACE(60),
  CONTACTPERSON2 = SPACE(100),
  DESIGNATIONCONTACTPERSON2 = SPACE(60),
  PANCONTACTPERSON2 = SPACE(10),
  ADDCONTRACTPERSON2 = SPACE(255),
  CONTACTNOCONTACTPERSON2 = SPACE(60),
  EMAILCONTACTPERSON2 = SPACE(60),
  CONTACTPERSON3 = SPACE(100),
  DESIGNATIONCONTACTPERSON3 = SPACE(60),
  PANCONTACTPERSON3 = SPACE(10),
  ADDCONTRACTPERSON3 = SPACE(255),
  CONTACTNOCONTACTPERSON3 = SPACE(60),
  EMAILCONTACTPERSON3 = SPACE(60),
  UPDATIONFLAG	= CONVERT(VARCHAR(1),'N'),
  RELATIONSHIP	= CONVERT(VARCHAR(1),''),
  MASTERPAN	= CONVERT(VARCHAR(15),''),
  TYPEOFFACILITY= CONVERT(VARCHAR(1),''),
  CIN_NO	= CONVERT(VARCHAR(21),'')

 INTO #UCC_NSE   
  
 FROM   
  CLIENT1 C1(NOLOCK),  
  CLIENT2 C2(NOLOCK),  
  CLIENT5 C5(NOLOCK),
  #CLIENTLIST1 CL (NOLOCK)

 WHERE   
  C1.CL_CODE = C2.CL_CODE  
  AND C1.CL_CODE = C5.CL_CODE  
  AND CL.PARTY_CODE = C2.PARTY_CODE
  AND C1.CL_TYPE <> 'REM'  
  AND 1 = (CASE   
		WHEN @CLTYPE='' THEN 1   
		WHEN @CLTYPE='I' THEN (CASE WHEN C1.CL_TYPE = 'INS' THEN 1 ELSE 0 END)
		WHEN @CLTYPE='C' THEN (CASE WHEN C1.CL_TYPE <> 'INS' THEN 1 ELSE 0 END)
		ELSE 0  
		END)  
  And BRANCH_CD Between @FROMBRANCH and @TOBRANCH 
  AND C5.SystumDate Between   
   Case When @optionval = 'A' then @FromDate else 'Jan  1 1900' End  
    And  
   Case When @optionval = 'A' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End  
  AND C5.ActiveFrom Between  
   Case When @optionval = 'S' then @FromDate else 'Jan  1 1900' End  
    And  
   Case When @optionval = 'S' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End  

  AND C5.InActiveFrom Not Between  
   Case When @optionval = 'S' then @FromDate else 'Jan  1 1900' End  
    And  
   Case When @optionval = 'S' then @ToDate + ' 23:59' else '' End  

  AND C5.InActiveFrom Between  
   Case When @optionval = 'I' then @FromDate else 'Jan  1 1900' End  
    And  
   Case When @optionval = 'I' then @ToDate + ' 23:59' else 'Dec 31 2049 23:59' End  
  
/*-----------------------------------------------------------------------------
  Updating #UCC_NSE For UCC Details
------------------------------------------------------------------------------*/  
  
	UPDATE
		#UCC_NSE
		SET   
			UCCCLIENTCODE = (
			CASE 
				WHEN #UCC_NSE.CATEGORY IN ('FII','MF','PMS','FDI','VC','BNK','BK','IC','DFI') THEN ISNULL(UC.UCC_CODE,'')
				ELSE ''
			END),
			MAPINID = ISNULL(UC.MAPIDID,'')
		FROM
			UCC_CLIENT UC (NOLOCK)
		WHERE
			UC.PARTY_CODE = #UCC_NSE.CLIENTCODE 

/*-----------------------------------------------------------------------------
  Updating #UCC_NSE For Client Details
------------------------------------------------------------------------------*/  

	UPDATE
		#UCC_NSE
		SET   
			CONTACTPERSON1 = ISNULL(CD.CONTACT_NAME,''),
			DESIGNATIONCONTACTPERSON1 = ISNULL(CD.DESIGNATION,''),
			PANCONTACTPERSON1 = ISNULL(CD.PANNO,''),
			ADDCONTRACTPERSON1 = 
					LEFT((ISNULL(rtrim(CD.ADDRESS1),'') + ' '   
					+ ISNULL(rtrim(CD.ADDRESS2),'') + ' '   
					+ ISNULL(rtrim(CD.ADDRESS3),'') + ' '   
					+ ISNULL(rtrim(CD.CITY),'') + ' '   
					+ ISNULL(rtrim(CD.ZIP),'') + ' '
					+ ISNULL(rtrim(CD.STATE),'') + ' '
					+ ISNULL(rtrim(CD.NATION),'')),255),
			CONTACTNOCONTACTPERSON1 = ISNULL(CD.PHONE_NO,''),
			EMAILCONTACTPERSON1 = ISNULL(CD.EMAIL,'')
		FROM
			MSAJAG.DBO.CLIENT_CONTACT_DETAILS CD (NOLOCK)
		WHERE
			CD.CL_CODE = #UCC_NSE.CLIENTCODE 
			AND LINE_NO = 1

/*-----------------------------------------------------------------------------
  Updating #UCC_NSE For EMAIL / SMS SERVICES Details
------------------------------------------------------------------------------*/  

	UPDATE
		#UCC_NSE
		SET   
			UPDATIONFLAG	= ISNULL(CM.UPDATIONFLAG,'N'),
			RELATIONSHIP	= ISNULL(CM.RELATIONSHIP,''),
			MASTERPAN		= ISNULL(CM.MASTERPAN,''),
			TYPEOFFACILITY	= ISNULL(CM.TYPEOFFACILITY,'')
	FROM
		MSAJAG.DBO.CLIENT_MASTER_UCC_DATA CM (NOLOCK)
	WHERE
		#UCC_NSE.CLIENTCODE = CM.PARTY_CODE

/*-----------------------------------------------------------------------------
  Updating #UCC_NSE For CIN Details
------------------------------------------------------------------------------*/

	UPDATE
		#UCC_NSE
		SET   
			CIN_NO = ISNULL(CM.CIN,'')
	FROM
		MSAJAG.DBO.CLIENT_MASTER_NOMINEE_DATA CM (NOLOCK)
	WHERE
		#UCC_NSE.CLIENTCODE = CM.PARTY_CODE

/*-----------------------------------------------------------------------------  
  Updating #UCC_NSE for Account Details  
-----------------------------------------------------------------------------*/  
/*  
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
*/  
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
 /* 
 Update   
  #UCC_NSE   
  Set bankname = ISNULL(Left(bank_name,60),''),   
  bankfulladdress = ISNULL(Left(branch_name,255),'')  
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
  */
/*-----------------------------------------------------------------------------  
  Updating #UCC_NSE Multiple DP Details  
-----------------------------------------------------------------------------*/  
  
 Update   
  #UCC_NSE   
  Set NSDL_DepositoryName = (Case When M.DpType ='NSDL' THEN Left(M.DpType,4) ELSE '' END),  
  NSDL_DepositoryParticipantId = Case When M.DpType ='NSDL' Then Left(M.DPID,8) else '' End ,  
  NSDL_DepositoryParticipantName = Case When M.DpType ='NSDL' Then Left(M.Introducer,25) else '' End,   
  NSDL_BeneficiaryAccountID = Case When M.DpType ='NSDL' Then Left(M.cltdpno,8) else '' End,
  CDSL_DepositoryName = (Case When M.DpType ='CDSL' THEN Left(M.DpType,4) ELSE '' END),  
  CDSL_DepositoryParticipantId = Case When M.DpType ='CDSL' Then Left(M.DPID,8) else '' End,  
  CDSL_DepositoryParticipantName = Case When M.DpType ='CDSL' Then Left(M.Introducer,25) else '' End,   
  CDSL_BeneficiaryAccountID = Case When M.DpType ='CDSL' Then Left(M.cltdpno,16) else '' End  
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
