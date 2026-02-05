-- Object: PROCEDURE citrus_usr.PR_TRATM_INS6
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[PR_TRATM_INS6]
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
                        SET @l_code='INT_TRANS_TYPE_CDSL' 
			SET @l_desc ='INTERNAL TRANS TYPES'
			DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='INT_TRANS_TYPE_CDSL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'INT_TRANS_TYPE_CDSL'
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
                    
                       

           	   	                                            
           		                                            
           	  
		    --BEGIN @I=19
		   WHILE @I<=19
		   BEGIN
		    --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                    
			

		    IF @I = 1
		    BEGIN
		      --
                        SET @l_sub_cd   = 'BONUS'
                         SET @l_sub_desc = 'BONUS'
		      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
                        SET @l_sub_cd  = 'EP-DR'
                        SET @l_sub_desc= 'EARLY PAYIN DEBIT'
		      --      
		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd = 'DEMAT'
		        SET @l_sub_desc = 'DEMAT'

		      --     
		    END 
		    ELSE IF @I = 4
		    BEGIN
		      --
			SET @l_sub_cd  = 'EXCHPAYOUT'
			SET @l_sub_desc = 'EXCHANGE  PAYOUT CREDIT'
                      --
		    END 
		    ELSE IF  @I = 5
		    BEGIN
		      --
			SET @l_sub_cd    = 'EXCHPAYIN'
			SET @l_sub_desc  = 'EXCHANGE  PAYOUT DEBIT'
		      --     
		    END    
		    ELSE IF @I = 6
		    BEGIN
		      --
			SET @l_sub_cd    = 'OF-CR'
			SET @l_sub_desc  = 'OFFMARKET CREDIT'
 
			  --      
		    END
		    ELSE IF  @I = 7
		    BEGIN
		      --
			SET @l_sub_cd     = 'OF-DR'
			SET @l_sub_desc   = 'OFFMARKET DEBIT'

			  --     
		    END    
		    ELSE IF @I = 8
		    BEGIN
		      --
			SET @l_sub_cd    = 'INTDEP-CR'
			SET @l_sub_desc  = 'INTERDEPOSITORY CREDIT'
		      --      
		    END
		    ELSE IF  @I = 9
		    BEGIN
		      --
		      SET @l_sub_cd  = 'INTDEP-DR'
		      SET @l_sub_desc  = 'INTERDEPOSITORY DEBIT'

		      --     
		    END    
		    ELSE IF @I = 10
		    BEGIN
		      --
			SET @l_sub_cd  = 'CORPORATE ACTION TYPE'
			SET @l_sub_desc = 'CORPORATE ACTION' 

		      --
		    END
		    ELSE IF  @I = 11
		    BEGIN
		      --
			SET @l_sub_cd  = 'REMAT'
			SET @l_sub_desc = 'REMAT'
		      --    
		    END    
		    ELSE IF @I = 12
		    BEGIN
		      --
		        SET @l_sub_cd     = 'SEL ELMN'
			SET @l_sub_desc   = 'SECURITY ELIMINATION'
		      --      
	            END
		    ELSE IF  @I = 13
		    BEGIN
		      --
		        SET @l_sub_cd   = 'TRANSFER'
		        SET @l_sub_desc  = 'TRANSFER'


	              --     
		    END    
	            ELSE IF @I = 14
	            BEGIN
	             --
	               SET @l_sub_cd   = 'TRANSMISSION'
		       SET @l_sub_desc   = 'TRANSMISSION'
		      --      
	            END
		    ELSE IF @I = 15         
		    BEGIN
		      --
			SET @l_sub_cd   = 'PLEDGE'
			SET @l_sub_desc  = 'PLEDGE'

		      --
		    END 
		    ELSE IF  @I = 16
		    BEGIN
		      --
			SET @l_sub_cd   = 'UNPLEDGE'
			SET @l_sub_desc    = 'UNPLEDGE'
                      --    
                    END    
		    ELSE IF @I = 17
		    BEGIN
		      --
			SET @l_sub_cd      = 'CONFISCATE'
			SET @l_sub_desc    = 'CONFISCATE'
		      --      
		    END
		    ELSE IF  @I = 18
		    BEGIN
		      --
			SET @l_sub_cd   = 'SETTLEMENT-CR'
			SET @l_sub_desc    = 'DIRECT PAY IN'
			  --    
		   END    
		   ELSE IF @I = 19
		   BEGIN
		     --
		       SET @l_sub_cd      = 'SETTLEMENT-DR'
		       SET @l_sub_desc    = 'DIRECT PAY OUT'
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


    /* PR_TRATM_INS6 
      select * from transaction_type_mstr
      select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_mstr 
      DELETE FROM transaction_type_mstr 
      sp_help transaction_type_mstr8*/

GO
