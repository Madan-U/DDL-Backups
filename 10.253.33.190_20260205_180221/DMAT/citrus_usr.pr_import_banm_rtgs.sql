-- Object: PROCEDURE citrus_usr.pr_import_banm_rtgs
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN
--[pr_import_banm] 'CDSL','HO','BULK','C:\BulkInsDbfolder\BANK DETAILS\CD100827U.001','|*~|','*|~*',''
--ROLLBACK TRAN

--SELECT TMPBA_DP_BANK_NM,TMPBA_DP_BR,TMPBA_DP_BANK,COUNT(*) FROM tmp_bank_mstr GROUP BY TMPBA_DP_BANK_NM,TMPBA_DP_BR,TMPBA_DP_BANK HAVING COUNT(*) >1

--CANARA BANK	CANARA BANK	560015091
--SELECT * FROM TMP_bank_mstr WHERE TMPBA_DP_BANK = '560015091'
--SELECT * FROM DP_MSTR
--SELECT* FROM BANK_MSTR

create PROCEDURE  [citrus_usr].[pr_import_banm_rtgs]( @pa_exch          VARCHAR(20)    
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
   IF @pa_mode = 'BULK'  
   BEGIN  
   --  
  
        truncate table tmp_bank_mstr  
  
        DECLARE @@ssql varchar(8000)  
        SET @@ssql ='BULK INSERT CITRUS_USR.tmp_bank_mstr  from ''' + @pa_db_source + ''' WITH   
        (  
           FIELDTERMINATOR = ''~'',  
           ROWTERMINATOR = ''\n''  
        )'  
  
        EXEC(@@ssql)  
   --  
   END  
    
  
  
  
    DECLARE @c_bank_adr     CURSOR    
    DECLARE @c_bank_conc    CURSOR    
    DECLARE @l_id           NUMERIC    
          , @l_count        NUMERIC    
          , @l_banm_id_old  INTEGER    
          , @l_adr1         VARCHAR(50)    
          , @l_adr2         VARCHAR(50)     
          , @l_adr3         VARCHAR(50)     
          , @l_city         VARCHAR(50)    
          , @l_state        VARCHAR(50)    
          , @l_cntry        VARCHAR(50)    
          , @l_zip          VARCHAR(50)    
          , @l_values       VARCHAR(500)    
          , @l_ph1          VARCHAR(15)     
          , @l_ph2          VARCHAR(15)    
          , @l_fax          VARCHAR(15)    
          , @l_email        VARCHAR(50)    
          , @l_conname      VARCHAR(25)    
          , @l_condesg      VARCHAR(25)    
  
    /*UPDATE bank_mstr     
    SET    banm_name       = LEFT(TMPBA_DP_BANK_NM, len(TMPBA_DP_BANK_NM)-charindex('-',REVERSE(TMPBA_DP_BANK_NM)))    
         , banm_branch     = RIGHT(TMPBA_DP_BANK_NM,CASE WHEN charindex('-',REVERSE(TMPBA_DP_BANK_NM))  = 0 THEN len(TMPBA_DP_BANK_NM) ELSE charindex('-',REVERSE(TMPBA_DP_BANK_NM))-1 END)     
         , banm_lst_upd_by = @pa_login_name  
         , banm_lst_upd_dt = getdate()  
    FROM   tmp_bank_mstr    
    WHERE  tmpba_dp_bank = banm_micr    
  */
  
  
    SELECT @l_count = COUNT(*) from tmp_bank_mstr WHERE tmpba_dp_bank NOT IN(SELECT banm_micr FROM bank_mstr)    
  
  
    SELECT @l_banm_id_old  = bitrm_bit_location    
    FROM   bitmap_ref_mstr    WITH(NOLOCK)    
    WHERE  bitrm_parent_cd = 'ENTITY_ID'    
    AND    bitrm_child_cd  = 'ENTITY_ID'    
  
    UPDATE bitmap_ref_mstr        
    SET    bitrm_bit_location = bitrm_bit_location + @l_count + 1    
    WHERE  bitrm_parent_cd = 'ENTITY_ID'    
    AND    bitrm_child_cd  = 'ENTITY_ID'    
  
    SELECT IDENTITY(INT, 1, 1) ID1, tmpba_dp_bank MICR ,TMPBA_DP_BR BRANCH
    , TMPBA_DP_BANK_NM NAME INTO #tmp_identity FROM tmp_bank_mstr WHERE TMPBA_DP_BR <> 'D'  
     AND   not exists (select CONVERT(varchar,banm_micr),isnull(banm_rtgs_cd ,'') from bank_mstr 
								where CONVERT(varchar,banm_micr) = CONVERT(varchar,tmpba_dp_bank)
and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,''))
  
 

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
    ,CONVERT(char(50),LEFT(tmpba_dp_bank_nm, len(tmpba_dp_bank_nm)-charindex('-',REVERSE(tmpba_dp_bank_nm))) )  
    ,CASE WHEN charindex('-',tmpba_dp_bank_nm)  = 0 THEN tmpba_dp_bank_nm + '_'+ TMPBA_DP_BR ELSE  CONVERT(char(50),RIGHT(tmpba_dp_bank_nm,CASE WHEN charindex('-',REVERSE(tmpba_dp_bank_nm))  = 0 THEN len(tmpba_dp_bank_nm) ELSE charindex('-',REVERSE(tmpba_dp_bank_nm))-1 END)) END      
    ,tmpba_dp_bank    
    ,@pa_login_name    
    ,getdate()    
    ,@pa_login_name    
    ,getdate()    
    ,1   ,TMPBA_DP_BR  
    FROM  #tmp_identity    
        , tmp_bank_mstr    
    WHERE micr  = tmpba_dp_bank
    AND   TMPBA_DP_BR  = BRANCH  
    AND   TMPBA_DP_BANK_NM = NAME
    AND   not exists (select CONVERT(varchar,banm_micr),isnull(banm_rtgs_cd ,'') from bank_mstr 
								where CONVERT(varchar,banm_micr) = CONVERT(varchar,tmpba_dp_bank)
and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')) 
              
    AND   ISNUMERIC(tmpba_dp_bank) = 1
  
  
    SET    @c_bank_adr =  CURSOR fast_forward FOR      
    SELECT banm_id    
         , tmpba_dp_bank_add1    
         , tmpba_dp_bank_add2    
         , tmpba_dp_bank_add3    
         , tmpba_dp_bank_city    
         , tmpba_dp_bank_state    
         , tmpba_dp_bank_cntry    
         , tmpba_dp_bank_zip    
    FROM   bank_mstr    
         , tmp_bank_mstr     
    WHERE  banm_micr = tmpba_dp_bank      
    and   isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')
    OPEN @c_bank_adr      
    FETCH NEXT FROM @c_bank_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip     
  
    WHILE @@fetch_status = 0      
    BEGIN      
    --      
  
      SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_adr3,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + isnull(@l_cntry,'') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*'   
  
      EXEC pr_ins_upd_addr @l_id, 'INS', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''      
  
      FETCH NEXT FROM @c_bank_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip     
    --      
    END      
  
  
    CLOSE      @c_bank_adr      
    DEALLOCATE @c_bank_adr      
  
  
    SET    @c_bank_conc =  CURSOR fast_forward FOR      
    SELECT banm_id    
         , tmpba_dp_bank_ph1    
         , tmpba_dp_bank_ph2    
         , tmpba_dp_bank_fax    
         , tmpba_dp_bank_email    
         , tmpba_dp_bank_conname    
         , tmpba_dp_bank_condesg    
    FROM   bank_mstr    
         , tmp_bank_mstr     
    WHERE  banm_micr = tmpba_dp_bank      
  and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')
    OPEN @c_bank_conc      
    FETCH NEXT FROM @c_bank_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg    
  
    WHILE @@fetch_status = 0      
    BEGIN      
    --      
  
      SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*CONNAME|*~|'   + ISNULL(@l_conname,'') + '|*~|*|~*CONDESG|*~|'  + isnull(@l_condesg,'') + '|*~|*|~*'    
  
      EXEC pr_ins_upd_conc @l_id, 'INS', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''      
  
      FETCH NEXT FROM @c_bank_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg    
    --      
    END      
  
  
    CLOSE      @c_bank_conc      
    DEALLOCATE @c_bank_conc   
   
    
      
--    
END

GO
