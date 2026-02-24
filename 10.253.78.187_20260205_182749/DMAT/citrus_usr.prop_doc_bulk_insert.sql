-- Object: PROCEDURE citrus_usr.prop_doc_bulk_insert
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin transaction
--exec [prop_doc_bulk_insert] 'B','P',54716,3,54716,3
--select * from entity_property_mstr where entpm_excpm_id in (1,2,5,6,7,8,11,12) and entpm_clicm_id = 2 and entpm_enttm_id = 54716
--select 2411(172)----
--select 2411+172 
--rollback transaction
--select * from product_mstr
--select * from exch_seg_mstr
--select * from excsm_prod_mstr  where excpm_excsm_id in (1,2,5,6) and excpm_prom_id in (1,2,3)
--select * from client_ctgry_mstr--01--INDIVIDUAL
--select * from entity_type_mstr--54723--INS--54716--CL_BR
--select * from entity_property_mstr
CREATE PROCEDURE [citrus_usr].[prop_doc_bulk_insert](@pa_lavel varchar(10)
                                     ,@pa_prop_doc varchar(10)
                                     ,@pa_source_entity numeric
                                     ,@pa_source_ctgry  numeric
                                     ,@pa_dest_entity varchar(50)
                                     ,@pa_dest_ctgry  varchar(50) --optional
                                     )
AS
BEGIN
--
  DECLARE  @@C_EXCPM          CURSOR
         , @@C_ENTTM_CLICM    CURSOR
         , @@C_PROPM          CURSOR
         , @@C_DOCM           CURSOR
         , @@C_ACCPROP        CURSOR
         , @@C_ACCDOCM        CURSOR

         , @@C_EXCPM_ID       NUMERIC
         , @@C_CLICM_ID       NUMERIC
         , @@C_ENTTM_ID       NUMERIC
         , @@SEQ              NUMERIC
         , @@C_ENTPM_PROP_ID  NUMERIC
         , @@C_ENTPM_CD       VARCHAR(25)
         , @@C_ENTPM_DESC     VARCHAR(200)
         , @@C_ENTPM_CLI_YN   CHAR(1)
         , @@C_ENTPM_RMKS     VARCHAR(250)
         , @@C_ENTPM_DATATYPE CHAR(1) 
         
         
         , @@C_DOCM_DOC_ID    NUMERIC
         , @@C_DOCM_CD        VARCHAR(25)
         , @@C_DOCM_DESC      VARCHAR(200) 
         , @@C_DOCM_RMKS      VARCHAR(250)
         
         , @@C_ACCPM_PROP_ID  NUMERIC
         , @@C_ACCPM_PROP_CD  VARCHAR(25)
         , @@C_ACCPM_PROP_DESC VARCHAR(200)
         , @@C_ACCPM_PROP_RMKS  VARCHAR(250)
         , @@C_ACCPM_DATATYPE   CHAR(1)
         
         
									, @@C_ACCDOCM_DOC_ID  NUMERIC
         , @@C_ACCDOCM_CD      VARCHAR(25)
         , @@C_ACCDOCM_DESC    VARCHAR(200)
         , @@C_ACCDOCM_RMKS    VARCHAR(250)

  IF @pa_lavel = 'B' AND @pa_prop_doc = 'P'
  BEGIN
  --
   IF @pa_source_entity <> 0 AND @pa_source_entity = 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ENTPM.ENTPM_EXCPM_ID
					FROM  ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
					WHERE ENTPM.ENTPM_DELETED_IND = 1
					AND   ENTPM.ENTPM_ENTTM_ID    = @pa_source_entity    
			--
			END
			ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ENTPM.ENTPM_EXCPM_ID
					FROM  ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
					WHERE ENTPM.ENTPM_DELETED_IND = 1
					AND   ENTPM.ENTPM_ENTTM_ID    = @pa_source_entity    
					AND   ENTPM.ENTPM_CLICM_ID    = @pa_source_ctgry    						
            --
			END
				
		  --
		  OPEN @@C_EXCPM
		  FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
		  --
		  WHILE @@FETCH_STATUS = 0
		  BEGIN--#C1
    --
      IF @pa_source_entity <> 0 AND @pa_source_ctgry <> 0
      BEGIN
      --
								SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						ELSE IF @pa_source_entity <> 0 
						BEGIN
						--
						  SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						
      
      OPEN @@C_ENTTM_CLICM
						FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
						--
						WHILE @@FETCH_STATUS = 0
						BEGIN--#C2
      --
								IF @pa_source_entity <> 0 AND @pa_source_entity = 0
								BEGIN
								--
										SET @@C_PROPM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ENTPM.ENTPM_PROP_ID
																,ENTPM.ENTPM_CD
																,ENTPM.ENTPM_DESC
																,ENTPM_CLI_YN
																,ENTPM_RMKS
																,ENTPM_DATATYPE
										FROM  ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
										WHERE ENTPM.ENTPM_DELETED_IND = 1
										AND   ENTPM.ENTPM_ENTTM_ID    = @pa_source_entity    
								--
								END
								ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
								BEGIN
								--
										SET @@C_PROPM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ENTPM.ENTPM_PROP_ID
																,ENTPM.ENTPM_CD
																,ENTPM.ENTPM_DESC
																,ENTPM.ENTPM_CLI_YN
																,ENTPM.ENTPM_RMKS
																,ENTPM.ENTPM_DATATYPE
										FROM  ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
										WHERE ENTPM.ENTPM_DELETED_IND = 1
										AND   ENTPM.ENTPM_ENTTM_ID    = @pa_source_entity    
										AND   ENTPM.ENTPM_CLICM_ID    = @pa_source_ctgry    						
								--
			     END
			     
			     OPEN @@C_PROPM
						  FETCH NEXT FROM @@C_PROPM INTO @@C_ENTPM_PROP_ID , @@C_ENTPM_CD, @@C_ENTPM_DESC,@@C_ENTPM_CLI_YN , @@C_ENTPM_RMKS , @@C_ENTPM_DATATYPE
						  WHILE @@FETCH_STATUS = 0
						  BEGIN--#C3
        --
          SELECT @@SEQ = ISNULL(MAX(entpm_id),0)+ 1
          FROM  entity_property_mstr WITH (NOLOCK)
        
          INSERT INTO entity_property_mstr
										( entpm_id
										, entpm_prop_id
										, entpm_clicm_id
										, entpm_enttm_id
										, entpm_excpm_id
										, entpm_cd
										, entpm_desc
										, entpm_cli_yn
										, entpm_mdty
										, entpm_rmks
										, entpm_created_by
										, entpm_created_dt
										, entpm_lst_upd_by
										, entpm_lst_upd_dt
										, entpm_deleted_ind
										, ENTPM_DATATYPE
		        ) 
		        VALUES
		        (@@SEQ 
		        ,@@C_ENTPM_PROP_ID
		        ,@@C_CLICM_ID
		        ,@@C_ENTTM_ID
		        ,@@C_EXCPM_ID
		        ,@@C_ENTPM_CD
		        ,@@C_ENTPM_DESC
		        ,@@C_ENTPM_CLI_YN 
		        ,0
		        ,@@C_ENTPM_RMKS
		        ,'HO'
		        ,GETDATE()
		        ,'HO'
		        ,GETDATE()
		        ,1
		        ,@@C_ENTPM_DATATYPE)
		        
          FETCH NEXT FROM @@C_PROPM INTO @@C_ENTPM_PROP_ID , @@C_ENTPM_CD, @@C_ENTPM_DESC,@@C_ENTPM_CLI_YN , @@C_ENTPM_RMKS , @@C_ENTPM_DATATYPE
        
        --
        END
        
      
								
								
        FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
      --
      END
      
      FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
    --
    END
  --
  END
  IF @pa_lavel = 'B' AND @pa_prop_doc = 'D'
  BEGIN
  --
   IF @pa_source_entity <> 0 AND @pa_source_entity = 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT DOCM.DOCM_EXCPM_ID
					FROM  DOCUMENT_MSTR  DOCM WITH (NOLOCK)
					WHERE DOCM.DOCM_DELETED_IND = 1
					AND   DOCM.DOCM_ENTTM_ID    = @pa_source_entity    
			--
			END
			ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT DOCM.DOCM_EXCPM_ID
					FROM  DOCUMENT_MSTR  DOCM WITH (NOLOCK)
					WHERE DOCM.DOCM_DELETED_IND = 1
					AND   DOCM.DOCM_ENTTM_ID    = @pa_source_entity    
					AND   DOCM.DOCM_CLICM_ID    = @pa_source_ctgry    						
			--
			END
				
		  --
		  OPEN @@C_EXCPM
		  FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
		  --
		  WHILE @@FETCH_STATUS = 0
		  BEGIN--#C1
    --
      IF @pa_source_entity <> 0 AND @pa_source_ctgry <> 0
      BEGIN
      --
								SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						ELSE IF @pa_source_entity <> 0 
						BEGIN
						--
						  SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						
      
      OPEN @@C_ENTTM_CLICM
						FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
						--
						WHILE @@FETCH_STATUS = 0
						BEGIN--#C2
      --
								IF @pa_source_entity <> 0 AND @pa_source_entity = 0
								BEGIN
								--
										SET @@C_DOCM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  DOCM.DOCM_DOC_ID
																,DOCM.DOCM_CD
																,DOCM.DOCM_DESC
																,DOCM.DOCM_RMKS
										FROM   DOCUMENT_MSTR DOCM WITH (NOLOCK)
										WHERE  DOCM.DOCM_DELETED_IND = 1
										AND    DOCM.DOCM_ENTTM_ID    = @pa_source_entity    
								--
								END
								ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
								BEGIN
								--
										SET @@C_DOCM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  DOCM.DOCM_DOC_ID
																,DOCM.DOCM_CD
																,DOCM.DOCM_DESC
																,DOCM.DOCM_RMKS
										FROM   DOCUMENT_MSTR DOCM WITH (NOLOCK)
										WHERE  DOCM.DOCM_DELETED_IND = 1
										AND    DOCM.DOCM_ENTTM_ID    = @pa_source_entity    
										AND    DOCM.DOCM_CLICM_ID    = @pa_source_ctgry    						
								--
			     END
			     
			     OPEN @@C_DOCM
						  FETCH NEXT FROM @@C_DOCM INTO @@C_DOCM_DOC_ID , @@C_DOCM_CD, @@C_DOCM_DESC, @@C_DOCM_RMKS 
						  WHILE @@FETCH_STATUS = 0
						  BEGIN--#C3
        --
          SELECT @@SEQ = ISNULL(MAX(DOCM_id),0)+ 1
          FROM  DOCUMENT_MSTR WITH (NOLOCK)
        
          INSERT INTO document_mstr
										( docm_id
										, docm_doc_id
										, docm_clicm_id
										, docm_enttm_id
										, docm_excpm_id	
										, docm_cd
										, docm_desc
										, docm_mdty
										, docm_rmks
										, docm_created_by
										, docm_created_dt
										, docm_lst_upd_by
										, docm_lst_upd_dt
										, docm_deleted_ind
	         )
		        VALUES
		        (@@SEQ 
		        ,@@C_DOCM_DOC_ID
		        ,@@C_CLICM_ID
		        ,@@C_ENTTM_ID
		        ,@@C_EXCPM_ID
		        ,@@C_DOCM_CD
		        ,@@C_DOCM_DESC
		        ,0
		        ,@@C_DOCM_RMKS
		        ,'HO'
		        ,GETDATE()
		        ,'HO'
		        ,GETDATE()
		        ,1
		        )
		        
          FETCH NEXT FROM @@C_DOCM INTO @@C_DOCM_DOC_ID , @@C_DOCM_CD, @@C_DOCM_DESC, @@C_DOCM_RMKS 
        
        --
        END
        
      
								
								
        FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
      --
      END
      
      FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
    --
    END
  --
  END
  IF @pa_lavel = 'A' AND @pa_prop_doc = 'P'
  BEGIN
  --
   IF @pa_source_entity <> 0 AND @pa_source_entity = 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ACCPM.ACCPM_EXCPM_ID
					FROM  ACCOUNT_PROPERTY_MSTR ACCPM WITH (NOLOCK)
					WHERE ACCPM.ACCPM_DELETED_IND = 1
					AND   ACCPM.ACCPM_ENTTM_ID    = @pa_source_entity    
			--
			END
			ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ACCPM.ACCPM_EXCPM_ID
					FROM  ACCOUNT_PROPERTY_MSTR ACCPM WITH (NOLOCK)
					WHERE ACCPM.ACCPM_DELETED_IND = 1
					AND   ACCPM.ACCPM_ENTTM_ID    = @pa_source_entity    
					AND   ACCPM.ACCPM_CLICM_ID    = @pa_source_ctgry    						
			--
			END
				
		  --
		  OPEN @@C_EXCPM
		  FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
		  --
		  WHILE @@FETCH_STATUS = 0
		  BEGIN--#C1
    --
      IF @pa_source_entity <> 0 AND @pa_source_ctgry <> 0
      BEGIN
      --
								SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						ELSE IF @pa_source_entity <> 0 
						BEGIN
						--
						  SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						
      
      OPEN @@C_ENTTM_CLICM
						FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
						--
						WHILE @@FETCH_STATUS = 0
						BEGIN--#C2
      --
								IF @pa_source_entity <> 0 AND @pa_source_entity = 0
								BEGIN
								--
										SET @@C_ACCPROP =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ENTPM.ENTPM_PROP_ID
																,ENTPM.ENTPM_CD
																,ENTPM.ENTPM_DESC
																,ENTPM_CLI_YN
																,ENTPM_RMKS
																,ENTPM_DATATYPE
										FROM  ENTITY_PROPERTY_MSTR ENTPM WITH (NOLOCK)
										WHERE ENTPM.ENTPM_DELETED_IND = 1
										AND   ENTPM.ENTPM_ENTTM_ID    = @pa_source_entity    
								--
								END
								ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
								BEGIN
								--
										SET @@C_ACCPROP =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ACCPM.ACCPM_PROP_ID
																,ACCPM.ACCPM_PROP_CD
																,ACCPM.ACCPM_PROP_DESC
																,ACCPM.ACCPM_PROP_RMKS
																,ACCPM.ACCPM_DATATYPE
										FROM  ACCOUNT_PROPERTY_MSTR ACCPM WITH (NOLOCK)
										WHERE ACCPM.ACCPM_DELETED_IND = 1
										AND   ACCPM.ACCPM_ENTTM_ID    = @pa_source_entity    
										AND   ACCPM.ACCPM_CLICM_ID    = @pa_source_ctgry    						
								--
			     END
			     
			     OPEN @@C_ACCPROP
						  FETCH NEXT FROM @@C_ACCPROP INTO @@C_ACCPM_PROP_ID , @@C_ACCPM_PROP_CD, @@C_ACCPM_PROP_DESC, @@C_ACCPM_PROP_RMKS , @@C_ACCPM_DATATYPE
						  WHILE @@FETCH_STATUS = 0
						  BEGIN--#C3
        --
          SELECT @@SEQ = ISNULL(MAX(ACCPM_ID),0)+ 1
          FROM  ACCOUNT_PROPERTY_MSTR WITH (NOLOCK)
           
          INSERT INTO ACCOUNT_PROPERTY_MSTR
										( ACCPM_ID
										, ACCPM_PROP_ID
										, ACCPM_CLICM_ID
										, ACCPM_ENTTM_ID
										, ACCPM_EXCPM_ID
										, ACCPM_PROP_CD
										, ACCPM_PROP_DESC
										, ACCPM_MDTY
										, ACCPM_ACCT_TYPE
										, ACCPM_DATATYPE
										, ACCPM_PROP_RMKS
										, ACCPM_CREATED_BY
										, ACCPM_CREATED_DT
										, ACCPM_LST_UPD_BY
										, ACCPM_LST_UPD_DT
										, ACCPM_DELETED_IND
           )
		        VALUES
		        (@@SEQ 
		        ,@@C_ACCPM_PROP_ID
		        ,@@C_CLICM_ID
		        ,@@C_ENTTM_ID
		        ,@@C_EXCPM_ID
		        ,@@C_ACCPM_PROP_CD
		        ,@@C_ACCPM_PROP_DESC
		        ,0
		        ,'DP'
		        ,@@C_ACCPM_DATATYPE
		        ,@@C_ACCPM_PROP_RMKS
		        ,'HO'
		        ,GETDATE()
		        ,'HO'
		        ,GETDATE()
		        ,1
		        )
		        
          FETCH NEXT FROM @@C_ACCPROP INTO @@C_ACCPM_PROP_ID , @@C_ACCPM_PROP_CD, @@C_ACCPM_PROP_DESC, @@C_ACCPM_PROP_RMKS , @@C_ACCPM_DATATYPE
        
        --
        END
        
      
								
								
        FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
      --
      END
      
      FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
    --
    END
  --
  END          
  IF @pa_lavel = 'A' AND @pa_prop_doc = 'D'
  BEGIN
  --
   IF @pa_source_entity <> 0 AND @pa_source_entity = 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ACCDOCM.ACCDOCM_EXCPM_ID
					FROM  ACCOUNT_DOCUMENT_MSTR  ACCDOCM WITH (NOLOCK)
					WHERE ACCDOCM.ACCDOCM_DELETED_IND = 1
					AND   ACCDOCM.ACCDOCM_ENTTM_ID    = @pa_source_entity    
			--
			END
			ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
			BEGIN
			--
					SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR
					SELECT DISTINCT ACCDOCM.ACCDOCM_EXCPM_ID
					FROM  ACCOUNT_DOCUMENT_MSTR  ACCDOCM WITH (NOLOCK)
					WHERE ACCDOCM.ACCDOCM_DELETED_IND = 1
					AND   ACCDOCM.ACCDOCM_ENTTM_ID    = @pa_source_entity    
					AND   ACCDOCM.ACCDOCM_CLICM_ID    = @pa_source_ctgry    						
			--
			END
				
		  --
		  OPEN @@C_EXCPM
		  FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
		  --
		  WHILE @@FETCH_STATUS = 0
		  BEGIN--#C1
    --
      IF @pa_source_entity <> 0 AND @pa_source_ctgry <> 0
      BEGIN
      --
								SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						ELSE IF @pa_source_entity <> 0 
						BEGIN
						--
						  SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR
								SELECT CLICM.CLICM_ID            CLICM_ID
													, ENTTM.ENTTM_ID            ENTTM_ID
								FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)
													, ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)
													, ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)
								WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
								AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
								AND    ENTTM.ENTTM_ID          = @pa_dest_entity 
								and    CLICM.CLICM_ID          = @pa_dest_ctgry   
								AND    CLICM.CLICM_DELETED_IND = 1
								AND    ENTTM.ENTTM_DELETED_IND = 1
								AND    ENTCM.ENTCM_DELETED_IND = 1
						--
						END
						
      
      OPEN @@C_ENTTM_CLICM
						FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
						--
						WHILE @@FETCH_STATUS = 0
						BEGIN--#C2
      --
								IF @pa_source_entity <> 0 AND @pa_source_entity = 0
								BEGIN
								--
										SET @@C_ACCDOCM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ACCDOCM.ACCDOCM_DOC_ID
																,ACCDOCM.ACCDOCM_CD
																,ACCDOCM.ACCDOCM_DESC
																,ACCDOCM.ACCDOCM_RMKS
										FROM   ACCOUNT_DOCUMENT_MSTR ACCDOCM WITH (NOLOCK)
										WHERE  ACCDOCM.ACCDOCM_DELETED_IND = 1
										AND    ACCDOCM.ACCDOCM_ENTTM_ID    = @pa_source_entity    
								--
								END
								ELSE IF @pa_source_entity <> 0 AND @pa_source_entity <> 0
								BEGIN
								--
										SET @@C_ACCDOCM =  CURSOR FAST_FORWARD FOR
										SELECT DISTINCT  ACCDOCM.ACCDOCM_DOC_ID
																,ACCDOCM.ACCDOCM_CD
																,ACCDOCM.ACCDOCM_DESC
																,ACCDOCM.ACCDOCM_RMKS
										FROM   ACCOUNT_DOCUMENT_MSTR ACCDOCM WITH (NOLOCK)
										WHERE  ACCDOCM.ACCDOCM_DELETED_IND = 1
										AND    ACCDOCM.ACCDOCM_ENTTM_ID    = @pa_source_entity    
										AND    ACCDOCM.ACCDOCM_CLICM_ID    = @pa_source_ctgry    						
								--
			     END
			     
			     OPEN @@C_ACCDOCM
						  FETCH NEXT FROM @@C_ACCDOCM INTO @@C_ACCDOCM_DOC_ID , @@C_ACCDOCM_CD, @@C_ACCDOCM_DESC, @@C_ACCDOCM_RMKS 
						  WHILE @@FETCH_STATUS = 0
						  BEGIN--#C3
        --
          SELECT @@SEQ = ISNULL(MAX(ACCDOCM_id),0)+ 1
          FROM  ACCOUNT_DOCUMENT_MSTR WITH (NOLOCK)
        
          INSERT INTO account_document_mstr
										( accdocm_id
										, accdocm_doc_id
										, accdocm_clicm_id
										, accdocm_enttm_id
										, accdocm_excpm_id	
										, accdocm_cd
										, accdocm_desc
										, accdocm_mdty
										, accdocm_rmks
										, accdocm_acct_type
										, accdocm_created_by
										, accdocm_created_dt
										, accdocm_lst_upd_by
										, accdocm_lst_upd_dt
										, accdocm_deleted_ind
	         )
		        VALUES
		        (@@SEQ 
		        ,@@C_ACCDOCM_DOC_ID
		        ,@@C_CLICM_ID
		        ,@@C_ENTTM_ID
		        ,@@C_EXCPM_ID
		        ,@@C_ACCDOCM_CD
		        ,@@C_ACCDOCM_DESC
		        ,0
		        ,@@C_ACCDOCM_RMKS
		        ,'DP'
		        ,'HO'
		        ,GETDATE()
		        ,'HO'
		        ,GETDATE()
		        ,1
		        )
		        
          FETCH NEXT FROM @@C_ACCDOCM INTO @@C_ACCDOCM_DOC_ID , @@C_ACCDOCM_CD, @@C_ACCDOCM_DESC, @@C_ACCDOCM_RMKS
        
        --
        END
        
      
								
								
        FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID
      --
      END
      
      FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID
    --
    END
  --
  END    
--
END

GO
