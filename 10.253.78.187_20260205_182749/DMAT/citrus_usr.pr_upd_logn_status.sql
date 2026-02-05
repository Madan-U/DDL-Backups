-- Object: PROCEDURE citrus_usr.pr_upd_logn_status
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_upd_logn_status](@pa_login_name   VARCHAR(20)
                                   ,@pa_login_status CHAR(1)
                                   )
AS
BEGIN
--

  DECLARE @l_logn_no_of_att numeric
         ,@l_logn_tot_att   numeric 

  
  IF @pa_login_status = 'S'
  BEGIN
  --
  
    UPDATE login_names 
    SET    logn_no_of_att   = 0 
    WHERE  logn_name        = @pa_login_name
    AND    logn_deleted_ind = 1
    AND    getdate()        between logn_from_dt and logn_to_dt
    
  --
  END
  ELSE IF @pa_login_status = 'U'
  BEGIN
  --
    
    UPDATE login_names 
    SET    logn_no_of_att   = isnull(logn_no_of_att,0) + 1 
    WHERE  logn_name        = @pa_login_name
    AND    logn_deleted_ind = 1
    and    logn_total_att   <> 0
    AND    getdate()        between logn_from_dt and logn_to_dt
     
    
    SELECT @l_logn_no_of_att =  logn_no_of_att   
          ,@l_logn_tot_att   =  logn_total_att 
    FROM   login_names      
    WHERE  logn_name         = @pa_login_name
    AND    logn_deleted_ind  = 1
    AND    getdate()        between logn_from_dt and logn_to_dt
    
    
    
    IF   @l_logn_no_of_att > @l_logn_tot_att and @l_logn_tot_att  <> 0
    BEGIN
    --
      UPDATE login_names
      SET    logn_status       = 'D'
      WHERE  logn_name         = @pa_login_name
      AND    logn_deleted_ind  = 1
      AND    getdate()        between logn_from_dt and logn_to_dt
    --
    END
  --
  END
  
--
END

--- select * from login_names // CHANGE ON 23 MARCH 2017 AFTER DISCUSSION WITH BRIJESH

GO
