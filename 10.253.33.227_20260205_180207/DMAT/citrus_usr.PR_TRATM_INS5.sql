-- Object: PROCEDURE citrus_usr.PR_TRATM_INS5
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[PR_TRATM_INS5]
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
                        SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='CDSL'
                        SET @l_code='TRANS_TYPE_CDSL' 
			SET @l_desc ='TRANSACTION TYPES'
			DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='TRANS_TYPE_CDSL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'TRANS_TYPE_CDSL'
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
                    
                       

           	   	                                            
           		                                            
           	  
		    --BEGIN @I=26
		   WHILE @I<=26
		   BEGIN
		    --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                    
			

		    IF @I = 1
		    BEGIN
		      --
                        SET @l_sub_cd = '2201'
                         SET @l_sub_desc = 'CREDIT DEMAT PENDING VERIFICATION'
		      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
                        SET @l_sub_cd  = '2202'
                        SET @l_sub_desc   = 'CREDIT DEMAT PENDING CONFIRMATION'
		      --      
		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd = '2205'
		        SET @l_sub_desc = 'CREDIT REMAT PENDING CONFIRMATION'

		      --     
		    END 
		    ELSE IF @I = 4
		    BEGIN
		      --
			SET @l_sub_cd  = '2210'
			SET @l_sub_desc  = 'CREDIT FREEZE'
                      --
		    END 
		    ELSE IF  @I = 5
		    BEGIN
		      --
			SET @l_sub_cd    = '2211'
			SET @l_sub_desc   = 'CREDIT SAFE KEEPING'
		      --     
		    END    
		    ELSE IF @I = 6
		    BEGIN
		      --
			SET @l_sub_cd    = '2212'
			SET @l_sub_desc  = 'CREDIT LOCK IN'
 
			  --      
		    END
		    ELSE IF  @I = 7
		    BEGIN
		      --
			SET @l_sub_cd     = '2215'
			SET @l_sub_desc    = 'CREDIT EARMARK'

			  --     
		    END    
		    ELSE IF @I = 8
		    BEGIN
		      --
			SET @l_sub_cd    = '2216'
			SET @l_sub_desc  = 'CREDIT PENDING ELIMINATION'
		      --      
		    END
		    ELSE IF  @I = 9
		    BEGIN
		      --
		      SET @l_sub_cd  = '2220'
		      SET @l_sub_desc  = 'CREDIT LEND AVAILABLE'

		      --     
		    END    
		    ELSE IF @I = 10
		    BEGIN
		      --
			SET @l_sub_cd  = '2221'
			SET @l_sub_desc  = 'CREDIT LEND ' 

		      --
		    END
		    ELSE IF  @I = 11
		    BEGIN
		      --
			SET @l_sub_cd  = '2225'
			SET @l_sub_desc    = 'CREDIT BORROW'
		      --    
		    END    
		    ELSE IF @I = 12
		    BEGIN
		      --
		        SET @l_sub_cd     = '2230'
			SET @l_sub_desc    = 'CREDIT PLEDGE'

		      --      
	            END
		    ELSE IF  @I = 13
		    BEGIN
		      --
		        SET @l_sub_cd   = '2246'
		        SET @l_sub_desc    = 'CREDIT CURRENT BALANCE'


	              --     
		    END    
	            ELSE IF @I = 14
	            BEGIN
	             --
	               SET @l_sub_cd   = '2251'
		       SET @l_sub_desc   = 'DEBIT DEMAT PENDING VERIFICATION'
		      --      
	            END
		    ELSE IF @I = 15         
		    BEGIN
		      --
			SET @l_sub_cd   = '2252'
			SET @l_sub_desc  = 'DEBIT DEMAT PENDING CONFIRMATION'

		      --
		    END 
		    ELSE IF  @I = 16
		    BEGIN
		      --
			SET @l_sub_cd   = '2255'
			SET @l_sub_desc    = 'DEBIT REMAT PENDING CONFIRMATION'

		      --    
                    END    
		    ELSE IF  @I = 17
		    BEGIN
		      --
			SET @l_sub_cd   = '2260'
			SET @l_sub_desc    = 'DEBIT FREEZE'
                      --    
                    END    
		    ELSE IF @I = 18
		    BEGIN
		      --
			SET @l_sub_cd      = '2261'
			SET @l_sub_desc    = 'DEBIT SAFE KEEPING'
		      --      
		    END
		    ELSE IF  @I = 19
		    BEGIN
		      --
			SET @l_sub_cd   = '2262'
			SET @l_sub_desc     = 'DEBIT LOCK IN'
	              --     
		    END    
		    ELSE IF @I = 20
		    BEGIN
		     --
		       SET @l_sub_cd  = '2265'		       
		       SET @l_sub_desc    = 'DEBIT EARMARK'
		     --      
		    END
		    ELSE IF @I = 21      
		    BEGIN
		      --
			SET @l_sub_cd   = '2266'
			SET @l_sub_desc   = 'DEBIT PENDING ELIMINATION'
		      --
		    END  
		    ELSE IF @I = 22
		    BEGIN
		      --
			SET @l_sub_cd    = '2270'		
			SET @l_sub_desc    = 'Debit Lend Available'
		      --      
		    END
		    ELSE IF @I = 23
		    BEGIN
		     --
		       SET @l_sub_cd    = '2271'
		       SET @l_sub_desc   = 'DEBIT LEND'
		    --      
		    END
		    ELSE IF @I = 24    
		    BEGIN
		      --
			SET @l_sub_cd    = '2275'
			SET @l_sub_desc  = 'DEBIT BORROW'
		      --
		    END 
		    ELSE IF @I = 25
		    BEGIN
		     --
		       SET @l_sub_cd    = '2277'
		       SET @l_sub_desc   = 'DEBIT CURRENT BALANCE'
		       --      
		    END
		    ELSE IF @I = 26
		    BEGIN
		      --
			SET @l_sub_cd      = '2280'		
			SET @l_sub_desc    = 'DEBIT PLEDGE'
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
/*EXECUTE PR_TRATM_INS5  select * from transaction_type_mstr
      select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
      DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
      sp_help transaction_type_mstr8*/

GO
