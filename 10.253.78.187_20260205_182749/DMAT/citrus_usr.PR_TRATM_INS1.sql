-- Object: PROCEDURE citrus_usr.PR_TRATM_INS1
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[PR_TRATM_INS1]
                   AS
                   BEGIN
                   --
                     DECLARE
                       
                        @l_desc   VARCHAR(100)
                       ,@l_code   VARCHAR(50)
                       ,@l_name VARCHAR(30)
                       ,@l_trantm_id  NUMERIC(30)
                       ,@I  SMALLINT
                       ,@l_trastm_id NUMERIC(30)
                       ,@l_trastm_tratm_id NUMERIC(30)
                       ,@l_sub_desc   VARCHAR(100)
                       ,@l_sub_cd  VARCHAR(50) 
                       ,@l_excm_id  NUMERIC(30)
                     
                        SET  @I =1
                        SET @l_name ='HO'
                        SET @l_code='BOOKTYPE_CODE'
                        SET @l_desc ='BOOKTYPE NARRATION CODE'
                        DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'BOOKTYPE_CODE')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'BOOKTYPE_CODE'
			
                   
                   
                   SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
                   SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='NSDL'
                                      

           		                                            
           		                                            
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
	           --BEGING  @I=5
           	   WHILE @I<=5
	           BEGIN
	              --
	                 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		         SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	            IF @I = 1
		    BEGIN
		      --
		        
		        SET @l_sub_cd     = '11'
		        SET @l_sub_desc  = 'FREE'
                      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --

			SET @l_sub_cd     = '12'
			SET @l_sub_desc = 'BLOCK'
			  --      
		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --

			SET @l_sub_cd     = '13'
			SET @l_sub_desc  = 'LOCK-IN'
		      --     
		    END    
		    ELSE IF @I = 4
		    BEGIN
		      --

			SET @l_sub_cd      = '14'
			SET @l_sub_desc = 'RELEASED BLOCK'
                      --	 		
		    END 
		    ELSE IF  @I = 5
		    BEGIN
		      --
		        SET @l_sub_cd      = '15'
		        SET @l_sub_desc  = 'RELEASED LOCK-IN'
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
      
         /* EXECUTE PR_TRATM_INS1
           select * from transaction_type_mstr
           select * from transaction_sub_type_mstr
           DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
           DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
           sp_help transaction_type_mstr*/

GO
