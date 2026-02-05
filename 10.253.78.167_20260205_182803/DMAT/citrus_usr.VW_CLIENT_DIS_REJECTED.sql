-- Object: VIEW citrus_usr.VW_CLIENT_DIS_REJECTED
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE VIEW [citrus_usr].[VW_CLIENT_DIS_REJECTED]  
AS  
SELECT DISTINCT RIGHT(DPAM_SBA_NO,4) DPCode,  ClientID=DPAM_SBA_NO,
'MOSL DP Delivery Inst. Slip No. ' + DPTDC_SLIP_NO + ' is being rejected, having execution date '+ convert(varchar,convert(datetime,DPTDC_EXECUTION_DT),104) +            
' for your DP A/C No. *'+ right(DPAM_SBA_NO,4) + ' Kindly contact your Branch.'  as message  ,  
DPTDC_LST_UPD_DT REJECTEDDATETIME  
FROM  
DPTDC_MAK,DP_ACCT_MSTR WHERE DPTDC_DPAM_ID=DPAM_ID  
AND DPAM_DELETED_IND=1 AND DPTDC_DELETED_IND IN (0) AND   
ISNULL(dptdc_res_desc,'')<>''  
AND ISNULL(dptdc_res_cd,'')<>''

GO
