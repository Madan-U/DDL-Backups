-- Object: PROCEDURE citrus_usr.pr_charge_waive_nsdl
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_charge_waive '3','chargetype','','0','0','','','','',''
--pr_charge_waive '3','TRANSACTION','EP-DR','1205810000000615','1205810000000615','apr 01 2009','apr 30 2009','INE772A01016','',''
--pr_charge_waive '3','WaiveFlagupdate','','0','0','apr 01 2009','apr 30 2009','','1,2,3,4,10',''
--select * from waivedata
CREATE proc [citrus_usr].[pr_charge_waive_nsdl]
(@pa_id numeric
,@pa_action varchar(100)
,@pa_cd varchar(100)
,@pa_from_acct numeric(18,0)
,@pa_to_acct numeric(18,0)
,@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_isin  varchar(50)
,@pa_filter varchar(8000)
,@pa_out varchar(8000) out)
as
begin 

declare @l_dpm_id numeric
select @l_dpm_id =  dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_id  and dpm_deleted_ind = 1   

if @pa_from_acct = 0 
begin
set  @pa_from_acct = 0 
if @pa_to_acct = 0
  set  @pa_to_acct = '999999999999999999' 
end 

if @pa_action = 'chargetype'
begin
select distinct trastm_id                   
      ,trastm_cd  code                
      ,trastm_desc  description                
   from   transaction_sub_type_mstr                 
     , transaction_type_mstr, charge_mstr                  
   where  trastm_tratm_id          = trantm_id                
   and    trastm_cd  = CHAM_CHARGE_TYPE
   and    trantm_code              = 'INT_TRANS_TYPE_NSDL'             
   and    trantm_deleted_ind       = 1            
   order by trastm_cd            
end 
----pass code 
----drop table waivedata 
--create table waivedata(id numeric identity(1,1)
-- , transaction_dt datetime
-- , tran_no varchar(50)
-- , tratm_Cd varchar(50)
-- , client_id varchar(25)
-- , isin varchar(50)
-- , qty numeric(18,0)
-- , waive_yn char(1))

if @pa_action = 'TRANSACTION'
begin
    --delete  from waivedata where transaction_dt between @pa_from_dt and @pa_to_dt
    --alter table CDSL_HOLDING_DTLS ADD WAIVE_FLAG CHAR(1)
	--insert into waivedata

if(@pa_from_acct='0' and @pa_to_dt='0')
begin
	select distinct convert(varchar(11),NSDHM_TRANSACTION_DT,109) NSDHM_TRANSACTION_DT,NSDHM_DPM_TRANS_NO,NSDHM_TRASTM_CD,NSDHM_BEN_ACCT_NO,NSDHM_ISIN,NSDHM_QTY, NSDHM_TRN_DESCP,case when WAIVE_FLAG='Y' then 'YES' else 'NO' end  flag 
    from nsdl_holding_dtls      
	,client_dp_brkg
	,profile_charges
	,charge_mstr 
	where NSDHM_DPM_ID = @l_dpm_id 
	--AND   month(cdshm_tras_dt) = 4 and year(cdshm_tras_dt) = 2009 
	AND   NSDHM_TRANSACTION_DT between  @pa_from_dt and @pa_to_dt
    --and   NSDHM_BEN_ACCT_NO between @pa_from_acct and @pa_to_acct
    and   NSDHM_ISIN like case when @pa_isin = '' then '%' else @pa_isin+'%' end
	and   NSDHM_TRANSACTION_DT >= clidb_eff_from_dt and  NSDHM_TRANSACTION_DT <= clidb_eff_to_dt
	AND   NSDHM_DPAM_ID = clidb_dpam_id 
	AND   clidb_brom_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
    --AND   (ISNULL(cdshm_charge,0) <> 0 OR  ISNULL(CDSHM_DP_CHARGE,0) <> 0)
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_type = NSDHM_BOOK_NAAR_CD
	and    NSDHM_QTY < case when NSDHM_BEN_ACCT_TYPE ='12' and nsdhm_book_naar_cd = '011' then 999999999999999 else 0 end 
	and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30','20','12')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))	 
    and   cham_deleted_ind = 1
	and   clidb_deleted_ind = 1
	and   CHAM_CHARGE_BASE = 'NORMAL' 
	and   proc_deleted_ind = 1
end
else
begin 
	select distinct convert(varchar(11),NSDHM_TRANSACTION_DT,109) NSDHM_TRANSACTION_DT,NSDHM_DPM_TRANS_NO,NSDHM_TRASTM_CD,NSDHM_BEN_ACCT_NO,NSDHM_ISIN,NSDHM_QTY, NSDHM_TRN_DESCP,case when WAIVE_FLAG='Y' then 'YES' else 'NO' end  flag 
    from nsdl_holding_dtls      
	,client_dp_brkg
	,profile_charges
	,charge_mstr 
	where NSDHM_DPM_ID = @l_dpm_id 
	--AND   month(cdshm_tras_dt) = 4 and year(cdshm_tras_dt) = 2009 
	AND   NSDHM_TRANSACTION_DT between  @pa_from_dt and @pa_to_dt
    and   NSDHM_BEN_ACCT_NO between @pa_from_acct and @pa_to_acct
    and   NSDHM_ISIN like case when @pa_isin = '' then '%' else @pa_isin+'%' end
	and   NSDHM_TRANSACTION_DT >= clidb_eff_from_dt and  NSDHM_TRANSACTION_DT <= clidb_eff_to_dt
	AND   NSDHM_DPAM_ID = clidb_dpam_id 
	AND   clidb_brom_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
    --AND   (ISNULL(cdshm_charge,0) <> 0 OR  ISNULL(CDSHM_DP_CHARGE,0) <> 0)
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_type = NSDHM_BOOK_NAAR_CD
	and    NSDHM_QTY < case when NSDHM_BEN_ACCT_TYPE ='12' and nsdhm_book_naar_cd = '011' then 999999999999999 else 0 end 
	and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30','20','12')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))	 
    and   cham_deleted_ind = 1
	and   clidb_deleted_ind = 1
	and   CHAM_CHARGE_BASE = 'NORMAL' 
	and   proc_deleted_ind = 1
end   



	
end 
--return with id with comma seperator
--1,2,3,4
if @pa_action = 'WaiveFlagupdate'
begin

--declare @l_sql varchar(1000)
--set @l_sql  = 'update waivedata set waive_yn = ''Y'' where id in ( ' + @pa_filter + ' )'
--print @l_sql  
--exec(@l_sql)
--select * from waivedata where transaction_dt between @pa_from_dt and @pa_to_dt

UPDATE A SET WAIVE_FLAG = TMP_STATUS , NSDHM_CHARGE = 0 , NSDHM_DP_CHARGE = 0
FROM nsdl_holding_dtls A
, TMP_TRXREC_WAIVEDOFF_CHRG_NSDL B
WHERE A.NSDHM_TRANSACTION_DT = B.TMP_TRXDATE 
AND A.NSDHM_DPM_TRANS_NO = B.TMP_TRXNO
AND A.NSDHM_TRASTM_CD = B.TMP_TRATM_CD
AND A.NSDHM_BEN_ACCT_NO = B.TMP_BEN_ACCT_NO
AND A.NSDHM_ISIN = B.TMP_ISIN_CD
AND A.NSDHM_QTY = B.TMP_QTY
AND A.NSDHM_TRN_DESCP = B.TMP_TRANS_DESC
and isnull(a.WAIVE_FLAG,'') = ''

end 
--

--whenever billing completed then join with above table and waive charge which have flag 'Y'


end

GO
