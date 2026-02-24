-- Object: PROCEDURE dbo.USP_GetAndSaveDRF_DP_CDSL_RTA_ProcessStatusDetails
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE PROCEDURE USP_GetAndSaveDRF_DP_CDSL_RTA_ProcessStatusDetails @DRFNo VARCHAR(35)  
AS  
BEGIN  

DECLARE @DRFDeMRM_Id bigint = (SELECT DISTINCT DEMRM_ID FROM [citrus_usr].demrm_mak WITH(NOLOCK) WHERE DEMRM_SLIP_SERIAL_NO =@DRFNo)

  
TRUNCATE table tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails  
  
INSERT INTO tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails  
  
SELECT  
DRFNo,DEMRM_ID,CurrentStatus,MakerStatus,IsMakerProcess,MakerDate,MakerBy
,IsCheckerProcess,IsCheckerRejected,CheckerStatus,CheckerRemarks,CheckerDate,CheckerBy  
,BatchUploadInCDSL,BatchNo,DRNNo,IsCDSLProcess,IsCDSLRejected,CDSLStatus,CDSLRemarks,  
CDSLDate,RTALetterGenerate,DispatchDate,IsRTAProcess,CONVERT(datetime,RTAProcessDate,103) 'RTAProcessDate'  
,RTAStatus,RTARemarks 
FROM (  
  
SELECT     
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',    
DMATDMK.DEMRM_ID 'DEMRM_ID',    
    
CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''     
THEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,''))    
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'  + isnull(citrus_usr.fn_get_errordesc(DMATDMK.DEMRM_ERRMSG),'')      
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'      
when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'     
when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,    
    
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 'Done' ELSE 'Pending' END 'MakerStatus',    
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 1 ELSE 0 END 'IsMakerProcess',    
CONVERT(VARCHAR(20),DMATDMK.DEMRM_CREATED_DT,113) 'MakerDate',    
    
DMATDMK.DEMRM_CREATED_BY 'MakerBy',    
DMATDMK.DEMRM_LST_UPD_BY 'CheckerBy',    
    
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1    
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 'Done'     
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND    
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 'Rejected'    
ELSE 'Pending' END 'CheckerStatus',  

CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1    
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 1     
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND    
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1    
ELSE 0 END 'IsCheckerProcess', 

CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND    
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1    
ELSE 0 END 'IsCheckerRejected', 
    
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>''     
AND (ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '')    
THEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') ELSE ISNULL(DMATDMK.demrm_res_desc_intobj,'')
END 'CheckerRemarks',    
    
CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113) 'CheckerDate',    
    
CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''     
OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )     
THEN CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'DispatchDate', 

CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> ''
THEN 1 ELSE 0 END 'BatchUploadInCDSL' ,
    
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN DMATRMT.DEMRM_BATCH_NO ELSE '' END 'BatchNo',    

CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,
    
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''     
THEN 'CDSL Rejected' 
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 'CDSL Done' ELSE '' END 'CDSLStatus',   
 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''     
THEN 1
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>'' THEN 1 ELSE 0 END 'IsCDSLProcess',   

CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''     
THEN 1 ELSE 0 END 'IsCDSLRejected',   
    
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''     
THEN DMATRMT.DEMRM_INTERNAL_REJ ELSE '' END 'CDSLRemarks',    
    
CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''     
OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )     
THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'CDSLDate',    
    
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''
AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' AND ISNULL(DMATDD.disp_demrm_id,0)<>0 AND ISNULL(DISP_DT,'')<>''    
THEN 1 ELSE 0 END   'RTALetterGenerate',    

CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,'')) NOT In('SETUP', '')      
THEN 1 ELSE 0 END 'IsRTAProcess',   
    
CASE WHEN citrus_usr.gettranstype(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0')) <> ''     
THEN citrus_usr.gettranstype_date(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0')) 
ELSE '' END 'RTAProcessDate',     
    
CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,'')) NOT In('SETUP', '')      
THEN 'Done' ELSE '' END 'RTAStatus',    
    
CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''     
THEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,'')) ELSE '' END 'RTARemarks'    
    
From [citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)     
LEFT JOIN [citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)     
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID     
LEFT JOIN (SELECT disp_demrm_id, MIN(DISP_DT) 'DISP_DT',MAX(DISP_DT) 'DISP_DT_MAX' FROM
[citrus_usr].dmat_dispatch WITH(NOLOCK)
WHERE disp_demrm_id = @DRFDeMRM_Id 
GROUP BY disp_demrm_id) DMATDD     
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id     
WHERE DMATDMK.DEMRM_SLIP_SERIAL_NO = @DRFNo    
)A  
END

GO
