-- Object: PROCEDURE citrus_usr.pr_ins_upd_Nommulti_BKP_09082025_SRE_39314
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


  
CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_Nommulti_BKP_09082025_SRE_39314]( @pa_id           VARCHAR(8000)  
                           , @pa_action       VARCHAR(20)  
                           , @pa_login_name   VARCHAR(20)  
                           --, @pa_banm_name    VARCHAR(100) = ''  
                           --, @pa_banm_branch  VARCHAR(100) = ''  
                           --, @pa_banm_micr    VARCHAR(10)  
                           --, @pa_rtgs_cd      VARCHAR(20)  
                           --, @pa_pay_loc_cd   VARCHAR(20)  
                           --, @pa_banm_rmks    VARCHAR(200)  
						    ,@PA_Nom_dpam_id NUMERIC
							,@PA_Nom_DPAM_SBA_NO VARCHAR(100)
							,@PA_nom_srno VARCHAR(10)
							,@PA_nom_fname VARCHAR(100)
							,@PA_nom_mname VARCHAR(30)
							,@PA_nom_tname VARCHAR(30 )
							,@PA_nom_fthname VARCHAR(100)
							,@PA_nom_dob DATETIME
							,@PA_nom_adr1 VARCHAR(50)
							,@PA_nom_adr2 VARCHAR(30)
							,@PA_nom_adr3 VARCHAR(30)
							,@PA_nom_city VARCHAR(30)
							,@PA_nom_state VARCHAR(30)
							,@PA_nom_country VARCHAR(30)
							,@PA_nom_zip VARCHAR(30)
							,@PA_nom_phone1_ind VARCHAR(100)
							,@PA_nom_phone1 VARCHAR(100)
							,@PA_nom_phone2_ind VARCHAR(100)
							,@PA_nom_phone2 VARCHAR(100)
							,@PA_nom_Addphone  VARCHAR(100)
							,@PA_nom_fax VARCHAR(100)
							,@PA_nom_pan VARCHAR(100)
							,@PA_nom_Uid VARCHAR(100)
							,@PA_nom_email VARCHAR(100)
							,@PA_nom_relation VARCHAR(100)
							,@PA_nom_percentage VARCHAR(100)
							,@PA_nom_res_sec_flag VARCHAR(100)
                           , @pa_chk_yn       INT  
                           , @pa_adr_flg      INT  
                           , @pa_adr_values   VARCHAR(8000)  
                           , @pa_conc_flg     INT  
                           , @pa_conc_values  VARCHAR(8000)  
                           , @rowdelimiter    CHAR(4)       = '*|~*'  
                           , @coldelimiter    CHAR(4)       = '|*~|'  
                           , @pa_errmsg       VARCHAR(8000) OUTPUT  
)  
AS  
/*  
*********************************************************************************  
 SYSTEM         : class  
 MODULE NAME    : pr_mak_banm  
 DESCRIPTION    : this procedure will contain the maker checker facility for bank master  
 COPYRIGHT(C)   : enc software solutions pvt. ltd.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE         REASON  
 -----  -------------     ----------   -------------------------------------------------  
 1.0    HARI              18-11-2006   INITIAL VERSION.  
 2.0    SUKHVINDER/TUSHAR 15-12-2006   INITIAL VERSION.  
 3.0    TUSHAR            27-04-2007   INITIAL VERSION.  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
--  
  SET NOCOUNT ON  
  --  
  DECLARE @@t_errorstr       VARCHAR(8000)  
        , @l_bmbanm_id       BIGINT  
        , @l_nom_id         BIGINT  
        , @@l_error          BIGINT  
        , @delimeter         VARCHAR(10)  
        , @@remainingstring  VARCHAR(8000)  
        , @@currstring       VARCHAR(8000)  
        , @@foundat          INTEGER  
        , @@delimeterlength  INT  
        , @l_action          VARCHAR(10)  
		, @@PA_DPAM_ID		 int
  --  
  set @@PA_DPAM_ID = 0
  SELECT @@PA_DPAM_ID = DPAM_ID  FROM DP_ACCT_MSTR_mak WHERE DPAM_CRN_NO = @PA_Nom_dpam_id --AND DPAM_DELETED_IND = '1' --AND DPAM_STAM_CD = 'ACTIVE'
	if @@PA_DPAM_ID = 0
	begin 
		print 'pp'
	SELECT @@PA_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR WHERE DPAM_CRN_NO = @PA_Nom_dpam_id --AND DPAM_DELETED_IND = '1' --AND DPAM_STAM_CD = 'ACTIVE'
	end
  SET @@l_error         = 0  
  SET @@t_errorstr      = ''  
  --  
  SET @delimeter        = '%'+ @rowdelimiter + '%'  
  SET @@delimeterlength = len(@rowdelimiter)  
  --  
  SET @@remainingstring = @pa_id  
  --  
  WHILE @@remainingstring <> ''  
  BEGIN  
  --  
    SET @@foundat = 0  
    SET @@foundat =  patindex('%'+@delimeter+'%',@@remainingstring)  
    --  
    IF @@foundat > 0  
    BEGIN  
    --  
      SET @@currstring      = substring(@@remainingstring, 0,@@foundat)  
      SET @@remainingstring = substring(@@remainingstring, @@foundat+@@delimeterlength,len(@@remainingstring)- @@foundat+@@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @@currstring      = @@remainingstring  
      SET @@remainingstring = ''  
    --  
    END  
   --  
   IF @@currstring <> ''  
   BEGIN  
     --  
     IF @pa_action = 'INS'  
     BEGIN  
       --  
       IF @pa_chk_yn = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         SELECT @l_nom_id      = bitrm_bit_location  
         FROM   bitmap_ref_mstr WITH(NOLOCK)  
         WHERE  bitrm_parent_cd = 'NOM_ID'  
         AND    bitrm_child_cd  = 'NOM_ID'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+1  
         WHERE  bitrm_parent_cd    = 'NOM_ID'  
         AND    bitrm_child_cd     = 'NOM_ID'  
         --  
         INSERT INTO Nominee_Multi  
         (nom_id
		,Nom_dpam_id
		,Nom_DPAM_SBA_NO
		,nom_srno
		,nom_fname
		,nom_mname
		,nom_tname
		,nom_fthname
		,nom_dob
		,nom_adr1
		,nom_adr2
		,nom_adr3
		,nom_city
		,nom_state
		,nom_country
		,nom_zip
		,nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
		,nom_fax
		,nom_pan
		,nom_Uid
		,nom_email
		,nom_relation
		,nom_percentage
		,nom_res_sec_flag
		,NOm_CREATED_BY
		,NOm_CREATED_DT
		,NOm_LST_UPD_BY
		,Nom_LST_UPD_DT
		,Nom_DELETED_IND
        )  
         VALUES  
         (@l_nom_id  
       		,@@PA_DPAM_ID
		,@pa_Nom_DPAM_SBA_NO
		,@pa_nom_srno
		,@pa_nom_fname
		,@pa_nom_mname
		,@pa_nom_tname
		,@pa_nom_fthname
		,@pa_nom_dob
		,@pa_nom_adr1
		,@pa_nom_adr2
		,@pa_nom_adr3
		,@pa_nom_city
		,@pa_nom_state
		,@pa_nom_country
		,@pa_nom_zip
		,@pa_nom_phone1_ind
		,@pa_nom_phone1
		,@pa_nom_phone2_ind
		,@pa_nom_phone2
		,@pa_nom_Addphone
		,@pa_nom_fax
		,@pa_nom_pan
		,@pa_nom_Uid
		,@pa_nom_email
		,@pa_nom_relation
		,@pa_nom_percentage
		,@pa_nom_res_sec_flag
         ,@pa_login_name  
         ,getdate()  
         ,@pa_login_name  
         ,getdate()  
         ,1  
         )  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @@t_errorstr= convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
       --  
       END  
       --  
       IF @pa_chk_yn IN  (1,2) -- IF MAKER IS INSERTING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --  
		 if exists (select 1 from Nominee_Multi where nom_id = @pa_id ) 
		 begin 

		 SELECT @l_nom_id       = @pa_id

		 end 
		 else 
		 begin 

		 SELECT @l_nom_id       = bitrm_bit_location  
         FROM   bitmap_ref_mstr  with(nolock)  
         WHERE  bitrm_parent_cd  = 'NOM_ID'  
         AND    bitrm_child_cd   = 'NOM_ID'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+1  
         WHERE  bitrm_parent_cd    = 'NOM_ID'  
         AND    bitrm_child_cd     = 'NOM_ID'

		 end 
		  if exists (select 1 from Nominee_Multi_mak where nom_id = @pa_id and Nom_DELETED_IND in (0,4,8)) 
		 begin 

		update Nominee_Multi_mak  set Nom_DELETED_IND = 2 where nom_id = @pa_id 

		 end 

           PRINT 'PANKAJ'
         --  
		 --if exists (select 1 from Nominee_Multi_mak where nom_srno = @pa_nom_srno and Nom_dpam_id = @@PA_DPAM_ID and Nom_DELETED_IND = 0 ) 
		 --begin 
		 --		 SELECT @pa_action  = 'edt'
		 --end 

         INSERT INTO Nominee_Multi_mak 
         (nom_id
		,Nom_dpam_id
		,Nom_DPAM_SBA_NO
		,nom_srno
		,nom_fname
		,nom_mname
		,nom_tname
		,nom_fthname
		,nom_dob
		,nom_adr1
		,nom_adr2
		,nom_adr3
		,nom_city
		,nom_state
		,nom_country
		,nom_zip
		,nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
		,nom_fax
		,nom_pan
		,nom_Uid
		,nom_email
		,nom_relation
		,nom_percentage
		,nom_res_sec_flag
		,NOm_CREATED_BY
		,NOm_CREATED_DT
		,NOm_LST_UPD_BY
		,Nom_LST_UPD_DT
		,Nom_DELETED_IND
        )  
         VALUES  
         (@l_nom_id  
       		,@@PA_DPAM_ID
		,@pa_Nom_DPAM_SBA_NO
		,@pa_nom_srno
		,@pa_nom_fname
		,@pa_nom_mname
		,@pa_nom_tname
		,@pa_nom_fthname
		,@pa_nom_dob
		,@pa_nom_adr1
		,@pa_nom_adr2
		,@pa_nom_adr3
		,@pa_nom_city
		,@pa_nom_state
		,@pa_nom_country
		,@pa_nom_zip
		,@pa_nom_phone1_ind
		,@pa_nom_phone1
		,@pa_nom_phone2_ind
		,@pa_nom_phone2
		,@pa_nom_Addphone
		,@pa_nom_fax
		,@pa_nom_pan
		,@pa_nom_Uid
		,@pa_nom_email
		,@pa_nom_relation
		,@pa_nom_percentage
		,@pa_nom_res_sec_flag
         ,@pa_login_name  
         ,getdate()  
         ,@pa_login_name  
         ,getdate()  
         , 0
         )  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @@t_errorstr=convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
        --  
       END  
     --  
    END  --ACTION TYPE = INS ENDS HERE  
    --  
    IF @pa_action = 'APP'  
    BEGIN  
    
    print '111'
     --  
     IF EXISTS(SELECT nom_id  
               FROM   Nominee_Multi_mak WITH (NOLOCK)  
               WHERE  nom_id   = CONVERT(INT, @@CURRSTRING) and nom_deleted_ind = 8 )  
     BEGIN  
     --  
       BEGIN TRANSACTION  
       --  
       UPDATE nom WITH (ROWLOCK)  
       SET   nom.nom_fname= nomm.nom_fname
			,nom.nom_mname=nomm.nom_mname
			,nom.nom_tname=nomm.nom_tname
			,nom.nom_fthname=nomm.nom_fthname
			,nom.nom_dob=nomm.nom_dob
			,nom.nom_adr1=nomm.nom_adr1
			,nom.nom_adr2=nomm.nom_adr2
			,nom.nom_adr3=nomm.nom_adr3
			,nom.nom_city=nomm.nom_city
			,nom.nom_state=nomm.nom_state
			,nom.nom_country=nomm.nom_country
			,nom.nom_zip=nomm.nom_zip
			,nom.nom_phone1_ind=nomm.nom_phone1_ind
			,nom.nom_phone1=nomm.nom_phone1
			,nom.nom_phone2_ind=nomm.nom_phone2_ind
			,nom.nom_phone2=nomm.nom_phone2
			,nom.nom_Addphone=nomm.nom_Addphone
			,nom.nom_fax=nomm.nom_fax
			,nom.nom_pan=nomm.nom_pan
			,nom.nom_Uid=nomm.nom_Uid
			,nom.nom_email=nomm.nom_email
			,nom.nom_relation=nomm.nom_relation
			,nom.nom_percentage=nomm.nom_percentage
			,nom.nom_res_sec_flag = nomm.nom_res_sec_flag
            , nom.nom_lst_upd_by     = @pa_login_name  
            , nom.nom_lst_upd_dt     = getdate()  
            , nom.nom_deleted_ind    = 1  
       FROM   Nominee_Multi                  nom
            , Nominee_Multi_mak              nomm
       WHERE  nom.nom_id = convert(int,@@currstring)  
       AND    nom.nom_id = nomm.nom_id 
       AND    nom.nom_deleted_ind    = 1  
       AND    nomm.nom_deleted_ind   = 8  
       AND    nomm.nom_created_by   <> @pa_login_name  
       --  
       SET @@l_error = @@error  
       --  
       IF @@l_error  > 0  
       BEGIN  
       --  
         SELECT @@t_errorstr     = convert(varchar,@@l_error)+@rowdelimiter  
         
         --  
         ROLLBACK TRANSACTION  
       --  
       END  
       --  
       ELSE  
       BEGIN  
       --  
         UPDATE Nominee_Multi_mak     WITH (ROWLOCK)  
         SET    nom_deleted_ind  = 9  
              , nom_lst_upd_by   = @pa_login_name  
              , nom_lst_upd_dt   = GETDATE()  
         WHERE  nom_id           = CONVERT(INT,@@currstring)  
         AND    nom_created_by  <> @pa_login_name  
         AND    nom_deleted_ind  = 8  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SELECT @@t_errorstr     = convert(varchar,@@l_error)+@rowdelimiter  
           
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
       --  
       END  
      --  
      END  
      ELSE   if  EXISTS(SELECT nom_id  
               FROM   Nominee_Multi_mak WITH (NOLOCK)  
               WHERE  nom_id   = CONVERT(INT, @@CURRSTRING) and nom_deleted_ind = 0 )  
      BEGIN  
      --  
      
        BEGIN TRANSACTION  
        --  
        INSERT INTO Nominee_Multi  
        (nom_id
,Nom_dpam_id
,Nom_DPAM_SBA_NO
,nom_srno
,nom_fname
,nom_mname
,nom_tname
,nom_fthname
,nom_dob
,nom_adr1
,nom_adr2
,nom_adr3
,nom_city
,nom_state
,nom_country
,nom_zip
,nom_phone1_ind
,nom_phone1
,nom_phone2_ind
,nom_phone2
,nom_Addphone
,nom_fax
,nom_pan
,nom_Uid
,nom_email
,nom_relation
,nom_percentage
,nom_res_sec_flag
,NOm_CREATED_BY
,NOm_CREATED_DT
,NOm_LST_UPD_BY
,Nom_LST_UPD_DT
,Nom_DELETED_IND 
        )  
        SELECT nom_id
,Nom_dpam_id
,Nom_DPAM_SBA_NO
,nom_srno
,nom_fname
,nom_mname
,nom_tname
,nom_fthname
,nom_dob
,nom_adr1
,nom_adr2
,nom_adr3
,nom_city
,nom_state
,nom_country
,nom_zip
,nom_phone1_ind
,nom_phone1
,nom_phone2_ind
,nom_phone2
,nom_Addphone
,nom_fax
,nom_pan
,nom_Uid
,nom_email
,nom_relation
,nom_percentage
,nom_res_sec_flag
,NOm_CREATED_BY
,NOm_CREATED_DT
             , @pa_login_name  
             , getdate()  
             , 1  
        FROM   Nominee_Multi_mak           nomm WITH (NOLOCK)  
        WHERE  nomm.nom_id           = CONVERT(numeric,@@currstring)  
        AND    nomm.nom_created_by  <> @pa_login_name  
        AND    nomm.nom_deleted_ind  = 0  
        --  
        
        SET @@l_error = convert(int, @@error)  
        --  
        IF @@l_error  > 0  
        BEGIN  
          --  
          SELECT @@t_errorstr     = convert(varchar,@@l_error)+@rowdelimiter  
          
          --  
          ROLLBACK TRANSACTION  
          --  
        END  
        ELSE  
        BEGIN  
        --  
           UPDATE Nominee_Multi_mak     WITH (ROWLOCK)  
         SET    nom_deleted_ind  = 1  
              , nom_lst_upd_by   = @pa_login_name  
              , nom_lst_upd_dt   = GETDATE()  
         WHERE  nom_id           = CONVERT(INT,@@currstring)  
         AND    nom_created_by  <> @pa_login_name  
         AND    nom_deleted_ind  = 0 
  
          SET @@l_error = @@error  
          --  
           IF  @@l_error > 0  
           BEGIN   
           --  
             SELECT @@t_errorstr    =convert(varchar,@@l_error)+@rowdelimiter  
             
             --  
             ROLLBACK TRANSACTION  
           --  
           END  
           ELSE  
           BEGIN  
           --  
             
             COMMIT TRANSACTION   
               
             SELECT @@t_errorstr     = convert(varchar,@@l_error)+@rowdelimiter  
                             
           --  
           END  
        --  
        END  
       --  
       END  
      --  
      END  
     --  
     IF @pa_action ='rej'  
     BEGIN  
       --  
       IF @pa_chk_yn = 1 -- IF CHECKER IS REJECTING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --  
         UPDATE Nominee_Multi_mak     WITH (ROWLOCK)  
         SET    nom_deleted_ind  = 3  
              , nom_lst_upd_by   = @pa_login_name  
              , nom_lst_upd_dt   = GETDATE()  
         WHERE  nom_id           = CONVERT(INT,@@currstring)  
         AND    nom_created_by  <> @pa_login_name  
         AND    nom_deleted_ind  = 0 
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error > 0  
         BEGIN  
         --  
           SELECT @@t_errorstr =convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
         --  
       END  
     --  
     END  
     --  
    
     IF @pa_action = 'EDT'  
     BEGIN  
       --  
       PRINT 'EDIT'
       SET @l_nom_id=@@currstring  
       --  
       IF @pa_chk_yn = 0 -- IF NO MAKER CHECKER  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
       UPDATE nom WITH (ROWLOCK)  
       SET   nom.nom_fname=@PA_nom_fname 
			,nom.nom_mname=@pa_nom_mname
			,nom.nom_tname=@pa_nom_tname
			,nom.nom_fthname=@pa_nom_fthname
			,nom.nom_dob=@pa_nom_dob
			,nom.nom_adr1=@pa_nom_adr1
			,nom.nom_adr2=@pa_nom_adr2
			,nom.nom_adr3=@pa_nom_adr3
			,nom.nom_city=@pa_nom_city
			,nom.nom_state=@pa_nom_state
			,nom.nom_country=@pa_nom_country
			,nom.nom_zip=@pa_nom_zip
			,nom.nom_phone1_ind=@pa_nom_phone1_ind
			,nom.nom_phone1=@pa_nom_phone1
			,nom.nom_phone2_ind=@pa_nom_phone2_ind
			,nom.nom_phone2=@pa_nom_phone2
			,nom.nom_Addphone=@pa_nom_Addphone
			,nom.nom_fax=@pa_nom_fax
			,nom.nom_pan=@pa_nom_pan
			,nom.nom_Uid=@pa_nom_Uid
			,nom.nom_email=@pa_nom_email
			,nom.nom_relation=@pa_nom_relation
			,nom.nom_percentage=@pa_nom_percentage
			,nom.nom_res_sec_flag = @pa_nom_res_sec_flag
            , nom.nom_lst_upd_by     = @pa_login_name  
            , nom.nom_lst_upd_dt     = getdate()  
            , nom.nom_deleted_ind    = 1  
       FROM   Nominee_Multi                  nom
       WHERE  nom.nom_id = convert(int,@@currstring)  
             AND    nom.nom_deleted_ind    = 1  
     
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error > 0  
         BEGIN  
           --  
           SET @@t_errorstr = convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
           --  
         END  
         ELSE  
         BEGIN  
           --  
           COMMIT TRANSACTION  
           --  
         END  
         --  
       END  
	    IF @pa_chk_yn in( 1,2) -- IF MAKER IS INSERTING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --  
		 print 'fdfdfd'
		 declare  @l_ind numeric
		 set @l_ind = 0 
		 if exists (select 1 from Nominee_Multi where nom_id = @pa_id ) 
		 begin 
		 set @l_ind = 8 
		 SELECT @l_nom_id       = @pa_id

		 end 
		 else 
		 begin 

		 SELECT @l_nom_id       = bitrm_bit_location  
         FROM   bitmap_ref_mstr  with(nolock)  
         WHERE  bitrm_parent_cd  = 'NOM_ID'  
         AND    bitrm_child_cd   = 'NOM_ID'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+1  
         WHERE  bitrm_parent_cd    = 'NOM_ID'  
         AND    bitrm_child_cd     = 'NOM_ID'

		 end 
		  if exists (select 1 from Nominee_Multi_mak where nom_id = @pa_id and Nom_DELETED_IND in (0,4,8)) 
		 begin 

		update Nominee_Multi_mak  set Nom_DELETED_IND = 2 where nom_id = @pa_id 

		 end 

           PRINT 'PANKAJ'
         --  
		 --if exists (select 1 from Nominee_Multi_mak where nom_srno = @pa_nom_srno and Nom_dpam_id = @@PA_DPAM_ID and Nom_DELETED_IND = 0 ) 
		 --begin 
		 --		 SELECT @pa_action  = 'edt'
		 --end 
print '121212'
PRINT @l_nom_id
         INSERT INTO Nominee_Multi_mak 
         (nom_id
		,Nom_dpam_id
		,Nom_DPAM_SBA_NO
		,nom_srno
		,nom_fname
		,nom_mname
		,nom_tname
		,nom_fthname
		,nom_dob
		,nom_adr1
		,nom_adr2
		,nom_adr3
		,nom_city
		,nom_state
		,nom_country
		,nom_zip
		,nom_phone1_ind
		,nom_phone1
		,nom_phone2_ind
		,nom_phone2
		,nom_Addphone
		,nom_fax
		,nom_pan
		,nom_Uid
		,nom_email
		,nom_relation
		,nom_percentage
		,nom_res_sec_flag
		,NOm_CREATED_BY
		,NOm_CREATED_DT
		,NOm_LST_UPD_BY
		,Nom_LST_UPD_DT
		,Nom_DELETED_IND
        )  
         VALUES  
         (@l_nom_id  
       		,@@PA_DPAM_ID
		,@pa_Nom_DPAM_SBA_NO
		,@pa_nom_srno
		,@pa_nom_fname
		,@pa_nom_mname
		,@pa_nom_tname
		,@pa_nom_fthname
		,@pa_nom_dob
		,@pa_nom_adr1
		,@pa_nom_adr2
		,@pa_nom_adr3
		,@pa_nom_city
		,@pa_nom_state
		,@pa_nom_country
		,@pa_nom_zip
		,@pa_nom_phone1_ind
		,@pa_nom_phone1
		,@pa_nom_phone2_ind
		,@pa_nom_phone2
		,@pa_nom_Addphone
		,@pa_nom_fax
		,@pa_nom_pan
		,@pa_nom_Uid
		,@pa_nom_email
		,@pa_nom_relation
		,@pa_nom_percentage
		,@pa_nom_res_sec_flag
         ,@pa_login_name  
         ,getdate()  
         ,@pa_login_name  
         ,getdate()  
         ,@l_ind
         )  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @@t_errorstr=convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           COMMIT TRANSACTION  
         --  
         END  
        --  
       END  

       --  
        
       --  
       END  
      --  
     END  --ACTION TYPE = EDT ENDS HERE  
    --  
   END  
  
   
 --  
 SET @pa_errmsg = @@t_errorstr  
 --  
END

GO
