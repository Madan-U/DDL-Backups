-- Object: PROCEDURE citrus_usr.pr_ins_missing_err_resp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_ins_missing_err_resp
create  proc pr_ins_missing_err_resp
as
begin 

		select identity(numeric,1,1) id , * into #tmp_miss_err from (
		select distinct TMPC_ERROR_CODE,TMPC_ERROR_DESC from TMP_COMMON_TRX_RESP_MSTR
		where TMPC_SETTLE_STATUS_FLG <> 'A'
		and not exists (select 1 from transaction_sub_type_mstr where TRASTM_DELETED_IND  =1  and TRASTM_TRATM_ID =  20 and TRASTM_CD = TMPC_ERROR_CODE)
		) a 

		insert into transaction_sub_type_mstr 
		select (select max(TRASTM_ID) from transaction_sub_type_mstr ) +id ,  1,20,TMPC_ERROR_CODE,TMPC_ERROR_DESC, getdate () , 'MIG' , getdate () , 'MIG' , 1  
		from #tmp_miss_err 

end

GO
