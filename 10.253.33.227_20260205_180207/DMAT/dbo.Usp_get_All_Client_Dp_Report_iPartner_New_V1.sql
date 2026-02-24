-- Object: PROCEDURE dbo.Usp_get_All_Client_Dp_Report_iPartner_New_V1
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--EXEC [Usp_get_All_Client_Dp_Report_iPartner_New_V1] 'ET'


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Usp_get_All_Client_Dp_Report_iPartner_New_V1]
(
	@Sub_Broker VARCHAR(100)='ET'
)
AS --Usp_get_All_Client_Dp_Report_iPartner 'ET'
BEGIN

SELECT CL_CODE INTO #CLT FROM INTRANET.RISK.dbo.Client_Details WHERE Sub_Broker = @Sub_Broker

CREATE INDEX #IX_CL ON #CLT(CL_CODE)





/**** ledger balance ****/
select PARTY_CODE,CLIENT_CODE    
,sum(CURR_BAL) Actual_amount  
, sum(BROK_BAL) Accrual_bal,'0' AS Branch_Code  INTO #LEDBALANCE  
from (
select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, sum(clic_charge_amt)*-1 BROK_BAL, '0' CURR_BAL  from     
  citrus_usr.dp_acct_mstr , citrus_usr.client_charges_cdsl ,#CLT C where 
  CL_CODE =DPAM_BBO_CODE AND
  clic_dpam_id = dpam_id and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth(getdate())    
  and dbo.ufn_GetLastDayOfMonth(GETDATE()) group by DPAM_SBA_NO,DPAM_BBO_CODE     
  union ALL
  select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, sum(clic_charge_amt)*-1 BROK_BAL, '0' CURR_BAL  from     
  citrus_usr.dp_acct_mstr , citrus_usr.client_charges_cdsl,#CLT C where CL_CODE =DPAM_BBO_CODE AND clic_dpam_id = dpam_id 
  and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth(DATEADD(month,-1,GETDATE()))    
  and dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE())) 
  and not exists (select ldg_account_id from citrus_usr.ledger5 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_TYPE='5'
  and LDG_VOUCHER_DT=dbo.ufn_GetLastDayOfMonth(DATEADD(month,-1,GETDATE())))
  group by DPAM_SBA_NO,DPAM_BBO_CODE 
  union all    
  select DPAM_BBO_CODE AS PARTY_CODE,DPAM_SBA_NO CLIENT_CODE,0 BROK_BAL  , sum(ldg_amount)*-1 CURR_BAL     
  from citrus_usr.ledger5 , citrus_usr.DP_ACCT_MSTR ,#CLT C where CL_CODE =DPAM_BBO_CODE AND LDG_ACCOUNT_ID = DPAM_ID and LDG_ACCOUNT_TYPE ='P' and LDG_DELETED_IND = 1 
  and DPAM_DELETED_IND = 1 
  group by DPAM_SBA_NO,DPAM_BBO_CODE )   BALANCE   
group by PARTY_CODE,CLIENT_CODE   



/*** end******/


SELECT distinct 
	 CLIENT_ID
	,FIRST_HOLD_NAME
	,DPID
	,ISNULL(POA_VER,0) AS POA_VER
	,CONVERT(VARCHAR(15),ACTIVE_DATE,103) AS ACTIVE_DATE
	,AMC_SCHEME
    ,ISNULL(DP_LEDGER,0) AS DP_LEDGER
	,ISNULL(accrual_CHARGES,0) AS accrual_CHARGES
	,account_status
	,Client_Sub_Type
	,CONVERT(VARCHAR(15),CONVERT(DATETIME,Date_of_Birth),103) AS Date_of_Birth
	,Nominee 
	,T1.brom_desc Scheme 
FROM #CLT c
	INNER JOIN (
			SELECT T.NISE_PARTY_CODE AS CLIENT_ID,FIRST_HOLD_NAME,T.CLIENT_CODE  AS DPID ,POA_VER,ACTIVE_DATE,BROM_DESC AMC_SCHEME,    
			DP_LEDGER =Actual_amount, accrual_CHARGES=Accrual_bal , 
			account_status=STATUS, Client_Sub_Type=SUB_TYPE,    
			Date_of_Birth=BO_DOB,Nominee= ISNULL(LTRIM(RTRIM(NAME)),'')+' '+ISNULL(LTRIM(RTRIM(MiddleName)),'') +' '+ISNULL(LTRIM(RTRIM(SearchName)),'')   


			FROM TBL_CLIENT_MASTER T    
			LEFT OUTER JOIN    
			citrus_usr.vw_get_next_amcdt A ON T.CLIENT_CODE=A.Client_code    
			LEFT OUTER JOIN citrus_usr.Nominee ON BOID=T.CLIENT_CODE      
			LEFT OUTER JOIN #LEDBALANCE  B ON B.CLIENT_CODE =T.CLIENT_CODE 
 ) a ON c.cl_code = a.CLIENT_ID
left join 
(
select brom_desc,dpam.DPAM_SBA_NO 
FROM [citrus_usr].DP_ACCT_MSTR DPAM
		LEFT OUTER JOIN 
        [citrus_usr].client_dp_brkg     on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
        LEFT OUTER JOIN 
      	[citrus_usr].brokerage_mstr on brom_id = clidb_brom_id  
        
		WHERE isNumeric(dpam.DPAM_SBA_NO)=1 
        --and dpam.DPAM_SBA_NO  BETWEEN '1203320000015028' AND '1203320000015028'
) T1 on a.DPID =T1.DPAM_SBA_NO




	 
END

GO
