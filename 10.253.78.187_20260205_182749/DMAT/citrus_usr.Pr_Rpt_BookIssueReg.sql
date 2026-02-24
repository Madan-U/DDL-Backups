-- Object: PROCEDURE citrus_usr.Pr_Rpt_BookIssueReg
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select * from dp_mstr where default_dp=dpm_excsm_id


--Pr_Rpt_BookIssueReg 3,'','','APR  1 2008','sep 21 2009',1,'HO|*~|','454',''


CREATE PROCEDURE [citrus_usr].[Pr_Rpt_BookIssueReg]        
(        
   @pa_excsmid  int            
  ,@pa_frmacct varchar(20)            
  ,@pa_toacct varchar(20)            
  ,@pa_frm_dt varchar(11)            
  ,@pa_to_dt varchar(11)            
  ,@pa_login_pr_entm_id numeric            
  ,@pa_login_entm_cd_chain  varchar(8000)    
  ,@pa_tratm_id numeric
  ,@pa_output varchar(8000) output            
        
)        
AS        
BEGIN        
--        
 DECLARE @l_dpm_id  int            
        ,@@l_child_entm_id numeric         
   if @pa_frm_dt = '' and @pa_to_dt = ''   
begin  
set @pa_frm_dt = '01/01/1900'
set @pa_to_dt = '12/31/2099'  
end   
     
  IF @pa_frmacct =''  
  BEGIN  
      --  
 SET @pa_frmacct='0'  
 SET @pa_toacct='9999999999999999'  
      --  
  END   
  IF @pa_toacct =''  
  BEGIN  
      --  
 SET @pa_toacct = @pa_frmacct  
      --  
  END  
  SELECT @@l_child_entm_id = citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                      
           
  select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1  
  

  CREATE TABLE #ACLIST(dpam_crn_no BIGINT,dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

  INSERT INTO #ACLIST SELECT dpam_crn_no,DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
  
  FROM citrus_usr.[fn_acct_list_bytushar](@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id,@pa_frmacct,@pa_toacct)
  
INSERT INTO #ACLIST 
SELECT right(poam_master_id,6) DPAM_Crn_no, poam_id DPAM_ID, POAM_master_id dpam_sba_no, Poam_name1 dpam_sba_name,
'1900-01-01 00:00:00.000',	'2900-01-01 00:00:00.000'
 FROM poa_mstr  


  IF LTRIM(RTRIM(ISNULL(@pa_frm_dt,''))) <> '' AND LTRIM(RTRIM(ISNULL(@pa_to_dt,''))) <> '' and @pa_tratm_id <> '10000'
  BEGIN  
		  SELECT distinct  dpam_id  
		 ,dpam_sba_name    ACCTNAME            
		 ,dpam_sba_no      ACCNO             
		 ,issue_dt = case when sliim_dt is null then convert(varchar(11),sliim_created_dt,109)   else convert(varchar(11),sliim_dt,109) end 
		 ,trastm_desc             TTYPE            
		 ,sliim_series_type       SERIESTYPE            
		 ,sliim_slip_no_fr        SLIPNOFROM            
		 ,sliim_slip_no_to        SLIPNOTO            
		 ,(CONVERT(NUMERIC,sliim_slip_no_to) - CONVERT(NUMERIC,sliim_slip_no_fr))+ 1      NOOFSLIPS    
		,sliim_created_dt                 
		,slibm_book_name
		  FROM   slip_issue_mstr  left outer join slip_book_mstr 
		  on SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
		  and SLIBM_TO_NO = SLIIM_SLIP_NO_to  and  slibm_deleted_ind=1    and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE        
			   ,transaction_sub_type_mstr             
			   ,#ACLIST ACCOUNT            
		  WHERE trastm_id    = sliim_tratm_id   
		  AND  (sliim_entm_id = ACCOUNT.dpam_crn_no or sliim_entm_id = ACCOUNT.dpam_id)
		  AND  SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO	
		  AND  sliim_dpm_id = @l_dpm_id   
          AND  trastm_id    = CASE WHEN @pa_tratm_id  <> '0' THEN @pa_tratm_id ELSE trastm_id END 
		  AND (ACCOUNT.DPAM_sba_NO between @pa_frmacct AND  @pa_toacct)
		  AND sliim_dt BETWEEN CONVERT(DATETIME,@pa_frm_dt) AND  CONVERT(DATETIME,@pa_to_dt + ' 23:59:59') 
          --AND sliim_id=slibm_id            
		  AND  sliim_deleted_ind =1                      
		  AND  trastm_deleted_ind =1            
		  ORDER BY sliim_created_dt,DPAM_SBA_NO, dpam_sba_name 
   END     
   ELSE if @pa_tratm_id <> 10000
   BEGIN

		  SELECT distinct dpam_id  
		 ,dpam_sba_name    ACCTNAME            
				,dpam_sba_no     ACCNO             
		 ,issue_dt = case when sliim_dt is null then convert(varchar(11),sliim_created_dt,109)   else convert(varchar(11),sliim_dt,109) end 
				,trastm_desc             TTYPE            
				,sliim_series_type       SERIESTYPE            
				,sliim_slip_no_fr        SLIPNOFROM            
				,sliim_slip_no_to        SLIPNOTO            
				,(CONVERT(NUMERIC,sliim_slip_no_to) - CONVERT(NUMERIC,sliim_slip_no_fr))+ 1      NOOFSLIPS 
			,sliim_created_dt    
			,slibm_book_name                
		   FROM   slip_issue_mstr  left outer join slip_book_mstr 
				on SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
				and SLIBM_TO_NO = SLIIM_SLIP_NO_to  and  slibm_deleted_ind=1    and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE                     
			   ,transaction_sub_type_mstr             
			   ,#ACLIST ACCOUNT            
		  WHERE trastm_id    = sliim_tratm_id  
		 -- and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE
		 -- and SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
		--  and SLIBM_TO_NO = SLIIM_SLIP_NO_to 
		 AND  (sliim_entm_id = ACCOUNT.dpam_crn_no or sliim_entm_id = ACCOUNT.dpam_id)
		  AND  SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO
		  AND  sliim_dpm_id = @l_dpm_id     
          AND  trastm_id    = CASE WHEN @pa_tratm_id  <> '0' THEN @pa_tratm_id ELSE trastm_id END 
		   AND (ACCOUNT.DPAM_sba_NO between @pa_frmacct AND  @pa_toacct)
			AND sliim_dt BETWEEN CONVERT(DATETIME,@pa_frm_dt) AND  CONVERT(DATETIME,@pa_to_dt + ' 23:59:59') 
		  AND sliim_deleted_ind =1       
          --AND sliim_id=slibm_id      
         -- and  slibm_deleted_ind=1
		  AND trastm_deleted_ind =1            
		  ORDER BY sliim_created_dt,DPAM_SBA_NO,dpam_sba_name   

   END
else 
begin
  SELECT distinct 0  
		 ,SLIIM_DPAM_ACCT_NO ACCTNAME            
				,SLIIM_DPAM_ACCT_NO ACCNO             
		 ,issue_dt = case when sliim_dt is null then convert(varchar(11),sliim_created_dt,109)   else convert(varchar(11),sliim_dt,109) end 
				,trastm_desc             TTYPE            
				,sliim_series_type       SERIESTYPE            
				,sliim_slip_no_fr        SLIPNOFROM            
				,sliim_slip_no_to        SLIPNOTO            
				,(CONVERT(NUMERIC,sliim_slip_no_to) - CONVERT(NUMERIC,sliim_slip_no_fr))+ 1      NOOFSLIPS 
			,sliim_created_dt    
			,slibm_book_name                
		  FROM   slip_issue_mstr  left outer join slip_book_mstr 
		  on SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
		  and SLIBM_TO_NO = SLIIM_SLIP_NO_to  and  slibm_deleted_ind=1    and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE                     
			   ,transaction_sub_type_mstr             
			 
		  WHERE trastm_id    = sliim_tratm_id  
		 -- and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE
		--  and SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
		 -- and SLIBM_TO_NO = SLIIM_SLIP_NO_to 
		  AND  sliim_dpm_id = @l_dpm_id     
          AND  trastm_id    = CASE WHEN @pa_tratm_id  <> '0' THEN @pa_tratm_id ELSE trastm_id END 
		  AND sliim_dt BETWEEN CONVERT(DATETIME,@pa_frm_dt) AND  CONVERT(DATETIME,@pa_to_dt + ' 23:59:59') 
		  AND sliim_deleted_ind =1       
          --AND sliim_id=slibm_id      
        --  and  slibm_deleted_ind=1
		  AND trastm_deleted_ind =1            
		  ORDER BY sliim_created_dt
end 
  
           
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST
--        
END

GO
