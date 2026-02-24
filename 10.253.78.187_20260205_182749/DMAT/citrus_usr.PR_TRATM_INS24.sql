-- Object: PROCEDURE citrus_usr.PR_TRATM_INS24
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*  EXECUTE PR_TRATM_INS24
     select * from transaction_type_mstr
     select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_m
      sp_help transaction_type_mstr */
      
             
                   CREATE  PROCEDURE [citrus_usr].[PR_TRATM_INS24]
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
                        SET @l_code='DEMAT_REJ_CD_NSDL'
                        SET  @l_desc ='DEMAT REJECTION CODES NSDL'
                        SELECT @l_excm_id =excm_id FROM exchange_mstr where excm_cd='NSDL'
                        DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='DEMAT_REJ_CD_NSDL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'DEMAT_REJ_CD_NSDL'
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
	            
	            
	           
			
	           --BEGING  @I=18
           	   WHILE @I<=18
	           BEGIN
	              --
	              
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 

                   
		    IF @I = 1
		    BEGIN
		      --
		        SET @l_sub_cd    = '1'
		        SET @l_sub_desc  = 'SHARE QUANTITY NOT RECEIVED AS MENTIONED IN DRF'
                      --      
		    END 
		    ELSE IF  @I = 2
		    BEGIN
		      --
		        SET @l_sub_cd     ='2'
		        SET @l_sub_desc   ='RECEIVED QUANTITY  IS MORE THAN THE DRF QUANTITY'
	              --     
		    END    
	            ELSE IF @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd   ='3'
		        SET @l_sub_desc ='CERTIFICATES SENT ARE FAKE'
 
                    END 
		    ELSE IF  @I = 4
		    BEGIN
		      --
		        SET @l_sub_cd    = '4'
		        SET @l_sub_desc  ='CERTIFICATES SENT ARE REPORTED STOLEN'
		      --     
		    END    
		    ELSE IF @I = 5
		    BEGIN
		      --
			
			SET @l_sub_cd    = '5'
			SET @l_sub_desc  = 'DUPLICATE CERTIFICATES ALREADY ISSUED'
			
		      --      
                    END
                    ELSE IF  @I = 6
		    BEGIN
		      --
		        
		        SET @l_sub_cd    = '6'
		        SET @l_sub_desc  = 'FORGED ENDORSEMENT' 
		      --     
		    END    
		    ELSE IF @I = 7
		    BEGIN
		      --
		        SET @l_sub_cd   = '7'
			SET @l_sub_desc = 'INCORRECT HOLDER(S) NAME/PATTRER'
                      --      
		    END
		    ELSE IF  @I = 8
		    BEGIN
		      --
                        SET @l_sub_cd    = '8'
			SET @l_sub_desc  = 'CERTIFICATE DETAILS MISMATCH' 
                      --     
		    END 
		    ELSE IF  @I = 9
		    BEGIN
		      --
			SET @l_sub_cd     ='9'
			SET @l_sub_desc   ='DRF SENT TO INCORRECT REGISTRAR'
		      --     
		    END    
		    ELSE IF @I = 10
		    BEGIN
		      --
			SET @l_sub_cd   ='10'
			SET @l_sub_desc ='CERTIFICATE(S) NOT RECEIVED WITHIN 30 DAYS'

			END 
		    ELSE IF  @I = 11
		    BEGIN
		      --
			SET @l_sub_cd   = '11'
			SET @l_sub_desc  ='SIGNATURE MISMATCH'
		      --     
		    END    
		    ELSE IF @I = 12
		    BEGIN
		      --

			SET @l_sub_cd    = '12'
			SET @l_sub_desc= 'COURT INJUNCION PENDING'
			
		      --      
		   END
	           ELSE IF  @I = 13
		    BEGIN
		      --

			SET @l_sub_cd    = '13'
			SET @l_sub_desc  = 'MISCELLANEOUS' 
		      --     
		   END 
		   IF @I = 14
		    BEGIN
		      --
		        SET @l_sub_cd    = '14'
		        SET @l_sub_desc  = 'DEMAT REQUEST INITIATED UNDER WRONG ISIN'
                      --      
		    END 
		    ELSE IF  @I = 15
		    BEGIN
		      --
		        SET @l_sub_cd     ='15'
		        SET @l_sub_desc   ='ALLOTMENT/CALL MONEY PAYMENT NOT ATTACHED'
	              --     
		    END    
	            ELSE IF @I = 16
		    BEGIN
		      --
		        SET @l_sub_cd   ='16'
		        SET @l_sub_desc ='SECURITY CERTIFICATES  NOT AVAILABLE FOR DEMAT'
 
                    END 
		    ELSE IF  @I = 17
		    BEGIN
		      --
		        SET @l_sub_cd    = '17'
		        SET @l_sub_desc  ='REJECTED UNDER ACA'
		      --     
		    END    
		    ELSE IF @I = 18
		    BEGIN
		      --
			
			SET @l_sub_cd    = '18'
			SET @l_sub_desc  = 'REJECTED ON ACCOUNT OF TRANSFER CUM DEMAT'
			
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
           	    --PRINT CONVERT(VARCHAR,@I) 
                  END
                END

GO
