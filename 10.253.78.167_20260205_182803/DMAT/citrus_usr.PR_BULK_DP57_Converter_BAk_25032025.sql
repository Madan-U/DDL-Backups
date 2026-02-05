-- Object: PROCEDURE citrus_usr.PR_BULK_DP57_Converter_BAk_25032025
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




--create table tmp_dp57( value varchar(8000))
--create table tmp_dp57_openqty (value varchar(8000),closing_qty numeric(18,5), opening_qty numeric(18,5))
--begin tran
--[pr_bulk_dp57_KJMC_NEWLOGIC] 'MIG','','1863','BULK','D:\BulkInsDbfolder\KJMC 10122012\44DP57U.09012012.011','','',''
--[pr_bulk_dp57] 'MIG','','1863','BULK','C:\BulkInsDbfolder\DPM DP57-CDSL FILE\44DP57U900.05072012.005','','',''
--SELECT * FROM FILETASK WHERE TASK_ID = 1863
--rollback
--drop table tmp_dp57_o
CREATE   proc [citrus_usr].[PR_BULK_DP57_Converter_BAk_25032025]
(  
 @PA_LOGIN_NAME    VARCHAR(20) 
,@PA_DPMDPID          VARCHAR(20)    
,@PA_TASK_ID        NUMERIC
,@PA_MODE          VARCHAR(10)                                    
,@PA_DB_SOURCE     VARCHAR(250)    
,@ROWDELIMITER     CHAR(4) =     '*|~*'      
,@COLDELIMITER     CHAR(4) =     '|*~|'    
,@SNO int=0  
,@PA_ERRMSG        VARCHAR(8000) OUTPUT)

as
begin 



 	IF  @PA_MODE ='BULK'  and  citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') not like 'cod_exp_%'
		BEGIN 
				UPDATE FILETASK
				SET    USERMSG = 'ERROR : File is not proper.Please Check.', STATUS='FAILED'
				, TASK_END_DATE = GETDATE()
				WHERE  TASK_ID = @PA_TASK_ID
				
				return
		END 




insert into Dp57log
select GETDATE(),'dp57 start','start'
 

--if @PA_MODE='BULK'
--BEGIN 
truncate table tmp_dp57 
--END 



		if exists (select 1 from sys.objects where name = 'tmp_dp57_o')
		drop table tmp_dp57_o
		
insert into Dp57log
select GETDATE(),'bulk insert ','start'

if @PA_MODE ='BULK' 
begin 

truncate table CODD_CDSL


DECLARE @@SSQL VARCHAR(8000)  
--SET @@SSQL ='BULK INSERT CODD_CDSL FROM ''' + @PA_DB_SOURCE + ''' WITH   
--( 
--						FIELDQUOTE = ''"''
--						, FIELDTERMINATOR = '',''
--						, ROWTERMINATOR = ''\n''
					
--						,FORMAT=''CSV''
--						,FIRSTROW = 2 

--)'  


--exec (@@SSQL)



declare @l_path varchar(1000)
declare @l_fillist varchar(5000)
 select @l_path = replace(@pa_db_source ,citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\')  ,'') --path without filename 
 select @l_fillist = citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') -- filelist 

 declare @l_count numeric
 declare @l_counter numeric
 select @l_count  = citrus_usr.ufn_CountString (@l_fillist,'*|~*')
 set @l_counter = 1 
 
 while @l_counter < = @l_count
 begin 

 


 
SET @@SSQL ='BULK INSERT CODD_CDSL FROM ''' +  @l_path + citrus_usr.fn_splitval_by (@l_fillist,@l_counter,'*|~*') + ''' WITH   
( 
						FIELDQUOTE = ''"''
						, FIELDTERMINATOR = '',''
						, ROWTERMINATOR = ''\n''
					
						,FORMAT=''CSV''
						,FIRSTROW = 2 

)'  


exec (@@SSQL)


 set @l_counter = @l_counter + 1 

 end 


end  


insert into CODD_CDSL_log
select *,getdate() from CODD_CDSL


insert into Dp57log
select GETDATE(),'bulk insert ','end'


--insert into Dp57log
--select GETDATE(),'DP57 FILE IS INCOMPLETE','START'

--IF not exists (select 1 	 from tmp_dp57 where citrus_usr.fn_splitval_by(value,	1	,'~') = 'T')
--		BEGIN
--		--

--		UPDATE filetask
--		SET    usermsg = 'DP57 FILE IS INCOMPLETE'  
--		WHERE  task_id = @pa_task_id

--		return 
--			--
--		END

--insert into Dp57log
--select GETDATE(),'DP57 FILE IS INCOMPLETE ','END'

insert into Dp57log
select GETDATE(),'insert tmp_dp57_o','start'
				--select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc into #tmp_dp57_o from tmp_dp57
				--select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc into tmp_dp57_o from tmp_dp57

select distinct TxnTyp+'~'+OrdSttsTo+'~'+TxnCd+'||' [TxnTyp~OrdSttsTo~TxnCd]
into #temp FROM CODD_CDSL  where not exists (select 1 from trxn_type_new where 
HAR_Type = case when TxnTyp='ATC' then 'ATS' else TxnTyp end 
and HARStatus= OrdSttsTo 
and HARCod = TxnCd)

if exists (select 1 from #temp ) 
begin 

declare @l_miss_trxtype varchar(8000)
set @l_miss_trxtype = 'Missing Combination in Standard CODD STATIC DATA : '
SELECT  @l_miss_trxtype  = @l_miss_trxtype + [TxnTyp~OrdSttsTo~TxnCd] from #temp 

drop table #temp

UPDATE FILETASK
SET    USERMSG = @l_miss_trxtype
--, STATUS='FAILED'
--, TASK_END_DATE = GETDATE()
WHERE  TASK_ID = @PA_TASK_ID
				
--return

end 
truncate table DP57bulkholding

insert into DP57bulkholding (column1,column2,column3,column4
,column5,column6,column7
,column8,column9,column10
,column11,column12,column13
,column14,column15,column16
,column18,column20,column26
,column27,column29,column30
,column31,column32,column34
,column35,column37 
,COLUMN21,COLUMN53)
SELECT distinct 'D',   case when   isnull(TxnsType,'')  in   ('2','3') and left(isnull(OthrClntId,'') ,8) = left(CLNTID,8) then '2' 
when   isnull(TxnsType,'')  in   ('2','3') and left(isnull(OthrClntId,'') ,8) <> left(CLNTID,8) then '3' 
else isnull(TxnsType,'') end  TxnTyp ,CLNTID,ISIN
,isnull(TxnID,'') ,Qty, isnull(TxnStatus,'') OrdSttsTo -- , OrdSttsTo
,SetUpDt,BizDt,isnull(BuySellInd,'')
,isnull(OthrClntId,''),isnull(ClrMmbId,''),isnull(SctiesSttlmTxId,'')
,isnull(OthrSttlmDtls,''),isnull(TxnID,''),isnull(ExecDt,'')
,case when TxnTyp ='DMT' then isnull(DOCNB ,'') else isnull(CntrLckInId,'') end,isnull(AuthntcnRefNb,''),isnull(XferTyp.cdsl_old_value,'') XferTyp 
,case when TxnTyp ='DMT' then isnull(DmatRejCd.CDSL_Old_Values,'')  else isnull(TxnRsnCd.cdsl_old_value,'') end TxnRsnCd,isnull(AccptdQty,''),isnull(ActlQty,'')
,case when  isnull(TxnsType,'')  in   ('2','3') then isnull(CnsdrtnAmt,'0') else isnull(ConfRejQty,'0') end ,isnull(EarmrkdQty,''),isnull(EFTSCd.CDSL_Old_Values,'') EFTSCd
,isnull(Trancode,'')  TxnCd,isnull(Addtllnf,'')
,isnull(NbOfSOA,''),linenb
 FROM CODD_CDSL 
 --left outer join Harm_source_cdsl  TxnTyp  on TxnTyp.Field_Description ='Transaction Type'  and TxnTyp.cdsl_old_value <> '' and TxnTyp = TxnTyp.Standard_Value
 --left outer join Harm_source_cdsl  OrdSttsTo  on OrdSttsTo.Field_Description ='Order Status / TRANSACTION STATUS'  
 --and  OrdSttsTo.cdsl_old_value <> '' and OrdSttsTo = OrdSttsTo.Standard_Value
 --and case when len(OrdSttsTo.cdsl_old_value)=3 then left(OrdSttsTo.cdsl_old_value,1) else  left(OrdSttsTo.cdsl_old_value,2)  end = case when TxnTyp.cdsl_old_value ='2' then '3' else   TxnTyp.cdsl_old_value  end 
 left outer join Harm_source_cdsl  XferTyp  on XferTyp.Field_Description ='TRANSFER TYPE'  and XferTyp.cdsl_old_value <> '' and XferTyp = XferTyp.Standard_Value
 left outer join Harm_source_cdsl  TxnRsnCd  on TxnRsnCd.Field_Description ='Trade Reason Code'  and TxnRsnCd.cdsl_old_value <> '' and TxnRsnCd = TxnRsnCd.Standard_Value
 left outer join STANDARD_VALUE_LIST  EFTSCd  on EFTSCd.ISO_Tags ='EFTSCd'  and EFTSCd.CDSL_Old_Values <> '' and EFTSCd = EFTSCd.Standard_Value
 left outer join STANDARD_VALUE_LIST  DmatRejCd  on DmatRejCd.ISO_Tags ='DmatRejCd'  and DmatRejCd.CDSL_Old_Values <> '' and DmatRejCd = DmatRejCd.Standard_Value
 --left outer join Harm_source_cdsl  EFTSCd  on EFTSCd.Field_Description ='EFTS CODE'  and EFTSCd.cdsl_old_value <> '' and EFTSCd = EFTSCd.Standard_Value
 --left outer join Harm_source_cdsl  TxnCd  on TxnCd.Field_Description ='TRANSACTION CODE'  and TxnCd.cdsl_old_value <> '' and TxnCd = TxnCd.Standard_Value
 left outer join trxn_type_new  on HAR_Type = CASe when TxnTyp ='ATC' then 'ATS' else TxnTyp end 
and HARStatus= OrdSttsTo 
and HARCod = TxnCd
		

select identity(numeric,1,1) id , 
--*,
convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , 
convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc ,
COLUMN1 column_1 ,
COLUMN2 column_2 ,
COLUMN3 column_3 ,
COLUMN4 column_4 ,
COLUMN5 column_5 ,
COLUMN6 column_6 ,
COLUMN7 column_7 ,
COLUMN9 column_9 ,
COLUMN10 column_10 ,
COLUMN11 column_11 ,
COLUMN12 column_12 ,
COLUMN13 column_13 ,
COLUMN14 column_14 ,
COLUMN15 column_15 ,
COLUMN18 column_18 ,
COLUMN20 column_20 ,
COLUMN24 column_24 ,
COLUMN26 column_26 ,
COLUMN27 column_27 ,
COLUMN29 column_29 ,
COLUMN30 column_30 ,
COLUMN31 column_31 ,
COLUMN32 column_32 ,
COLUMN34 column_34 ,
COLUMN35 column_35 ,
COLUMN37 column_37 ,
COLUMN53 column_53 ,
convert(varchar(8000),isnull(	COLUMN1	,'')+'~'+
isnull(	COLUMN2	,'')+'~'+
isnull(	COLUMN3	,'')+'~'+
isnull(	COLUMN4	,'')+'~'+
isnull(	COLUMN5	,'')+'~'+
isnull(	COLUMN6	,'')+'~'+
isnull(	COLUMN7	,'')+'~'+
isnull(	COLUMN8	,'')+'~'+
isnull(	COLUMN9	,'')+'~'+
isnull(	COLUMN10	,'')+'~'+
isnull(	COLUMN11	,'')+'~'+
isnull(	COLUMN12	,'')+'~'+
isnull(	COLUMN13	,'')+'~'+
isnull(	COLUMN14	,'')+'~'+
isnull(	COLUMN15	,'')+'~'+
isnull(	COLUMN16	,'')+'~'+
isnull(	COLUMN17	,'')+'~'+
isnull(	COLUMN18	,'')+'~'+
isnull(	COLUMN19	,'')+'~'+
isnull(	COLUMN20	,'')+'~'+
isnull(	COLUMN21	,'')+'~'+
isnull(	COLUMN22	,'')+'~'+
isnull(	COLUMN23	,'')+'~'+
isnull(	COLUMN24	,'')+'~'+
isnull(	COLUMN25	,'')+'~'+
isnull(	COLUMN26	,'')+'~'+
isnull(	COLUMN27	,'')+'~'+
isnull(	COLUMN28	,'')+'~'+
isnull(	COLUMN29	,'')+'~'+
isnull(	COLUMN30	,'')+'~'+
isnull(	COLUMN31	,'')+'~'+
isnull(	COLUMN32	,'')+'~'+
isnull(	COLUMN33	,'')+'~'+
isnull(	COLUMN34	,'')+'~'+
isnull(	COLUMN35	,'')+'~'+
isnull(	COLUMN36	,'')+'~'+
isnull(	COLUMN37	,'')+'~'+
isnull(	COLUMN38	,'')+'~'+
isnull(	COLUMN39	,'')+'~'+
isnull(	COLUMN40	,'')+'~'+
isnull(	COLUMN41	,'')+'~'+
isnull(	COLUMN42	,'')+'~'+
isnull(	COLUMN43	,'')+'~'+
isnull(	COLUMN44	,'')+'~'+
isnull(	COLUMN45	,'')+'~'+
isnull(	COLUMN46	,'')+'~'+
isnull(	COLUMN47	,'')+'~'+
isnull(	COLUMN48	,'')+'~'+
isnull(	COLUMN49	,'')+'~'+
isnull(	COLUMN50	,'')+'~'+
isnull(	COLUMN51	,'')+'~'+
isnull(	COLUMN52	,'')+'~'+
isnull(	COLUMN53	,''))  value

into #tmp_dp57_o from DP57bulkholding




				
				
delete from #tmp_dp57_o  where column_3  = '1203320186015090'

select *
into tmp_dp57_o from #tmp_dp57_o

			create clustered index ix_1 on #tmp_dp57_o(id, value)
			create clustered index ix_1 on tmp_dp57_o(id, value)
			create index ix_2 on #tmp_dp57_o(column_1, column_2,column_3)
			
			
--/*	cdsl issue cuspa account 05042023		*/
--if exists(select 1 from tmp_dp57_o where left(column_3 ,8)='12033200' )
--begin 

--declare @l_old_dp_cnt numeric
--select @l_old_dp_cnt  = count(1) from tmp_dp57_o  where left(value ,1)='D' and left(column_3 ,8)='12033200'

--select * into #tempdata_toolddp from (
--select replace(value ,'~33201~','~33200~') value from tmp_dp57_o  where left(value ,1)='H'
--union all
--select value from tmp_dp57_o  where left(value ,1)='D' and left(column_3 ,8)='12033200'
--union all
--select replace(value,'~'+citrus_usr.fn_splitval_by(value ,2,'~') +'~','~'+CONVERT(varchar,@l_old_dp_cnt)+'~') from tmp_dp57_o  where left(value ,1)='T'
--) a


--delete from [172.31.16.94].dmat.citrus_usr.tmp_dp57  

--insert into [172.31.16.94].dmat.citrus_usr.tmp_dp57 
--select * from #tempdata_toolddp 

--exec [172.31.16.94].dmat.citrus_usr.[pr_bulk_dp57_fromnewdp] 'MIG','12033200',0,'','','*|~*', '|*~|','0',''

--drop table #tempdata_toolddp

--end 

--/*cdsl issue cuspa account 05042023		*/

insert into Dp57log
select GETDATE(),'insert tmp_dp57_o','end'
		declare @l_dpm_dpid varchar(50)
		set @l_dpm_dpid  = ''
		select top  1 @l_dpm_dpid = column_2 
		from #tmp_dp57_o 
		where column_1 = 'H'

		

		IF @L_DPM_DPID  = '' 
		SET @L_DPM_DPID  = @PA_DPMDPID


		declare @l_dpm_id  numeric
		set @l_dpm_id = 0 
		select @l_dpm_id  = dpm_id  from dp_mstr where dpm_dpid like '%' + @l_dpm_dpid -- and default_dp = dpm_excsm_id  
		print @l_dpm_id 
		IF @l_dpm_id = 0 or (@PA_DPMDPID <> (select top 1 '120'+ CNTRLSCTIESDPSTRYPTCPT from CODD_CDSL ))
		BEGIN
		--

		UPDATE filetask
		SET    usermsg = 'ERROR : DPID NOT MATCHED'  
		WHERE  task_id = @pa_task_id

		return 
			--
		END

		 

		print 'yogesh'
		print @l_dpm_id
insert into Dp57log
select GETDATE(),' delete in case full file','start'

		DECLARE @L_TRANS_DT  DATETIME 
		--SELECT @L_TRANS_DT = CONVERT(DATETIME, LEFT(column_4,2)+'/'+SUBSTRING(column_4,3,2)+'/20'+RIGHT(column_4,2),103)
		--FROM #tmp_dp57_o WHERE column_1='H'

			SELECT @L_TRANS_DT = column_9
		FROM #tmp_dp57_o -- WHERE citrus_usr.fn_splitval_by(value,	1	,'~') ='H'---  added by yogesh dated 17122021

		print @L_TRANS_DT
		print @l_dpm_id 
		--if exists(SELECT * from #tmp_dp57_o WHERE column_1='H' and column_3 = 'F')
	  if exists (select 1  where citrus_usr.fn_splitval_by(citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\'),	5	,'_') in ('F'))-- added by yogesh dated 17122021
		begin 
			DELETE FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
		end 
		
		
		
insert into Dp57log
select GETDATE(),' delete in case full file','end'
 

insert into Dp57log
select GETDATE(),'Following Client Not Mapped','start'

--added below line as per mail from vishal dated 25012023
delete from #tmp_dp57_o where column_3 = '1203320006951435'
--added above line as per mail from vishal dated 25012023



		IF EXISTS(SELECT distinct column_3 FROM #tmp_dp57_o 
				  WHERE column_1='D' 
				  AND column_2 not in ('8','11','10') --<> '8'
				  AND  
		not exists (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 
		and column_3 =dpam_sba_no) and LEFT(column_3,8) not in ('12033200','16010100') ) 	
		
		BEGIN
		--

		declare @l_string  varchar(8000)
		set @l_string   = '' 
		select @l_string  = @l_string    + column_3 + ',' 
		FROM #tmp_dp57_o 
		WHERE 
		not exists (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 
		and column_3 =dpam_sba_no
		
		)
		AND column_1='D' and column_2 not in ('8','11','10') --<>'8' 
		and LEFT(column_3,8) not in ('12033200','16010100') --- added apr 04 2023

		UPDATE filetask
		SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
		WHERE  task_id = @pa_task_id

		UPDATE TBL_AUTO_PROCESS_DETAIL SET PROCESS_STATUS='98',
		PROCESS_HALTED_REASON='ERROR : FOLLOWING CLIENT NOT MAPPED ' + @L_STRING
		WHERE PROCESS_FOR='DP57900' and PROCESS_DATE=convert(varchar(11),getdate(),109) and @PA_MODE='AUTO'
        return
		--
		END

insert into Dp57log
select GETDATE(),'Following Client Not Mapped','end'
--
--changed by tushar on sep 29 2012
--select dpam_id , dpam_sba_no , DPHMCD_ISIN , max(DPHMCD_HOLDING_DT) maxtransdt into #holding from dp_daily_hldg_cdsl a , dp_Acct_mstr 
--where dpam_id = DPHMCD_DPAM_ID and dpam_sba_no in (select distinct column_3 
--from #tmp_dp57_o)
--and DPHMCD_HOLDING_DT < @L_TRANS_DT 
--group by dpam_sba_no , DPHMCD_ISIN ,dpam_id 


--update t set qty  =  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' then convert(numeric(18,5),column_6) else convert(numeric(18,5),column_6)*-1 end                 
--from #tmp_dp57_o t with(nolock)  
--where column_1='D' 

insert into Dp57log
select GETDATE(),'update qty','start'

update t set qty  =  case when column_2 = '1' 
and  column_7  in ('109') and   column_11   =''
				then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_29) 
							  else convert(numeric(18,5),column_29)*-1 end  
				when column_35 = '2277' and column_2 = '1' and  column_7  in ('105') 
				then 		  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_29) 
							  else convert(numeric(18,5),column_29)*-1 end  

/*case added by latesh on may 07 2012 */
when column_35 = '3102' and  column_7  in ('608')
and column_26 ='V'
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_30) 
							  else convert(numeric(18,5),column_30)*-1 end 

when column_35 = '3102' and  column_7  in ('608')
and column_26 ='C'
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_32) 
							  else convert(numeric(18,5),column_32)*-1 end 

when column_35 = '2252' and  column_7  in ('604')
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_31) 
							  else convert(numeric(18,5),column_31)*-1 end 

when column_35 = '2246' and  column_7  in ('605')
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_31) 
							  else convert(numeric(18,5),column_31)*-1 end 
when column_35 = '2225' and  column_7  in ('821')
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_31) 
							  else convert(numeric(18,5),column_31)*-1 end 


when column_2 = '32' and  column_35  in ('2246')
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_31) 
							  else convert(numeric(18,5),column_31)*-1 end 


when  column_35  in ('3202') and  column_7  in ('705')
then case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_29) 
							  else convert(numeric(18,5),column_29)*-1 end 


/*case added by latesh on may 07 2012 */

				when column_2 = '32' and  column_7  in ('3207') 
				then 		  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_31) 
							  else convert(numeric(18,5),column_31)*-1 end  


-------------------------- added on 21/10/2022--For early payin reversal dr -------------------------
						when column_2 = '4'  and  column_7  in ('426') and  column_35 = '4466' then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_30) 
							  else convert(numeric(18,5),column_30)*-1 end  
-------------------------- added on 21/10/2022--For early payin reversal dr -------------------------

						  when column_2 = '4'  and  column_7 not in ('401','409','431','433','417') then -- 431 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_29) 
							  else convert(numeric(18,5),column_29)*-1 end  
						  else 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' 
							  then convert(numeric(18,5),column_6) 
							  else convert(numeric(18,5),column_6)*-1 end  
						  end                
from #tmp_dp57_o t with(nolock)  
where column_1 = 'D'


insert into Dp57log
select GETDATE(),'update qty','end'


insert into Dp57log
select GETDATE(),'update desc','start'

update t set cdasdesc =  
case when column_2 in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 <> '' or column_14 <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and (column_13 <> '' or column_14 <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 = '' and column_14 = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and(column_13 = '' and column_14 = '')  then 'OF-DR' end   
											+ ' TD:'+column_15 +' '  
											+ 'TX:'+column_5 +' '  
											+ column_11 +' '  
											+ case when column_13 <> ''   then 'SET:'+ column_13 else '' end   

							   
							  when column_2 in ('1') 
										and column_7 in ('102','111')   then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'EARMARK-CR'  
													 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'EARMARK-DR' end   
											+ ' SETT '+column_13 +' '  
											+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','')  +' '  
											+ column_5 +' '  

							  
							  when column_2 in ('1') 
										and column_7 in ('109')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'BSEBOPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'BSEBOPAYIN-DR' end   
												+ ' SETT '+column_13 +' '  
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','')  +' '  
												+ column_5 +' '  
							 when column_2 in ('1') 
										and column_7 in ('107')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'NSCCL-CR'
												when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'NSCCL-DR' end 
												+ ' SETT '+column_13 +' '
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','')  +' '
												+ column_5 +' ' 


							when column_2 in ('16') 
										and column_7 in ('1603')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'NSCCL-CR'
												 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'NSCCL-DR' end 
													+ ' IN001002 12'+column_20 +' '
													+ ' SETT N'+ left(column_13,6)  +'N'
							  when column_2 in ('4') 
										and column_7 in ('409','426','433')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and column_34 not in  ('79','80') then 'EP-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and column_34  not in  ('79','80') then 'EP-DR'   
												 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and column_34  in  ('79','80') then 'BSEEPPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and column_34  in  ('79','80') then 'BSEEPPAYIN-DR'  
														end   
														+ ' TXN:'+column_5 +' '  
														+ 'CTBO: '+ column_11  +' '  
														+ column_13 +' '  
														+ 'EXID: ' + CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','') +' '  		
							  when column_2 in ('5') 
										and column_7 in ('511','521')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'INTDEP-CR'
												  when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'INTDEP-DR' end 
													+ ' '+column_5 +' '
													+ ' CTRBO '+column_11 +' '
													+ ' '+ column_13
											
						      when column_2 in ('14') 
										and column_7 in  ('1401')
										and '26' = (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = column_3 and dpam_deleted_ind = 1 )
								  then 
										case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'BSE-PAYOUT-CR'
											  when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'BSE-PAYOUT-DR' end 
												+ ' SETT '+ column_13
												+ ' BO-'+ column_11

								when column_2 in ('14') 
										and column_7  in ('1401')
										and '26' <> (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = column_3 and dpam_deleted_ind = 1 )
								  then 
										 case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' then 'SETTLEMENT-CR'
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' then 'SETTLEMENT-DR' end 
										+ ' SETT '+ column_13
										+ ' EX-'+ CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','') 
										+ ' ' + column_5


							  when column_2 in ('6') then 
											'DEMAT'  
											+ column_5 +' '  
											+ case   
											when column_7 ='601' then 'SETUP-CR PENDING VERIFICATION'  
											when column_7 ='607' then 'DELETE-DB PENDING VERIFICATION'  
											when column_7 ='602' then 'VERIFY-DB PENDING VERIFICATION'  
											when column_7 ='603' then 'VERIFY-CR PENDING CONFIRMATION'  
											when column_7 ='604' then 'CLOSE-DB PENDING CONFIRMATION'  
											when column_7 ='605' then 'CLOSE-CR CONFIRMED BALANCE'  
											when column_7 ='606' then 'CLOSE-CR LOCK-IN BALANCE'            
											when column_7 ='608' then 'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'  
											when column_7 ='609' then 'CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING VERIFICATION)'      
											end   

								when column_2 in ('32') and  column_7  in ('3206') then 
											'By Destat'  

								when column_2 in ('32') and  column_7  in ('3208') then 
											'By Destat Setup'  

								when column_2 in ('32') and  column_7  in ('3207') then 
											'By Destat Confirm'  

								when column_2 in ('33') and  column_7  in ('3304') then 
											'To Restat Confirm'  
/*case added by latesh on may 07 2012 */

								when column_2 in ('33') and  column_7  in ('3301') then 
											'To Restat Setup'  
/*case added by latesh on may 07 2012 */

								when column_2 in ('7') and  column_7  in ('707') then 
											'To Remat Confirm'  

								when column_2 in ('8') and  column_7  in ('816') then 
											'By Pledge Rejection'  
when column_2 in ('8') and  column_7  in ('821') then 
											'Pledge Accept: ' + column_5  + ' CTR BO:' + column_11  +  ' CR Pledgee'  

											   
								when column_2 in ('18') 
								and  column_7  in ('1801') then 
											'To Transfer\'+ column_11 
											
											when column_2 in ('18') 
								 and column_27  in ('1','3')
								-- and column_35  in ('2246')
								  then 
											'Transfer\'+ column_11 
											when column_2 in ('18') 
								 and  column_27  in ('0','2') then 
											'Transmission\'+ column_11 
											 
							  else 

								CITRUS_USR.fn_dp57_stuff('desc',column_2,'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',column_7,'','')

							  end 
							  
from #tmp_dp57_o t with(nolock)  
where column_1='D' 
 
 insert into Dp57log
select GETDATE(),'update desc','end'
 


/*
update t set closing_qty  = isnull((select sum(isnull(qty,0)) 
from #tmp_dp57_o t1 with(nolock) 
where t1.id < t.id and CITRUS_USR.FN_SPLITVAL_BY(t1.VALUE,3,'~') =CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
and citrus_usr.fn_splitval_by(t1.value,4,'~')  = citrus_usr.fn_splitval_by(t.value,4,'~')
and  citrus_usr.fn_splitval_by(t1.value,35,'~') in ('2246','2277','2280','2201')
 
)    ,0)                 
from #tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2280','2201')
*/
--select * from #tmp_dp57_o  t
--where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') ='1206210000005248' 
--and citrus_usr.fn_splitval_by(t.value,4,'~') ='INE862A01015' 
-- 
--
--SELECT opening_qty  ,  isnull(closing_qty,0) , isnull((select top 1 DPHMCD_CURR_QTY from #holding , dp_Acct_mstr where dpam_id = DPHMCD_DPAM_ID 
--and dpam_sba_no = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') and DPHMCD_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
--and DPHMCD_HOLDING_DT < @L_TRANS_DT order by DPHMCD_HOLDING_DT desc,DPHMCD_CURR_QTY desc),0) 
--, isnull((select sum(qty) from #tmp_dp57_o i 
--where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(i.VALUE,3,'~')
--and  citrus_usr.fn_splitval_by(i.value,4,'~') = citrus_usr.fn_splitval_by(t.value,4,'~')
--and i.id < t.id 
--and citrus_usr.fn_splitval_by(i.value,35,'~') in ('2246','2277','2201')
--) ,0)
--from #tmp_dp57_o t with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201')
--AND citrus_usr.fn_splitval_by(t.value,4,'~') = 'INE455F01025'
--AND CITRUS_USR.FN_SPLITVAL_BY(T.VALUE,3,'~') = '1205680000001311'
--
--select isnull((select sum(cdshm_qty) from cdsl_holding_dtls i 
--where i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--and  i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
--and i.CDSHM_TRAS_DT = @L_TRANS_DT
--and i.CDSHM_TRATM_CD in ('2246','2277','2201')
--and not exists(select column_3,citrus_usr.fn_splitval_by(t.value,4,'~')
--				 from #tmp_dp57_o 
--				 where column_3 = CDSHM_BEN_ACCT_NO
--				 and citrus_usr.fn_splitval_by(t.value,4,'~') = CDSHM_ISIN)),0)
--from #tmp_dp57_o t with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201')
				 
update #tmp_dp57_o set opening_qty = 0

--update #tmp_dp57_o set #tmp_dp57_o.opening_qty = c.qty 
--from (select b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~') cl, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,4,'~') isin, qty=isnull(sum(a.qty),0)
--from #tmp_dp57_o a, #tmp_dp57_o b
--where CITRUS_USR.FN_SPLITVAL_BY(a.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~')
--and citrus_usr.fn_splitval_by(a.value,4,'~') = citrus_usr.fn_splitval_by(b.value,4,'~')
--and a.id < b.id 
--group by b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~'), citrus_usr.fn_splitval_by(b.value,4,'~') ) c
--where CITRUS_USR.FN_SPLITVAL_BY(#tmp_dp57_o.VALUE,3,'~')= c.cl
--and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,4,'~')= c.isin
--and #tmp_dp57_o.id = c.id 

--select * from #tmp_dp57_o where value like '%INE192A01025%' and value like '%1201090000015901%'
 
--update t set opening_qty  =   opening_qty + cdslqty
--from #tmp_dp57_o t with(nolock)  
--,(select  CDSHM_ISIN, CDSHM_BEN_ACCT_NO,sum(cdshm_qty) cdslqty from cdsl_holding_dtls i 
--where i.CDSHM_TRAS_DT = @L_TRANS_DT
--and i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
--and not exists(select column_3,column_4
--				 from #tmp_dp57_o 
--				 where column_3 = CDSHM_BEN_ACCT_NO
--				 and column_4 = CDSHM_ISIN
--				 and CDSHM_TRANS_NO = column_5)
--group by  CDSHM_ISIN, CDSHM_BEN_ACCT_NO) i 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--and i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')

--select * from #tmp_dp57_o where value like '%INE192A01025%' and value like '%1201090000015901%'

--update t set opening_qty  =   opening_qty  + isnull(isnull(DPHMCD_CURR_QTY,'0')+isnull(dphmcd_demat_pnd_ver_qty,'0') ,0) 
----+ isnull((select sum(cdshm_qty) from cdsl_holding_dtls i 
----where i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
----and  i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
----and i.CDSHM_TRAS_DT = @L_TRANS_DT
----and i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
----and not exists(select column_3,citrus_usr.fn_splitval_by(t.value,4,'~')
----				 from #tmp_dp57_o 
----				 where column_3 = CDSHM_BEN_ACCT_NO
----				 and citrus_usr.fn_splitval_by(t.value,4,'~') = CDSHM_ISIN
----				 and CDSHM_TRANS_NO = column_5)
----) ,0)
--from #tmp_dp57_o t , #holding hldg , dp_daily_hldg_cdsl mainhldg with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and  column_3  = dpam_sba_no 
--and dpam_id = DPHMCD_DPAM_ID 
--and citrus_usr.fn_splitval_by(t.value,4,'~') = mainhldg.dphmcd_isin 
--and mainhldg.dphmcd_isin = hldg.dphmcd_isin 
--and maxtransdt = DPHMCD_HOLDING_DT 

--
--update t set opening_qty  = opening_qty + isnull(closing_qty,0)
--from #tmp_dp57_o t 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')


select * into #tempdata_demat_dtls from   #tmp_dp57_o where column_2 in ('6','32')




/*for update demat rejection code */


 insert into Dp57log
select GETDATE(),'update Demat_request_mstr','start'

UPDATE Demat_request_mstr 
SET DEMRM_STATUS = column_7,DEMRM_COMPANY_OBJ=column_27,DEMRM_CREDIT_RECD = CASE WHEN column_7 = '608' and ltrim(rtrim(isnull(column_27,''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tempdata_demat_dtls,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=column_4  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = column_18 
AND  DEMRM_TRANSACTION_NO = column_5 
AND dEMRM_DELETED_IND = 1 
and column_1='D' 
and column_35 in ('3102')
and dpam_sba_no=column_3
and DPAM_DPM_ID = @l_dpm_id and   column_7='608'
/*for update demat rejection code */

/*for update destat rejection code */

UPDATE Demat_request_mstr 
SET DEMRM_STATUS = column_7,DEMRM_COMPANY_OBJ=column_27,DEMRM_CREDIT_RECD = CASE WHEN column_7 in ('3206','3207') and ltrim(rtrim(isnull(column_27,''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tempdata_demat_dtls,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=column_4  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = column_18 
AND  DEMRM_TRANSACTION_NO = column_5 
AND dEMRM_DELETED_IND = 1 
and column_1='D' 
and column_35 in ('3115','3110')
and dpam_sba_no=column_3
and column_27 <> 0  -- for rejection code
and DPAM_DPM_ID = @l_dpm_id
/*for update destat rejection code */

-- commented on Mar 22 2017 for optimization by lateshw
--/* for update of demat confirmation flag in demat request mstr */
--update d set DEMRM_CREDIT_RECD ='C'
--from cdsl_holding_dtls,demat_request_mstr d where cdshm_tratm_cd='2246' 
--and  CDSHM_CDAS_SUB_TRAS_TYPE='605'
--and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~'),''))) <> ''
--and cdshm_tras_dt>='aug 01 2011' 
--and demrm_slip_serial_no=citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,18,'~')
--and isnull(DEMRM_COMPANY_OBJ,'')=''
--and DEMRM_CREDIT_RECD <>'C'
--/* for update of demat confirmation flag in demat request mstr */ 

--/* for update of destat confirmation flag in demat request mstr */
--update d set DEMRM_CREDIT_RECD ='C'
--from cdsl_holding_dtls,demat_request_mstr d where cdshm_tratm_cd='2246' 
--and  CDSHM_CDAS_SUB_TRAS_TYPE='3207'
--and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~'),''))) <> ''
--and cdshm_tras_dt>='aug 01 2011' 
--and demrm_slip_serial_no=citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,18,'~')
--and isnull(DEMRM_COMPANY_OBJ,'')=''
--and DEMRM_CREDIT_RECD <>'C'
--/* for update of destat confirmation flag in demat request mstr */ 
-- commented on Mar 22 2017 for optimization by lateshw

/* for update of demat confirmation flag in demat request mstr */
update d set DEMRM_CREDIT_RECD ='C'
from #tempdata_demat_dtls with(nolock),demat_request_mstr d with(nolock) , dp_acct_mstr with (nolock) 
where column_35  ='2246' 
and  column_7='605' and dpam_id = demrm_dpam_id and  dpam_sba_no = column_3
and ltrim(rtrim(isnull(column_27,''))) <> ''

and demrm_slip_serial_no=column_18
and isnull(DEMRM_COMPANY_OBJ,'')=''
and DEMRM_CREDIT_RECD <>'C'
/* for update of demat confirmation flag in demat request mstr */ 

/* for update of destat confirmation flag in demat request mstr */
update d set DEMRM_CREDIT_RECD ='C'
from #tempdata_demat_dtls with(nolock) ,demat_request_mstr d with(nolock)  , dp_acct_mstr with (nolock) 
where column_35  ='2246' 
and  column_7='3207' and dpam_id = demrm_dpam_id  
and dpam_sba_no = column_3
and ltrim(rtrim(isnull(column_27,''))) <> ''
and demrm_slip_serial_no=column_18
and isnull(DEMRM_COMPANY_OBJ,'')=''
and DEMRM_CREDIT_RECD <>'C'
/* for update of destat confirmation flag in demat request mstr */ 


/*demat in case of Auto CA rejection from CDSL on Jun 2 2016 by Latesh w*/

Update demat_request_mstr  set DEMRM_STATUS = column_7,
DEMRM_COMPANY_OBJ=column_7
,DEMRM_CREDIT_RECD = CASE WHEN column_7 = '609' then 'Y' else DEMRM_CREDIT_RECD end
,demrm_response_dt  =column_9
FROM #tempdata_demat_dtls with(nolock),demat_request_mstr with(nolock),dp_acct_mstr with (nolock) --,dp_acct_mstr with(nolock)
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=column_4  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = column_18 
AND  DEMRM_TRANSACTION_NO = column_5 
and dpam_sba_no=column_3
AND dEMRM_DELETED_IND = 1 
and column_1='D' 
and column_7 in ('609')
--and dpam_sba_no = cdshm_ben_acct_no 
and dpam_dpm_id  = @l_dpm_id

/*demat in case of Auto CA rejection from CDSL  on Jun 2 2016 by Latesh w*/


 insert into Dp57log
select GETDATE(),'update Demat_request_mstr','end'



 insert into Dp57log
select GETDATE(),'into #tempdatacdsl','start'

		--DELETE FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
		
-- alter table CDSL_HOLDING_DTLS alter column cdshm_internal_trastm varchar(50)
-- alter table CDSL_HOLDING_DTLS add cdshm_trans_cdas_code varchar(50)
SELECT cdshm_dpm_id,cdshm_ben_acct_no,cdshm_dpam_id,cdshm_tratm_cd
,cdshm_tratm_desc,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_int_ref_no,cdshm_trans_no
,cdshm_sett_type,cdshm_sett_no,cdshm_counter_boid,cdshm_counter_dpid
,cdshm_counter_cmbpid,cdshm_excm_id,cdshm_trade_no,cdshm_tratm_type_desc,cdshm_opn_bal
,cdshm_bal_type,CDSHM_TRG_SETTM_NO --into #temp_cdsl_holding_dtls
into #tempdatacdsl FROM   cdsl_holding_dtls with (nolock)
WHERE  CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
--change bu tushar on sep 29 2012
create clustered index ix_1 on #tempdatacdsl (cdshm_tras_dt 
,cdshm_ben_acct_no 
,cdshm_trans_no 
,cdshm_isin
,cdshm_qty 
,cdshm_sett_no 
,cdshm_counter_boid 
,cdshm_counter_dpid)


 insert into Dp57log
select GETDATE(),'into #tempdatacdsl','end'


 insert into Dp57log
select GETDATE(),'into CDSL_HOLDING_DTLS','start'

INSERT INTO CDSL_HOLDING_DTLS(
CDSHM_DPM_ID,CDSHM_BEN_ACCT_NO,CDSHM_DPAM_ID,CDSHM_TRATM_CD,CDSHM_TRATM_DESC,CDSHM_TRAS_DT
,CDSHM_ISIN,CDSHM_QTY,CDSHM_INT_REF_NO,CDSHM_TRANS_NO,CDSHM_SETT_TYPE,CDSHM_SETT_NO,CDSHM_COUNTER_BOID
,CDSHM_COUNTER_DPID,CDSHM_COUNTER_CMBPID,CDSHM_EXCM_ID,CDSHM_TRADE_NO,CDSHM_CREATED_BY,CDSHM_CREATED_DT,CDSHM_LST_UPD_BY
,CDSHM_LST_UPD_DT,CDSHM_DELETED_IND,cdshm_slip_no,cdshm_tratm_type_desc,cdshm_internal_trastm,CDSHM_BAL_TYPE,cdshm_id
,cdshm_opn_bal,cdshm_charge,CDSHM_DP_CHARGE,CDSHM_TRG_SETTM_NO,WAIVE_FLAG,cdshm_trans_cdas_code
,CDSHM_CDAS_TRAS_TYPE,CDSHM_CDAS_SUB_TRAS_TYPE
) 
		select @l_dpm_id , column_3, dpam_id , column_35
		--,CITRUS_USR.fn_dp57_stuff('desc',column_2,'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',column_7,'','')
        ,cdasdesc 
		,column_9
		,column_4 
		,qty--case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','')  ='CR' then convert(numeric(18,3),column_6) else convert(numeric(18,3),column_6)*-1 end 
		,CONVERT(VARCHAR(16),column_37 )
		,column_5  
		,left(column_13,6) --CITRUS_USR.fn_dp57_stuff('settmid',left(column_13,6),'','') 
		,right(column_13,7)
		,case when column_11 like '%IN%' then '' else  column_11 end 
		,case when column_11 like '%IN%' then column_11  else  '' end  CDSHM_COUNTER_DPID
		,column_12 CDSHM_COUNTER_CMBPID
		,CITRUS_USR.fn_dp57_stuff('excmid',left(column_13,6),'','') 
		,column_15 
		,'MIG'
		,getdate()
		,'MIG'
		,getdate()
		,1
		,null
		,case when column_2 = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when column_2 = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when column_2 = '15'  and column_7 = '1503'  then 'NSCCL-DR'
			  when column_2 in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 <> '' or column_14 <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and (column_13 <> '' or column_14 <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 = '' and column_14 = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and(column_13 = '' and column_14 = '')  then 'OF-DR' end   
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',column_2,column_10,column_13) ,citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')) end cdshm_tratm_type_desc -- pending from latesh 
		,case when column_2 = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when column_2 = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when column_2 = '15'  and column_7 = '1503'  then 'NSCCL-DR'
			  when column_2 in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 <> '' or column_14 <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and (column_13 <> '' or column_14 <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'CR' and (column_13 = '' and column_14 = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',column_35,'','') = 'DR' and(column_13 = '' and column_14 = '')  then 'OF-DR' end   
			  
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',column_2,column_10,column_13),citrus_usr.fn_splitval_by(replace(cdasdesc,' ','|'),1,'|'))  end   cdshm_internal_tratm  -- pending from latesh 
		,'' cdshm_bal_type 
		,column_53 
		,'0' openingbal 
		,null
		,null
		,column_14 
		,null
		,value
		,column_2 
		,column_7 
		FROM #tmp_dp57_o (Nolock), DP_aCCT_MSTR (Nolock)
		WHERE column_3 = DPAM_SBA_NO and column_1  in ('D') 
		and LEFT(column_3,8)  not in ('12033200','16010100') --- added apr 04 2023
		and not exists(select cdshm_tras_dt
						,cdshm_ben_acct_no,cdshm_trans_no
						,cdshm_isin,cdshm_qty
						,cdshm_sett_no,cdshm_counter_boid
						,cdshm_counter_dpid from #tempdatacdsl  a (Nolock)
						where cdshm_tras_dt = column_9
						and cdshm_ben_acct_no = dpam_sba_no
						and cdshm_trans_no = column_5 
						and cdshm_isin = column_4 
						and cdshm_qty = qty  and cdshm_tratm_cd = column_35
						and cdshm_sett_no = right(column_13,7)
						and cdshm_counter_boid = case when column_11 like '%IN%' then '' else  column_11 end 
						and cdshm_counter_dpid = case when column_11 like '%IN%' then column_11  else  '' end )


-- insert into Dp57log
--select GETDATE(),'into CDSL_HOLDING_DTLS','end'


-- insert into Dp57log
--select GETDATE(),'into filetask','start'

DECLARE @Rows numeric

SELECT @Rows=@@ROWCOUNT




declare @l_filecount numeric
,@l_insertedcount numeric
,@l_insertedcount_pl numeric
set @l_filecount = 0
set  @l_insertedcount = 0 
set @l_insertedcount_pl = 0 

--select @l_filecount = column_2 from tmp_dp57_o where citrus_usr.fn_splitval_by(value,	1	,'~')='T'
select @l_filecount = count(1) from tmp_dp57_o 
SELECT @l_insertedcount = @Rows 

--
--
--
--select @l_insertedcount = count(1)
--FROM #tmp_dp57_o , DP_aCCT_MSTR 
--WHERE column_3 = DPAM_SBA_NO 
--and not exists(select cdshm_tras_dt
--,cdshm_ben_acct_no,cdshm_trans_no
--,cdshm_isin,cdshm_qty
--,cdshm_sett_no,cdshm_counter_boid
--,cdshm_counter_dpid from #tempdatacdsl  a 
--where cdshm_tras_dt = convert(datetime,left(column_9,2)+'/'+substring(column_9,3,2)+'/'+substring(column_9,5,4),103) 
--and cdshm_ben_acct_no = dpam_sba_no
--and cdshm_trans_no = column_5 
--and cdshm_isin = column_4 
--and cdshm_qty = qty  and cdshm_tratm_cd = column_35
--and cdshm_sett_no = right(column_13,7)
--and cdshm_counter_boid = case when column_11 like '%IN%' then '' else  column_11 end 
--and cdshm_counter_dpid = case when column_11 like '%IN%' then column_11  else  '' end )
--


select @l_insertedcount_pl =  count(1)
FROM #tmp_dp57_o where not exists 
(select dpam_sba_no 
from dp_acct_mstr 
where dpam_dpm_id = @l_dpm_id
and dpam_deleted_ind = 1
and column_3= dpam_sba_no)
AND column_1='D' and column_2 in ('8','11','10') 

UPDATE filetask
SET    uploadfilename = isnull(uploadfilename ,'') 
+  replace(citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\') ,'*|~*','<BR>')  +'~'
+'<BR>'+ 'FILE DATA COUNT : '  + convert(varchar,@l_filecount) 
+'<BR>'+ ' DATA INSERTED : ' + convert(varchar,@l_insertedcount+isnull(@l_insertedcount_pl,0))    
+'<BR>'+  case when exists(select 1 from filetask 
					where citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\') = citrus_usr.fn_splitval_by(uploadfilename,1,'~')
					
					) then  '--> File Already Imported' else '' end 
,  TASK_FILEDATE = @L_TRANS_DT
WHERE  task_id = @pa_task_id


 insert into Dp57log
select GETDATE(),'into CDSL_HOLDING_DTLS','end'

truncate table #tmp_dp57_o
drop table #tmp_dp57_o


 insert into Dp57log
select GETDATE(),'updat  desc','start'

Exec citrus_usr.pr_upd_dp57_desc
exec citrus_usr.PR_UPD_PLEDGEMARGIN_DESC
--exec  citrus_usr.[pr_Upd_freeze_stat] 

 insert into Dp57log
select GETDATE(),'updat  desc','end'

insert into Dp57log
select GETDATE(),'dp57 final done','end'
END

GO
