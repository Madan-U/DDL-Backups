-- Object: FUNCTION citrus_usr.fn_dailyholding_cdsl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_dailyholding_cdsl](  
@dpmid int,  
@pa_holdingdate datetime,  
@pa_fromaccid varchar(16),                                      
@pa_toaccid varchar(16),                                      
@pa_isincd varchar(12),                
@pa_group_cd varchar(10),                       
@pa_login_pr_entm_id numeric,                                        
@pa_child_entm_id  int  
)  returns @temp  TABLE (dpam_sba_no varchar(8),dpam_sba_name varchar(150),DPHMCD_DPAM_ID bigint,DPHMCD_ISIN varchar(12),DPHMCD_CURR_QTY numeric(18,3),DPHMCD_FREE_QTY numeric(18,3),DPHMCD_FREEZE_QTY numeric(18,3),DPHMCD_PLEDGE_QTY numeric(18,3),DPHMCD_DEMAT_PND_VER_QTY numeric(18,3),DPHMCD_REMAT_PND_CONF_QTY numeric(18,3),DPHMCD_DEMAT_PND_CONF_QTY numeric(18,3),DPHMCD_SAFE_KEEPING_QTY numeric(18,3),DPHMCD_LOCKIN_QTY numeric(18,3),DPHMCD_ELIMINATION_QTY numeric(18,3),DPHMCD_EARMARK_QTY numeric(18,3),DPHMCD_AVAIL_LEND_QTY numeric(18,3),DPHMCD_LEND_QTY numeric(18,3),DPHMCD_BORROW_QTY numeric(18,3))           
AS    
begin  
  
  
 IF @pa_fromaccid = ''                                      
 BEGIN                                      
  SET @pa_fromaccid = '0'                                      
  SET @pa_toaccid = '99999999999999999'                                      
 END                                      
 IF @pa_toaccid = ''                                      
 BEGIN                                  
  SET @pa_toaccid = @pa_fromaccid                                      
 END            
  
  
  
  
  declare @@acclist  TABLE(dpam_id BIGINT unique nonclustered,dpam_sba_no varchar(16),dpam_sba_name varchar(150))    
  
           
  
  if @pa_fromaccid <> '0'  
  begin  
   Insert into @@acclist  
   Select dpam_id,dpam_sba_no,dpam_sba_name   
   From citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id)   
   Where (convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid))  
   and @pa_holdingdate between eff_from and eff_to   
  end  
  else  
  begin  
   Insert into @@acclist  
   Select dpam_id,dpam_sba_no,dpam_sba_name   
   From citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,@pa_child_entm_id)   
   Where @pa_holdingdate between eff_from and eff_to   
  end  
  
  if rtrim(ltrim(@pa_group_cd)) = ''  
  begin  
		insert into @temp  
		Select dpam_sba_no,dpam_sba_name,d.DPHMCD_DPAM_ID,d.DPHMCD_ISIN,d.DPHMCD_CURR_QTY,  
		d.DPHMCD_FREE_QTY,d.DPHMCD_FREEZE_QTY,d.DPHMCD_PLEDGE_QTY,d.DPHMCD_DEMAT_PND_VER_QTY,d.DPHMCD_REMAT_PND_CONF_QTY,d.DPHMCD_DEMAT_PND_CONF_QTY,d.DPHMCD_SAFE_KEEPING_QTY,d.DPHMCD_LOCKIN_QTY,d.DPHMCD_ELIMINATION_QTY,d.DPHMCD_EARMARK_QTY,d.DPHMCD_AVAIL_LEND_QTY,d.DPHMCD_LEND_QTY,d.DPHMCD_BORROW_QTY
		from DP_DAILY_HLDG_CDSL d with(nolock), (    
		Select dpam_sba_no,dpam_sba_name,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_HOLDING_DT=max(DPHMCD_HOLDING_DT)
		From DP_DAILY_HLDG_CDSL with(nolock),  
		@@acclist account        
		Where DPHMCD_DPAM_ID = account.dpam_id                                            
		and DPHMCD_HOLDING_DT  <= @pa_holdingdate     
		and DPHMCD_ISIN like @pa_isincd + '%'  
		group by dpam_sba_no,dpam_sba_name,DPHMCD_DPAM_ID,DPHMCD_ISIN
		) d1  
		Where d.DPHMCD_HOLDING_DT  <= @pa_holdingdate      
		and d.DPHMCD_HOLDING_DT = d1.DPHMCD_HOLDING_DT
		and d.DPHMCD_DPAM_ID = d1.DPHMCD_DPAM_ID     
		and d.DPHMCD_ISIN = d1.DPHMCD_ISIN      
		and d.DPHMCD_DPAM_ID = @dpmid    
  end   
  else  
  begin  
     
		insert into @temp  
		Select dpam_sba_no,dpam_sba_name,d.DPHMCD_DPAM_ID,d.DPHMCD_ISIN,d.DPHMCD_CURR_QTY,  
		d.DPHMCD_FREE_QTY,d.DPHMCD_FREEZE_QTY,d.DPHMCD_PLEDGE_QTY,d.DPHMCD_DEMAT_PND_VER_QTY,d.DPHMCD_REMAT_PND_CONF_QTY,d.DPHMCD_DEMAT_PND_CONF_QTY,d.DPHMCD_SAFE_KEEPING_QTY,d.DPHMCD_LOCKIN_QTY,d.DPHMCD_ELIMINATION_QTY,d.DPHMCD_EARMARK_QTY,d.DPHMCD_AVAIL_LEND_QTY,d.DPHMCD_LEND_QTY,d.DPHMCD_BORROW_QTY
		from DP_DAILY_HLDG_CDSL d with(nolock), (    
		Select dpam_sba_no,dpam_sba_name,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_HOLDING_DT=max(DPHMCD_HOLDING_DT)
		From DP_DAILY_HLDG_CDSL with(nolock)
		,@@acclist account        
		,account_group_mapping g with(nolock)  
		Where DPHMCD_DPAM_ID = account.dpam_id
		and g.dpam_id = DPHMCD_DPAM_ID                
		and group_cd =  @pa_group_cd                                                        
		and DPHMCD_HOLDING_DT  <= @pa_holdingdate     
		and DPHMCD_ISIN like @pa_isincd + '%'  
		group by dpam_sba_no,dpam_sba_name,DPHMCD_DPAM_ID,DPHMCD_ISIN
		) d1  
		Where d.DPHMCD_HOLDING_DT  <= @pa_holdingdate      
		and d.DPHMCD_HOLDING_DT = d1.DPHMCD_HOLDING_DT
		and d.DPHMCD_DPAM_ID = d1.DPHMCD_DPAM_ID     
		and d.DPHMCD_ISIN = d1.DPHMCD_ISIN      
		and d.DPHMCD_DPAM_ID = @dpmid    


  end   
  

  
 return  
end

GO
