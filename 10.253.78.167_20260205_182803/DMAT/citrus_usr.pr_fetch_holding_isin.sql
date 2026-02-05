-- Object: PROCEDURE citrus_usr.pr_fetch_holding_isin
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

---pr_fetch_holding_isin	1,30,'','','12345678','1234567890123456','Oct 27 2008','dsisin'
CREATE PROCEDURE [citrus_usr].[pr_fetch_holding_isin](@pa_startRowIndex int,                                                      
                                      @pa_maximumRows int  , 
                                      @pa_cd varchar(20),                                                
                                      @pa_desc varchar(20),              
                                      @pa_id varchar(16) , 
                                      @pa_boid varchar(16) , 
                                      @pa_request_dt datetime, 
                                      @pa_out VARCHAR(8000)OUTPUT
                                      )
AS
BEGIN


     DECLARE @first_id BIGINT                                                    
           , @startRow BIGINT                        
           , @l_count  BIGINT   

     SET @l_count  = 0                   
     SET ROWCOUNT 0       
               

	 DECLARE @l_exch_cd VARCHAR(20)
           , @l_dpam_id numeric
	 SELECT  @l_exch_cd = excsm_exch_cd ,@pa_id = dpm_id FROM EXCH_SEG_MSTR  , dp_mstr 
	 WHERE   excsm_id = default_dp
     and     dpm_excsm_id  = default_dp
     and     dpm_dpid = @pa_id 
     and     dpm_deleted_ind = 1

     select @l_dpam_id = dpam_id from dp_acct_mstr where dpam_sba_no = @pa_boid and  dpam_dpm_id = @pa_id and dpam_deleted_ind = 1 

    
             
 
     if @l_exch_cd = 'CDSL'
     begin
     --
       select distinct identity(bigint,1,1) id , isin_cd  , ISIN_NAME ,  DPHMCD_CURR_QTY qty into #cdsl from DP_DAILY_HLDG_CDSL , isin_mstr
       where DPHMCD_ISIN = ISIN_CD 
       and isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'
       and DPHMCD_DPAM_ID = @l_dpam_id
       and (isnull(DPHMCD_CURR_QTY,0) <> 0 or isnull(DPHMCD_FREE_QTY,0) <> 0)
       and  convert(varchar(11),DPHMCD_HOLDING_DT,109) = convert(varchar(11),@pa_request_dt,109) 
     --
     end 
     else 
     begin
     --
       select distinct identity(bigint,1,1) id , isin_cd  , ISIN_NAME ,  DPDHMD_QTY qty into #nsdl from DP_DAILY_HLDG_NSDL , isin_mstr
       where DPDHMD_ISIN = ISIN_CD 
       and DPDHMD_DPAM_ID = @l_dpam_id
       and isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'
       and isnull(DPDHMD_QTY,0) <> 0 
       and  convert(varchar(11),DPDHMD_HOLDING_DT,109) = convert(varchar(11),@pa_request_dt,109) 
     --
     end       

     SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
     IF @pa_startRowIndex = 0                                  
     SET @pa_startRowIndex = 1                                                      
     SET ROWCOUNT @pa_startRowIndex  


     if @l_exch_cd = 'CDSL'
     begin
       SELECT @first_id = ID                                                 
       FROM #CDSL 
       where isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'                                                  
       ORDER BY ID  

       IF @pa_startRowIndex =1                        
       BEGIN                        
       --                        
        SELECT @l_count = COUNT(id)                        
        FROM #cdsl  
        where isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'
       --                        
       END   

       SET ROWCOUNT @pa_maximumRows         
      
 
       SELECT  isin_cd                        
              ,isin_name                        
              ,qty  , @l_count                                              
       FROM #cdsl                                      
       WHERE id >= @first_id 
        and isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'                                        
       ORDER BY isin_name           


     end 
     else 
     begin
       SELECT @first_id = ID                                                 
       FROM #NSDL 
  where  isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'                                                  
       ORDER BY ID


       IF @pa_startRowIndex =1                        
       BEGIN                        
       --                        
        SELECT @l_count = COUNT(id)   
                           
        FROM #nsdl 
        where isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'                                          
       --                        
       END


       SET ROWCOUNT @pa_maximumRows    

       SELECT  isin_cd                        
              ,isin_name                        
              ,qty  , @l_count                                                     
       FROM #nsdl                                      
       WHERE id >= @first_id
         and isin_cd like @pa_cd   +'%'                                            
       and ISIN_NAME like @pa_desc  +'%'                                         
       ORDER BY isin_name
     

     end 
     

     

END

GO
