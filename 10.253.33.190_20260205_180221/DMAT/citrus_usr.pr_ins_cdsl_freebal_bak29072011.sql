-- Object: PROCEDURE citrus_usr.pr_ins_cdsl_freebal_bak29072011
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECT * FROM DP_MSTR WHERE DPM_EXCSM_ID=DEFAULT_DP
--begin tran
--Exec [pr_ins_cdsl_freebal] 'HO','12345678',1,'BULK','D:\BulkInsDbfolder\DPM DPC7(FREE BALANCE)-CDSL FILE\08DPC7U.366715','','',''
--select * from TMP_DPC7_CDSL_TRX_MSTR_MAIN
--rollback

create procedure [citrus_usr].[pr_ins_cdsl_freebal_bak29072011](
 @pa_login_name varchar(25)
,@pa_dpmdpid varchar(50)
,@pa_task_id numeric
,@pa_mode varchar(50)
,@pa_db_source varchar(100)
,@RowDelimiter varchar(10)
,@ColDelimiter varchar(10)
,@pa_errmsg varchar(20) output
)      
as
begin
--
  set nocount on
set dateformat dmy		    
		    declare @l_dpmdpid varchar(50)      
		          , @l_dpm_id  varchar(50)      
		          , @l_holdin_dt datetime      
		          , @l_max_holding_dt datetime      
		          , @l_err_string varchar(8000)  
		          , @@SSQL VARCHAR(8000)
				        , @@DP_ID VARCHAR(8)
				        , @@TRX_DT DATETIME
		   If @pa_mode='BULK'
		   Begin 
		   -- bulk
		   
					  DELETE FROM TMP_DPC7_CDSL_TRX_MSTR

                      if exists(select name from sysobjects where name = 'TMP_DPC7_CDSL_TRX_MSTR_MAIN' )
						drop table TMP_DPC7_CDSL_TRX_MSTR_MAIN

						create table  TMP_DPC7_CDSL_TRX_MSTR_MAIN ( VALUESDETAILS varchar(8000))
                    
--					  SET @@SSQL = 'BULK INSERT TMP_DPC7_CDSL_TRX_MSTR_MAIN FROM ''' + @pa_db_source +  ''' WITH
--									 (
--									   FIELDTERMINATOR=''\n'',
--									   ROWTERMINATOR = ''\n''  
--					 			 )'
--
--                      DELETE FROM TMP_DPC7_CDSL_TRX_MSTR_MAIN WHERE LEFT(VALUESDETAILS,2) NOT IN ('01','04','06')
						SET @@SSQL = 'BULK INSERT TMP_DPC7_CDSL_TRX_MSTR_MAIN FROM ''' + @pa_db_source +  ''' WITH
															 (
                                                               
															   FIELDTERMINATOR=''\n'',
															   ROWTERMINATOR = ''\n''  
					 									 )'

						                     

						PRINT @@SSQL
						EXEC (@@SSQL)

declare @l_business_dt datetime
select  left(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),2) from TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '06'
select substring(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),3,2) from TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '06'
select  right(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),4) from TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '06'
select @l_business_dt = convert(datetime,left(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),2) + '/' + substring(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),3,2) + '/' + right(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),4),103)  from TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '06'
print  @l_business_dt
UPDATE filetask
SET    TASK_FILEDATE = @l_business_dt
WHERE  task_id = @pa_task_id


                        DELETE FROM TMP_DPC7_CDSL_TRX_MSTR_MAIN WHERE LEFT(VALUESDETAILS,2) NOT IN ('01','04','06')
					 			 
    			
declare @l_val varchar(10)
,@l_val1 varchar(10)
,@l_val2 varchar(10)
,@l_client_id varchar(20)
,@l_id numeric
,@L_DPID VARCHAR(20)
select identity(bigint,1,1) id, * into #TMP_DPC7_CDSL_TRX_MSTR_MAIN from TMP_DPC7_CDSL_TRX_MSTR_MAIN
SELECT @L_DPID = DPM_DPID from dp_mstr ,exch_seg_mstr where dpm_excsm_id=excsm_id and excsm_exch_cd='CDSL' AND DPM_EXCSM_ID=DEFAULT_DP
declare @c_cursor cursor 

        SET @c_cursor =  CURSOR fast_forward FOR            
        select ID , left(VALUESDETAILS,2), citrus_usr.fn_splitval_by (VALUESDETAILS,3,'~') from #TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) in ('04' ,'01')

			OPEN @c_cursor            
			FETCH NEXT FROM @c_cursor   
			into @l_id, @l_val ,@l_client_id

			WHILE @@fetch_status = 0            
			BEGIN            
			-- 
              if  @l_val = '01'
              begin 
              set @l_val1 = ''           
              set @l_val1 = @l_client_id
              end 
              
              update #TMP_DPC7_CDSL_TRX_MSTR_MAIN set  VALUESDETAILS = VALUESDETAILS + '~' + @l_val1 where left(VALUESDETAILS,2) = '04' and id = @l_id
 
             FETCH NEXT FROM @c_cursor  into @l_id, @l_val ,@l_client_id
			--
			end 

close @c_cursor
deallocate @c_cursor


--declare @l_business_dt datetime
--
--select @l_business_dt = convert(datetime,left(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),2) + '/' + substring(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),3,2) + '/' + right(citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~'),4),103)  from TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '06'

insert into TMP_DPC7_CDSL_TRX_MSTR
(TMPDPC7_LN_IDTFR
,TMPDPC7_BOID
,TMPDPC7_ISIN
,TMPDPC7_CURR_BAL
,TMPDPC7_FREE_BAL
,TMPDPC7_EARMARK_BAL
,TMPDPC7_PLEDGE_BAL
,TMPDPC7_REMLOCK_BAL
,TMPDPC7_BUSM_DT
,TMPDPC7_SETTID)
select '01'
,citrus_usr.fn_splitval_by(VALUESDETAILS,18,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,2,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,3,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,4,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,5,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,6,'~')
,citrus_usr.fn_splitval_by(VALUESDETAILS,7,'~')
,@l_business_dt
,citrus_usr.fn_splitval_by(VALUESDETAILS,17,'~') from #TMP_DPC7_CDSL_TRX_MSTR_MAIN where left(VALUESDETAILS,2) = '04'





    	--
    	END
    	
    	
   

    	delete from cdsl_free_balance where DPHMC_HOLDING_DT  in ( select top 1 TMPDPC7_BUSM_DT  from TMP_DPC7_CDSL_TRX_MSTR)
    	
    	select @l_dpm_id = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_dpid= @L_DPID and dpm_deleted_ind = 1 
    	
    	PRINT @l_dpm_id
    	update tmp
    	set    TMPDPC7_ACCT_ID = dpam_id 
    	from   TMP_DPC7_CDSL_TRX_MSTR tmp
    	, dp_acct_mstr 
    	where right(dpam_sba_no,8) = TMPDPC7_BOID
    	and dpam_dpm_id = @l_dpm_id
    	and dpam_deleted_ind = 1 
    	
    	insert into cdsl_free_balance
    	(DPHMC_DPM_ID
					,DPHMC_DPAM_ID
					,DPHMC_ISIN
					,DPHMC_CURR_QTY
					,DPHMC_FREE_QTY
					,DPHMC_FREEZE_QTY
					,DPHMC_PLEDGE_QTY
					,DPHMC_DEMAT_PND_VER_QTY
					,DPHMC_REMAT_PND_CONF_QTY
					,DPHMC_DEMAT_PND_CONF_QTY
					,DPHMC_SAFE_KEEPING_QTY
					,DPHMC_LOCKIN_QTY
					,DPHMC_ELIMINATION_QTY
					,DPHMC_EARMARK_QTY
					,DPHMC_AVAIL_LEND_QTY
					,DPHMC_LEND_QTY
					,DPHMC_BORROW_QTY
					,DPHMC_HOLDING_DT
					,DPHMC_CREATED_BY
					,DPHMC_CREATED_DT
					,DPHMC_LST_UPD_BY
					,DPHMC_LST_UPD_DT
					,DPHMC_DELETED_IND)
					select @l_dpm_id 
					, TMPDPC7_ACCT_ID
					, TMPDPC7_ISIN
					, TMPDPC7_CURR_BAL
					, TMPDPC7_FREE_BAL
					, TMPDPC7_FREEZE_BAL
					, TMPDPC7_PLEDGE_BAL
					, TMPDPC7_DPV_BAL
					, TMPDPC7_RPC_BAL
					, TMPDPC7_DPC_BAL
					, 0
					, TMPDPC7_LOCKIN_BAL
					, TMPDPC7_ELIM_BAL
					, TMPDPC7_EARMARK_BAL
					, 0
					, 0
					, 0
					, TMPDPC7_BUSM_DT
					, @pa_login_name
					, getdate()
					, @pa_login_name
					, getdate()
					, 1
					from TMP_DPC7_CDSL_TRX_MSTR WHERE ISNULL(TMPDPC7_ACCT_ID,0) <> 0
					
					
	IF EXISTS(SELECT TMPDPC7_BOID, TMPDPC7_ISIN FROM TMP_DPC7_CDSL_TRX_MSTR WHERE isnull(TMPDPC7_ACCT_ID,0) = 0 ) 																					
      BEGIN
      --
        UPDATE filetask
        SET    usermsg = 'ERROR : Following Client Not Mapped ' + citrus_usr.fn_merge_str('DPC7',0,'')
        ,STATUS = 'FAILED'
        ,  TASK_END_DATE = getdate()
        WHERE  task_id = @pa_task_id
      --
      END				
	ELSE if not exists (select DPHMC_DPM_ID,DPHMC_DPAM_ID,DPHMC_ISIN from DP_HLDG_MSTR_CDSL)
	begin 
	BEGIN TRAN

	INSERT INTO DP_DAILY_HLDG_CDSL(DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND)
	SELECT DPHMC_DPM_ID,DPHMC_DPAM_ID,DPHMC_ISIN,DPHMC_CURR_QTY,DPHMC_FREE_QTY,DPHMC_FREEZE_QTY,DPHMC_PLEDGE_QTY,DPHMC_DEMAT_PND_VER_QTY,DPHMC_REMAT_PND_CONF_QTY,DPHMC_DEMAT_PND_CONF_QTY,DPHMC_SAFE_KEEPING_QTY,DPHMC_LOCKIN_QTY,DPHMC_ELIMINATION_QTY,DPHMC_EARMARK_QTY,DPHMC_AVAIL_LEND_QTY,DPHMC_LEND_QTY,DPHMC_BORROW_QTY,DPHMC_HOLDING_DT,DPHMC_CREATED_BY,DPHMC_CREATED_DT,DPHMC_LST_UPD_BY,DPHMC_LST_UPD_DT,DPHMC_DELETED_IND
	FROM CDSl_FREE_BALANCE


	INSERT INTO DP_HLDG_MSTR_CDSL(DPHMC_DPM_ID,DPHMC_DPAM_ID,DPHMC_ISIN,DPHMC_CURR_QTY,DPHMC_FREE_QTY,DPHMC_FREEZE_QTY,DPHMC_PLEDGE_QTY,DPHMC_DEMAT_PND_VER_QTY,DPHMC_REMAT_PND_CONF_QTY,DPHMC_DEMAT_PND_CONF_QTY,DPHMC_SAFE_KEEPING_QTY,DPHMC_LOCKIN_QTY,DPHMC_ELIMINATION_QTY,DPHMC_EARMARK_QTY,DPHMC_AVAIL_LEND_QTY,DPHMC_LEND_QTY,DPHMC_BORROW_QTY,DPHMC_HOLDING_DT,DPHMC_CREATED_BY,DPHMC_CREATED_DT,DPHMC_LST_UPD_BY,DPHMC_LST_UPD_DT,DPHMC_DELETED_IND)
	SELECT DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
	FROM DP_DAILY_HLDG_CDSL  

	COMMIT TRAN

	end

UPDATE filetask
SET    TASK_END_DATE = getdate(),STATUS = 'COMPLETED'
WHERE  task_id = @pa_task_id
and isnull(STATUS,'') <> 'FAILED'
					
--
end

GO
