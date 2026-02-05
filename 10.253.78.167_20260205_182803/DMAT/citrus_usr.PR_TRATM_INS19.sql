-- Object: PROCEDURE citrus_usr.PR_TRATM_INS19
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_TRATM_INS19]
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
                        SELECT @l_excm_id = excm_id FROM exchange_mstr where excm_cd='NSDL'
                        SET @l_code='DEMAT_LOCK_CD_NSDL'
                        SET @l_desc ='DEMAT LOCKIN CODES'
                        DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='DMAT_LOCK_CD_NSDL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'DMAT_LOCK_CD_NSDL'
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
                    
                       

           	   	                                            
           		                                            
           	  
		    --BEGIN @I=10
		   WHILE @I<=10
		   BEGIN
		    --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                    
			

		    IF @I = 1
		    BEGIN
		      --
                        SET @l_sub_cd   = '00'
                        SET @l_sub_desc = 'NONE'
                      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
			    SET @l_sub_cd   = '01'
			    SET @l_sub_desc = 'DIRECTOR/RELATIVE QUOTA'
		      --      
		    END 
		    ELSE IF @I = 3
		    BEGIN
		      --
			    SET @l_sub_cd  = '02'
			    SET @l_sub_desc= 'EMPLOYEE QUOTA'

			  --      
		    END 
		    ELSE IF  @I = 4
		    BEGIN
		      --
		        SET @l_sub_cd = '03'
		        SET @l_sub_desc = 'PREFERENTIAL QUOTA'

		     --     
		    END 
		    ELSE IF @I = 5
		    BEGIN
		      --
			SET @l_sub_cd  = '04'
                        SET @l_sub_desc = 'PROMOTERS QUOTA'

                      --
		    END 
		    ELSE IF  @I = 6
		    BEGIN
		      --
			SET @l_sub_cd    = '05'
			SET @l_sub_desc  = 'UNDERWRITERS QUOTA'

			--     
		    END    
		    ELSE IF @I = 7
		    BEGIN
		      --
			SET @l_sub_cd    = '06'
			SET @l_sub_desc  = 'PROMOTERS PLACEMENT QUOTA'

		      --      
		    END
		    ELSE IF  @I = 8
		    BEGIN
		      --
			SET @l_sub_cd     = '07'
			SET @l_sub_desc   = '54EA OF IT ACT 1961'

		      --     
		    END    
		    ELSE IF @I = 9
		    BEGIN
		      --
			SET @l_sub_cd    = '08'
			SET @l_sub_desc  = '54EB OF IT ACT 1961'

		      --      
		    END
		    ELSE IF  @I = 10
		    BEGIN
		      --
		        SET @l_sub_cd  = '99'
		        SET @l_sub_desc  = 'OTHERS'

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
		  
		  
		   /* EXECUTE PR_TRATM_INS19 select * from transaction_type_mstr
		        select * from transaction_sub_type_mstr
		        DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
		        DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
		        sp_help transaction_type_mstr8*/

GO
