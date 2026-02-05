-- Object: PROCEDURE citrus_usr.pr_import_setm_converter
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

 

CREATE PROCEDURE  [citrus_usr].[pr_import_setm_converter]( @pa_exch          VARCHAR(20)  
			                    ,@pa_login_name    VARCHAR(20)  
                                ,@pa_mode          VARCHAR(10)  																																
                                ,@pa_db_source     VARCHAR(250)  
								,@rowdelimiter     CHAR(4) =     '*|~*'    
								,@coldelimiter     CHAR(4) =     '|*~|'    
								,@pa_errmsg        VARCHAR(8000) output  
																															)    
AS  
/*  
*********************************************************************************  
 SYSTEM         : Dp  
 MODULE NAME    : Pr_import_setm  
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables  
 COPYRIGHT(C)   : Marketplace Technologies   
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  --------------------------------------------------  
 1.0    TUSHAR            08-OCT-2007   VERSION.  
-----------------------------------------------------------------------------------*/  
BEGIN  
--
  DECLARE  @@ssql varchar(8000)
  DECLARE  @l_id  NUMERIC
  declare @pa_task_id numeric
  
select @pa_task_id=task_id from filetask where status='running' and task_name like '%STANDARD SETTLEMENT MASTER%'

  

 	IF  @PA_MODE ='BULK'  and  citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') not like 'cc_clnd_%'
		BEGIN 
				UPDATE FILETASK
				SET    USERMSG = 'ERROR : File is not proper.Please Check.', STATUS ='FAILED', TASK_END_DATE = GETDATE()
				WHERE  TASK_ID = @PA_TASK_ID
				
				return
		END 




  
  IF @pa_exch = 'CDSL'
  BEGIN
  --
    TRUNCATE TABLE tmpsetm_mstr
			
			IF @pa_mode = 'BULK'
				BEGIN
				--
						TRUNCATE TABLE cc_clnd_converter

						
						SET @@ssql ='BULK INSERT CITRUS_USR.cc_clnd_converter	 from ''' + @pa_db_source + ''' WITH 
						(
									FIELDQUOTE = ''"''
						, FIELDTERMINATOR = '',''
						, ROWTERMINATOR = ''\n''
					
						,FORMAT=''CSV''
						,FIRSTROW = 2 

						)'
print @@ssql 
						EXEC(@@ssql)

						
				--
				END

				--insert into cc_clnd_converter_log
				--		select *, getdate() from cc_clnd_converter 

				insert into tmpsetm_mstr(TMPSETM_CC_ID
,TMPSETM_EXCH_ID
,TMPSETM_SETM_ID
,TMPSETM_SETM_TYPE
,TMPSETM_SETM_START_DT
,TMPSETM_EARMARK_DT
,TMPSETM_SETM_DT
,TMPSETM_START_TRD_DATE
,TMPSETM_END_TRD_DATE
)
select distinct  isnull(ccid.CDSL_Old_Value ,'00')   
--,SttlmPrdFr
, case when isnull(exchid.CDSL_Old_Value ,'00') ='' then '00' else     isnull(exchid.CDSL_Old_Value ,'00') end 
,SctiesSttlmTxId
--,case when  isnull(MktTpAndId.CDSL_Old_Value ,'0')     ='' then '0' else     isnull(MktTpAndId.CDSL_Old_Value ,'0')     end  
--, case when isnull(exchid.CDSL_Old_Value ,'00') ='' then '00' else     isnull(exchid.CDSL_Old_Value ,'00') end + replace(isnull(ccid.CDSL_Old_Value ,'00'),'NA','00')
--+case when  isnull(MktTpAndId.CDSL_Old_Value ,'0')     ='' then '0' else     isnull(MktTpAndId.CDSL_Old_Value ,'0')     end  
,left(SctiesSttlmTxId,6) 
,SttlmPrdFr
,max(NSLDDdlnDt) 
,PyoutDt 
,SttlmPrdFr
,SttlmPrdTo
 from cc_clnd_converter left outer join (select Standard_Value, CDSL_Old_Value from Harm_source_cdsl  where Field_Description ='Market Type' ) MktTpAndId   
						on  MKTTPANDID = MktTpAndId.Standard_Value 
 left outer join (select Standard_Value, CDSL_Old_Value from Harm_source_cdsl  where Field_Description ='CLEARING CORPORATION ID') ccid 
		on  CLRSYSID = ccid.Standard_Value
		 left outer join (select Standard_Value, CDSL_Old_Value from Harm_source_cdsl  where Field_Description ='Exchange ID') exchid 
		on  Xchg = exchid.Standard_Value
					where   ClrSysId is not null 
					--and SttlmPrdFr like '%2024%'
 group by  isnull(ccid.CDSL_Old_Value ,'00')   
,case when isnull(exchid.CDSL_Old_Value ,'00') ='' then '00' else     isnull(exchid.CDSL_Old_Value ,'00') end
,SctiesSttlmTxId
, case when isnull(exchid.CDSL_Old_Value ,'00') ='' then '00' else     isnull(exchid.CDSL_Old_Value ,'00') end + replace(isnull(ccid.CDSL_Old_Value ,'00'),'NA','00') +case when  isnull(MktTpAndId.CDSL_Old_Value ,'0')     ='' then '0' else     isnull(MktTpAndId.CDSL_Old_Value ,'0')     end      
,SttlmPrdFr
,PyoutDt 
,SttlmPrdFr
,SttlmPrdTo 
  

				UPDATE settlement_mstr 
				SET    setm_ccm_id                = isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0) 
					, setm_excm_id               = citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id)
					, setm_payin_dt              = tmpsetm_earmark_dt
					, setm_payout_dt             = tmpsetm_setm_dt
					, setm_settm_id              = settm_id
                    , setm_no                    = right(tmpsetm_setm_id,7)
					, setm_start_dt              = tmpsetm_start_trd_date
					, setm_end_dt                = tmpsetm_end_trd_date
					, setm_lst_upd_dt            = getdate()
					, setm_lst_upd_by            = @pa_login_name
					, setm_deadline_time = right(CONVERT(varchar,TMPSETM_EARMARK_DT,108),8)
				FROM   tmpsetm_mstr
				     , settlement_type_mstr         
				WHERE  citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id) = settm_excm_id
				and case when len(tmpsetm_setm_id) > 7 then ltrim(rtrim(substring(tmpsetm_setm_id,1,len(tmpsetm_setm_id)-7)))
				else convert(varchar,tmpsetm_setm_type) end
				= CASE WHEN SETTM_EXCM_ID = 3 and settm_type_cdsl = 'NR' THEN 'N' ELSE ltrim(rtrim(settm_type_cdsl)) END 
				AND    RIGHT(tmpsetm_setm_id,7)   = setm_no
                AND    convert(datetime,tmpsetm_setm_dt) >= 'APR  1 2008'
                and   isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0) in (select ccm_id from cc_mstr) 
                and   isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0) <> 0
                AND ISNULL(citrus_usr.fn_get_mapping('excm_id','cdsl',tmpsetm_exch_id),0) <> 0                
                and settm_id = setm_settm_id

				SELECT @l_id = ISNULL(MAX(setm_id),0)+10  FROM settlement_mstr 

				SELECT IDENTITY(INT, 1, 1) ID1, case when len(tmpsetm_setm_id) > 7 then ltrim(rtrim(substring(tmpsetm_setm_id,1,len(tmpsetm_setm_id)-7))) else convert(varchar,tmpsetm_setm_type) end 
				setm_type , RIGHT(tmpsetm_setm_id,7) setm_no
--, case when TMPSETM_CC_ID='29' then '16' else citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id) end exch_id 
,citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id) exch_id 
,TMPSETM_SETM_START_DT

INTO #tmp_identity_setm FROM tmpsetm_mstr 

--select * from #tmp_identity_setm where id1 =112 
		

				INSERT INTO settlement_mstr 
				( setm_id
				, setm_settm_id
				, setm_excm_id
				, setm_ccm_id
				, setm_no
				, setm_start_dt
				, setm_end_dt
				, setm_deadline_dt
				, setm_deadline_time
				, setm_payin_dt
				, setm_payout_dt
				, setm_auction_dt
				, setm_created_by
				, setm_created_dt
				, setm_lst_upd_by
				, setm_lst_upd_dt
				, setm_deleted_ind
				)
				SELECT 
						id1 + @l_id
				--, citrus_usr.fn_get_mapping('setm_type',CASE tmpsetm_exch_nm WHEN 'BOMBAY STOCK EXCHANGE LIMITED' then 'BSE'
				--																																																													WHEN 'NATIONAL STOCK EXCHANGE OF INDIA LIMITED' then 'NSE'
				--																																																													WHEN 'MULTI COMMODITY EXCHANGE OF INDIA LIMITED' then 'MCX'
				--																																																													WHEN 'THE DELHI STOCK EXCHANGE ASSOCIATION LIMITED' then 'DSE'
				--																																																													WHEN 'THE CALCUTTA STOCK EXCHANGE ASSOCIATION LIMITED' then 'CSE' END,tmpsetm_setm_type) 
				,settm_id

				, citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id)
				, isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0) 
				, right(tmpsetm_setm_id,7)
				, tmpsetm_start_trd_date
				, tmpsetm_end_trd_date
				, getdate()
				, right(CONVERT(varchar,TMPSETM_EARMARK_DT,108),8) --CONVERT(varchar,getdate(),108)
				, tmpsetm_earmark_dt
				, tmpsetm_setm_dt
				, tmpsetm_setm_dt
				, @pa_login_name
				, getdate()
				, @pa_login_name
				, getdate()
				, 1 
				FROM  tmpsetm_mstr            tmpsetm
						,  #tmp_identity_setm       tmpsetmid
						,  settlement_type_mstr    settm
				WHERE tmpsetmid.setm_type   = tmpsetm.tmpsetm_setm_type
                and   settm.settm_excm_id = tmpsetmid.exch_id
				AND   case when len(tmpsetm_setm_id) > 7 then ltrim(rtrim(substring(tmpsetm_setm_id,1,len(tmpsetm_setm_id)-7))) else convert(varchar,tmpsetm.tmpsetm_setm_type) end = CASE WHEN SETTM_EXCM_ID = 3 and settm_type_cdsl = 'NR' THEN 'N' ELSE ltrim(rtrim(settm_type_cdsl)) END 
				AND   tmpsetmid.setm_no     = right(tmpsetm_setm_id,7)  
                AND    convert(datetime,tmpsetm_setm_dt) >= 'APR  1 2008'
                and   isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0)  in (select ccm_id from cc_mstr)
                and   isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_cc_id),0) <> 0 
                AND   ISNULL(citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id),0) <> 0                
                and  not exists(select SETM_NO,SETM_SETTM_ID from settlement_mstr where 
                settm_excm_id = citrus_usr.fn_get_mapping('excm_id',@pa_exch,tmpsetm_exch_id) 
                and setm_no = right(TMPSETM_SETM_ID,7) and setm_settm_id = settm_id )
			order by 1 

		--
		END
		ELSE  --below part is not working 
		BEGIN
		--
		  IF @pa_mode = 'BULK'
				BEGIN
				--
					   truncate table 	tmpsetm_nsdl_value 
                       TRUNCATE TABLE tmpsetm_nsdl_mstr

						
						SET @@ssql ='BULK INSERT CITRUS_USR.tmpsetm_nsdl_value	 from ''' + @pa_db_source + ''' WITH 
						(
									FIELDTERMINATOR = ''\n'',
									ROWTERMINATOR = ''\n''
						)'

						EXEC(@@ssql)
				--
				END


				delete from tmpsetm_nsdl_value where left(value,2) = '01'

				insert into tmpsetm_nsdl_mstr
				(
				TMPSETM_NSDL_CC_ID
				,TMPSETM_NSDL_CC_MKTTYP
				,TMPSETM_NSDL_CC_SETM_NUM
				,TMPSETM_NSDL_CC_SETM_PRD_FROM
				,TMPSETM_NSDL_CC_SETM_PRD_TO
				,TMPSETM_NSDL_CC_NSDL_DEADLINE_DT
				,TMPSETM_NSDL_CC_NSDL_DEADLINE_TIME
				,TMPSETM_NSDL_CC_PAY_IN_DT
				,TMPSETM_NSDL_CC_PAY_OUT_DT
				)
				select ltrim(rtrim(substring(value ,10,8)))
				,case when len(ltrim(rtrim(substring(value ,18,2)))) <2 then '0' + ltrim(rtrim(substring(value ,18,2))) else ltrim(rtrim(substring(value ,18,2))) end
				,ltrim(rtrim(substring(value ,20,7)))
				,ltrim(rtrim(substring(value ,27,8)))
				,ltrim(rtrim(substring(value ,35,8)))
				,ltrim(rtrim(substring(value ,43,8)))
				,ltrim(rtrim(substring(value ,51,4)))
				,ltrim(rtrim(substring(value ,55,8)))
				,ltrim(rtrim(substring(value ,63,8)))
				from tmpsetm_nsdl_value

	





				UPDATE settlement_mstr 
				SET   --setm_ccm_id                   =  isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0),
					  setm_payin_dt                  = tmpsetm_nsdl_cc_pay_in_dt
					, setm_payout_dt                 = tmpsetm_nsdl_cc_pay_out_dt
					, setm_start_dt                  = tmpsetm_nsdl_cc_setm_prd_from
					, setm_end_dt                    = tmpsetm_nsdl_cc_setm_prd_to
					, setm_lst_upd_dt                = getdate()
					, setm_lst_upd_by                = @pa_login_name
				FROM   tmpsetm_nsdl_mstr,  settlement_type_mstr  
				WHERE  settm_type  = convert(varchar,tmpsetm_nsdl_cc_mkttyp) and  settm_type  <> '' 
				and    settm_id						  = setm_settm_id
				AND    tmpsetm_nsdl_cc_setm_num       = setm_no
                and    tmpsetm_nsdl_cc_id in (select ccm_cd from cc_mstr)
                and     isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0) <> 0



				SELECT @l_id = ISNULL(MAX(setm_id),0) FROM settlement_mstr 

				SELECT IDENTITY(INT, 1, 1) ID1, tmpsetm_nsdl_cc_mkttyp setm_type , tmpsetm_nsdl_cc_setm_num setm_no,isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0) cc_id INTO #tmp_identity_nsdl_setm FROM tmpsetm_nsdl_mstr  where isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0) <> 0

                UPDATE tmpsetm_nsdl_mstr SET TMPSETM_NSDL_CC_MKTTYP= '0' + CONVERT(VARCHAR,TMPSETM_NSDL_CC_MKTTYP) WHERE LEN(LTRIM(RTRIM(TMPSETM_NSDL_CC_MKTTYP)))=1

				INSERT INTO settlement_mstr 
				( setm_id
				, setm_settm_id
				, setm_excm_id
				, setm_ccm_id
				, setm_no
				, setm_start_dt
				, setm_end_dt
				, setm_deadline_dt
				, setm_deadline_time
				, setm_payin_dt
				, setm_payout_dt
				, setm_auction_dt
				, setm_created_by
				, setm_created_dt
				, setm_lst_upd_by
				, setm_lst_upd_dt
				, setm_deleted_ind
				)	
				SELECT distinct 
						id1 + @l_id
				
                 , settm_id																																																																	
				, case when left(tmpsetm_nsdl_cc_setm_num,1) = '0' then 4  when left(tmpsetm_nsdl_cc_setm_num,1) = '2' then 3 else 0 end  
              
				, isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0)
				, tmpsetm_nsdl_cc_setm_num
				, tmpsetm_nsdl_cc_setm_prd_from
				, tmpsetm_nsdl_cc_setm_prd_to
				, tmpsetm_nsdl_cc_nsdl_deadline_dt
   				, tmpsetm_nsdl_cc_nsdl_deadline_time
 			    , tmpsetm_nsdl_cc_pay_in_dt
				, tmpsetm_nsdl_cc_pay_out_dt
				, tmpsetm_nsdl_cc_pay_in_dt--?????????
				, 'Ho'
				, getdate()
				, 'Ho'
				, getdate()
				, 1 
				FROM  tmpsetm_nsdl_mstr       tmpsetm
				,  #tmp_identity_nsdl_setm  tmpsetmid
				,  settlement_type_mstr    settm
				WHERE tmpsetmid.setm_type   = tmpsetm.tmpsetm_nsdl_cc_mkttyp
				AND   tmpsetmid.setm_no     = tmpsetm_nsdl_cc_setm_num
				and   settm.settm_excm_id = case when left(tmpsetm_nsdl_cc_setm_num,1) = '0' then 4  when left(tmpsetm_nsdl_cc_setm_num,1) = '2' then 3 else 0 end  
                and  citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id) = cc_id
                AND   CONVERT(DATETIME,TMPSETM_NSDL_CC_SETM_PRD_FROM,103) >= 'apr 01 2008'
                and settm_type = convert(varchar,TMPSETM_NSDL_CC_MKTTYP)
                and  settm_type  <> '' 
                and   tmpsetm_nsdl_cc_id in (select ccm_cd from cc_mstr)
                and  isnull(citrus_usr.fn_get_mapping('CC_id','cdsl',tmpsetm_nsdl_cc_id),0) <> 0
                and  not exists(select setm_id from settlement_mstr where settm_excm_id = case when left(tmpsetm_nsdl_cc_setm_num,1) = '0' then 4  when left(tmpsetm_nsdl_cc_setm_num,1) = '2' then 3 else 0 end  
                and setm_no = tmpsetm_nsdl_cc_setm_num) 
				

			
		--
		END
 
  
--  
END

GO
