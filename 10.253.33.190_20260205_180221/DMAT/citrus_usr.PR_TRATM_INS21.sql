-- Object: PROCEDURE citrus_usr.PR_TRATM_INS21
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[PR_TRATM_INS21]
                AS
                BEGIN
                  --
                    DECLARE
                        @l_excm_id   NUMERIC(30)
                       ,@l_desc   VARCHAR(100)
                       ,@l_name VARCHAR(30)
                       ,@l_trantm_id  NUMERIC(30)
                       ,@l_book_cd  VARCHAR(30)
                       ,@l_code VARCHAR(50)
                       ,@I  SMALLINT
                       ,@l_trastm_id NUMERIC(30)
                       ,@l_trastm_tratm_id NUMERIC(30)
                       ,@l_sub_desc   VARCHAR(100)
                       ,@l_sub_cd    VARCHAR(50)
                        SET  @I =1
                        SET @l_name ='HO'
                        SET @l_code='SLIP_TYPE_NSDL' 
                        SET @l_desc ='SLIP TYPES'

               

                     
                      SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='NSDL'
                      DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='SLIP_TYPE_NSDL')
		      DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'SLIP_TYPE_NSDL'
                      
                
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
		    
		    --BEGIN @I=11
		   WHILE @I<=11
		   BEGIN
		      --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			

		    
		    
		    IF  @I = 1
		    BEGIN
		      --
		        SET @l_sub_cd    = '901'
			SET @l_sub_desc  = 'DEMAT'
		      --     
		    END    
		    ELSE IF @I = 2
		    BEGIN
		      --
		        SET @l_sub_cd     = '902'
			SET @l_sub_desc   = 'REMAT'

		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd    = '925'
			SET @l_sub_desc  = 'INTER DEPOSITORY(DELIVERY)'
		      --     
		    END    
		    ELSE IF @I = 4
		    BEGIN
		      --
		        SET @l_sub_cd     = '904_ACT'
			SET @l_sub_desc   = 'ACCOUNT TRANSFER(DELIVERY)'
		      --      
	            END
	            ELSE IF  @I = 5
		    BEGIN
		      --
			SET @l_sub_cd    = '926'
			SET @l_sub_desc  = 'INTER DEPOSITORY(RECEIPT)'
		      --     
		    END    
		    ELSE IF @I = 6
		    BEGIN
		      --
			SET @l_sub_cd     = '905_ACT'
			SET @l_sub_desc   = 'ACCOUNT TRANSFER(RECEIPT)'
		      --      
	            END
	            ELSE IF @I = 7
		    BEGIN
		      --
			SET @l_sub_cd     = '904_P2C'
			SET @l_sub_desc   = 'DELIVERY INSTRUCTION BY CM ON PAYOUT TO BENEFICIARY'

		      --      
	            END
	            ELSE IF  @I = 8
		    BEGIN
		      --
		        SET @l_sub_cd     = '934'
			SET @l_sub_desc   = 'POOL TO POOL' 
                      --     
		    END    
		    ELSE IF @I = 9
		    BEGIN
		      --
		        SET @l_sub_cd     = '906'
			SET @l_sub_desc   = 'DELIVERY OUT'
		      --      
		    END
		    ELSE IF  @I = 10
		    BEGIN
		      --
		      SET @l_sub_cd    = '912'
		      SET @l_sub_desc  = 'IRREVERSIBLE DELIVERY OUT'
		      --     
		    END    
		    ELSE IF @I =11
		    BEGIN
		      --
		        SET @l_sub_cd    = '907'
			SET @l_sub_desc  = 'INTER SETTLEMENT'
		    END
		    
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
		    SET @I = @I+1 
		  
                   END
		    
		 END


                        /* EXECUTE PR_TRATM_INS21  select * from transaction_type_mstr
		        select * from transaction_sub_type_mstr
		        DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
		        DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
		        sp_help transaction_type_mstr8*/

GO
