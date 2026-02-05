-- Object: PROCEDURE citrus_usr.pr_upd_climseqno
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_upd_climseqno](@pa_errmsg VARCHAR(1000) OUTPUT    
                                ,@pa_output VARCHAR(8000) OUTPUT)    
AS    
BEGIN    
--    
          
      
    
    
            
  BEGIN TRANSACTION   

  DECLARE @l_clim_seq_no  NUMERIC    
        , @l_error        NUMERIC     
        , @l_clim_crn_no  NUMERIC     
        , @l_climseqno    NUMERIC  
          
  DECLARE @c_cursor        CURSOR   
    
  SELECT @l_climseqno = ISNULL(max(clim_seq_no),0) FROM clim_seq_no    
  --  
  SELECT @l_clim_seq_no = @l_climseqno
      
  SET     @c_cursor  = CURSOR fast_forward FOR     
  SELECT  clim.clim_crn_no     
  FROM    client_mstr clim  WITH(NOLOCK)  
  WHERE   clim.clim_deleted_ind  = 1    
  AND     clim.clim_crn_no NOT IN (SELECT clim_crn_no FROM clim_seq_no)    
      
      
    
    
  OPEN    @c_cursor    
  --    
  FETCH next FROM @c_cursor INTO @l_clim_crn_no    
    
  WHILE @@fetch_status      = 0    
  BEGIN --#cursor    
  --    
       
    SET @l_clim_seq_no = @l_clim_seq_no + 1  
      
    INSERT INTO clim_seq_no    
    ( clim_crn_no    
    , clim_exch_seg    
    , clim_seq_no    
    , clim_ind    
    , clim_created_dt    
    , clim_lst_upd_dt    
    )    
    VALUES    
    ( @l_clim_crn_no    
    , ISNULL(null,'')    
    , @l_clim_seq_no    
    , ISNULL(null,0)    
    , GETDATE()    
    , GETDATE()    
    )    
      
  
    SET @l_error = @@error    
    
    IF @l_error <> 0     
    BEGIN    
    --    
      ROLLBACK TRANSACTION    
          
      SET @pa_errmsg = @l_error    
        
      RETURN 
    --    
    END    
      
       
    FETCH next FROM @c_cursor INTO @l_clim_crn_no    
  --      
  END  --#cursor    
  CLOSE      @c_cursor    
  DEALLOCATE @c_cursor      

  COMMIT TRANSACTION    
    
    
   
      
      
  SELECT clim.clim_crn_no            clim_crn_no  
       , clim.clim_name1             clim_name1  
       , ISNULL(clim.clim_name2,'')  clim_name2    
       , ISNULL(clim.clim_name3,'')  clim_name3     
       , climseqno.clim_seq_no       clim_seq_no  
  FROM   clim_seq_no   climseqno     WITH(NOLOCK)  
       , client_mstr   clim          WITH(NOLOCK)   
  WHERE  clim.clim_crn_no           = climseqno.clim_crn_no  
  AND    climseqno.clim_seq_no      > @l_climseqno   
      
--    
END

GO
