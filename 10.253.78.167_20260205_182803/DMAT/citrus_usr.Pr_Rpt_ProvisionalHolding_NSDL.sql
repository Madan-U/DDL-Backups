-- Object: PROCEDURE citrus_usr.Pr_Rpt_ProvisionalHolding_NSDL
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_rpt_provisionalholding_nsdl 'NSDL',4,'Y','6/11/2008 12:00:00 AM','10000004','10000004','','N',1,'HO|*~|',''


CREATE Proc [citrus_usr].[Pr_Rpt_ProvisionalHolding_NSDL]
@pa_dptype varchar(4),                  
@pa_excsmid int,                  
@pa_asondate char(1),                  
@pa_fordate datetime,                  
@pa_fromaccid varchar(16),                  
@pa_toaccid varchar(16),                  
@pa_isincd varchar(12),            
@pa_withvalue char(1), --Y/N                  
@pa_login_pr_entm_id numeric,                    
@pa_login_entm_cd_chain  varchar(8000),                    
@pa_output varchar(8000) output                    
as                        
begin                        
                        
declare @@dpmid int,                        
@@tmpholding_dt datetime

  

select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
declare @@l_child_entm_id      numeric                    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
                  
                  
if @pa_fromaccid = ''                  
begin                  
 set @pa_fromaccid = '0'                  
 set @pa_toaccid = '99999999999999999'                  
end                    
if @pa_toaccid = ''                  
begin                  
 set @pa_toaccid = @pa_fromaccid                  
end   

               
                      
create table #tmpprovisonal
(dpam_id bigint,
 ben_acct_type varchar(3),
 isin_cd varchar(12),
 Qty numeric(18,3),
 sett_type varchar(5),
 sett_no varchar(10),
 blk_lock_flg varchar(5),
 lock_cd varchar(5),
 ReleaseDt datetime
)

create table #nsdltran                         
(                          
dpam_id bigint,                          
Ben_ctgry varchar(2),                    
Ben_acct_type varchar(2),                         
isin_cd varchar(12),  
sett_type varchar(3),    
sett_no varchar(10),
blk_lock_flg varchar(5),
lock_cd varchar(5),
ReleaseDt datetime,             
dpm_trans_no varchar(20),            
Qty numeric(19,3),                          
Book_Narr_cd varchar(3),                          
trans_type int,            
)    

                      
                      
            
         
        select top 1 @pa_fordate = DPDHM_HOLDING_DT from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1   

		set @@tmpholding_dt = dateadd(d,1,@pa_fordate) 

		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
        
		insert into #tmpprovisonal            
		select dpam_id,DPDHM_BENF_ACCT_TYP,DPDHM_ISIN ISINCD,DPDHM_QTY,DPDHM_SETT_TYPE= case when DPDHM_SETT_TYPE = '00' then '' else DPDHM_SETT_TYPE end ,DPDHM_SETT_NO                  
		,DPDHM_BLK_LOCK_FLG,DPDHM_BLK_LOCK_CD,DPDHM_REL_DT
		from DP_HLDG_MSTR_NSDL, 
		#ACLIST account  
		where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                        
		and DPDHM_dpam_id = account.dpam_id                    
		and (DPDHM_HOLDING_DT between eff_from and eff_to)                  
		and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
		and DPDHM_ISIN LIKE @pa_isincd + '%'  

      insert into #nsdltran(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,lock_cd,ReleaseDt,dpm_trans_no,Qty,Book_Narr_cd,trans_type)                         
      select NSDHM_dpam_id,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,NSDHM_ISIN,nsdhm_sett_type=case when nsdhm_sett_type = '00' then '' else nsdhm_sett_type end,nsdhm_sett_no,nsdhm_block_log_flag,nsdhm_block_lock_cd,nsdhm_lockin_rel_date,nsdhm_dpm_trans_no,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,0            
      from NSDL_HOLDING_DTLS with(nolock),
	  #ACLIST account             
      where                       
      NSDHM_TRANSACTION_DT >= @@tmpholding_dt     
  	  and nsdhm_dpam_id = account.dpam_id                    
	  and (nsdhm_transaction_dt between eff_from and eff_to)                  
	  and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
	  and nsdhm_ISIN LIKE @pa_isincd + '%'
	  and nsdhm_dpm_id = @@dpmid   


     --for non pool accounts   
     delete from #nsdltran where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')                 
       
     update m set trans_type = 1               
     from #nsdltran m                
     where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #nsdltran m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)             
     --for non pool accounts              
  
     -- for pool accounts  
      delete from #nsdltran where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')  
   
      update #nsdltran set trans_type = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'  
     -- for pool accounts 



	  insert into #tmpprovisonal
	  select dpam_id,ben_acct_type,isin_cd,sum(Qty),sett_type,sett_no,blk_lock_flg,lock_cd,ReleaseDt 
	  from #nsdltran
	  group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,lock_cd,ReleaseDt

	  if @pa_withvalue = 'N'
	  begin


			select t.dpam_id,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP,t.isin_cd ISINCD,isin_name ,convert(numeric(18,3),QTY) Qty ,CASE WHEN sett_type <> '00' THEN sett_type ELSE '' END SettmType,sett_no SettmNo,'' CCID                  
			,blk_lock_flg LockFlg,isnull(BLCK.descp,'') LockCD,CASE WHEN convert(varchar(11),ReleaseDt,109)='JAN  1 1900' THEN '' ELSE convert(varchar(11),ReleaseDt,109 ) END ReleaseDt
			,holding_dt=convert(varchar(11),@@tmpholding_dt,109)
			from 
			(
				select dpam_id,ben_acct_type,isin_cd,sum(QTY) Qty,sett_type,sett_no
				,blk_lock_flg ,lock_cd,ReleaseDt
				from #tmpprovisonal  
				group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,lock_cd,ReleaseDt  
			) t
			LEFT OUTER JOIN ISIN_MSTR I ON t.isin_cd = I.ISIN_CD,                  
			#ACLIST account, citrus_usr.FN_GETSUBTRANSDTLS('BLK_CD_NSDL') BLCK ,
			citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN  
			where t.dpam_id = account.dpam_id                    
			and (@@tmpholding_dt between eff_from and eff_to) 
			and  t.lock_cd = BLCK.CD                 
			and Ben_acct_type = BEN.CD
			order by DPAM_sba_NO,ISIN_NAME,t.isin_cd,Ben_acct_type 


        

	  end
	  else
	  begin
		

			select t.dpam_id,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP,t.isin_cd ISINCD,isin_name ,convert(numeric(18,3),Qty) Qty,CASE WHEN sett_type <> '00' THEN sett_type ELSE '' END SettmType,sett_no SettmNo,'' CCID                  
			,blk_lock_flg LockFlg,isnull(BLCK.descp,'') LockCD,CASE WHEN convert(varchar(11),ReleaseDt,109)='JAN  1 1900' THEN '' ELSE convert(varchar(11),ReleaseDt,109 ) END ReleaseDt
			,Valuation= convert(numeric(18,3),QTY*isnull(clopm_nsdl_rt,0)),holding_dt=convert(varchar(11),@@tmpholding_dt,109),cmp=isnull(clopm_nsdl_rt,0.00)
			from 
			(
				select dpam_id,ben_acct_type,isin_cd,sum(QTY) Qty,sett_type,sett_no
				,blk_lock_flg ,lock_cd,ReleaseDt
				from #tmpprovisonal  
				group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,lock_cd,ReleaseDt  
			) t 
			LEFT OUTER JOIN ISIN_MSTR I ON t.isin_cd = I.ISIN_CD
			LEFT OUTER JOIN CLOSING_LAST_NSDL on t.isin_cd = CLOPM_ISIN_CD,                  
			#ACLIST account,
			citrus_usr.FN_GETSUBTRANSDTLS('BLK_CD_NSDL') BLCK ,  
			citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN  
			where t.dpam_id = account.dpam_id                    
			and (@@tmpholding_dt between eff_from and eff_to)     
			and  t.lock_cd = BLCK.CD                  
			and Ben_acct_type = BEN.CD
			order by DPAM_sba_NO,ISIN_NAME,t.isin_cd,Ben_acct_type 


	  end





                  
                 
                    

          
      TRUNCATE TABLE #nsdltran
	  DROP TABLE #nsdltran 
      TRUNCATE TABLE #tmpprovisonal
	  DROP TABLE #tmpprovisonal
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST           
                        
END

GO
