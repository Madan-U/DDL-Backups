-- Object: PROCEDURE dbo.USP_GetClientDRFProcessCompleteStatusDetails
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE PROCEDURE [dbo].[USP_GetClientDRFProcessCompleteStatusDetails]    
AS    
BEGIN    
SELECT DISTINCT DRFId,DRFNo,DEMRM_ID,MAX(CurrentStatus) 'CurrentStatus',MAX(MakerStatus) 'MakerProcessStatus'      
,MAX(IsMakerProcess) 'IsMakerProcess'      
,MAX(MakerDate) 'MakerProcessDate',MAX(MakerBy) 'MakerBy'      
,MAX(IsCheckerProcess) 'IsCheckerProcess',MAX(IsCheckerRejected) 'IsCheckerRejected'      
,MAX(CheckerStatus) 'CheckerProcessStatus'      
,MAX(CheckerRemarks) 'CheckerProcessRemarks',MAX(CheckerDate) 'CheckerProcessDate'      
,MAX(CheckerBy) 'CheckerBy'      
,MAX(BatchUploadInCDSL) 'BatchUploadInCDSL',MAX(BatchNo) 'BatchNo',MAX(DRNNo) 'DRNNo'      
,MAX(IsCDSLProcess) 'IsCDSLProcess',MAX(IsCDSLRejected)'IsCDSLRejected'      
,MAX(CDSLStatus) 'CDSLStatus',MAX(CDSLRemarks) 'CDSLRemarks',       
MAX(CDSLDate) 'CDSLProcessDate',MAX(RTALetterGenerate) 'RTALetterGenerate'      
,MAX(DispatchDate) 'DispatchDate',MAX(IsRTAProcess) 'IsRTAProcess',      
CASE WHEN CONVERT(VARCHAR(17),MAX(RTAProcessDate),113) ='01 Jan 1900 00:00' THEN ''    
ELSE CONVERT(VARCHAR(17),MAX(RTAProcessDate),113) END 'RTAProcessDate'       
,MAX(RTAStatus) 'RTAStatus',MAX(RTARemarks) 'RTARemarks'  INTO #DRFDetails    
        
FROM (         
         
SELECT  DISTINCT      
DRFId,DRFNo,DEMRM_ID,CurrentStatus,MakerStatus ,IsMakerProcess,MakerDate ,MakerBy       
,IsCheckerProcess,IsCheckerRejected,CheckerStatus ,CheckerRemarks ,CheckerDate ,CheckerBy       
,BatchUploadInCDSL,BatchNo,DRNNo,IsCDSLProcess,IsCDSLRejected,CDSLStatus,CDSLRemarks,       
CDSLDate ,RTALetterGenerate,    
CASE WHEN RTALetterGenerate=1 THEN CDSLDate ELSE '' END DispatchDate,IsRTAProcess,    
CASE WHEN CONVERT(datetime,RTAProcessDate,103) = '1900-01-01 00:00:00.000' THEN ''      
ELSE CONVERT(datetime,RTAProcessDate,103)  END 'RTAProcessDate'      
,RTAStatus,RTARemarks       
 FROM      
(     
SELECT  DISTINCT      
PADRFIRPM.DRFId 'DRFId',    
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',         
--DMATDMK.DEMRM_ID 'DEMRM_ID',         
'' 'DEMRM_ID',        
         
--CASE WHEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''          
--THEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,''))         
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'    
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'           
--when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'          
--when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,       
    
    
CASE      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'    
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-DB PENDING CONFIRMATION' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'         
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') IN ('VERIFY-CR PENDING CONFIRMATION','Destat Confirm') THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'        
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')= 'CLOSE-CR LOCK-IN BALANCE' THEN  'CONFIRMED (CR LOCK-IN BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='DELETE-DB PENDING VERIFICATION' THEN  'DELETED'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') like '%REJECTED%' THEN  'REJECTED'
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING VERIFICATION)' THEN  'CANCELLED DUE TO AUTO CA'       
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'    
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'    
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
THEN CASE WHEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <>'' THEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') +' '+ ISNULL(DMATDMK.DEMRM_RMKS,'')        
WHEN ISNULL(DMATDMK.demrm_res_desc_intobj,'')<>'' THEN ISNULL(DMATDMK.demrm_res_desc_intobj,'') +' '+ ISNULL(DMATDMK.DEMRM_RMKS,'')        
ELSE '' END          
ELSE ''        
END 'CheckerRemarks',           
         
CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113) 'CheckerDate',         
         
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''          
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )          
--THEN CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'DispatchDate',        
--'' DispatchDate,      
       
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> ''       
THEN 1          
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0' THEN 1          
ELSE 0 END 'BatchUploadInCDSL' ,       
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN DMATRMT.DEMRM_BATCH_NO ELSE '' END 'BatchNo',         
       
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'       
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,       
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''          
THEN 'CDSL Rejected'    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'          
THEN 'CDSL Rejected'    
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'       
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 'CDSL Done' ELSE '' END 'CDSLStatus',        
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''          
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'          
THEN 1           
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'       
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 1 ELSE 0 END 'IsCDSLProcess',        
       
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''          
THEN 1          
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'          
THEN 1          
ELSE 0 END 'IsCDSLRejected',        
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''          
THEN DMATRMT.DEMRM_INTERNAL_REJ           
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'          
THEN 'CDSL Rejected - Batch Generated'           
ELSE '' END 'CDSLRemarks',         
         
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''          
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )          
--THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'CDSLDate',       
    CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''      
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'      
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE '' END   'CDSLDate',       
--CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> ''    
--THEN Convert(Nvarchar(255),(MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),113) END 'CDSLDate',    
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''       
AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' AND ISNULL(DMATDD.disp_demrm_id,0)<>0       
AND ISNULL((MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),'')<>''         
THEN 1 ELSE 0 END   'RTALetterGenerate',         
       
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')      
NOT In('SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')       
THEN 1 ELSE 0 END 'IsRTAProcess',        
         
--CASE WHEN citrus_usr.gettranstype(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0')) <> ''          
--THEN citrus_usr.gettranstype_date(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0'))        
--ELSE '' END 'RTAProcessDate',      
-- CAST(CDSLHD.cdshm_tras_dt as date) 'RTAProcessDate',      
    
--CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')      
--NOT In('SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')      
--THEN Convert(NVARCHAR(255),(MAX(CDSLHD.cdshm_created_dt) OVER (PARTITION BY cdshm_dpam_id)),113)    
--ELSE ''    
--END  'RTAProcessDate',    
    
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')      
NOT In('SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')      
THEN Convert(NVARCHAR(255),cdshm_created_dt,113)    
ELSE ''    
END  'RTAProcessDate',    
         
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,'')) NOT In('SETUP', '')          
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')      
NOT In('SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')       
THEN 'Done' ELSE '' END 'RTAStatus',         
    
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''          
--THEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,'')) ELSE ''    
CASE           
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)' THEN  'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'          
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='DELETE-DB PENDING VERIFICATION' THEN  'DELETED'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING VERIFICATION)' THEN  'CANCELLED DUE TO AUTO CA'       
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')= 'CLOSE-CR LOCK-IN BALANCE' THEN  'CONFIRMED (CR LOCK-IN BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'    
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-DB PENDING CONFIRMATION' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'     
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') IN ('VERIFY-CR PENDING CONFIRMATION','Destat Confirm') THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'        
    
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'    
ELSE ''    
END 'RTARemarks'        
         
From [MIS].[ProcessAutomation].dbo.tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)       
JOIN [citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)    
ON PADRFIRPM.DRFNo = DMATDMK.DEMRM_SLIP_SERIAL_NO    
LEFT JOIN [citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)         
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID         
LEFT JOIN [citrus_usr].dmat_dispatch DMATDD WITH(NOLOCK)        
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id  and DISP_TO = 'R'       
LEFT JOIN (    
SELECT * FROM (          
--SELECT DENSE_RANK() over(partition by cdshm_trans_no order by cdshm_created_dt desc,CDSHM_TRATM_CD desc, cdshm_id desc) 'SRNo'    
SELECT DENSE_RANK() over(partition by cdshm_trans_no order by CDSHM_CDAS_SUB_TRAS_TYPE desc) 'SRNo'
,DEMRM_SLIP_SERIAL_NO, CDSHM_TRATM_DESC,cdshm_id 'cdshm_id'    
,cdshm_trans_no,cdshm_dpam_id,cdshm_created_dt          
FROM [MIS].[ProcessAutomation].dbo.tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)      
JOIN [citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)       
ON PADRFIRPM.DRFNo = DMATRMT.DEMRM_SLIP_SERIAL_NO    
JOIN [citrus_usr].cdsl_holding_dtls CDSLHD WITH(NOLOCK)    
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no       
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id           
---where cdshm_trans_no='10475391' and cdshm_dpam_id=7305641          
) S WHERE SRNo=1       
) CDSLHD       
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no       
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id        
--AND ISNULL(CDSHM_TRATM_DESC,'') IN ('DEMAT10473466 CLOSE-CR CONFIRMED BALANCE'       
--,'DEMAT10473459 REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)')       
WHERE  DMATDMK.demrm_deleted_ind in(0,1,-1)           
AND CAST(DMATDMK.DEMRM_CREATED_DT as date) >= '2022-11-07'      
---AND DMATDMK.DEMRM_SLIP_SERIAL_NO = '10211'      
)DRFDetails      
)BB      
Group by DRFId,DRFNo,DEMRM_ID          
    
INSERT INTO [MIS].[ProcessAutomation].dbo.tbl_ClientDRFProcessCompleteStatusDetails      
SELECT * FROM #DRFDetails    
    
END

GO
