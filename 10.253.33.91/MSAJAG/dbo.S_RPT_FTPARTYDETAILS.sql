-- Object: PROCEDURE dbo.S_RPT_FTPARTYDETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[S_RPT_FTPARTYDETAILS]
                  
@PARTYCODE AS VARCHAR(20)                  
                      
AS                   
                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                              
SELECT CL2.CL_CODE,                                  
 CL2.PARTY_CODE,                                  
 CL2.DUMMY1,                                    
 T.TURNOVER_TAX/* =  (CASE WHEN CL2.TURNOVER_TAX=0 THEN 'N' WHEN CL2.TURNOVER_TAX=1 THEN 'Y' END)  */,                                  
 SEBI_TURN_TAX = T.SEBITURN_TAX /* =  (CASE WHEN CL2.SEBI_TURN_TAX=0 THEN 'N' WHEN CL2.SEBI_TURN_TAX=1 THEN 'Y' END)  */,                                  
 SERVICE_CHRG = (CASE WHEN CL2.SERVICE_CHRG=0 THEN 'EXCLUSIVE'                                  
    WHEN CL2.SERVICE_CHRG=1 THEN 'INCL IN BROK'                                    
    WHEN CL2.SERVICE_CHRG=2 THEN 'INCLUSIVE'                                  
 END),                                    
 T.INSURANCE_CHRG/* = (CASE WHEN CL2.INSURANCE_CHRG=0 THEN 'N' WHEN CL2.INSURANCE_CHRG =1 THEN 'Y' END)  */,                                  
 T.OTHER_CHRG/* =(CASE WHEN CL2.OTHER_CHRG=0 THEN 'N' WHEN CL2.OTHER_CHRG=1 THEN 'Y' END)*/,                                  
 CL2.TABLE_NO,                                  
 /*CBS.TABLE_NO,*/                                  
 CL2.SUB_TABLENO,                                  
 /*SUB_TABLENO = CBS.TABLE_NO *//*?????????????*/                                  
 CL2.DEMAT_TABLENO,                                  
 CL2.P_TO_P,                                  
 CL2.STD_RATE,                                  
 CL2.DEMAT_TABLENO,                                  
 CL2.ALBMDELCHRG,                                   
 CL2.ALBMDELIVERY,                                  
 CL2.ALBMCF_TABLENO,                                  
 CL2.MF_TABLENO,                                  
 CL2.SB_TABLENO,                                   
 CL2.BROK1_TABLENO,                                  
 CL2.BROK2_TABLENO,                                  
 BROK3_TABLE_NO= (CASE WHEN CL2.BROK3_TABLENO=0 THEN 'TREAT AS BROKERAGE'WHEN CL2.BROK3_TABLENO=1 THEN 'TREAT AS CHARGES' ELSE 'NOT SELECTED' END),                                  
 DUMMY1= (CASE WHEN CL2.DUMMY1=0 THEN 'PREMIUM' WHEN CL2.DUMMY1=1 THEN 'STRIKE' WHEN CL2.DUMMY1=2 THEN 'STRIKE + PREMIUM' ELSE 'NOT SELECTED' END),                                  
 CL2.DUMMY2,                                  
 BROKERNOTE = T.BROKER_NOTE /*= (CASE WHEN CL2.BROKERNOTE=0 THEN 'N' WHEN CL2.BROKERNOTE=1 THEN 'Y' END)  */,                                  
 BROK_SCHEME = (CASE WHEN CL2.BROK_SCHEME=0 THEN 'DEFAULT'                                    
  WHEN CL2.BROK_SCHEME=1 THEN 'MAX LOGIC (F/S) - BUY SIDE'                                    
  WHEN CL2.BROK_SCHEME=2 THEN 'MAX RATE'                                  
  WHEN CL2.BROK_SCHEME=3 THEN 'MAX LOGIC (F/S) - SELL SIDE'                                    
  WHEN CL2.BROK_SCHEME=4 THEN 'FLAT BROKERAGE DEFAULT'                                    
  WHEN CL2.BROK_SCHEME=5 THEN 'FLAT BROKERAGE (MAX LOGIC) - BUY SIDE'                                    
  WHEN CL2.BROK_SCHEME=6 THEN 'FLAT BROKERAGE (MAX LOGIC) - SELL SIDE'                                    
 END),                                    
 BROK3_TABLE_NO= (CASE WHEN CL2.BROK3_TABLENO=0 THEN 'TREAT AS BROKERAGE' WHEN CL2.BROK3_TABLENO=1 THEN 'TREAT AS CHARGES' ELSE 'NOT SELECTED' END),                                    
 DUMMY1= (CASE WHEN CL2.DUMMY1=0 THEN 'PREMIUM' WHEN CL2.DUMMY1=1 THEN 'STRIKE' WHEN CL2.DUMMY1=2 THEN 'STRIKE + PREMIUM' ELSE 'NOT SELECTED' END),                                  
 CL2.DUMMY2,                                    
 CL1.LONG_NAME,CL1.L_ADDRESS1,CL1.L_ADDRESS2, CL1.L_ADDRESS3,                                   
 CL1.L_CITY,CL1.L_STATE,CL1.L_NATION,CL1.L_ZIP,CL1.FAX,CL1.RES_PHONE1, RES_PHONE2, OFF_PHONE1, OFF_PHONE2, CL1.EMAIL,                                    
 CL1.BRANCH_CD,CL1.CL_TYPE,                          
 CL_STATUS=S.DESCRIPTION,CL1.FAMILY,CL1.SUB_BROKER,CL1.MOBILE_PAGER,CL1.PAN_GIR_NO,CL1.TRADER,                                    
 S1.NAME,B1.BRANCH,               
 CONTTYPE= (CASE WHEN CL2.INSCONT='S' THEN 'SCRIPWISE' WHEN CL2.INSCONT='O' THEN 'ORDERWISE' WHEN CL2.INSCONT='N' THEN 'NORMAL' ELSE 'NOT AVAILABLE' END),                                  
 PARTICIPANT = (CASE WHEN CL1.CL_TYPE='INS' THEN CL2.BANKID ELSE  '' END),                                  
 CUSTODIAN = (CASE WHEN CL1.CL_TYPE='INS' THEN CL2.CLTDPNO ELSE '' END),                                  
 PRINTF = (CASE WHEN CL2.PRINTF=0 THEN 'PRINT' ELSE 'DONT PRINT' END),                                  
 CONTPRT = (CASE WHEN CL2.PRINTF =0 THEN 'DETAIL BILL AND CONTRACT'                                  
  WHEN CL2.PRINTF =1 THEN 'DONT PRINT BILL AND CONTRACT'                                    
  WHEN CL2.PRINTF =2 THEN 'SUMMARISED CONTRACT AND DETAIL BILL'                                    
  WHEN CL2.PRINTF =3 THEN 'SUMMARISED BILL AND DETAIL CONTRACT'                                    
  WHEN CL2.PRINTF =4 THEN 'BOTH SUMMARISED'                                    
 END),                                  
 CONVERT(VARCHAR(11),C5.ACTIVEFROM) AS ACTIVEFROM,                                    
 INACTIVEFROM = (CASE WHEN CONVERT(VARCHAR(11),C5.INACTIVEFROM) ='JAN  1 1900' THEN 'N.A.' ELSE CONVERT(VARCHAR(11),C5.INACTIVEFROM) END),                                  
 /*CONVERT(VARCHAR(11),C5.INACTIVEFROM)   AS INACTIVEFROM,*/                                  
 C5.INTRODUCER,                                  
 C5.APPROVER,                                  
 SCHEME_TYPE=CL1.CL_TYPE,                                  
 TRADE_TYPE = 'NRM' ,                              
S1.PHONE1,                              
 S1.PHONE2,                          
 PANNAME = ISNULL(ADDEMAILID,'')      
,Deactive_Remarks =ISNULL(CB.Deactive_Remarks,''),Deactive_value=case Deactive_value when 'R' THEN 'ReActive' WHEN 'C'THEN 'Closure'    
WHEN 'I'THEN 'In Active'WHEN 'D'THEN 'Dormant'WHEN 'O'THEN 'Other' ELSE '' END                          
 FROM                                  
  CLIENT2 CL2 (NOLOCK), CLIENT1 CL1 LEFT OUTER JOIN CLIENT5 C5  (NOLOCK) ON ( C5.CL_CODE = CL1.CL_CODE ) ,                                  
  SUBBROKERS S1 (NOLOCK),BRANCH B1 (NOLOCK), TAXES T     (NOLOCK), CLIENTSTATUS S (NOLOCK)       
  ,MSAJAG..client_brok_details CB  (nolock)                          
  WHERE CL1.CL_CODE = CL2.CL_CODE                                  
  AND CL2.TRAN_CAT = T.TRANS_CAT                                  
  AND S1.SUB_BROKER = CL1.SUB_BROKER                                    
  AND CL2.PARTY_CODE =@PARTYCODE                                  
  AND B1.BRANCH_CODE = CL1.BRANCH_CD                                  
  AND CL1.CL_STATUS = S.CL_STATUS               
 and t.to_date='2049-12-31 23:59:59.000'      
 AND CB.Exchange='NSE' AND CB.Segment='CAPITAL'      
  And Cl1.cl_code = CB.cl_code

GO
