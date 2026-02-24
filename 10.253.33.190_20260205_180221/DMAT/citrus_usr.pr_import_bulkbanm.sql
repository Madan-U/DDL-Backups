-- Object: PROCEDURE citrus_usr.pr_import_bulkbanm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
[temp table] 
Column_name                Type        Computed        Length 
NAME OF THE BANK        nvarchar        no        100 
BRANCH NAME                nvarchar        no        100 
IFSC CODE                nvarchar        no        100 
MICR CODE                nvarchar        no        100 

*/
CREATE PROCEDURE  [citrus_usr].[pr_import_bulkbanm](@pa_login_name varchar(50),@pa_cr_date datetime) 
AS    
/*    
*********************************************************************************    
 SYSTEM         : Dp    
 MODULE NAME    : Pr_import_Banm    
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables    
 COPYRIGHT(C)   : Marketplace Technologies     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            08-OCT-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
--    

    DECLARE @l_id           NUMERIC    
          , @l_count        NUMERIC    
          , @l_banm_id_old  INTEGER    
  
  
  
    SELECT @l_count = COUNT(*) from [temp table]  
    WHERE not exists(select * from bank_mstr 
    where banm_name = [NAME OF THE BANK]
    and banm_branch = [BRANCH NAME] )    
  
  
    SELECT @l_banm_id_old  = bitrm_bit_location    
    FROM   bitmap_ref_mstr    WITH(NOLOCK)    
    WHERE  bitrm_parent_cd = 'ENTITY_ID'    
    AND    bitrm_child_cd  = 'ENTITY_ID'    
  
    UPDATE bitmap_ref_mstr        
    SET    bitrm_bit_location = bitrm_bit_location + @l_count + 1    
    WHERE  bitrm_parent_cd = 'ENTITY_ID'    
    AND    bitrm_child_cd  = 'ENTITY_ID'    
  
    SELECT IDENTITY(INT, 1, 1) ID1, [BRANCH NAME] branch
    , [NAME OF THE BANK] NAME INTO #tmp_identity FROM [temp table]  WHERE not exists (select * from bank_mstr 
    where banm_name = [NAME OF THE BANK]
    and banm_branch = [BRANCH NAME] )
  
 

    INSERT INTO bank_mstr(banm_id    
    ,banm_name    
    ,banm_branch    
    ,banm_micr    
    ,banm_created_by    
    ,banm_created_dt    
    ,banm_lst_upd_by    
    ,banm_lst_upd_dt    
    ,banm_deleted_ind,banm_rtgs_cd)    
    SELECT ID1 + @l_banm_id_old   
    ,[NAME OF THE BANK]
    ,[BRANCH NAME]   
    ,[MICR CODE]    
    ,@pa_login_name    
    ,@pa_cr_date
    ,@pa_login_name    
    ,@pa_cr_date
    ,1   ,[IFSC CODE]
    FROM  #tmp_identity    
        , [temp table]     
    WHERE [NAME OF THE BANK]  = BRANCH  
    AND   [BRANCH NAME]       = NAME
    AND   not exists (select * from bank_mstr 
					  where banm_name = [NAME OF THE BANK]
					  and banm_branch = [BRANCH NAME]) 
    
   


  
      
   
    
      
--    
END

GO
