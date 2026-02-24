-- Object: PROCEDURE citrus_usr.PR_RPT_PROBILL
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [citrus_usr].[PR_RPT_PROBILL](@PA_FROM_DT DATETIME,@PA_TO_DT DATETIME
,@PA_OUT VARCHAR(8000) OUT )
AS
BEGIN
	select CONVERT(VARCHAR(10),CLIC_TRANS_DT,103) AS CLIC_TRANS_DT,SUM(CLIC_CHARGE_AMT) AS CLIC_CHARGE_AMT,DPAM_SBA_NO,DPAM_SBA_NAME,FINA_ACC_CODE,FINA_ACC_NAME from client_charges_cdsl,DP_ACCT_MSTR,FIN_ACCOUNT_MSTR where CLIC_TRANS_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT AND clic_flg= 'B'AND
	CLIC_DELETED_IND = 1 AND CLIC_DPAM_ID = DPAM_ID AND CLIC_POST_TOACCT = FINA_ACC_ID GROUP BY CLIC_TRANS_DT,DPAM_SBA_NO,DPAM_SBA_NAME,FINA_ACC_CODE,FINA_ACC_NAME
END

GO
