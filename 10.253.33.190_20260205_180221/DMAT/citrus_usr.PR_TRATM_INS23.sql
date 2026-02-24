-- Object: PROCEDURE citrus_usr.PR_TRATM_INS23
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE    PROCEDURE [citrus_usr].[PR_TRATM_INS23]
                AS
                BEGIN
                  --
                    DECLARE
                        @l_excm_id   NUMERIC(30)
                       ,@l_desc   VARCHAR(100)
                       ,@l_name VARCHAR(30)
                       ,@l_trantm_id  NUMERIC(30)
                       ,@l_code VARCHAR(50)
                       ,@I  SMALLINT
                       ,@l_trastm_id NUMERIC(30)
                       ,@l_trastm_tratm_id NUMERIC(30)
                       ,@l_sub_desc   VARCHAR(100)
                       ,@l_sub_cd    VARCHAR(50)
                        SET  @I =1
                        SET @l_name ='HO'
                        SET @l_code = 'RES_STAT_CD_NSDL' 
                        SET @l_desc ='RESPONSE FILE STATUS NSDL'

               

                     
                      SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='NSDL'
                     DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT trantm_id FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'RES_STAT_CD_NSDL')
		     DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'RES_STAT_CD_NSDL'
                
                
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
		    , 1
		    )
		    
		   --BEGIN @I=6
		   WHILE @I<=6
		   BEGIN
		    --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                    
			

		    
		    
		    IF @I = 1
		    BEGIN
		      --
			SET @l_sub_cd   = 'P'
			SET @l_sub_desc = 'PENDING RESPONSE'
		      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
			SET @l_sub_cd   = 'E'
			SET @l_sub_desc = 'EXECUTE SUCCESSFULY'
		      --      
		    END 
		    IF @I = 3
		    BEGIN
		      --
                        SET @l_sub_cd   = 'A1'
                        SET @l_sub_desc = 'ACCEPTED AT SOURCE BY DPM'
		      --      
		    END 
		    ELSE IF @I = 4
		    BEGIN
		      --
			SET @l_sub_cd   = 'R1'
			SET @l_sub_desc = 'REJECTED AT SOURCE BY DPM'
		      --      
		    END 
		    ELSE IF @I = 5
		    BEGIN
		      --
			SET @l_sub_cd   = 'A2'
			SET @l_sub_desc = 'ACCEPTED AT TARGET BY DPM'
		      --      
		    END 
		    ELSE IF @I = 6
		    BEGIN
		      --
			SET @l_sub_cd   = 'R2'
			SET @l_sub_desc = 'REJECTED AT TARGET BY DPM'
		      --      
		    END 
		    


		    
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
                   SET @I = @I+1 
		  END
		END
	

    /* EXECUTE PR_TRATM_INS23
      select * from transaction_type_mstr
      select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_mstr 
      DELETE FROM transaction_type_mstr 
      sp_help transaction_type_mstr8*/

GO
