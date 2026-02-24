-- Object: PROCEDURE citrus_usr.Tpin_Status_Update
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



Create Proc Tpin_Status_Update

as
 
 BEGIN TRAN
 UPDATE E SET Ex_qty=DPT3_TOT_LOCKED_QTY,Pend_qty=DPT3_PENDING_QTY,VALID=1 , DUMMY3=DPT3_EDIS_TXN_STATUS FROM E_Dis_Trxn_Data E ,
 dpt3_mstr where DPT3_CREATED_DT >=Convert(varchar(11),getdate()-5,120)   
 AND DPT3_EDIS_TXN_STATUS in ('L','E')  AND CDSL_TRXN_Id=DPT3_TXN_ID  AND ISNULL(DUMMY3,'')=''
 

UPDATE E SET Ex_qty=DPT3_TOT_LOCKED_QTY,Pend_qty=DPT3_PENDING_QTY
 FROM E_Dis_Trxn_Data E ,dpt3_mstr
 WHERE  DPT3_CREATED_DT >=Convert(varchar(11),getdate(),120) AND  DPT3_EDIS_TXN_STATUS ='P' 
 AND ISNULL(VALID,'0')='0' AND CDSL_TRXN_Id=DPT3_TXN_ID
 
 COMMIT

GO
