-- Object: PROCEDURE dbo.BROK_AUTO_PROCESS_30July2024
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create PROC [dbo].[BROK_AUTO_PROCESS_30July2024]
AS 
SELECT CLIENTCODE,EXCHANGE =(CASE WHEN SEGMENT ='NSECM' THEN 'NSE' 
								  WHEN SEGMENT ='BSECM' THEN 'BSE'
								  WHEN SEGMENT ='NSEFO' THEN 'NSE'
								  WHEN SEGMENT ='NSX'   THEN 'NSX'
								  WHEN SEGMENT ='MCX'   THEN 'MCX'
								  WHEN SEGMENT ='NCDEX'   THEN 'NCX' 
								   WHEN SEGMENT ='BSEFO' THEN 'BSE' 
								  END) ,
								  F_SEGMENT =(CASE WHEN SEGMENT IN ('NSECM','BSECM' ) THEN 'CAPITAL' ELSE 'FUTURES' END ),SEGMENT
,INTRADAY,DELIVERY ,UPDATEDON, BO_UPDATE INTO #BROKMOD 
FROM [INTRANET].RISK.DBO.SB_ClientModiBrk_B2C_Phase2 
 WHERE UPDATEDON >=CONVERT(VARCHAR(11),GETDATE()-1,120) and segment NOT LIKE '%OPTION%' AND STATUS IN ('A','AUTO') and ISNULL(BO_UPDATE,'N') ='N'
 AND Delivery IS NOT NULL 

INSERT INTO  #BROKMOD 
SELECT clientcODE,EXCHANGE =(CASE WHEN SEGMENT ='NSECM' THEN 'NSE' 
								  WHEN SEGMENT ='BSECM' THEN 'BSE'
								  WHEN SEGMENT ='NSEFO' THEN 'NSE'
								  WHEN SEGMENT ='NSX'   THEN 'NSX'
								  WHEN SEGMENT ='MCX'   THEN 'MCX'
								  WHEN SEGMENT ='NCDEX'   THEN 'NCX' 
								  WHEN SEGMENT ='BSEFO' THEN 'BSE' END) ,
								  F_SEGMENT =(CASE WHEN SEGMENT IN ('NSECM','BSECM' ) THEN 'CAPITAL' ELSE 'FUTURES' END ),
								  SEGMENT,TableNoIntr,TableNoDel ,UpdatedON,ReverseStatus
FROM [INTRANET].RISK.DBO.SB_ClientModiBrk WHERE UPDATEDON >=CONVERT(VARCHAR(11),GETDATE()-1,120)  
and segment NOT LIKE '%OPTION%' and ISNULL(ReverseStatus,'N') ='N'
 AND  TABLENOINTR IS NOT NULL


    insert into client_Brok_details_log                                                                   
select                                                                
Cl_Code,b.Exchange,b.Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,    

Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,  

Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,

Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By='Auto',Edit_on=getdate(),SYSTEMDATE,Active_Date,CheckActiveClient,Deactive_Remarks,Deactive_value                
from client_Brok_details b ,#BROKMOD d where cl_code =clientcODE
and B.EXCHANGE =d.Exchange AND B.SEGMENT =d.f_Segment





UPDATE D SET TRD_BROK=INTRADAY,DEL_BROK=DELIVERY,Imp_Status='0' ,Modifiedon =GETDATE(),Modifiedby ='AUTO',
Trd_Eff_Dt=GETDATE(),Del_Eff_Dt =getdate(),Brok_Eff_Date=getdate()  FROM #BROKMOD B,CLIENT_BROK_DETAILS D
WHERE B.CLIENTCODE=CL_CODE AND B.EXCHANGE=D.Exchange AND B.F_SEGMENT =D.SEGMENT  AND F_SEGMENT ='CAPITAL'



UPDATE D SET Fut_Brok=INTRADAY,Fut_Opt_Brok=INTRADAY,	Fut_Fut_Fin_Brok=DELIVERY,	Fut_Opt_Exc=INTRADAY ,Imp_Status='0',Modifiedon =GETDATE(),Modifiedby ='AUTO'
,Trd_Eff_Dt=GETDATE(),Del_Eff_Dt =getdate() ,Brok_Eff_Date=getdate()
  FROM #BROKMOD B,CLIENT_BROK_DETAILS D
WHERE B.CLIENTCODE=CL_CODE AND B.EXCHANGE=D.Exchange AND B.F_SEGMENT =D.SEGMENT  AND F_SEGMENT ='FUTURES'

UPDATE B SET BO_UPDATE ='Y' FROM INTRANET.RISK.DBO.SB_ClientModiBrk_B2C_Phase2 B,#BROKMOD C
WHERE B.CLIENTCODE =C.CLIENTCODE AND B.SEGMENT=C.SEGMENT AND C.UpdatedON=B.UpdatedON
 
UPDATE B SET ReverseStatus ='Y' FROM INTRANET.RISK.DBO.SB_ClientModiBrk B,#BROKMOD C
WHERE B.CLIENTCODE =C.CLIENTCODE AND B.SEGMENT=C.SEGMENT  AND C.UpdatedON=B.UpdatedON
 

 --select B.*, C.TRD_BROK,C.DEL_BROK,C.Fut_Brok ,C.Fut_Opt_Brok ,C.Fut_Fut_Fin_Brok,C.Fut_Opt_Exc  FROM #BROKMOD B,CLIENT_BROK_DETAILS C
 --WHERE B.EXCHANGE =C.Exchange AND B.F_SEGMENT =C.Segment
 --AND CL_CODE=CLIENTCODE

GO
