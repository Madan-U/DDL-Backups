-- Object: PROCEDURE citrus_usr.pr_ins_upd_dp89
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN
--SELECT * FROM TMP_DP89_CDSL_TRX_MSTR
--pr_ins_upd_dp89 'HO','NORMAL','','*|~*','|*~|',''
--ROLLBACK
CREATE procedure [citrus_usr].[pr_ins_upd_dp89]
(@pa_login_name    VARCHAR(20)  
,@pa_mode          VARCHAR(10)  																																
,@pa_db_source     VARCHAR(250)  
,@rowdelimiter     CHAR(4) =     '*|~*'    
,@coldelimiter     CHAR(4) =     '|*~|'    
,@pa_errmsg        VARCHAR(8000) output  
)
as
begin
--select * from TMP_DP89_CDSL_TRX_MSTR
--2006-08-14 10:30:00.000
--select convert(16082006:103000
--TMP_CLIENT_DTLS_MSTR_CDSL
/*create table Transaction_DP89
(Dp89_dpm_id     numeric
,Dp89_dpam_id    numeric
,Dp89_Ex_Id      int
,Dp89_Settl_type varchar(10)
,Dp89_Settl_Id   varchar(20)
,Dp89_BO_ID      varchar(16)
,Dp89_CM_Id      varchar(20)
,Dp89_CM_Nm      varchar(100)
,Dp89_ISIN       varchar(15)
,Dp89_Trx_Qty    numeric(16,3)
,Dp89_Earmark_Shrt_Qty numeric(16,3)
,Dp89_Txn_Type_Flag char(1)
,Dp89_Trn_Status char(1)
,Dp89_Txn_Id varchar(16)
,Dp89_Int_RefNo varchar(16)
,Dp89_Earmark_DateTime  datetime
,Dp89_Settl_DateTime datetime
,Dp89_Free_Balance	numeric(16,3)
,Dp89_Probable_Status char(1)
,Dp89_Balance_Amt numeric(16,3)
,Dp89_created_dt datetime
,Dp89_created_by varchar(20)
,Dp89_lst_upd_dt datetime
,Dp89_lst_upd_by varchar(20)
,Dp89_deleted_ind  smallint
)*/
--
if @pa_mode = 'BULK'
begin
--

						
    Truncate Table TMP_DP89_CDSL_TRX_MSTR

	DECLARE @@ssql varchar(8000)
	SET @@ssql ='BULK INSERT TMP_DP89_CDSL_TRX_MSTR from ''' + @pa_db_source + ''' WITH 
	(
					FIELDTERMINATOR = ''~'',
					ROWTERMINATOR = ''\n''

	)'

	EXEC(@@ssql)
							  
--
end



update TMP_DP89_CDSL_TRX_MSTR
set    TmpDp89_Earmark_DateTime = SUBSTRING(TmpDp89_Earmark_DateTime,1,2) + '/' + SUBSTRING(TmpDp89_Earmark_DateTime,3,2) + '/' + SUBSTRING(TmpDp89_Earmark_DateTime,5,4) +' '+ SUBSTRING(TmpDp89_Earmark_DateTime,10,2) + ':' +  SUBSTRING(TmpDp89_Earmark_DateTime,12,2) + ':' +  SUBSTRING(TmpDp89_Earmark_DateTime,14,2)
      ,TmpDp89_Settl_DateTime   = SUBSTRING(TmpDp89_Settl_DateTime,1,2) + '/' + SUBSTRING(TmpDp89_Settl_DateTime,3,2) + '/' + SUBSTRING(TmpDp89_Settl_DateTime,5,4) +' '+ SUBSTRING(TmpDp89_Settl_DateTime,10,2) + ':' +  SUBSTRING(TmpDp89_Settl_DateTime,12,2) + ':' +  SUBSTRING(TmpDp89_Settl_DateTime,14,2)
      ,TmpDp89_Setup_TimeStamp  = SUBSTRING(TmpDp89_Setup_TimeStamp,1,2) + '/' + SUBSTRING(TmpDp89_Setup_TimeStamp,3,2) + '/' + SUBSTRING(TmpDp89_Setup_TimeStamp,5,4) +' '+ SUBSTRING(TmpDp89_Setup_TimeStamp,10,2) + ':' +  SUBSTRING(TmpDp89_Setup_TimeStamp,12,2) + ':' +  SUBSTRING(TmpDp89_Setup_TimeStamp,14,2)


update tmp SET TmpDp89_Settl_Type_desc  = convert(varchar,settm_id)
      ,TmpDp89_Settl_Id = right(TmpDp89_Settl_Id,7)
from   TMP_DP89_CDSL_TRX_MSTR tmp
      ,settlement_type_mstr 
where  settm_type_cdsl = case when left(TmpDp89_Settl_Id,1)='W' THEN 'TT' when left(TmpDp89_Settl_Id,1)='N' THEN 'NR' when left(TmpDp89_Settl_Id,1)='A' THEN 'NA' ELSE substring(TmpDp89_Settl_Id,1,len(TmpDp89_Settl_Id)-7) END


update DP89
set    Dp89_Probable_Status = TmpDp89_Probable_Status
,      Dp89_Trn_Status = TmpDp89_Trn_Status
from   Transaction_DP89 DP89
,      TMP_DP89_CDSL_TRX_MSTR 
where  Dp89_Settl_DateTime    = convert(datetime,TmpDp89_Settl_DateTime,103)
and    Dp89_Earmark_DateTime  = convert(datetime,TmpDp89_Earmark_DateTime,103)
and    Dp89_Txn_Id = TmpDp89_Txn_Id_Early_Payin
and    Dp89_BO_ID  = TmpDp89_BO_ID
and    Dp89_ISIN   = TmpDp89_ISIN





update TMP
set   TmpDp89_Ex_Id = excm_id
from   TMP_DP89_CDSL_TRX_MSTR tmp
      ,exchange_mstr 
where    EXCM_short_name = convert(varchar,TmpDp89_Ex_Id )





insert into Transaction_DP89
(Dp89_dpam_id
,Dp89_dpm_id
,Dp89_Ex_Id
,Dp89_Settl_type 
,Dp89_Settl_Id   
,Dp89_BO_ID      
,Dp89_CM_Id      
,Dp89_CM_Nm      
,Dp89_ISIN       
,Dp89_Trx_Qty    
,Dp89_Earmark_Shrt_Qty 
,Dp89_Txn_Type_Flag 
,Dp89_Trn_Status 
,Dp89_Txn_Id 
,Dp89_Int_RefNo 
,Dp89_Earmark_DateTime  
,Dp89_Settl_DateTime 
,Dp89_Free_Balance	
,Dp89_Probable_Status 
,Dp89_Balance_Amt 
,Dp89_created_dt 
,Dp89_created_by 
,Dp89_lst_upd_dt 
,Dp89_lst_upd_by 
,Dp89_deleted_ind
)
select dpam_id
,dpam_dpm_id
,TmpDp89_Ex_Id
,TmpDp89_Settl_Type_desc
,TmpDp89_Settl_Id
,TmpDp89_BO_ID      
,TmpDp89_CM_Id      
,TmpDp89_CM_Nm      
,TmpDp89_ISIN       
,TmpDp89_Trx_Qty    
,TmpDp89_Earmark_Shrt_Qty 
,TmpDp89_Txn_Type_Flag 
,TmpDp89_Trn_Status 
,TmpDp89_Txn_Id_Early_Payin 
,TmpDp89_Int_RefNo 
,convert(datetime,TmpDp89_Earmark_DateTime,103)
,convert(datetime,TmpDp89_Settl_DateTime,103) 
,TmpDp89_Free_Balance	
,TmpDp89_Probable_Status 
,TmpDp89_Balance_Amt
,getdate()
,@pa_login_name
,getdate()
,@pa_login_name
,1 
from TMP_DP89_CDSL_TRX_MSTR
,dp_acct_mstr
where TmpDp89_BO_ID = dpam_sba_no and not exists(select dp89_dpam_id
                      , dp89_dpm_id 
                      , Dp89_Earmark_DateTime
                      , Dp89_Settl_DateTime
                      , dp89_isin 
                 from   Transaction_DP89 where Dp89_Earmark_DateTime = convert(datetime,TmpDp89_Earmark_DateTime,103)
                 and  Dp89_Settl_DateTime = convert(datetime,TmpDp89_Settl_DateTime,103) 
                 and  dp89_isin   =  TmpDp89_ISIN 
                 and  Dp89_BO_ID  = TmpDp89_BO_ID
                 and    TmpDp89_Txn_Id_Early_Payin = Dp89_Txn_Id 
                 )
and dpam_deleted_ind =1


update dp_trx_dtls_cdsl 
set DPTDC_STATUS = CASE WHEN TmpDp89_Trn_Status ='S' THEN '1S' 
					WHEN TmpDp89_Trn_Status = 'D' THEN '1D'
					WHEN TmpDp89_Trn_Status = 'F' THEN '1F'
					WHEN TmpDp89_Trn_Status = 'E' THEN '1E'
					WHEN TmpDp89_Trn_Status = 'C' THEN '1C'
					ELSE 
						DPTDC_STATUS
					END
from dp_trx_dtls_cdsl,TMP_DP89_CDSL_TRX_MSTR,dp_acct_mstr
where dptdc_dpam_id = dpam_id and dpam_sba_no= TmpDp89_BO_ID AND dptdc_isin = TmpDp89_ISIN AND DPTDC_EXECUTION_DT = convert(datetime,TmpDp89_Earmark_DateTime,103)
and DPTDC_TRANS_NO =  TmpDp89_Txn_Id_Early_Payin 
and isnull(dptdc_trans_no,'') <> '' and TmpDp89_Txn_Type_Flag = 'N' and DPTDC_INTERNAL_TRASTM ='NP'  
and dptdc_deleted_ind = 1 

update dp_trx_dtls_cdsl 
set DPTDC_STATUS = CASE WHEN TmpDp89_Trn_Status ='S' THEN '1S' 
					WHEN TmpDp89_Trn_Status = 'D' THEN '1D'
					WHEN TmpDp89_Trn_Status = 'F' THEN '1F'
					WHEN TmpDp89_Trn_Status = 'E' THEN '1E'
					WHEN TmpDp89_Trn_Status = 'C' THEN '1C'
					ELSE 
						DPTDC_STATUS
					END
from dp_trx_dtls_cdsl,TMP_DP89_CDSL_TRX_MSTR,dp_acct_mstr
where dptdc_dpam_id = dpam_id and dpam_sba_no= TmpDp89_BO_ID AND dptdc_isin = TmpDp89_ISIN AND DPTDC_EXECUTION_DT = convert(datetime,TmpDp89_Earmark_DateTime,103)  
and DPTDC_TRANS_NO =  TmpDp89_Txn_Id_Early_Payin 
and isnull(dptdc_trans_no,'') <> '' and TmpDp89_Txn_Type_Flag = 'E' and DPTDC_INTERNAL_TRASTM ='EP' 
and dptdc_deleted_ind = 1 


 
end

GO
