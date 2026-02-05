-- Object: PROCEDURE citrus_usr.PR_TRATM_INS27
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*  EXECUTE PR_TRATM_INS27
     select * from transaction_type_mstr
     select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_mstr
      DELETE FROM  transaction_type_mstr
      sp_help transaction_type_mstr8 */
      
             
         create   PROCEDURE [citrus_usr].[PR_TRATM_INS27]
	      AS
		BEGIN
		--
		  DECLARE
		   @l_excm_id    NUMERIC(30)
		  ,@l_desc   VARCHAR(100)
		  ,@l_name VARCHAR(30)
		  ,@l_trantm_id  NUMERIC(30)
		  ,@l_code  VARCHAR(50)
		  ,@I  SMALLINT
		  ,@l_trastm_id NUMERIC(30)
		  ,@l_trastm_tratm_id NUMERIC(30)
		  ,@l_sub_desc   VARCHAR(100)
		  ,@l_sub_cd  VARCHAR(50) 
		   SET  @I =1
		   SET @l_name ='HO'
		   SET @l_code='ALL_REJ_CD_NSDL'
		   SET  @l_desc ='REJECTION CODE NSDL'
		   SELECT @l_excm_id =excm_id FROM exchange_mstr where excm_cd='NSDL'
		   DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='ALL_REJ_CD_NSDL')
		   DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'ALL_REJ_CD_NSDL'
		   SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr

		INSERT INTO transaction_type_mstr
		(trantm_id
		,trantm_excm_id
		,trantm_code
		,trantm_desc
		,trantm_created_dt
		,trantm_created_by
		,trantm_lst_upd_dt
		,trantm_lst_upd_by
		,trantm_deleted_ind
		) 
		VALUES  
		(@l_trantm_id 
		,@l_excm_id 
		,@l_code 
		,@l_desc  
		,GETDATE()
		,@l_name
		,GETDATE()
		,@l_name
		,1
		) 
	

		   	            
	       IF @I = 1
	       BEGIN
	       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
               SET @l_sub_cd    = '3'
	       SET @l_sub_desc  = 'INVALID CLIENT STATUS'

		INSERT INTO transaction_sub_type_mstr
	       (trastm_id
	       ,trastm_excm_id
	       ,trastm_tratm_id
	       ,trastm_cd
	       ,trastm_desc
	       ,trastm_created_dt
	       ,trastm_created_by
	       ,trastm_lst_upd_dt
	       ,trastm_lst_upd_by
	       ,trastm_deleted_ind
	       )
	      VALUES
	      (@l_trastm_id
	      ,@l_excm_id 
	      ,@l_trastm_tratm_id
	      ,@l_sub_cd  
	      ,@l_sub_desc
	      ,GETDATE()
	      ,@l_name
	      ,GETDATE()
	      ,@l_name
	      ,1
	      )
	      END
	           
		                            
		   		 
		 IF  @I = 1
	         BEGIN
		   --
		SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		SET @l_sub_cd     = '4'
		SET @l_sub_desc   = 'INVALID SECURITY STATUS'
		INSERT INTO transaction_sub_type_mstr
	      ( trastm_id
	       ,trastm_excm_id
	       ,trastm_tratm_id
	       ,trastm_cd
	       ,trastm_desc
	       ,trastm_created_dt
	       ,trastm_created_by
	       ,trastm_lst_upd_dt
	       ,trastm_lst_upd_by
	       ,trastm_deleted_ind
	       )
	      VALUES
	      (@l_trastm_id
	      ,@l_excm_id 
	      ,@l_trastm_tratm_id
	      ,@l_sub_cd  
	      ,@l_sub_desc
	      ,GETDATE()
	      ,@l_name
	      ,GETDATE()
	      ,@l_name
	      ,1
	      )

	      --     
	      END
		   		    
		    
		    
	         IF @I = 1
	         BEGIN
	         --
		   SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		   SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		   SET @l_sub_cd   = '5'
		   SET @l_sub_desc = 'CANNOT VERIFY/RELEASE IN THIS STATUS'
		   INSERT INTO transaction_sub_type_mstr
		   ( trastm_id
		    ,trastm_excm_id
		    ,trastm_tratm_id
		    ,trastm_cd
		    ,trastm_desc
		    ,trastm_created_dt
		    ,trastm_created_by
		    ,trastm_lst_upd_dt
		    ,trastm_lst_upd_by
		    ,trastm_deleted_ind
		    )
		    VALUES
		    (@l_trastm_id
		    ,@l_excm_id 
		    ,@l_trastm_tratm_id
		    ,@l_sub_cd  
		    ,@l_sub_desc
		    ,GETDATE()
		    ,@l_name
		    ,GETDATE()
		    ,@l_name
		     ,1
		     )
		        
                    END 
		    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '6'
		        SET @l_sub_desc  = 'CANNOT CANCEL IN THIS STATUS'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
                       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '7'
			SET @l_sub_desc  = 'INSUFFICIENT POSITIONS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
			
		    END
                    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '8'
		        SET @l_sub_desc  = 'COULD NOT PROCESS IN TIME' 
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '9'
			SET @l_sub_desc  = 'BUSINESS DATE NOT IN BETWEEN SETTLEMENT START DATE & NSDL DATE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
                      --      
		    END
		   
		    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
                        SET @l_sub_cd     = '10'
			SET @l_sub_desc  = 'INVALID OTHER CM BP STATUS ' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
                      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '11'
			SET @l_sub_desc  = 'DP IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --
		    END
                    IF  @I = 1
		    BEGIN
		      --
		        
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd     = '12'
		        SET @l_sub_desc  = 'NSDL DEADLINE VALIDATION FAILED AT EOD'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
                     --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '13'
			SET @l_sub_desc  = 'SOURCE AND TARGET CM’S CANNOT BE SAME'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END
                    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd     = '3001'
		        SET @l_sub_desc  = 'SNDR NOT AUTHORIZED TO GIVE ORDER FOR ORDER ISSUER'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		     --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        
	                SET @l_sub_cd    = '3002'
			SET @l_sub_desc  = 'BATCH NUMBER MUST EXIST'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END
                    IF @I = 1           
                    BEGIN
		      --
		       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		       SET @l_sub_cd    = '3003'
		       SET @l_sub_desc  = 'DP IS NOT IN VALID STATUS'
		       INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd   =  '3004'
			SET @l_sub_desc  = 'SENDER IS NOT A DEPOSITORY PARTICIPANT' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
                    END
                    IF @I = 1            
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '3005'
		        SET @l_sub_desc  = 'BUSINESS TYPE NOT COMPATIBLE WITH SETTLEMENT TYPE'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --
		    END  
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3006'
			SET @l_sub_desc  = 'SHARE REGISTRAR NOT FOUND' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
                    END
                    IF @I = 1
                    BEGIN
		     --
		       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		       SET @l_sub_cd     = '3007'
		       SET @l_sub_desc  = 'SAFE CUSTODY ACCOUNT IS NOT IN VALID STATUS'
		       INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		     --
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3008'
			SET @l_sub_desc  = 'SECURITY QTY MUST BE SPECIFIED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
	              --
	               SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '3009'
			SET @l_sub_desc  = 'ORDER FOR THE ORDER ISSUER DUPLICATED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
                      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3010'
			SET @l_sub_desc  = 'ISSUER REFERENCE IS MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3011'
			SET @l_sub_desc  = 'SETTLEMENT TYPE IS MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
			  --		    
		    END    
		    IF @I = 23
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3012'
			SET @l_sub_desc  = 'INVALID SETTLEMENT TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3013'
			SET @l_sub_desc  = 'REASON CD SHOULD NOT BE SPECIFIED FOR DMAT ORDERS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
			  --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3014'
			SET @l_sub_desc  = 'INVALID REASON CODE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3015'
			SET @l_sub_desc  = 'INVALID OWNER OR CLIENT INDICATOR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3016'
			SET @l_sub_desc  = 'NO.OF CMS RECD FOR AN ISIN ARE NOT SAME AS IN DEL'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3019'
			SET @l_sub_desc   = 'ISIN MUST EXIST'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3023'
			SET @l_sub_desc  = 'INVALID TARGET ACCOUNT TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3024'
			SET @l_sub_desc  = 'INVALID SOURCE ACCOUNT TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
	              --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3030'
			SET @l_sub_desc  = 'BP IS NOT DEFINED AS A CLEARING MEMBER IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3031'
			SET @l_sub_desc  = 'BP IS NOT DEFINED AS A DP IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		       --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3032'
			SET @l_sub_desc    = 'CLEARING CORPORATION IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3033'
		        SET @l_sub_desc    = 'SOURCE AND TARGET ACCOUNTS SHOULD BE DIFFERENT'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		    
		      --		    
		    END    
	            IF @I = 1
	            BEGIN
	              --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3035'
		        SET @l_sub_desc    = 'RCPT IN STMT SHOULD CORRESPOND TO DLVY OUT STMT'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		       
	              --      
                    END 
                    IF @I = 1
	            BEGIN
	              --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3036'
		        SET @l_sub_desc    = 'DLVY-OUT AND RCPT-IN SETTLEMENT NO.MISMATCH'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		       
	              --      
	            END 
		    IF @I = 1
                    BEGIN
	              --		
	                SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
	                SET  @l_sub_cd     = '3037'
	                SET @l_sub_desc    = 'DELIVERY OUT CONFIRMATION NOT SETTLED'
	                INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
	              
	              --		    
		    END    
	            IF @I = 1
	            BEGIN
	              --
	                SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
	                SET  @l_sub_cd     = '3038'
	                SET @l_sub_desc    = 'TOTAL QTY FOR ISIN AND IN DLVY STMT SHOULD MATCH'
	                INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
	               
	             --      
                    END 
                    IF @I = 1
	            BEGIN
	              --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3039'
		        SET @l_sub_desc   = 'SUM OF QTY FOR ALL CMS SHOULD EQUAL TOTAL QTY'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		        
	              --		    
	            END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3040'
		        SET @l_sub_desc    = 'CM ACCOUNT NOT OPENED WITH DP'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		       
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3042'
		        SET @l_sub_desc    = 'INVALID CLEARING CORPORATION ID'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
                      )
		       
		       
		   END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd   = '3043'
		        SET @l_sub_desc  = 'INVALID ISIN'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		     
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3045'
		        SET @l_sub_desc   = 'ISIN NOT IN VALID STATUS'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		        
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3047'
		        SET @l_sub_desc   = 'BP ROLE IS IN DELETED STATUS IN NSDS'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3048'
		        SET @l_sub_desc   = 'INVALID MARKET TYPE'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd     = '3049'
		        SET @l_sub_desc   = 'CLOSURE/EXEC. DATE GREATER THAN ISIN MATURITY DATE'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3050'
		        SET @l_sub_desc    = 'ORDER FOR THE ORDER ISSUER DOES NOT EXIST'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		       
		      --      
		    END 
		    IF @I =1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3051'
		        SET @l_sub_desc  = 'CM DOES NOT EXIST FOR GIVEN CC,CC-CM-ID AND DP-ID'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		     
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3053'
		        SET @l_sub_desc  = 'ORDER DOES NOT EXIST FOR THE ORDER#, ISSUER COMBINATION'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		        
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd   = '3060'
		        SET @l_sub_desc  = 'TARGET ACCOUNT TYPE IS MANDATORY'
		        INSERT INTO transaction_sub_type_mstr
		        (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd    = '3068'
		        SET @l_sub_desc   = 'Invalid Market type'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      
		      --      
                    END 
                    
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3070'
			SET @l_sub_desc  = 'INVALID CC SETTLEMENT CYCLE NUMBER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
			
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3073'
			SET @l_sub_desc   = 'BP IS NOT DEFINED AS A CC IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3074'
			SET @l_sub_desc    = 'CLEARING MEMBER IS NOT DEFINED IN DM'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3076'
			SET @l_sub_desc  = 'INVALID ORDER STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
                    END 
                    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3077'
			SET @l_sub_desc   = 'INVALID CONFIRMED OR REJECTED QUANTITY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
			END 
		    IF @I = 1
	            BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3078'
			SET @l_sub_desc   = 'INVALID LOCKED IN DATE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3079'
			SET @l_sub_desc  = 'INVALID SENDER ID'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3080'
			SET @l_sub_desc    = 'SENDER MUST BE A SHARE REGISTRAR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3081'
			SET @l_sub_desc    = 'CC CALENDAR NOT DEFINED FOR GIVEN CC, MARKET TYPE, SETTLEMENT NUMBER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3082'
			SET @l_sub_desc   = 'SETTLEMENT DATE MUST BE BETWEEN PRD START DATE & NSDL DEADLINE DATE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3083'
			SET @l_sub_desc   = 'ORDER STATUS IS NOT VALID'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3084'
			SET @l_sub_desc   = 'IRREVERSIBLE DELIVERY OUT ORDER CANNOT BE CANCELLED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3085'
			SET @l_sub_desc  = 'INVALID SENDER ID FOR SUB MSG TYPE: 301'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3086'
			SET @l_sub_desc   = 'BP IS NOT DEFINED AS A CLEARING CORPORATION IN NSD'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3092'
			SET @l_sub_desc    = 'INVALID CM FOR CC-CM COMBINATION'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3095'
			SET @l_sub_desc   = 'TARGET DEPOSITORY ID IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3096'
			SET @l_sub_desc   = 'TARGET DEPOSITORY ID DOES NOT EXIST'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3097'
			SET @l_sub_desc    = 'NO DLVY OUT STMT HDR EXISTS FOR CORR.REL.REF.NO'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3098'
			SET @l_sub_desc    = 'NO DELIVERY OUT STMT SENT TO CC'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
	            IF @I = 1
	            BEGIN
	              --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET  @l_sub_cd     = '3102'
		        SET @l_sub_desc    = 'BOOKING REJECTED – LACK OF POSITIONS'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      

	              --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3103'
			SET @l_sub_desc    = 'SOURCE ACCOUNT IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3104'
			SET @l_sub_desc    = 'TARGET ACCOUNT IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3105'
			SET @l_sub_desc    = 'LOCKED-IN DATE CANNOT BE GIVEN FOR DEMAT ORDERS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3106'
			SET @l_sub_desc   = 'BOOKING REJECTION - ACCOUNT IS DELETED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I =1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3107'
			SET @l_sub_desc    = 'BOOKING REJECTION - INVALID SECURITY STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3108'
			SET @l_sub_desc    = 'BOOKING REJECTION - ACCOUNT IS SUSPENDED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3109'
			SET @l_sub_desc  = 'BOOKING REJECTION - POSITION IS SUSPENDED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3110'
			SET @l_sub_desc  = 'BOOKING REJECTION - SECURITY IS SUSPENDED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3111'
			SET @l_sub_desc   = 'LOCKED-IN DATE CANNOT BE AN EARLIER DATE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3112'
			SET @l_sub_desc   = 'INVALID SETTLEMENT TYPE (MUST BE DMT OR RMT)'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3113'
			SET @l_sub_desc    = 'SOURCE ACCOUNT TYPE NOT KNOWN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3114'
			SET @l_sub_desc    = 'TARGET ACCOUNT TYPE NOT KNOWN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3115'
			SET @l_sub_desc    = 'SOURCE ACCOUNT TYPE MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3116'
			SET @l_sub_desc    = 'MARKET TYPE MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3117'
			SET @l_sub_desc    = 'COUNTER PARTY IS NOT DEFINED IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3118'
			SET @l_sub_desc    = 'COUNTER PARTY NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     ='3119'
			SET @l_sub_desc    = 'COUNTER PARTY IS NOT DEFINED AS A DP IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			
		      --  
		    END 
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3120'
			SET @l_sub_desc  = 'COUNTER PARTY IS NOT A VALID DP'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			  --      
		    END 
		    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3121'
			SET @l_sub_desc   = 'STLM DATE NOT EQUAL TO SYSTEM STLM RUN DATE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd   = '3122'
			SET @l_sub_desc = 'BENEFICIARY ACCOUNT NO IS MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

			END 
		    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3123'
			SET @l_sub_desc  = 'TARGET ACCOUNT TYPE IS MANDATORY FOR DFP ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3124'
			SET @l_sub_desc  = 'CLEARING MEMBER IS NOT DEFINED IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END
	             IF  @I =1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3125'
			SET @l_sub_desc  = 'CLEARING MEMBER IS NOT IN VALID STATUS' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3126'
			SET @l_sub_desc  = 'BP IS NOT DEFINED AS A CLEARING MEMBER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			  --      
		    END
		    IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd     = '3127'
			SET @l_sub_desc   = 'BP IS NOT A VALID CLEARING MEMBER' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			  --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3128'
			SET @l_sub_desc  = 'STLM CYCLE NO NOT RQD IF SCA TYPE IS HOUSE OR CLNT'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --
		    END
	            IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3129'
			SET @l_sub_desc  = 'MARKET TYPE NOT RQD IF SCA TYPE IS HOUSE OR CLNT'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3130'
			SET @l_sub_desc   = 'SETTLEMENT CYCLE NO IS MANDATORY FOR POOL SCA TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
	            END
	            IF  @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3131'
			SET @l_sub_desc  = 'INVALID ACCOUNT FOR CLEARING MEMBER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --     
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3132'
			SET @l_sub_desc  = 'ASSOC. DP OF THE CM DOES NOT MATCH WITH ORDR ISSR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
			END
			IF @I = 1           
			BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd    = '3133'
		        SET @l_sub_desc  = 'CUSTODY ACCOUNT STATUS NOT IN VALID STATUS'
		        INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd   =  '3134'
			SET @l_sub_desc  = 'CLEARING MEMBER IS MANDATORY FOR POOL ACCOUNT' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

	            END
		    IF @I = 1          
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3135'
			SET @l_sub_desc  = 'CLEARING CORPORATION IS NOT IN VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
)
		      --
		    END  
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3136'
			SET @l_sub_desc  = 'NO DETAILS EXIST' 
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
			END
			IF @I = 1
			BEGIN
		     --
		       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		       SET @l_sub_cd    = '3137'
		       SET @l_sub_desc  = 'MARKET TYPE IS MANDATORY FOR POOL ACCOUNTS'
		       INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		     --
		    END    
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3138'
			SET @l_sub_desc  = 'MARKET TYPE IS NOT KNOWN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
)

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3139'
			SET @l_sub_desc  = 'BP IS NOT IN ACTIVE OR TO-DELETE STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		     --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3140'
			SET @l_sub_desc  = 'CM ROLE IS NOT IN "ACTIVE" OR "TO DELETE STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
	            END 
		    IF @I = 1
		    BEGIN
		      --
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		        SET @l_sub_cd     = '3141'
			SET @l_sub_desc  = 'CM DOES NOT EXIST FOR THE GIVEN CC AND CC-CM-ID'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3142'
			SET @l_sub_desc  = 'REPEATING COUNTER IS ZERO IN PARTIAL REJECTION'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
			IF @I = 1
		        BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3143'
			SET @l_sub_desc  = 'SYSTEM STLM DATE IS GREATER THAN NSDL DEADLINE DT'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

			  --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3144'
			SET @l_sub_desc  = 'CONFIRMATION ALREADY RECEIVED FOR THE STATEMENT'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
	            END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3145'
			SET @l_sub_desc  = 'NSDL DEADLINE TIME HAS PASSED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3146'
			SET @l_sub_desc  = 'NO. OF ISIN’S RCVD IS NOT SAME AS IN DLVY OUT ORDR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3147'
			SET @l_sub_desc   = 'SOURCE SCA TYPE IS NOT COMPATIBLE WITH MARKET TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd    = '3148'
			SET @l_sub_desc  = 'TARGET SCA TYPE IS NOT COMPATIBLE WITH MARKET TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
	           END 

		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3149'
			SET @l_sub_desc  = 'SRC & TRGT POOL A/CS SHOULD BE SAME MRKT TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
                      )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3150'
			SET @L_sub_desc  = 'SETTLEMENT CYCLE NUM SHOULD NOT BE GIVEN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
	            END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3151'
			SET @l_sub_desc  = 'MARKET TYPE SHOULD NOT BE GIVEN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		       --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3152'
			SET @l_sub_desc    = 'STATEMENT REFERENCE NUMBER SHOULD BE UNIQUE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		     IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3153'
			SET @l_sub_desc    = 'INTER STLMT CYCLE NO SHOULD NOT BE GIVEN'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3154'
			SET @l_sub_desc    = 'STLMT CYCLE# SHOULD BE GIVEN FOR INTER STLMT XFR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
			IF @I = 1
		        BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3155'
			SET @l_sub_desc    = 'CC ID DOES NOT MATCH WITH DELIVERY OUT ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		        IF @I = 1
			BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3156'
			SET @l_sub_desc    = 'MARKET TYPE DOES NOT MATCH WITH DELIVERY OUT ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3157'
			SET @l_sub_desc    = 'STLMT CYCLE NO.DOES NOT MATCH WITH DLVY OUT ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		     --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3158'
			SET @l_sub_desc   = 'STLMT.# SHOULD NOT BE SAME AS INTER STLMT NO'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3159'
			SET @l_sub_desc    = 'CM SHOULD BE GIVEN ONLY FOR POOL ACCOUNTS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
			IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3160'
			SET @l_sub_desc    = 'TARGET ACCOUNT TYPE IS MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3161'
			SET @l_sub_desc  = 'SI REJECTED;INVALID SI INDICATOR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3162'
			SET @l_sub_desc   = 'STANDING INSTRUCTION EXISTS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3163'
			SET @l_sub_desc   = 'DUPLICATE DMAT / RMAT CONFIRMATION ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3164'
			SET @l_sub_desc   = 'BENEFICIARY A/C NO. IS NOT ASSOCIATED WITH TARGET'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET @l_sub_cd     = '3165'
			SET @l_sub_desc   = 'STANDING INSTRUCTION DOES NOT EXIST'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3166'
			SET @l_sub_desc    = 'CANCELLED - OVERDUE STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3167'
			SET @l_sub_desc  = 'CANCELLED - NOT MATCHED STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3168'
			SET @l_sub_desc  = 'CM NOT MATCHED WITH THE EXISTING STANDING INSTRUCT'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3169'
			SET @l_sub_desc  = 'BOTH MARKET TYPE AND SETTLEMENT CYCLE NO. SHOULD N'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3170'
			SET @l_sub_desc   = 'CC CLNDR ENTRY FOR STLMT IS NOT STARTED FOR PARTIA'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
)

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3171'
			SET @l_sub_desc  = 'CC CLNDR ENTRY FOR STLMT IS NOT STARTED FOR FINAL'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3177'
			SET @l_sub_desc   = 'INVALID IRREVERSIBLE REASON'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3178'
			SET @l_sub_desc    = 'INVALID IRREVERSIBLE INDICATOR IN D.O. ORDER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3180'
			SET @l_sub_desc  = 'NUMBER OF REMAT CERTIFICATES SHOULD BE GREATER THA'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3181'
			SET @l_sub_desc   = 'NUMBER OF REMAT CERTIFICATES SHOULD NOT OCCUR FOR'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
			END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3182'
			SET @l_sub_desc   = 'SI REJECTED;INVALID CLIENT ID'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3184'
			SET @l_sub_desc  = 'CANCELLED-CONFIRMATION NOT RECEIVED OR REJECTED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3200'
			SET @l_sub_desc    = 'INVALID LOCKED IN DATE/REASON'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3201'
			SET @l_sub_desc    = 'INVALID REJECTED QUANTITY/REJECT CODE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3273'
			SET @l_sub_desc   = 'ORDER NUMBER IS NOT IN VALID RANGE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3332'
			SET @l_sub_desc   = 'SENDER ID IS NOT DEFINED IN NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3333'
			SET @l_sub_desc   = 'ADO EXEC DATE IS SAME AS THE INSTRUCTION EXECUTION'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )
			


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3334'
			SET @l_sub_desc  = 'ADO EXEC DATE IS BEFORE THE INSTRUCTION EXECUTION'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3417'
			SET @l_sub_desc   = 'BATCH NO. MUST BE BETWEEN 1 AND 999'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3542'
			SET @l_sub_desc    = 'PRESS ENTER TO CONTINUE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3620'
			SET @l_sub_desc   = 'TARGET ACCOUNT IS NOT FOUND'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3751'
			SET @l_sub_desc   = 'SENDER ID IS NOT IN A VALID STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3752'
			SET @l_sub_desc    = 'SENDER ID IS NOT DEFINED AS A DP TO NSDS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3757'
			SET @l_sub_desc    = 'SETTLEMENT TYPE IS MANDATORY'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3766'
			SET @l_sub_desc    = 'CLOSURE DATE SHOULD BE SPECIFIED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3773'
			SET @l_sub_desc    = 'AGREEMENT NUMBER SHOULD BE SPECIFIED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3798'
			SET @l_sub_desc    = 'INVALID FEE TRANSACTION TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3799'
			SET @l_sub_desc    = 'INVALID BENEFICIARY ACCOUNT NUMBER'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3800'
			SET @l_sub_desc   = 'INVALID CLIENT TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3801'
			SET @l_sub_desc    = 'INVALID CLIENT STATUS'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3802'
			SET @l_sub_desc    = 'INVALID CC ID/ MARKET TYPE COMBINATION'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3803'
			SET @l_sub_desc  = 'SETTLEMENT TYPE SHOULD BE LND OR BRW'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd   = '3804'
			SET @l_sub_desc  = 'INVALID DETAIL ORDER TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3805'
			SET @l_sub_desc   = 'INVALID ORDER LEG TYPE'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd    = '3806'
			SET @l_sub_desc   = 'LND/BRW ORDER DOES NOT EXISTS IN LBO'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3807'
			SET @l_sub_desc    = 'LND/BRW order is not in sent to INTMD STA'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3808'
			SET @l_sub_desc    = 'SENDER ID SHOULD BE THE INTERMEDIARY ID'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3809'
			SET @l_sub_desc    = 'LND/BRW ORDER IS NOT IN SETTLED OR PART CLOSED STA'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3810'
			SET @l_sub_desc    = 'REJECTION REASON NOT SPECIFIED'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )

		      --      
		    END 
		    IF @I = 1
		    BEGIN
		      --		
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3812'
			SET @l_sub_desc    = 'CONFIRMATION QTY CANNOT BE ZEROES WHEN ORDER IS AC'
			INSERT INTO transaction_sub_type_mstr
		       (trastm_id
		       ,trastm_excm_id
		       ,trastm_tratm_id
		       ,trastm_cd
		       ,trastm_desc
		       ,trastm_created_dt
		       ,trastm_created_by
		       ,trastm_lst_upd_dt
		       ,trastm_lst_upd_by
		       ,trastm_deleted_ind
		       )
		      VALUES
		      (@l_trastm_id
		      ,@l_excm_id 
		      ,@l_trastm_tratm_id
		      ,@l_sub_cd  
		      ,@l_sub_desc
		      ,GETDATE()
		      ,@l_name
		      ,GETDATE()
		      ,@l_name
		      ,1
		       )


		      --		    
		    END    
		    IF @I = 1
		    BEGIN
		      --
                        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
			SET  @l_sub_cd     = '3815'
			SET @l_sub_desc    = 'CLOSE ORDER QTY IS GREATER THAN BALANCE QTY'
			INSERT INTO transaction_sub_type_mstr
           		              ( trastm_id
           		               ,trastm_excm_id
           		               ,trastm_tratm_id
           		               ,trastm_cd
           		               ,trastm_desc
           		               ,trastm_created_dt
           		               ,trastm_created_by
           		               ,trastm_lst_upd_dt
           		               ,trastm_lst_upd_by
           		               ,trastm_deleted_ind
           		               )
           		              VALUES
           		              (@l_trastm_id
           		              ,@l_excm_id 
           		              ,@l_trastm_tratm_id
           		              ,@l_sub_cd  
           		              ,@l_sub_desc
           		              ,GETDATE()
           		              ,@l_name
           		              ,GETDATE()
           		              ,@l_name
           		              ,1
           		              )
           	   
           	    
                    END
                    IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd   = '3822'
		            SET @l_sub_desc = 'OLD ISIN UNDERGONE AUTO CA'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd   = '3824'
		            SET @l_sub_desc  = 'INTERMIDIARY ID SHOULD BE SPECIFIED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		      SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		      SET @l_sub_cd    = '3826'
		      SET @l_sub_desc= 'INTERMEDIARY BP ROLE NOT IN VALID STATUS' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3827'
		            SET @l_sub_desc  = 'INTERMEDIARY IS NOT DEFINED AS DP'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd  = '3828'
		            SET @l_sub_desc  = 'INTERMEDIARY IS NOT DEFINED IN NSDL '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                        --
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3829'
		            SET @l_sub_desc  = 'INTERMEDIARY IS NOT IN VALID STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                        --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3831'
		            SET @l_sub_desc  = 'SENDER ID IS NOT VALID-SO THE REQUEST IS REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3832'
		            SET @l_sub_desc  = 'DP ID IS NOT VALID-SO THE REQUEST IS REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3833'
		            SET @l_sub_desc  = 'ACCOUNT NUMBER ALREADY EXISTS-SO THE REQUEST IS '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3834'
		            SET @l_sub_desc  = 'INTERMEDIARY CLIENT ID IS INVALID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3835'
		           SET @l_sub_desc  = 'INTERMEDIARY ACCOUNT NOT IN VALID STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		          BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3836'
		            SET @l_sub_desc  = 'INTERMEDIARY CLIENT STATUS IS INVALID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd   = '3837'
		            SET @l_sub_desc  = 'LND/BRW BEN ACCT NO HAS TO BE SPECIFIED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3838'
		            SET @l_sub_desc  = 'DPS SOURCE CUSTODY ACCOUNT IS NOT IN VALID STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3839'
		            SET @l_sub_desc  = 'DPS LND CUSTODY ACCOUNT IS NOT IN VALID STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		       END
		       IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3840'
		            SET @l_sub_desc  = 'DPS SOURCE CUSTODY ACCOUNT IS NOT DEFINED TO NSDL' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		         --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3841'
		            SET @l_sub_desc  = 'DPS LND CUSTODY ACCOUNT IS NOT DEFINED TO NSDS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		   
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd   = '3842'
		            SET @l_sub_desc  = 'TOTAL CONF QTY CANNOT BE GREATER THAN REQUESTED QTY'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                        --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3844'
		            SET @l_sub_desc  = ' BOTH WITH SEC AND WITHOUT SEC QTY CANNOT BE ZERO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3846'
		            SET @l_sub_desc  = 'CM CAN NOT LEND THE STOCK'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		         --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3847'
		            SET @l_sub_desc  = 'CLOSURE DATE IS LESS THAN SYSTEM DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3848'
		            SET @l_sub_desc  = 'CUSTODY ACCOUNT DOES NOT EXISTS IN THE SYSTEM FOR' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		       --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3850'
		            SET @l_sub_desc  = 'CM ID SHOULD BE SENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF  @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3851'
		            SET @l_sub_desc  = 'MARKET TYPE SHOULD BE SENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		       --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3852'
		            SET @l_sub_desc  = 'SETTLEMENT CYCLE NUMBER SHOULD BE SENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '3853'
		            SET @l_sub_desc = 'CM ID SHOULD NOT BE GIVEN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd    = '3854'
		            SET @l_sub_desc = 'MARKET TYPE SHOULD NOT BE GIVEN' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3855'
		            SET @l_sub_desc  = 'SETTLEMENT CYCLE NUMBER SHOULD NOT BE GIVEN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                 --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '3856'
		            SET @l_sub_desc  = 'CM ID IS NOT IN INVALID STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '3857'
		            SET @l_sub_desc  = 'CM ID IS NOT DEFINED AS A CM TO NSDS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3858'
		            SET @l_sub_desc  = 'CM IS NOT PRESENT IN THE SYSTEM'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3859'
		            SET @l_sub_desc = 'CM DETAILS SHOULD BE GIVEN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3860'
		            SET @l_sub_desc  = 'INTERMEDIARY IS IN TO BE DEACTIVATED STATUS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                 --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3861'
		            SET @l_sub_desc  = 'INVALID MARKET TYPE – CA'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                 --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3863'
		            SET @l_sub_desc  = 'SETTLEMENT DATE LESS THAN SYSTEM DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                 --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3865'
		            SET @l_sub_desc  = 'DP ID NOT FOUND'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                --
		       END
		       IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '3869'
		            SET @l_sub_desc  = 'DUPLICATE OPEN ORDER EXISTS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		                 --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '3870'
		            SET @l_sub_desc  = 'UNFREEZE ALREADY EXISTS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4001'
		            SET @l_sub_desc = 'BP_ID DOES NOT EXIST IN THE SYSTEM'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4002'
		            SET @l_sub_desc = 'ISIN DOES NOT EXIST IN THE SYSTEM'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4003'
		            SET @l_sub_desc  = 'RECORD DATE SPECIFIED IS MORE THAN 90 DAYS BACK'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4004'
		            SET @l_sub_desc  = 'FULL INDICATOR SHOULD BE EITHER F OR I'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4005'
		            SET @l_sub_desc  = 'RECORD DATE IS AFTER SR DEADLINE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET @l_sub_cd     = '4006'
		            SET @l_sub_desc = 'SENDER IS NOT SPECIFIED FOR THIS ISIN NO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4007'
		            SET @l_sub_desc = 'LAST RECD DATE SHOULD BE VALID FOR INCREMENTAL RPT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4008'
		            SET @l_sub_desc  = 'RECORD DATE IS AFTER NSDL DEADLINE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4009'
		            SET @l_sub_desc  = 'SR DEADLINE DATE IS BEFORE PERMISSIBLE SR DEADLINE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		       END
		       IF @I = 1
		       BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4010'
		            SET @l_sub_desc = 'LAST RECORD DATE IS AFTER CURRENT RECORD DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4011'
		            SET @l_sub_desc  = 'NO LOCK-IN DETAILS FOR THE SELECTED DP ID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd  = '4012'
		            SET @l_sub_desc  = 'BENEFICIARY DETAILS REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4013'
		            SET @l_sub_desc  = 'REQUEST DOES NOT EXIST'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4014'
		            SET @l_sub_desc = 'COMPLETE STATEMENT WAS RECEIVED EARLIER'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4015'
		            SET @l_sub_desc  = 'ISIN MISMATCH IN THE STATEMENT RECEIVED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4016'
		            SET @l_sub_desc  = 'BENEFICIARY DETAILS RECEIVED BEFORE RECORD DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		     END
		     IF @I = 1
		     BEGIN
		        --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4017'
		           SET @l_sub_desc  = 'RECORD DATE MISMATCH IN THE STATEMENT RECEIVED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4018'
		            SET @l_sub_desc = 'REPORT INDICATOR MISMATCH IN THE STATEMENT RECEIVE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4019'
		            SET @l_sub_desc= 'LAST RECORD DATE MISMATCH IN THE STATEMENT RECEIVE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4020'
		            SET @l_sub_desc  = 'BENEFICIARY DETAILS RECEIVED AFTER DEADLINE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4021'
		            SET @l_sub_desc  = 'ACCOUNT ALREADY EXISTS, DUPLICATE RECORD RECEIVED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		         --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4022'
		            SET @l_sub_desc  = 'UNKNOWN REASON CODE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4023'
		            SET @l_sub_desc  = 'LOCKED POSITION ALREADY EXISTS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4024'
		            SET @l_sub_desc  = 'BENEFICIARY DETAILS ACCEPTED; PROCESS SUCCESSFUL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4025'
		            SET @l_sub_desc  = 'DP ID IS NOT VALID; SO THE STATEMENT IS REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4026'
		            SET @l_sub_desc  = 'RCNLN STMT DATE IS NOT A VALID ONE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		         --
		        END
		        IF @I = 1
		        BEGIN
		          --
		             SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd    = '4027'
		             SET @l_sub_desc  = 'STMT RCVD EARLIER WITHOUT ERR , SO CURR REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4028'
		            SET @l_sub_desc = 'ISIN IS NOT VALID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4029'
		            SET @l_sub_desc  = 'LOCK-IN REASON CODE NOT FOUND IN THE SYSTEM'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4030'
		            SET @l_sub_desc  = 'CLEARING MEMBER IS NOT VALID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		       END
		       IF @I =1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4031'
		            SET @l_sub_desc  = 'INVALID MARKET TYPE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                 --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4032'
		            SET @l_sub_desc  = 'DP STATEMENT DATE IS BEFORE MINIMUM ALLOWABLE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4034'
		            SET @l_sub_desc  = 'PRIMARY DTLS REJECTED;INVALID ACCOUNT TYPE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4035'
		            SET @l_sub_desc  = 'RECONCILIATION STATEMENT RECEIVED FOR FUTURE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I =1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4036'
		            SET @l_sub_desc = 'DUPLICATE ALLOTMENT STATEMENT, STATEMENT REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4038'
		            SET @l_sub_desc  = 'SHR-ID SPECIFIED IS NOT VALID FOR THE ISIN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4039'
		            SET @l_sub_desc  = 'QUANTITY ALLOCATED TO DP IS ZERO' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4040'
		            SET @l_sub_desc  = 'LOCK-IN RELEASE DATE IS NOT A FUTURE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4041'
		            SET @l_sub_desc = 'QTY ALLOTTED TO BENEFICIARY CANT BE ZERO FOR SINGLE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd    = '4042'
		            SET @l_sub_desc = 'TOTAL QUANTITY FOR THIS STATEMENT DOES NOT MATCH'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4045'
		            SET @l_sub_desc  = 'DUPLICATE ALLOCATION DETAILS FOR THE BENEFICIARY'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4046'
		            SET @l_sub_desc  = 'NUMBER OF ISIN ASSOCIATED WITH THE PO MISMATCH'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4047'
		             SET @l_sub_desc  = 'STMT RCVD EARLIER WITH ERROR AND NO EOS, MSG REJEC'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4050'
		            SET @l_sub_desc  = 'PRIMARY DTLS REJECTED;CLNTID NOT EXIST FOR THAT DP'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4051'
		            SET @l_sub_desc = 'PAGES OF THE MESSAGE RECEIVED OUT OF SEQUENCE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		       IF @I = 1
		       BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     ='4054'
		            SET @l_sub_desc = ' Order Status Is Invalid'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		          --
		  
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4056'
		           SET @l_sub_desc = 'STMT RECEIVED EARLIER WITHOUT ERROR AND EOS RECEIV'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4057'
		            SET @l_sub_desc = 'DUPLICATE CONFIRMATION STATEMENT FOR DP'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4058'
		            SET @l_sub_desc = 'INITIAL BOOKING DETAILS DO NOT MATCH'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4059'
		            SET @l_sub_desc = 'CONFIRMATION H+C+S SUM DOES NOT MATCH WITH INITIAL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '4061'
		            SET @l_sub_desc = 'INVALID DP ID AND ORDER NUMBER COMBINATION'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4063'
		            SET @l_sub_desc = 'ERROR IN LEVEL ONE IDS STATUS OR END OF STMT INVAL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                --
		        END
		        IF @I = 1
		        BEGIN
		          --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4066'
		           SET @l_sub_desc = 'HEADER DETAILS MISMATCH ACROSS PAGES'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                --
		       END
		       IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4067'
		           SET @l_sub_desc = 'INVALID LOCK-IN REASON CODE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4068'
		           SET @l_sub_desc = 'INVALID LOCKED-IN RELEASE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		         END
		         IF @I = 1
		         BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4069'
		            SET @l_sub_desc = 'INVALID CHECK DIGIT IN CLIENT-ID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4070'
		           SET @l_sub_desc = 'INVALID RCON SUCCES FLAG'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4071'
		            SET @l_sub_desc = 'BUSINESS DATE CANNOT BE A FUTURE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4077'
		           SET @l_sub_desc = 'CURRENT DATE GREATER THAN REFUND WARRANT DATE '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4051'
		           SET @l_sub_desc = 'PAGES OF THE MESSAGE RECEIVED OUT OF SEQUENCE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4089'
		           SET @l_sub_desc = 'NUMBER OF ISIN ASSOCIATED WITH THE PO MISMATCH'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		            --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4092'
		           SET @l_sub_desc = 'INVALID DATA FOR ISSUE TYPE OF PUBLIC OFFER'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4093'
		            SET @l_sub_desc = 'OPEN DATE OF ISSUE SHOULD BE GREATER THAN BUSINESS '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4096'
		           SET @l_sub_desc = 'ACTUAL CLOSURE DATE SHOULD BE > OPEN DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4097'
		            SET @l_sub_desc = 'QUANTITY LESS THAN ZERO, STATEMENT REJECTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		       END
		       IF @I = 1
		       BEGIN
		         --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4099'
		           SET @l_sub_desc = 'INVALID ISSUE NO AND SHR-ID COMBINATION'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		        --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4310'
		           SET @l_sub_desc = 'INVALID GENERIC GROUP'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		       END
		       IF @I = 1
		       BEGIN
		         --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '4312'
		           SET @l_sub_desc ='NON REDEMPTION CA EXEC DATE SHOULD BE < EFCT END DT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		         --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4313'
		            SET @l_sub_desc ='DEMPTION FOR THIS ISIN HAS ALREADY BEEN SETUP THROUGH ACA'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4371'
		            SET @l_sub_desc = 'INVALID C/A ORDER SERIAL NO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4507'
		            SET @l_sub_desc = 'PO APPLICATION REACHED AFTER THE DEADLINE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4508'
		            SET @l_sub_desc = 'APPLN DATE NOT BETWEEN OPEN AND CLOSURE DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '4991'
		            SET @l_sub_desc = 'STATEMENT ACCEPTED'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5000'
		            SET @l_sub_desc = 'ACCEPTED BY NSDL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		            --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5001'
		            SET @l_sub_desc = 'ACA EXEC DATE SHOULD BE GREATER THAN BUSINESS DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5002'
		            SET @l_sub_desc = 'ACA TYPE INDICATOR SHOULD BE BETWEEN 1 AND'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                      --
		      END
		      IF @I = 1
		      BEGIN
		        --
		             SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '5003'
		             SET @l_sub_desc = 'MINIMUM NUMBER OF LOOP ISIN SHOULD BE ONE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		       END
		       IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5004'
		            SET @l_sub_desc = 'INVALID MULTIPLICATION FACTOR'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		            --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5005'
		            SET @l_sub_desc = 'LACK OF POSITIONS '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '5016'
		            SET @l_sub_desc = 'FRACTION POSITION ARE EXISTING FOR ISIN(S)'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '5017'
		             SET @l_sub_desc = 'FOR REDEMP CA-EXEC-DATE SHOULD BE > SEC-EFCT-ENDDT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6014'
		            SET @l_sub_desc = 'INVALID PAGE NO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		       IF @I = 1
		       BEGIN
		          --
		         SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		          SET  @l_sub_cd     = '6015'
		           SET @l_sub_desc = 'INVALID FUNCTION OF MESSAGE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '6016'
		              SET @l_sub_desc = 'INVALID ISIN' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                      --
		        END
		        IF @I = 1
		        BEGIN
		            --
		               SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		               SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		              SET  @l_sub_cd     = '6017'
		               SET @l_sub_desc = 'QUANTITY SHOULD BE SAME AS TOTAL QUANTITY FOR AN I'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                      --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6018'
		           SET @l_sub_desc = 'RECEIVER TRANS REF NO SHOULD BE NONREF '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		                      --
		        END
		        IF @I =1
		        BEGIN
		          --
		              SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6019'
		            SET @l_sub_desc = 'TYPE OF TRANSACTION IS DELFREE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		              SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6020'
		             SET @l_sub_desc = 'DELIVERY DATE NOT THE SAME AS BUSINESS DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		             SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6021'
		            SET @l_sub_desc = 'DELIVERY PARTY IS SPACES'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6022'
		            SET @l_sub_desc = 'INVALID BP ID '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6023'
		              SET @l_sub_desc = 'IF ROLE IS DP, BENEFICIARY SHOULD BE PRESENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6024'
		            SET @l_sub_desc = 'CC ID/MARKET TYPE/SETTLEMENT NUMBER COMBINATION'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		       IF @I = 1
		        BEGIN
		            --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6025'
		            SET @l_sub_desc = 'INVALID CM ID '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6026'
		            SET @l_sub_desc = 'NO PAGE INDICATOR'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6027'
		            SET @l_sub_desc = 'NO MATCHING INSTRUCTION FOUND'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6048'
		            SET @l_sub_desc = 'INVALID SENDER ID IN BATCH NO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6049'
		            SET @l_sub_desc = 'INVALID SENDER DEPOSITORY ID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6050'
		            SET @l_sub_desc = 'INVALID TARGET DEPOSITORY ID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6051'
		            SET @l_sub_desc = 'BATCH NO.DOES NOT EXIST IN SYSTEM '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6052'
		            SET @l_sub_desc = 'TOTAL SECURITY QUANTITY SHOULD NOT BE ZERO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		              SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		              SET  @l_sub_cd     = '6053'
		              SET @l_sub_desc = 'INVALID SEC QUANTITY, SECURITY INDICATOR'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I =1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6054'
		            SET @l_sub_desc = 'INVALID MARKET TYPE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6060'
		            SET @l_sub_desc = 'QUANTITY NOT CORRECT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		       IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '6061'
		            SET @l_sub_desc = 'OTHER REJECTION REASONS'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                            --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7000'
		            SET @l_sub_desc = 'NO ORDER EXITS FOR BONUS UPDATE INSTRUCTION ' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '7001'
		             SET @l_sub_desc = 'BONUS RECORD DATE<SYSTEM DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                            --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7002'
		            SET @l_sub_desc = 'CA EXEC DATE < BONUS REC DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7003'
		            SET @l_sub_desc = 'NO OF DB-ISINS NOT EQUAL TO REPTING PART'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7004'
		            SET @l_sub_desc = 'NO OF CREDIT ISIN NOT EQUAL TO REPTING PART2'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7006'
		            SET @l_sub_desc = 'NO OF DEBIT ISIN GREATER THAN ONE FOR BONUS ACA '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '7007'
		           SET @l_sub_desc = 'DEBIT MULTIFICATION FACTOR SHOULD NOT BE EQUAL TO ZERO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7008'
		           SET @l_sub_desc = 'CREDIT MULTIFICATION FACTOR SHOULD NOT BE EQUAL TO ZERO'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7010'
		            SET @l_sub_desc = 'CANCELLATION NOT ALLOWED AFTER EXECUTION DATE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '7011'
		            SET @l_sub_desc = 'BASE ISIN SHOULD BE SPACES FOR BONUS ACA'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9406'
		            SET @l_sub_desc = 'CLIENT DTLS REJECTED BY NSDL '
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9407'
		            SET @l_sub_desc = 'SIGN DTLS REJECTED;INVALID CLIENT ID'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		             SET  @l_sub_cd     = '9408'
		            SET @l_sub_desc = 'ADDR DTLS REJECTED;NO PROPER 151-MSG'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		           --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9409'
		            SET @l_sub_desc = 'INVALID ACCT TYPE IN 111-MESSAGE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9410'
		           SET @l_sub_desc = 'NO CORRESPONDING 111 MESSAGE FOR 113 MESSAGE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9420'
		            SET @l_sub_desc = 'STANDING INSTRUCTION REJECTED' 
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          -- 
		            SELECT m_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9421'
		            SET @l_sub_desc = 'ADDRESS DETAILS REJECTED' 
		            INSERT INTO transaction_sub_type_mstr     
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		            --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9422'
		           SET @l_sub_desc = 'POSITION EXISTS FOR THE CLIENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9423'
		            SET @l_sub_desc = 'PENDING CA/IPO AT DM FOR THE CLIENT'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9425'
		            SET @l_sub_desc = 'STATUS AT DM IS NOT ACTIVE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9426'
		            SET @l_sub_desc = 'CREDIT RECEIVED IN CM POOL A/C AFTER STMT IS RUN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        IF @I = 1
		       BEGIN
		         --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		              SET  @l_sub_cd     = '9427'
		             SET @l_sub_desc = 'ORIGINAL ORDER REJECTED BY NSDL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		  
		  
		                                  --
		        END
		        IF @I = 1
		       BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9450'
		            SET @l_sub_desc = 'THE CLIENT DOES NOT HAVE ANY POSITION IN THIS ISIN'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		          --
		        END
		        IF @I = 1
		        BEGIN
		          --
		            SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		            SET  @l_sub_cd     = '9453'
		            SET @l_sub_desc = 'THE CLIENT IS NOT ACTIVE'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		        ELSE IF @I = 1
		        BEGIN
		          --
		           SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
		           SET  @l_sub_cd     = '9454'
		            SET @l_sub_desc = 'FREEZE ORDER ALREADY EXIST FOR THE SAME LEVEL'
		            INSERT INTO transaction_sub_type_mstr
		                     ( trastm_id
		                      ,trastm_excm_id
		                      ,trastm_tratm_id
		                      ,trastm_cd
		                      ,trastm_desc
		                      ,trastm_created_dt
		                      ,trastm_created_by
		                      ,trastm_lst_upd_dt
		                      ,trastm_lst_upd_by
		                      ,trastm_deleted_ind
		                      )
		                     VALUES
		                     (@l_trastm_id
		                     ,@l_excm_id
		                     ,@l_trastm_tratm_id
		                     ,@l_sub_cd
		                     ,@l_sub_desc
		                     ,GETDATE()
		                     ,@l_name
		                     ,GETDATE()
		                     ,@l_name
		                     ,1
		                     )
		           --
		        END
		  
		      END

GO
