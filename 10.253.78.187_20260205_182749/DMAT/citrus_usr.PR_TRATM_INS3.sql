-- Object: PROCEDURE citrus_usr.PR_TRATM_INS3
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[PR_TRATM_INS3]
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
                        SET @l_code='TRANS_TYPE_NSDL' 
                        SET @l_desc ='TRANSACTION TYPES'
                        SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='NSDL'
                        
                        DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='TRANS_TYPE_NSDL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'TRANS_TYPE_NSDL'
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
		    
		    --BEGIN @I=47
		   WHILE @I<=47
		   BEGIN
		      --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			

		    IF @I = 1
		    BEGIN
		      --
                        SET @l_sub_cd    = '801'
			SET @l_sub_desc  = 'POOL  POOL ACCOUNT TRANSFER (VALID ONLY FROM CC’S CM POOL)'
			  --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
                        SET @l_sub_cd    = '900'
			SET @l_sub_desc  = 'REPURCHASE INSTRUCTION'
		      --      
		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd    = '901'
			SET @l_sub_desc  = 'DEMAT INSTRUCTION'
		      --     
		    END    
		    ELSE IF @I = 4
		    BEGIN
		      --
		        SET @l_sub_cd     = '902'
			SET @l_sub_desc   = 'REMAT INSTRUCTION'

		    END 
		    ELSE IF  @I = 5
		    BEGIN
		      --
		        SET @l_sub_cd    = '903'
			SET @l_sub_desc  = 'INTRA TRANSFER INSTRUCTION'
		      --     
		    END    
		    ELSE IF @I = 6
		    BEGIN
		      --
		        SET @l_sub_cd     = '904'
			SET @l_sub_desc   = 'DELIVERY FREE OF PAYMENT (INTER DP) INSTRUCTION' 
                      --      
	            END
		    ELSE IF  @I = 7
		    BEGIN
		      --
		        SET @l_sub_cd     = '905'
			SET @l_sub_desc   = 'RECEIPT FREE OF PAYMENT (INTER DP) INSTRUCTION' 
                      --     
		    END    
		    ELSE IF @I = 8
		    BEGIN
		      --
		        SET @l_sub_cd     = '906'
			SET @l_sub_desc   = 'DELIVERY OUT INSTRUCTION' 
		      --      
		    END
		    ELSE IF  @I = 9
		    BEGIN
		      --
		      SET @l_sub_cd    = '907'
		      SET @l_sub_desc  = 'INTER SETTLEMENT TRANSFER' 
		      --     
		    END    
		    ELSE IF @I = 10
		    BEGIN
		      --
		        SET @l_sub_cd    = '908'
			SET @l_sub_desc  = 'PLEDGING INSTRUCTION (PLEDGOR END - INITIATION PROCESS)'
		      --
		    END
		    ELSE IF  @I = 11
		    BEGIN
		      --
		        SET @l_sub_cd    = '909'
			SET @l_sub_desc  = 'HYPOTHECATION INSTRUCTION (PLEDGOR END INITIATION PROCESS)'

		      --     
		    END    
		    ELSE IF @I = 12
		    BEGIN
		      --

			SET @l_sub_cd     = '910'
			SET @l_sub_desc   = 'PLEDGE INVOCATION INSTRUCTION (PLEDGEE END INVOCATION INITIATION)' 

		      --      
			END
		    ELSE IF  @I = 13
	            BEGIN
	              --
                        SET @l_sub_cd     = '911'
                        SET @l_sub_desc   = 'PLEDGE CLOSURE INSTRUCTION (PLEDGOR END)' 
                      --     
                    END    
		    ELSE IF @I = 14
		    BEGIN
		      --

			SET @l_sub_cd    = '912'
			SET @l_sub_desc  = 'IRREVERSIBLE DELIVERY OUT INSTRUCTION'
                      --      
		    END
		    ELSE IF @I = 15         
		    BEGIN
	              --
	                SET @l_sub_cd     = '913'
	                SET  @l_sub_desc  = 'NSDL TRANSFER (DELIVERY) INSTRUCTION'
	              --
	            END    
		    ELSE IF @I = 16
		    BEGIN
		      --
		        SET @l_sub_cd    = '914'
			SET  @l_sub_desc  = 'SLB LENDING INSTRUCTION' 

		    END
	            ELSE IF @I = 17            
		    BEGIN
		      --
		        SET @l_sub_cd    = '915'
			SET @l_sub_desc  = 'SLB BORROW INSTRUCTION' 
		      --
		    END  
		    ELSE IF  @I = 18
		    BEGIN
		      --
			SET @l_sub_cd   = '916'
			SET @l_sub_desc = 'PLEDGING CONFIRMATION (PLEDGEE END -CONFIRMATION OF PLEDGE)'
	              --     
		    END    
		    ELSE IF @I = 19
		    BEGIN
		      --
		         SET @l_sub_cd     = '917'
		         SET @l_sub_desc   = 'HYPOTHECATION CONFIRMATION (PLEDGEE END - CONFIRMATION OF HYPOTHECATION)' 
		      --      
		    END
		    ELSE IF  @I = 20
		    BEGIN
		      --
			SET @l_sub_cd     = '918'
		        SET @l_sub_desc   = 'INVOCATION CONFIRMATION (PLEDGOR END -CONFIRMATION OF INVOCATION)'
		      --     
		    END    
		    ELSE IF @I = 21
		    BEGIN
		      --
		        SET @l_sub_cd    = '919'
			SET @l_sub_desc  = 'CLOSURE CONFIRMATION (PLEDGEE END)' 
		      --      
		    END
		    ELSE IF @I = 22      
		    BEGIN
		      --
			SET @l_sub_cd    = '920'
			SET  @l_sub_desc  = 'RECEIPT-IN INTIMATION'
		      --
		    END    
		    ELSE IF @I = 23
		    BEGIN
		      --
			SET @l_sub_cd    = '921'
			SET  @l_sub_desc = 'CORPORATE ACTION (DEBIT)' 
                      --
		    END
		    ELSE IF @I = 24          
		    BEGIN
		      --
		        SET @l_sub_cd     = '922'
			SET @l_sub_desc  = 'CORPORATE ACTION (CREDIT)'
		      --
		    END
		    ELSE IF  @I = 25
		    BEGIN
		      --
			SET @l_sub_cd    = '923'
			SET @l_sub_desc  = 'LOCK-IN RELEASE'
		      --     
		    END    
		    ELSE IF @I = 26
		    BEGIN
		      --
		        SET @l_sub_cd     = '924'
			SET @l_sub_desc   = 'INITIAL PUBLIC OFFER'
		      --      
		    END
		    ELSE IF  @I = 27
		    BEGIN
		      --
			SET @l_sub_cd   = '925'
			SET @l_sub_desc  = 'INTER DEPOSITORY TRANSFER INSTRUCTION (DELIVERY)'
			  --     
		    END    
		    ELSE IF @I = 28
		    BEGIN
		      --
		        SET @l_sub_cd    = '926'
			SET @l_sub_desc  = 'INTER DEPOSITORY TRANSFER INSTRUCTION (RECEIPT)' 
		      --      
		    END
		    ELSE IF @I = 29       
		    BEGIN
		      --
			SET @l_sub_cd    = '927'
			SET  @l_sub_desc = 'AUTO DO TRANSFER INSTRUCTION'
		      --
		    END    
		    ELSE IF @I = 30
		    BEGIN
		      --
			SET @l_sub_cd    = '930'
			SET  @l_sub_desc  = 'DEFERRED DELIVERY OUT INSTRUCTION DFP'

		    END
		    ELSE IF @I = 31          
		    BEGIN
		      --
		        SET @l_sub_cd     = '931'
			SET @l_sub_desc   = 'DEFERRED DELIVERY OUT INTIMATION'
		      --
		    END  
		    ELSE IF  @I = 32
		    BEGIN
		      --
			SET @l_sub_cd     = '934'
			SET @l_sub_desc   = 'CM POOL DELIVERY INSTRUCTION'
		    END    
		    ELSE IF @I = 33
		    BEGIN
		      --
			 SET @l_sub_cd   = '935'
			 SET @l_sub_desc = 'CM POOL RECEIPT INSTRUCTION'
		      --      
		    END
		    ELSE IF  @I = 34
		    BEGIN
		      --
			    SET @l_sub_cd       = '936'
			    SET @l_sub_desc   = 'ACCOUNT FREEZING INSTRUCTION' 
		    END    
		    ELSE IF @I = 35
		    BEGIN
		      --
			SET @l_sub_cd      = '937'
			SET @l_sub_desc  = 'ACCOUNT UNFREEZING INSTRUCTION' 
		      --      
		    END
		    ELSE IF @I = 36   
		    BEGIN
		      --
			SET @l_sub_cd    = '938'
			SET  @l_sub_desc  = 'LEND CONFIRMATION' 
		      --
		    END    
		    ELSE IF @I = 37
		    BEGIN
		      --
			SET  @l_sub_cd    = '939'
			SET  @l_sub_desc  = 'BORROW CONFIRMATION'  
			  --
		    END
		    ELSE IF @I = 38        
		    BEGIN
		      --
			SET @l_sub_cd     = '940'
			SET @l_sub_desc  = 'LEND RECALL INITIATION' 
		      --
		    END  
		    ELSE IF @I = 39        
		    BEGIN
		      --

			SET @l_sub_cd     = '941'
			SET @l_sub_desc  = 'LEND  REPAY INITIATION' 
		      --
		    END  
		    ELSE IF  @I = 40
		    BEGIN
		      --
			SET @l_sub_cd     = '942'
			SET @l_sub_desc  = 'BORROW RECALL INITIATION' 
		    END    
		    ELSE IF @I = 41
		    BEGIN
		      --
			 SET @l_sub_cd       = '943'
			 SET @l_sub_desc   = 'BORROW REPAY INITIATION' 
		      --      
		    END
		    ELSE IF  @I = 42
		    BEGIN
		      --
			SET @l_sub_cd       = '944'
			SET @l_sub_desc   = 'LEND RECALL CONFIRMATION' 
		      --	
		    END    
		    ELSE IF @I = 43
		    BEGIN
		      --
			SET @l_sub_cd      = '945'
			SET @l_sub_desc  = 'LEND REPAY CONFIRMATION' 
		      --      
		    END
		    ELSE IF @I = 44
		    BEGIN
		      --
			SET @l_sub_cd    = '946'
			SET @l_sub_desc  = 'BORROW RECALL CONFIRMATION' 
		      --
		    END    
		    ELSE IF @I = 45
		    BEGIN
		      --
			SET @l_sub_cd    = '947'
			SET @l_sub_desc  = 'BORROW REPAY CONFIRMATION'  
		      --
		    END
		    ELSE IF @I = 46     
		    BEGIN
		      --
			SET @l_sub_cd     = '949'
			SET @l_sub_desc  = 'LEND CONFIRMATION INTIMATION'  
		      --
		    END 
		    ELSE IF @I = 47   
		    BEGIN
		      --
			SET @l_sub_cd     = '950'
			SET @l_sub_desc  = 'BORROW CONFIRMATION INTIMATION' 
		      --
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
		 
		  /* EXECUTE PR_TRATM_INS3
           select * from transaction_type_mstr
           select * from transaction_sub_type_mstr
           DELETE FROM transaction_sub_type_mstr 
           DELETE FROM transaction_type_mstr 
           sp_help transaction_type_mstr8*/

GO
