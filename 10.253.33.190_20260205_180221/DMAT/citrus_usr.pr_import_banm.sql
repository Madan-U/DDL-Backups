-- Object: PROCEDURE citrus_usr.pr_import_banm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN
--[pr_import_banm] 'CDSL','HO','BULK','C:\BulkInsDbfolder_CDSL\BANK MASTER - CD10\CD101027U.003','|*~|','*|~*',''
--[pr_import_banm] 'CDSL','HO','normal','','|*~|','*|~*',''
--ROLLBACK TRAN
--commit
--SELECT TMPBA_DP_BANK_NM,TMPBA_DP_BR,TMPBA_DP_BANK,COUNT(*) FROM tmp_bank_mstr GROUP BY TMPBA_DP_BANK_NM,TMPBA_DP_BR,TMPBA_DP_BANK HAVING COUNT(*) >1

--CANARA BANK	CANARA BANK	560015091
--SELECT * FROM TMP_bank_mstr WHERE TMPBA_DP_BANK = '560015091'
--SELECT * FROM DP_MSTR
--SELECT* FROM BANK_MSTR

CREATE PROCEDURE  [citrus_usr].[pr_import_banm]( @pa_exch          VARCHAR(20)    
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
    
  --return 
  
  
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
  
--    UPDATE bank_mstr     
--    SET    banm_lst_upd_by = @pa_login_name  
--         , banm_lst_upd_dt = getdate()  
--		 , banm_rtgs_Cd = isnull(TMPBA_DP_BR,'')
--    FROM   tmp_bank_mstr    
--	where  tmpba_dp_bank = banm_micr 
--	and tmpba_dp_bank_nm   = banm_name 
--	and TMPBA_DP_BANK_ADD1 + '('+ TMPBA_DP_BANK_ZIP +')'= BANM_BRANCH
-- 
--  
 
 select CONVERT(varchar,isnull(banm_micr ,'')) banm_micr,isnull(banm_rtgs_cd ,'') banm_rtgs_cd into #bank_mstr from bank_mstr 
  select  ISNULL(TMPBA_DP_BANK,'')tmpba_dp_bank , ISNULL(TMPBA_DP_BR,'')TMPBA_DP_BR into  #bank_addresses_dtls from  bank_addresses_dtls
 
  UPDATE bank_mstr     
    SET    banm_lst_upd_by = @pa_login_name 
         , banm_lst_upd_dt = getdate()  
		 ,BANM_NAME=TMPBA_DP_BANK_NM
    FROM   tmp_bank_mstr    
	where  tmpba_dp_bank = iSNULL(banm_micr,'')
	and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'') 
	AND BANM_NAME<>TMPBA_DP_BANK_NM
	
	
    SELECT @l_count = COUNT(*) from tmp_bank_mstr WHERE not exists(select CONVERT(varchar,banm_micr),isnull(banm_rtgs_cd ,'') from bank_mstr 
								where CONVERT(varchar,banm_micr) = CONVERT(varchar,tmpba_dp_bank)
and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,''))    


  
  
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
     AND   not exists (select CONVERT(varchar,iSNULL(banm_micr,'')),isnull(banm_rtgs_cd ,'') from #bank_mstr 
								where CONVERT(varchar,iSNULL(banm_micr,'')) = CONVERT(varchar,ISNULL(tmpba_dp_bank,''))
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
    ,tmpba_dp_bank_nm--CONVERT(char(50),LEFT(tmpba_dp_bank_nm, len(tmpba_dp_bank_nm)-charindex('-',REVERSE(tmpba_dp_bank_nm))) )  
    ,TMPBA_DP_BR--CASE WHEN charindex('-',tmpba_dp_bank_nm)  = 0 THEN tmpba_dp_bank_nm + '_'+ TMPBA_DP_BR ELSE  CONVERT(char(50),RIGHT(tmpba_dp_bank_nm,CASE WHEN charindex('-',REVERSE(tmpba_dp_bank_nm))  = 0 THEN len(tmpba_dp_bank_nm) ELSE charindex('-',REVERSE(tmpba_dp_bank_nm))-1 END)) END      
    ,ISNULL(tmpba_dp_bank,'')    
    ,@pa_login_name    
    ,getdate()    
    ,@pa_login_name    
    ,getdate()    
    ,1   ,TMPBA_DP_BR  
    FROM  #tmp_identity    
        , tmp_bank_mstr    
    WHERE --micr  = tmpba_dp_bank
    isnull(micr,'')  = isnull(tmpba_dp_bank,'')
    AND   TMPBA_DP_BR  = BRANCH  
    AND   TMPBA_DP_BANK_NM = NAME
    AND   not exists (select CONVERT(varchar,iSNULL(banm_micr,'')),isnull(banm_rtgs_cd ,'') from #bank_mstr 
								where CONVERT(varchar,iSNULL(banm_micr,'')) = CONVERT(varchar,ISNULL(tmpba_dp_bank,''))
and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')) 
    
   -- AND   ISNUMERIC(tmpba_dp_bank) = 1

  

--insert into bank_addresses_dtls
--select TMPBA_DP_BANK
--,TMPBA_DP_BR
--,TMPBA_DP_BANK_ADD1
--,TMPBA_DP_BANK_ADD2
--,TMPBA_DP_BANK_ADD3
--,TMPBA_DP_BANK_CITY
--,TMPBA_DP_BANK_STATE
--,TMPBA_DP_BANK_CNTRY
--,TMPBA_DP_BANK_ZIP
--,TMPBA_DP_BANK_PH1
--,TMPBA_DP_BANK_PH2
--,TMPBA_DP_BANK_FAX
--,TMPBA_DP_BANK_EMAIL
--,TMPBA_DP_BANK_CONNAME
--,TMPBA_DP_BANK_CONDESG,'MIG',getdate(),'MIG',getdate(),1
--from tmp_bank_mstr 
--where not exists(select  banm_micr, banm_rtgs_cd from bank_mstr
-- where isnull(banm_micr ,'') = isnull(TMPBA_DP_BANK ,'') and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'') )


insert into bank_addresses_dtls
select ISNULL(TMPBA_DP_BANK,'') 
,TMPBA_DP_BR
,TMPBA_DP_BANK_ADD1
,TMPBA_DP_BANK_ADD2
,TMPBA_DP_BANK_ADD3
,TMPBA_DP_BANK_CITY
,TMPBA_DP_BANK_STATE
,TMPBA_DP_BANK_CNTRY
,TMPBA_DP_BANK_ZIP
,TMPBA_DP_BANK_PH1
,TMPBA_DP_BANK_PH2
,TMPBA_DP_BANK_FAX
,TMPBA_DP_BANK_EMAIL
,TMPBA_DP_BANK_CONNAME
,TMPBA_DP_BANK_CONDESG,'MIG',getdate(),'MIG',getdate(),1
from tmp_bank_mstr a
where not exists(select  b.TMPBA_DP_BANK , b.TMPBA_DP_BR from  #bank_addresses_dtls b 
where isnull(a.TMPBA_DP_BANK ,'') = isnull(b.TMPBA_DP_BANK ,'') and isnull(a.TMPBA_DP_BR ,'') = isnull(b.TMPBA_DP_BR,'') )


update a
set 
a.TMPBA_DP_BANK_ADD1    =      b.TMPBA_DP_BANK_ADD1    
,a.TMPBA_DP_BANK_ADD2=		   b.TMPBA_DP_BANK_ADD2
,a.TMPBA_DP_BANK_ADD3=		   b.TMPBA_DP_BANK_ADD3
,a.TMPBA_DP_BANK_CITY=		   b.TMPBA_DP_BANK_CITY
,a.TMPBA_DP_BANK_STATE=		   b.TMPBA_DP_BANK_STATE
,a.TMPBA_DP_BANK_CNTRY=		   b.TMPBA_DP_BANK_CNTRY
,a.TMPBA_DP_BANK_ZIP=			   b.TMPBA_DP_BANK_ZIP
,a.TMPBA_DP_BANK_PH1=			   b.TMPBA_DP_BANK_PH1
,a.TMPBA_DP_BANK_PH2=			   b.TMPBA_DP_BANK_PH2
,a.TMPBA_DP_BANK_FAX=			   b.TMPBA_DP_BANK_FAX
,a.TMPBA_DP_BANK_EMAIL=		   b.TMPBA_DP_BANK_EMAIL
,a.TMPBA_DP_BANK_CONNAME=		   b.TMPBA_DP_BANK_CONNAME
,a.TMPBA_DP_BANK_CONDESG=		   b.TMPBA_DP_BANK_CONDESG
from bank_addresses_dtls a ,tmp_bank_mstr b 
where  isnull(a.TMPBA_DP_BANK,'') = isnull(b.TMPBA_DP_BANK,'')
and isnull(a.TMPBA_DP_BR,'') = isnull(b.TMPBA_DP_BR,'')



  
    --SET    @c_bank_adr =  CURSOR fast_forward FOR      
    --SELECT banm_id    
    --     , tmpba_dp_bank_add1    
    --     , tmpba_dp_bank_add2    
    --     , tmpba_dp_bank_add3    
    --     , tmpba_dp_bank_city    
    --     , tmpba_dp_bank_state    
    --     , tmpba_dp_bank_cntry    
    --     , tmpba_dp_bank_zip    
    --FROM   bank_mstr    
    --     , tmp_bank_mstr     
    --WHERE  banm_micr = tmpba_dp_bank      
    --and   isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')
    --OPEN @c_bank_adr      
    --FETCH NEXT FROM @c_bank_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip     
  
    --WHILE @@fetch_status = 0      
    --BEGIN      
    ----      
  
    --  SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_adr3,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + isnull(@l_cntry,'') + '|*~|' + isnull(@l_zip,'') + '|*~|*|~*'   
  
    --  EXEC pr_ins_upd_addr @l_id, 'EDT', @pa_login_name, @l_id,'', @l_values, 0 ,'*|~*','|*~|',''      
  
    --  FETCH NEXT FROM @c_bank_adr INTO @l_id ,@l_adr1, @l_adr2, @l_adr3, @l_city, @l_state, @l_cntry, @l_zip     
--    ----      
--    --END      
--  
--  
--    --CLOSE      @c_bank_adr      
--    --DEALLOCATE @c_bank_adr      
--    
--    
--    
--		select banm_id into #tempbanm from bank_mstr where banm_deleted_ind = 1 group by banm_id 
--		having count(banm_id)= 1
--
--
--
--
--		select  adr1, adr2, adr3, city , state, country, pin, existsflag into #tmp_addresses from (
--		select distinct TMPBA_DP_BANK_ADD1 adr1 ,TMPBA_DP_BANK_ADD2 adr2 ,TMPBA_DP_BANK_ADD3 adr3 ,TMPBA_DP_BANK_CITY city 
--		,TMPBA_DP_BANK_STATE state
--		,TMPBA_DP_BANK_CNTRY country
--		,TMPBA_DP_BANK_ZIP pin
--		,'N' existsflag from tmp_bank_mstr where isnull(TMPBA_DP_BANK_ADD1,'') <> ''
--		) a 
--
--
--
--		update #tmp_addresses set existsflag = 'Y'
--		from #tmp_addresses , addresses where ltrim(rtrim(ADR_1))=ltrim(rtrim(adr1))
--		and ltrim(rtrim(ADR_2))=ltrim(rtrim(adr2))
--		and ltrim(rtrim(ADR_3))=ltrim(rtrim(adr3))
--		and ltrim(rtrim(ADR_city))=ltrim(rtrim(city))
--		and ltrim(rtrim(ADR_state))=ltrim(rtrim(state))
--		and ltrim(rtrim(ADR_country))=ltrim(rtrim(country))
--		and ltrim(rtrim(ADR_zip))=ltrim(rtrim(pin))
--
--
--
--		select identity(numeric,1,1) id, * into #tmp_addresses1 from #tmp_addresses where existsflag ='N'
--		declare @l_bitlocation numeric
--		select @l_bitlocation  = bitrm_bit_location + 1 from bitmap_ref_mstr  where bitrm_parent_cd ='ADR_conc_ID'
--
--
--		update bitmap_ref_mstr set bitrm_bit_location = @l_bitlocation + (select count(*) from #tmp_addresses1) 
--		where bitrm_parent_cd ='ADR_conc_ID'
--
--		insert into addresses 
--		select @l_bitlocation  + id , adr1,adr2,adr3,city,state,country,pin,'MIG',getdate(),'MIG',getdate(),1 from #tmp_addresses1
--
--
--		declare @l_concm_id numeric,
--		@l_concm_cd varchar(50)
--		select @l_concm_id = concm_id , @l_concm_cd = concm_cd  from conc_code_mstr where concm_cd = 'OFF_ADR1'
--
--
--
--		update  entac set entac_adr_conc_id = adr_id 
--		from bank_mstr 
--		 , tmp_bank_mstr 
--		 , addresses 
--		 , entity_adr_conc entac
--		where entac_ent_id = banm_id 
--		and entac_deleted_ind =1 
--		and ENTAC_CONCM_CD ='OFF_ADR1'
--		and banm_micr= tmpba_dp_bank
--		and banm_rtgs_cd= TMPBA_DP_BR
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD1 )) = ltrim(rtrim(ADR_1)) 
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD2 )) = ltrim(rtrim(ADR_2))
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD3 )) = ltrim(rtrim(ADR_3))
--		and ltrim(rtrim(TMPBA_DP_BANK_CITY )) = ltrim(rtrim(ADR_city))
--		and ltrim(rtrim(TMPBA_DP_BANK_STATE )) = ltrim(rtrim(ADR_state))
--		and ltrim(rtrim(TMPBA_DP_BANK_CNTRY )) = ltrim(rtrim(ADR_country))
--		and ltrim(rtrim(TMPBA_DP_BANK_ZIP))  = ltrim(rtrim(ADR_zip))
--
--
--
--
--		
--
--		insert into entity_adr_conc
--		select distinct banm_id,'',@l_concm_id ,@l_concm_cd, adr_id,'MIG',getdate(),'MIG',getdate(),1  
--		from bank_mstr 
--		 , tmp_bank_mstr 
--		 , addresses 
--		where banm_micr= tmpba_dp_bank
--		and banm_rtgs_cd= TMPBA_DP_BR 
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD1 )) = ltrim(rtrim(ADR_1)) 
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD2 )) = ltrim(rtrim(ADR_2))
--		and ltrim(rtrim(TMPBA_DP_BANK_ADD3 )) = ltrim(rtrim(ADR_3))
--		and ltrim(rtrim(TMPBA_DP_BANK_CITY )) = ltrim(rtrim(ADR_city))
--		and ltrim(rtrim(TMPBA_DP_BANK_STATE )) = ltrim(rtrim(ADR_state))
--		and ltrim(rtrim(TMPBA_DP_BANK_CNTRY )) = ltrim(rtrim(ADR_country))
--		and ltrim(rtrim(TMPBA_DP_BANK_ZIP))  = ltrim(rtrim(ADR_zip))
--		and banm_id in (select banm_id from #tempbanm)
--		and not exists(select entac_ent_id , entac_concm_id 
--				   from entity_adr_conc 
--				   where entac_ent_id = banm_id 
--					and entac_deleted_ind =1 
--					and ENTAC_CONCM_CD ='OFF_ADR1')
--					
--
--
--
--
--  
  
  --  SET    @c_bank_conc =  CURSOR fast_forward FOR      
  --  SELECT banm_id    
  --       , tmpba_dp_bank_ph1    
  --       , tmpba_dp_bank_ph2    
  --       , tmpba_dp_bank_fax    
  --       , tmpba_dp_bank_email    
  --       , tmpba_dp_bank_conname    
  --       , tmpba_dp_bank_condesg    
  --  FROM   bank_mstr    
  --       , tmp_bank_mstr     
  --  WHERE  banm_micr = tmpba_dp_bank      
  --and isnull(banm_rtgs_cd ,'') = isnull(TMPBA_DP_BR,'')
  --  OPEN @c_bank_conc      
  --  FETCH NEXT FROM @c_bank_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg    
  
  --  WHILE @@fetch_status = 0      
  --  BEGIN      
  --  --      
  
  --    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*CONNAME|*~|'   + ISNULL(@l_conname,'') + '|*~|*|~*CONDESG|*~|'  + isnull(@l_condesg,'') + '|*~|*|~*'    
  
  --    EXEC pr_ins_upd_conc @l_id, 'EDT', @pa_login_name, @l_id, '', @l_values, 0 ,'*|~*','|*~|',''      
  
  --    FETCH NEXT FROM @c_bank_conc INTO @l_id ,@l_ph1, @l_ph2, @l_fax, @l_email, @l_conname, @l_condesg    
  --  --      
  --  END      
  
  
  --  CLOSE      @c_bank_conc      
  --  DEALLOCATE @c_bank_conc   
   
    update a set BANM_NAME = TMPBA_DP_BANK_NM 
, banm_branch = TMPBA_DP_BANK_ADD1
from BANK_MSTR a , TMP_BANK_MSTR 
where isnull(BANM_MICR ,'') = isnull(TMPBA_DP_BANK,'')
and tmpba_dp_br = banm_rtgs_cd 
and BANM_NAME <> TMPBA_DP_BANK_NM
and BANM_NAME  = tmpba_dp_br
   
     drop table #bank_mstr
	  drop table #bank_addresses_dtls   
      
--    
END

GO
