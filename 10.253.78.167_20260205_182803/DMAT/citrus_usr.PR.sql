-- Object: PROCEDURE citrus_usr.PR
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/* EXECUTE PR  select * from transaction_type_mstr
      select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
      DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
      select * from transaction_type_mstr where  trantm_id=11
      select * from  transaction_sub_type_mstr where  trastm_tratm_id=11
      select * from transaction_type_mstr tran*/
			
			

CREATE  PROCEDURE [citrus_usr].[PR]
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
		
            --   DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID in(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE in ('TRANS_STAT_NSDL_801','TRANS_STAT_NSDL_901','TRANS_STAT_NSDL_902','TRANS_STAT_NSDL_903','TRANS_STAT_NSDL_904','TRANS_STAT_NSDL_905','TRANS_STAT_NSDL_906','TRANS_STAT_NSDL_912','TRANS_STAT_NSDL_907','TRANS_STAT_NSDL_908','TRANS_STAT_NSDL_909','TRANS_STAT_NSDL_910','TRANS_STAT_NSDL_911','TRANS_STAT_NSDL_913',))
	     --  DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE in( 'TRANS_STAT_NSDL_801','TRANS_STAT_NSDL_901','TRANS_STAT_NSDL_902','TRANS_STAT_NSDL_903','TRANS_STAT_NSDL_904','TRANS_STAT_NSDL_905','TRANS_STAT_NSDL_906','TRANS_STAT_NSDL_912','TRANS_STAT_NSDL_907','TRANS_STAT_NSDL_908','TRANS_STAT_NSDL_909','TRANS_STAT_NSDL_910','TRANS_STAT_NSDL_911','TRANS_STAT_NSDL_913')
	         
    DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID in(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE in ('TRANS_STAT_NSDL_801','TRANS_STAT_NSDL_900','TRANS_STAT_NSDL_901','TRANS_STAT_NSDL_902','TRANS_STAT_NSDL_903','TRANS_STAT_NSDL_904','TRANS_STAT_NSDL_905','TRANS_STAT_NSDL_906','TRANS_STAT_NSDL_912','TRANS_STAT_NSDL_907','TRANS_STAT_NSDL_908','TRANS_STAT_NSDL_909','TRANS_STAT_NSDL_910','TRANS_STAT_NSDL_911','TRANS_STAT_NSDL_913','TRANS_STAT_NSDL_914','TRANS_STAT_NSDL_915','TRANS_STAT_NSDL_916','TRANS_STAT_NSDL_917','TRANS_STAT_NSDL_918','TRANS_STAT_NSDL_919','TRANS_STAT_NSDL_920','TRANS_STAT_NSDL_921','TRANS_STAT_NSDL_922','TRANS_STAT_NSDL_923','TRANS_STAT_NSDL_924','TRANS_STAT_NSDL_925','TRANS_STAT_NSDL_926','TRANS_STAT_NSDL_927','TRANS_STAT_NSDL_930','TRANS_STAT_NSDL_931','TRANS_STAT_NSDL_934','TRANS_STAT_NSDL_935','TRANS_STAT_NSDL_936','TRANS_STAT_NSDL_937'))
    DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE in( 'TRANS_STAT_NSDL_801','TRANS_STAT_NSDL_900','TRANS_STAT_NSDL_901','TRANS_STAT_NSDL_902','TRANS_STAT_NSDL_903','TRANS_STAT_NSDL_904','TRANS_STAT_NSDL_905','TRANS_STAT_NSDL_906','TRANS_STAT_NSDL_912','TRANS_STAT_NSDL_907','TRANS_STAT_NSDL_908','TRANS_STAT_NSDL_909','TRANS_STAT_NSDL_910','TRANS_STAT_NSDL_911','TRANS_STAT_NSDL_913','TRANS_STAT_NSDL_914','TRANS_STAT_NSDL_915','TRANS_STAT_NSDL_916','TRANS_STAT_NSDL_917','TRANS_STAT_NSDL_918','TRANS_STAT_NSDL_919','TRANS_STAT_NSDL_920','TRANS_STAT_NSDL_921','TRANS_STAT_NSDL_922','TRANS_STAT_NSDL_923','TRANS_STAT_NSDL_924','TRANS_STAT_NSDL_925','TRANS_STAT_NSDL_926','TRANS_STAT_NSDL_927','TRANS_STAT_NSDL_930','TRANS_STAT_NSDL_931','TRANS_STAT_NSDL_934','TRANS_STAT_NSDL_935','TRANS_STAT_NSDL_936','TRANS_STAT_NSDL_937')
		 			
      
			
      
          IF @I = 1
          BEGIN
            --
              SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
              SET @l_code = 'TRANS_STAT_NSDL_801'
              SET @l_desc = 'POOL  POOL ACCOUNT TRANSFER (VALID ONLY FROM CC’S CM POOL) TRANS STATUS'
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

            --
          END
          SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
          IF @I=1
          BEGIN
            --
              SET @l_sub_cd   = '11'
              SET @l_sub_desc  = 'CAPTURED'
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
	  IF @I=1
          BEGIN
	    --
	      SET @l_sub_cd      = '32' 
	      SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          IF @I=1
	  BEGIN
	    --
              SET @l_sub_cd     = 51
              SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	  IF @I=1
	  BEGIN
	    --
	      SET @l_sub_cd   = 54
	      SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          IF @I=1
          BEGIN
            --
              SET @l_sub_cd  = 55
	      SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       END--------------------------------------------------------------------------1 
       IF @I = 1
        BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code = 'TRANS_STAT_NSDL_900'
	     SET @l_desc = 'POOL  POOL ACCOUNT TRANSFER (VALID ONLY FROM CC’S CM POOL) TRANS STATUS'
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

	   --
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	IF @I=1
        BEGIN
        --
       SET @l_sub_cd       = '11'
       SET @l_sub_desc  = 'CAPTURED'
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
   IF @I=1
   BEGIN
    --
      SET @l_sub_cd      = '32' 
      SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
  IF @I=1
          BEGIN
          --
         SET @l_sub_cd   = '33'
         SET @l_sub_desc  = 'ACCEPTED BY NSDL'
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
     IF @I=1
     BEGIN
      --
        SET @l_sub_cd      = '35' 
        SET @l_sub_desc  = 'PARTIALLY CONFIRMED'

         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
  IF @I=1
  BEGIN
    --
       SET @l_sub_cd     = 51
       SET @l_sub_desc  = 'CLOSED,SETTED'  
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
  IF @I=1
  BEGIN
    --
      SET @l_sub_cd   = 54
      SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
   IF @I=1
   BEGIN
     --
       SET @l_sub_cd  = 55
      SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
    END-----------------------------
	 
       IF @I = 1
       BEGIN
         --
           SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
           SET @l_code  = 'TRANS_STAT_NSDL_901'
           SET @l_desc   = 'DEMAT INSTRUCTION TRANS STATUS '
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
         --
       END
       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
       IF @I=1
       BEGIN
         --
           SET @l_sub_cd       = '11'
           SET @l_sub_desc  = 'CAPTURED'
           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       IF @I=1
       BEGIN
	--
	  SET @l_sub_cd   = '12'
	  SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       IF @I=1
       BEGIN
         --
           SET @l_sub_cd      = '32'
           SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       IF @I=1
       BEGIN
         --
           SET  @l_sub_cd   = '33'
           SET @l_sub_desc  = 'ACCEPTED BY NSDL'
           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '35'
	    SET @l_sub_desc  = 'PARTIALLY CONFIRMED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

       
       
       IF @I=1
       BEGIN
         --
           SET @l_sub_cd     ='51'
           SET @l_sub_desc  = 'CLOSED,SETTED'  
           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           --
             SET @l_sub_cd   = '54'
             SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
          --
            SET @l_sub_cd  = '55'
            SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
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
                        
                        
 --------------------------------------------------------------------------2
     
      
         IF  @I = 1
         BEGIN
           --
             SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
             SET @l_code    = 'TRANS_STAT_NSDL_902'
             SET @l_desc   = 'REMAT INSTRUCTION TRANS STATUS'
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
           --
         END
         SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
         IF @I=1
         BEGIN
           --
             SET @l_sub_cd       = '11'
             SET @l_sub_desc  = 'CAPTURED'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
           --
	     SET @l_sub_cd      = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	 SET  @l_sub_cd   = '33'
	 SET @l_sub_desc  = 'ACCEPTED BY NSDL'
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
	 END
	 IF @I = 1
	 BEGIN
	   --
	    SET @l_sub_cd   = '35'
	    SET @l_sub_desc = 'PARTIALLY CONFIRMED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   ='54'
	     SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
         IF @I=1
         BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
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
                              
                              

 
--------------------------------------------------------3
      
      
      IF @I = 1
      BEGIN
        --
           SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
           SET @l_code    = 'TRANS_STAT_NSDL_903'
           SET @l_desc   = 'INTRA TRANSFER INSTRUCTION TRANS STATUS'
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
      END
      SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
      IF @I=1
      BEGIN
	--
	   SET @l_sub_cd       = '11'
	   SET @l_sub_desc  = 'CAPTURED'
	   SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      	 IF @I=1
      	 BEGIN
                 --
      	     SET @l_sub_cd      = '31'
      	     SET @l_sub_desc  = 'RELEASED'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      	 IF @I=1
      	 BEGIN
      	 SET  @l_sub_cd   = '38'
      	 SET @l_sub_desc  = 'SETTLED' 
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
      	    SET @l_sub_cd   = '40'
      	    SET @l_sub_desc  = 'OVERDUE' 
      	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
      	 BEGIN
      	   --
      	     SET @l_sub_cd     = '51'
      	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
         IF @I=1
         BEGIN
	   --
             SET @l_sub_cd   = '53'
             SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'                  
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       IF @I=1
       BEGIN
      	 --
	   SET @l_sub_cd   = '54'
	   SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
           IF @I=1
           BEGIN
      	   --
      	     SET @l_sub_cd  = 55
      	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      	 END------------------4
      	 IF @I = 1
	 BEGIN
           --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code   = 'TRANS_STAT_NSDL_904'
	     SET @l_desc   = 'DELIVERY FREE OF PAYMENT (INTER DP) INSTRUCTION TRANS STATUS'
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
         END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
		  --
	     SET @l_sub_cd      = '31'
	     SET @l_sub_desc  = 'RELEASED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	 SET  @l_sub_cd   = '32'
	 SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	 SET  @l_sub_cd   = '33'
	 SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '34'
	     SET @l_sub_desc  = 'MATCHED BY NSDL'                                                                                              
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd   ='40'
	    SET @l_sub_desc  = 'OVERDUE' 
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '41'
	     SET @l_sub_desc  = 'OVERDUE (FROM NSDL)'                               
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '53'
	     SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '54'
	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 IF @I=1
	 BEGIN
           --
             SET @l_sub_cd  = '55'
             SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         END-------------5
         IF @I = 1
	 BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_905'
	     SET @l_desc   = 'RECEIPT FREE OF PAYMENT (INTER DP) INSTRUCTION TRANS STATUS'
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
	   --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
             SET @l_sub_cd      = '31'
             SET @l_sub_desc  = 'RELEASED'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           -- 
             SET  @l_sub_cd   = '33'
             SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           --
             SET  @l_sub_cd   = '34'
             SET @l_sub_desc  = 'MATCHED BY NSDL'                                                                                              
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '40'
	     SET @l_sub_desc  = 'OVERDUE' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '41'
	     SET @l_sub_desc  = 'OVERDUE (FROM NSDL)'                               
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '53'
	     SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '54'
	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
         END-------------6
         IF @I = 1
	 BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_906'
	     SET @l_desc   = 'DELIVERY OUT INSTRUCTION TRANS STATUS'
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
	    --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd      = '31'
	     SET @l_sub_desc  = 'RELEASED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   -- '
	     SET  @l_sub_cd   = '33'
	     SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   -- '
	     SET  @l_sub_cd   = '35'
	     SET @l_sub_desc  = 'PARTIALLY ACCEPTED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '40'
	     SET @l_sub_desc  = 'OVERDUE' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '41'
	     SET @l_sub_desc  = 'OVERDUE AT DM'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '53'
	     SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '54'
	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	 END-------------7
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '56'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CC'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_912'
	     SET @l_desc   = 'IRREVERSIBLE DELIVERY OUT INSTRUCTION   TRANS STATUS'
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
	    --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	  IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST REJECTED'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd      = '31'
	     SET @l_sub_desc  = 'RELEASED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   -- 
	     SET  @l_sub_cd   = '33'
	     SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   -- '
	     SET  @l_sub_cd   = '35'
	     SET @l_sub_desc  = 'PARTIALLY ACCEPTED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd    = '36'
	    SET @l_sub_desc  = 'CANCELLATION REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '40'
	     SET @l_sub_desc  = 'OVERDUE' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '41'
	     SET @l_sub_desc  = 'OVERDUE AT DM'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '53'
	     SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '54'
	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	 END-------------7
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '56'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CC'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code  = 'TRANS_STAT_NSDL_907'
	     SET @l_desc   = 'DEMAT INSTRUCTION TRANS STATUS'
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
	   --
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd      ='32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd      ='37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '38'
	     SET @l_sub_desc  = 'SETTLED' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '41'
	     SET @l_sub_desc  = 'OVERDUE AT DM'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '53'
	     SET @l_sub_desc  = 'CLOSED,FAILED AT SETTLEMENT'

	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '54'
	     SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
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
	       
         END-----------------9
        
         IF @I = 1
	 BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_908'
	     SET @l_desc   = 'PLEDGING INSTRUCTION (PLEDGOR END - INITIATION PROCESS) TRANS STATUS'
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
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd       = '21'
		 SET @l_sub_desc  = 'RECEIVED FOR PLEDGE CONFIRMATION'
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd      = '27'
		 SET @l_sub_desc  = 'PLEDGE REQUEST,ACCEPTED '                          
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	  IF @I=1
	  BEGIN
	    --
	    SET @l_sub_cd     = '28'
	    SET @l_sub_desc  = 'PLEDGE REQUEST,REJECTED'                         
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
          IF @I=1
          BEGIN
            --
              SET @l_sub_cd   = '29'
              SET @l_sub_desc   = 'CANCELLATION REQUEST ACCEPTED'                                                
              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --     
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'CANCELLATION REQUEST IN TRANSIT TO NSDL'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	 --
	    SET  @l_sub_cd   = '33'
	    SET @l_sub_desc  = 'CANCELLATION REQUEST ACCEPTED BY NSDL'
            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd   = '38'
	    SET @l_sub_desc  = 'PLEDGED'                                            
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '54'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'
 
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  ='55'
	     SET @l_sub_desc   = 'CLOSED ,CANCELLED BY PLEDGE'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '56'
	    SET @l_sub_desc  = 'CLOSED, INVOKED BY PLEDGEE'                         
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '59'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY PLEDGEE'
                                 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1	
	 BEGIN
	   --
	     SET @l_sub_cd  = '65'
	     SET @l_sub_desc   = 'PARTIALLY CLOSED' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '66'
	    SET @l_sub_desc   = 'PARTIALLY INVOKED'                      
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '67'
	     SET @l_sub_desc   = 'PARTIALLY CLOSED/INVOKED'                                                           
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '70'
	     SET @l_sub_desc  = 'OPENED ON ACCOUNT OF AUTO CA'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
         BEGIN
          --
	    SET @l_sub_cd       = '71'
	    SET @l_sub_desc  = 'CLOSED ON ACCOUNT OF AUTO CA'

	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd      = '72'
	 SET @l_sub_desc  = 'OPENED ON ACCOUNT OF AUTO CA -BONUS'

	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
  IF @I=1
  BEGIN
  --
   SET @l_sub_cd      = '73'
   SET @l_sub_desc  = 'CLOSED ON ACCOUNT OF AUTO CA -BONUS'


   SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_909'
	     SET @l_desc   = 'HYPOTHECATION INSTRUCTION (PLEDGOR END INITIATION PROCESS) TRANS STATUS'
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
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
           --
	     SET @l_sub_cd       = '21'
	     SET @l_sub_desc  = 'RECEIVED FOR PLEDGE CONFIRMATION'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           --
             SET @l_sub_cd      = '27'
             SET @l_sub_desc  = 'PLEDGE REQUEST,ACCEPTED'                          
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
             SET @l_sub_cd     = '28'
	     SET @l_sub_desc  = 'PLEDGE REQUEST,REJECTED'                         
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '29'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST ACCEPTED'                                                
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'CANCELLATION REQUEST IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '33'
	     SET @l_sub_desc  = 'CANCELLATION REQUEST ACCEPTED BY NSDL'                                 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '34'
	     SET @l_sub_desc  = 'MATCHED BY NSDL'                                                                                              
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	    SET @l_sub_cd   = '38'
	    SET @l_sub_desc  = 'PLEDGED'                                            
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '54'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED ,CANCELLED BY PLEDGE'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '56'
	    SET @l_sub_desc  = 'CLOSED, INVOKED BY PLEDGEE'                         
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '59'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY PLEDGEE'                                                          
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1	
	 BEGIN
	   --
	     SET @l_sub_cd  = '65'
	     SET @l_sub_desc   = 'PARTIALLY CLOSED' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '66'
	    SET @l_sub_desc   = 'PARTIALLY INVOKED'                      
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   ='67'
	     SET @l_sub_desc   = 'PARTIALLY CLOSED/INVOKED'                                                           
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '70'
	     SET @l_sub_desc  = 'OPENED ON ACCOUNT OF AUTO CA'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	  BEGIN
	   --
	    SET @l_sub_cd       = '71'
	    SET @l_sub_desc  = 'CLOSED ON ACCOUNT OF AUTO CA'

	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      IF @I=1
      BEGIN
	--
	 SET @l_sub_cd      = '72'
	 SET @l_sub_desc  = 'OPENED ON ACCOUNT OF AUTO CA  BONUS'

	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      
      
      IF @I=1
      BEGIN
        --
         SET @l_sub_cd      = '73'
         SET @l_sub_desc  = 'CLOSED ON ACCOUNT OF AUTO CA -BONUS'
      
      
         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	        SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	        SET @l_code    = 'TRANS_STAT_NSDL_910'
	        SET @l_desc   = 'PLEDGE INVOCATION INSTRUCTION (PLEDGEE END INVOCATION INITIATION) TRANS STATUS'
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
	    --
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	    --
	      SET @l_sub_cd   = '11'
	      SET @l_sub_desc  = 'CAPTURED'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           --
	     SET @l_sub_cd       = '21'
	     SET @l_sub_desc  = 'INVOCATION REQUEST RECEIVED FROM PLEDGEE'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
	         SET @l_sub_cd      = '27'
	         SET @l_sub_desc  = 'INVOCATION REQUEST ACCEPTED'                          
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '28'
		 SET @l_sub_desc  = 'INVOCATION REQUEST REJECTED'                         
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
             IF @I=1
	     BEGIN
	       --
	         SET  @l_sub_cd   = '32'
	         SET @l_sub_desc  = 'CANCELLATION REQUEST IN TRANSIT TO NSDL'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --'
	         SET  @l_sub_cd   = '33'
	         SET @l_sub_desc  = 'CANCELLATION REQUEST ACCEPTED BY NSDL'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
	         SET @l_sub_cd     = '51'
	         SET @l_sub_desc  = 'CLOSED,SETTED'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
	         SET @l_sub_cd   = '54'
	         SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,CANCELLED CLIENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
	         SET @l_sub_cd   = '59'
	         SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY PLEDGEE'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     END--------------------------------12
	     IF @I = 1
	     BEGIN
	       --
		 SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
		 SET @l_code    = 'TRANS_STAT_NSDL_911'
		 SET @l_desc   = 'PLEDGE CLOSURE INSTRUCTION (PLEDGOR END) TRANS STATUS'
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
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '11'
		 SET @l_sub_desc  = 'CAPTURED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd       = '21'
		 SET @l_sub_desc  = 'RECEIVED FOR CLOSURE'
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '27'
		 SET @l_sub_desc  = 'CLOSURE REQUEST ACCEPTED'                          
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --'
		 SET @l_sub_cd  = '28'
		 SET @l_sub_desc  = 'CLOSURE REQUEST REJECTED'                         
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '32'
		 SET @l_sub_desc  = 'CANCELLATION REQUEST IN TRANSIT TO NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '33'
		 SET @l_sub_desc  = 'CANCELLATION REQUEST ACCEPTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '51'
		 SET @l_sub_desc  = 'CLOSED,SETTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '54'
		 SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,CANCELLED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '59'
		 SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY PLEDGEE'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '70'
		 SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'

		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '71'
		 SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'

		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	        SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	        SET @l_code    = 'TRANS_STAT_NSDL_913'
	        SET @l_desc   = 'NSDL TRANSFER (DELIVERY) INSTRUCTION TRANS STATUS'
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
	      --
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
             IF @I=1
             BEGIN
               --
	         SET @l_sub_cd       = '11'
	         SET @l_sub_desc  = 'CAPTURED'
	         SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '32'
		 SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '41'
		 SET @l_sub_desc  = 'OVERDUE AT DM'

		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '51'
		 SET @l_sub_desc  = 'CLOSED,SETTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '54'
		 SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLINET'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     -------------------------------------------
	     IF @I = 1
	     BEGIN
	      --
		SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
		SET @l_code    = 'TRANS_STAT_NSDL_914'
		SET @l_desc   = 'LEND / BORROW INSTRUCTION TRANS STATUS'


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
	      --
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		  IF @I=1
		  BEGIN
		    --
		 SET @l_sub_cd       = '11'
		 SET @l_sub_desc  = 'CAPTURED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '21'
		 SET @l_sub_desc  = 'RECEIVED FROM COUNTER PARTY'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '30'
		 SET @l_sub_desc  = 'RELEASED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '31'
		 SET @l_sub_desc   = 'OVERDUE'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '32'
		 SET @l_sub_desc   = 'IN TRANSIT TO NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     	   
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '33'
		 SET @l_sub_desc   = 'ACCEPTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     	   
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '34'
		 SET @l_sub_desc   = 'OVERDUE AT DM'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     		
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '40'
		 SET @l_sub_desc   = 'PARTIALLY CONFIRMED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '41'
		 SET @l_sub_desc   = 'CONFIRMED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '45'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '46'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED, ON ACCOUNT OF PENDING BONUS'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '47'
		 SET @l_sub_desc   = 'ORDER CHANGED DUE TO REDEMPTION ACA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '48'
		 SET @l_sub_desc   = 'ORDER CHANGED DUE TO BONUS ACA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '51'
		 SET @l_sub_desc   = 'CLOSED,SETTLED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '52'
		 SET @l_sub_desc   = 'CLOSED,CANCELED BY CLIENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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


	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '53'
		 SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     	     IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd  = '54'
			 SET @l_sub_desc   = 'CLOSED,REJECTED BY CLIENT'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,REJECTED BY COUNTER PARTY'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '56'
		 SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     	     IF @I=1
		     BEGIN
		       --
		 SET @l_sub_cd  = '57'
		 SET @l_sub_desc   = 'CLOSED,FAILED DURING COUNTER PARTY SETTLEMENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '58'
		 SET @l_sub_desc   = 'CLOSED,CONFIRMATION REJECTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '70'
		 SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '71'
		 SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '72'
		 SET @l_sub_desc   = 'CONFIRMED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '73'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '74'
		 SET @l_sub_desc   = 'CLOSED SETTLED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	SET @l_code    = 'TRANS_STAT_NSDL_915'
	SET @l_desc   = 'LEND / BORROW INSTRUCTION TRANS STATUS'


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
	--
	END
        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	IF @I=1
	BEGIN
	--
	 SET @l_sub_cd       = '11'
	 SET @l_sub_desc  = 'CAPTURED'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET  @l_sub_cd   = '21'
	 SET @l_sub_desc  = 'RECEIVED FROM COUNTER PARTY'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd     = '30'
	 SET @l_sub_desc  = 'RELEASED'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '31'
		 SET @l_sub_desc   = 'OVERDUE'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '32'
		 SET @l_sub_desc   = 'IN TRANSIT TO NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '33'
		 SET @l_sub_desc   = 'ACCEPTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     IF @I=1
	     BEGIN
		--
		  SET @l_sub_cd  = '34'
		  SET @l_sub_desc   = 'OVERDUE AT DM'
		  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     		
		IF @I=1
		BEGIN
	        --
		  SET @l_sub_cd  = '40'
		  SET @l_sub_desc   = 'PARTIALLY CONFIRMED'
		  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	      IF @I=1
	      BEGIN
	       --
	         SET  @l_sub_cd  = '41'
	         SET @l_sub_desc   = 'CONFIRMED'
	          SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	      
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '45'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	IF @I=1
	BEGIN
         --
	   SET @l_sub_cd  = '46'
	   SET @l_sub_desc   = 'PARTIALLY CLOSED, ON ACCOUNT OF PENDING BONUS'
	   SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	IF @I=1
	BEGIN
	--
	 SET @l_sub_cd  = '47'
	 SET @l_sub_desc   = 'ORDER CHANGED DUE TO REDEMPTION ACA'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     
	     
	IF @I=1
	BEGIN
	--
	SET @l_sub_cd  = '48'
	SET @l_sub_desc   = 'ORDER CHANGED DUE TO BONUS ACA'
	SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
      IF @I=1
      BEGIN
        --
	  SET @l_sub_cd  = '51'
	  SET @l_sub_desc   = 'CLOSED,SETTLED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	IF @I=1
	BEGIN
	--
	 SET @l_sub_cd  = '52'
	 SET @l_sub_desc   = 'CLOSED,CANCELED BY CLIENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '53'
	 SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     
	     
	IF @I=1
	 BEGIN
	       --
		 SET @l_sub_cd  = '54'
		 SET @l_sub_desc   = 'CLOSED,REJECTED BY CLIENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
    IF @I=1
    BEGIN
       --
	 SET @l_sub_cd  = '55'
	 SET @l_sub_desc   = 'CLOSED,REJECTED BY COUNTER PARTY'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '56'
	 SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '57'
	 SET @l_sub_desc   = 'CLOSED,FAILED DURING COUNTER PARTY SETTLEMENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '58'
		 SET @l_sub_desc   = 'CLOSED,CONFIRMATION REJECTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '70'
		 SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '71'
		 SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '72'
		 SET @l_sub_desc   = 'CONFIRMED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '73'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '74'
		 SET @l_sub_desc   = 'CLOSED SETTLED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
		SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
		SET @l_code    = 'TRANS_STAT_NSDL_916'
		SET @l_desc   = 'PLEDGE HYPOTHECATION CONFIRMATION INSTRUCTION TRANS STATUS'


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
	      --
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		  IF @I=1
		  BEGIN
		    --
		 SET @l_sub_cd       = '21'
		 SET @l_sub_desc  = 'RECEIVED FOR PLEDGE CONFIRMATION'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '27'
		 SET @l_sub_desc  = 'PLEDGE REQUEST, ACCEPTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '28'
		 SET @l_sub_desc  = 'PLEDGE REQUEST, REJECTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '29'
		 SET @l_sub_desc   = 'CANCELLATION REQUEST ACCEPTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '38'
		 SET @l_sub_desc   = 'PLEDGED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '51'
		 SET @l_sub_desc   = 'CLOSED,SETTLED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	    IF @I=1
	    BEGIN
	      --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,CANCELLED BY PLEDGOR'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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


		     IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd  = '56'
			 SET @l_sub_desc   = 'CLOSED,INVOKED BY PLEDGEE'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

		     IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd  = '59'
			 SET @l_sub_desc   = 'CLOSED,REJECTED'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '65'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '66'
		 SET @l_sub_desc   = 'PARTIALLY INVOKED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '67'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED/INVOKED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '70'
		 SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '71'
		 SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
		SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
		SET @l_code    = 'TRANS_STAT_NSDL_917'
		SET @l_desc   = 'PLEDGE HYPOTHECATION CONFIRMATION INSTRUCTION TRANS STATUS'


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
	      --
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		  IF @I=1
		  BEGIN
		    --
		 SET @l_sub_cd       = '21'
		 SET @l_sub_desc  = 'RECEIVED FOR PLEDGE CONFIRMATION'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '27'
		 SET @l_sub_desc  = 'PLEDGE REQUEST, ACCEPTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '28'
		 SET @l_sub_desc  = 'PLEDGE REQUEST, REJECTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
		     IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd   = '29'
			 SET @l_sub_desc   = 'CANCELLATION  REQUEST ACCEPTED'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
		     IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd  = '38'
			 SET @l_sub_desc   = 'PLEDGED'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     	   
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '51'
		 SET @l_sub_desc   = 'CLOSED,SETTLED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '55'
		 SET @l_sub_desc   = 'CLOSED,CANCELLED BY PLEDGOR'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     		
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '56'
		 SET @l_sub_desc   = 'CLOSED,INVOKED BY PLEDGEE'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '59'
		 SET @l_sub_desc   = 'CLOSED,REJECTED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     	IF @I=1
	     	BEGIN
	       --
		 SET @l_sub_cd  = '65'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd  = '66'
		 SET @l_sub_desc   = 'PARTIALLY INVOKED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
		IF @I=1
		BEGIN
		       --
		 SET @l_sub_cd  = '67'
		 SET @l_sub_desc   = 'PARTIALLY CLOSED/INVOKED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
	     
	     
		IF @I=1
		BEGIN
	     	   --
		 SET @l_sub_cd  = '70'
		 SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     
		    IF @I=1
		     BEGIN
		       --
			 SET @l_sub_cd  = '71'
			 SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'
			 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
              SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
              SET @l_code = 'TRANS_STAT_NSDL_918'
              SET @l_desc = 'PLEDGE INVOCATION CONFIRMATION TRANS STATUS'
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

            --
          END
          SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
          IF @I=1
          BEGIN
            --
              SET @l_sub_cd       = '21'
              SET @l_sub_desc  = 'INVOCATION REQUEST RECEIVED FROM PLEDGEE'
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
	  IF @I=1
          BEGIN
	    --
	      SET @l_sub_cd      = '27' 
	      SET @l_sub_desc  = 'INVOCATION REQUEST ACCEPTED'
              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          IF @I=1
	  BEGIN
	    --
              SET @l_sub_cd     = 28
              SET @l_sub_desc  = 'INVOCATION REQUEST REJECTED'  
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
	  IF @I=1
	  BEGIN
	    --
	      SET @l_sub_cd   = 51
	      SET @l_sub_desc   = 'CLOSED,SETTLED'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          IF @I=1
          BEGIN
            --
              SET @l_sub_cd  = 59
	      SET @l_sub_desc   = 'CLOSED,REJECTED BY PLEDGOR '
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	  IF @I=1
	  BEGIN
	    --
	      SET @l_sub_cd   = 70
	      SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	  IF @I=1
	  BEGIN
	  --
	    SET @l_sub_cd  = 71
            SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO CA'
            SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       END--------------------------------------------------------------------------19
       IF @I = 1
       BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code = 'TRANS_STAT_NSDL_919'
	     SET @l_desc = 'PLEDGE CLOSURE CONFIRMATION TRANS STATUS'
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

	   --
         END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '21'
	     SET @l_sub_desc  = 'RECEIVED FOR CLOSURE'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	  IF @I=1
                 BEGIN
       	    --
       	      SET @l_sub_cd      = '22' 
       	      SET @l_sub_desc  = 'CLOSURE REQUEST ACCEPTED'
                     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	  IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd      = '27' 
	      SET @l_sub_desc  = 'CLOSURE REQUEST ACCEPTED'

	       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          IF @I=1
       	  BEGIN
       	    --
	     SET @l_sub_cd     = 28
	     SET @l_sub_desc  = 'CLOSURE REQUEST REJECTED'  
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
       	  IF @I=1
       	  BEGIN
       	    --
       	      SET @l_sub_cd   = 51
       	      SET @l_sub_desc   = 'CLOSED,SETTLED'
       	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
              IF @I=1
              BEGIN
                --
                SET @l_sub_cd  = 59
       	        SET @l_sub_desc   = 'CLOSED,REJECTED BY PLEDGOR '
       	        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	      
       	  IF @I=1
       	  BEGIN
       	    --
       	      SET @l_sub_cd   = 70
       	      SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
       	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	  IF @I=1
       	  BEGIN
       	  --
       	    SET @l_sub_cd  = 71
                   SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO'
                   SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
          END----------------20
          IF @I = 1
          BEGIN
            --
            SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
            SET @l_code  = 'TRANS_STAT_NSDL_920'
            SET @l_desc   = 'RECEIPT-IN INTIMATION TRANS STATUS '
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
         --
       END
       SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
       IF @I=1
       BEGIN
         --
           SET @l_sub_cd       = '21'
           SET @l_sub_desc  = 'RECEIVED FROM NSDL'
           SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       IF @I=1
       BEGIN
	--
	  SET @l_sub_cd   = '51'
	  SET @l_sub_desc  = 'CLOSED,SETTLED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      
                        
                        
 --------------------------------------------------------------------------21
     
      
         IF  @I = 1
         BEGIN
           --
             SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
             SET @l_code    = 'TRANS_STAT_NSDL_921'
             SET @l_desc   = 'CORPORATE ACTION DEBIT  TRANS STATUS'
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
           --
         END
         SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
         IF @I=1
         BEGIN
           --
             SET @l_sub_cd   = '11'
             SET @l_sub_desc  = 'RECEIVED FROM NSDL'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '12'
	    SET @l_sub_desc  = 'TEMPORARY STATUS'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
           --
	     SET @l_sub_cd      = '32'
	     SET @l_sub_desc  = 'CONFIRMATION SENT TO NSDL'
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	
	
         IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	  BEGIN
	   --
	     SET @l_sub_cd  = '53'
	     SET @l_sub_desc   = 'BOOKING INCOMPLETE,FAILED DURING CONFIRMATION'
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   ='54'
	     SET @l_sub_desc   = 'CLOSED,REJECTED '
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
         

 
--------------------------------------------------------21
      
      
      IF @I = 1
      BEGIN
        --
           SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
           SET @l_code    = 'TRANS_STAT_NSDL_922'
           SET @l_desc   = 'CORPORATE ACTION CREDIT TRANS STATUS' 
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
      END
      SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
      
       IF @I=1
	BEGIN
	  --
	    SET @l_sub_cd       = '11'
	    SET @l_sub_desc  = 'RECEIVED FROM NSDL'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
       	 BEGIN
       	  --
       	    SET @l_sub_cd   = '12'
       	    SET @l_sub_desc  = 'TEMPORARY STATUS'
       	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	 IF @I=1
       	 BEGIN
                  --
       	     SET @l_sub_cd      = '32'
       	     SET @l_sub_desc  = 'CONFIRMATION SENT TO NSDL'
                    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       	
       	
                IF @I=1
       	 BEGIN
       	   --
       	     SET @l_sub_cd     = '51'
       	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
       	 IF @I=1
       	  BEGIN
       	   --
       	     SET @l_sub_cd  = '53'
       	     SET @l_sub_desc   = 'BOOKING INCOMPLETE,FAILED DURING CONFIRMATION'
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
       	 IF @I=1
       	 BEGIN
       	   --
       	     SET @l_sub_cd   ='54'
       	     SET @l_sub_desc   = 'CLOSED,REJECTED '
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
         END -----------------------------------------------------------22
      
      
    
      	 IF @I = 1
	 BEGIN
           --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_923'
	     SET @l_desc   = 'LOCK-IN RELEASE TRANS STATUS'
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
         END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 END ------------------------------23----------------------------
	 IF @I = 1
   BEGIN
     --
       SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
       SET @l_code = 'TRANS_STAT_NSDL_924'
       SET @l_desc = 'INITIAL PUBLIC OFFER TRANS STATUS'
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

     --
   END
   SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
   IF @I=1
   BEGIN
     --
       SET @l_sub_cd       = '11'
       SET @l_sub_desc  = 'CAPTURED'
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
IF @I=1
BEGIN
--
SET @l_sub_cd      = '32'
SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
   IF @I=1
BEGIN
--
       SET @l_sub_cd     = '33'
       SET @l_sub_desc  = 'ACCEPTED BY NSDL'
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
IF @I=1
BEGIN
--
SET @l_sub_cd   = '34'
SET @l_sub_desc   = 'NON PAYMENT IN NSDL'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
   IF @I=1
   BEGIN
     --
       SET @l_sub_cd  ='35'
SET @l_sub_desc   = 'NON PAYMENT ACCEPTED'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
   BEGIN
     --
       SET @l_sub_cd   = '51'
       SET @l_sub_desc   = 'CLOSED, FULL/PARTIAL ALLOTTED'
       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
      BEGIN
	--
	  SET @l_sub_cd   =  '52'
	  SET @l_sub_desc   = 'SUSPENSE BOOKED/BOOKING FAILED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
      BEGIN
	--
	  SET @l_sub_cd   = '53'
	  SET @l_sub_desc   = 'NON PAYMENT REJECTED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
      BEGIN
	--
	  SET @l_sub_cd   = '54'
	  SET @l_sub_desc   = 'REJECTED BY NSDL'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
      BEGIN
	--
	  SET @l_sub_cd   = '55'
	  SET @l_sub_desc   = 'CLOSED,CANCELLED'
	  SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '58'
	     SET @l_sub_desc   = 'CLOSED, NOT ALLOTTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   =  '59'
	     SET @l_sub_desc   = 'CLOSED, REJECTED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

------------------------------------------------------------------
IF @I = 1
BEGIN
  --
    SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
    SET @l_code  = 'TRANS_STAT_NSDL_925'
    SET @l_desc   = 'INTER DEPOSITORY TRANS STATUS '
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
  --
END


SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
IF @I=1
BEGIN
  --
    SET @l_sub_cd       = '11'
    SET @l_sub_desc  = 'CAPTURED'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
--
SET @l_sub_cd   = '21'
SET @l_sub_desc  = 'RECEIVED FROM NSDL'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
  --
    SET @l_sub_cd      = '25'
    SET @l_sub_desc  = 'CONFIRMATION CAPTURED'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

IF @I=1
BEGIN
  --
    SET  @l_sub_cd   = '31'
    SET @l_sub_desc  = 'RELEASED'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
  --
    SET  @l_sub_cd   = '32'
    SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
  --
    SET  @l_sub_cd   = '33'
    SET @l_sub_desc  = 'ACCEPTED BY NSDL'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
SET @l_sub_cd    = '34'
SET @l_sub_desc  = 'MATCHED BY NSDL'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
SET @l_sub_cd    = '35'
SET @l_sub_desc  = 'SENT TO CDSL'
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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



IF @I=1
BEGIN
  --
    SET @l_sub_cd     ='36'
    SET @l_sub_desc  = 'MATCHED BY CDSL, AWAITING SHR CONFIRMATION'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
  IF @I=1
  BEGIN
    --
      SET @l_sub_cd   = '37'
      SET @l_sub_desc   = 'FUTURE DATED ORDER RECEIVED BY NSDL'
      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
  IF @I=1
  BEGIN
   --
     SET @l_sub_cd  = '40'
     SET @l_sub_desc   = 'OVERDUE'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '41'
	      SET @l_sub_desc   = 'OVERDUE AT DM'
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

   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '51'
	      SET @l_sub_desc   = 'CLOSED,SETTLED'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '53'
	      SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '54'
	      SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '55'
	      SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '56'
	      SET @l_sub_desc   = 'CLOSED,REJECTED BY CDSL'
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
   IF @I=1
	   BEGIN
	    --
	      SET @l_sub_cd  = '57'
	      SET @l_sub_desc   = 'CLOSED,REJECTED BY SHR'
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



------------------*************26
IF @I = 1
 BEGIN
   --
     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
     SET @l_code  = 'TRANS_STAT_NSDL_926'
     SET @l_desc   = 'INTER DEPOSITORY TRANS STATUS '
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
   --
 END


 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
 IF @I=1
 BEGIN
   --
     SET @l_sub_cd       = '11'
     SET @l_sub_desc  = 'CAPTURED'
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
 IF @I=1
 BEGIN
--
SET @l_sub_cd   = '21'
SET @l_sub_desc  = 'RECEIVED FROM NSDL'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
 IF @I=1
 BEGIN
   --
     SET @l_sub_cd      = '25'
     SET @l_sub_desc  = 'CONFIRMATION CAPTURED'
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

 IF @I=1
 BEGIN
   --
     SET  @l_sub_cd   = '31'
     SET @l_sub_desc  = 'RELEASED'
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
  --
    SET  @l_sub_cd   = '32'
    SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
IF @I=1
BEGIN
  --
    SET  @l_sub_cd   = '33'
    SET @l_sub_desc  = 'ACCEPRTED BY NSDL'
    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
SET @l_sub_cd    = '34'
SET @l_sub_desc  = 'MATCHED BY NSDL'
SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
SET @l_sub_cd    = '35'
SET @l_sub_desc  = 'SENT TO CDSL'
      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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



 IF @I=1
 BEGIN
   --
     SET @l_sub_cd     ='36'
     SET @l_sub_desc  = 'MATCHED BY CDSL, AWAITING SHR CONFIRMATION'
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
   IF @I=1
   BEGIN
     --
       SET @l_sub_cd   = '37'
       SET @l_sub_desc   = 'FUTURE DATED ORDER RECEIVED BY NSDL'
       SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
   IF @I=1
   BEGIN
    --
      SET @l_sub_cd  = '40'
      SET @l_sub_desc   = 'OVERDUE'
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
    IF @I=1
	    BEGIN
	     --
	       SET @l_sub_cd  = '41'
	       SET @l_sub_desc   = 'OVERDUE AT DM'
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

    IF @I=1
	    BEGIN
	     --
	       SET @l_sub_cd  = '51'
	       SET @l_sub_desc   = 'CLOSED,SETTLED'
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
    IF @I=1
	    BEGIN
	     --
	       SET @l_sub_cd  = '53'
	       SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
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
    IF @I=1
	    BEGIN
	     --
	       SET @l_sub_cd  = '54'
	       SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
    IF @I=1
	    BEGIN
	     --
	       SET @l_sub_cd  = '55'
	       SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
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
    IF @I=1
    BEGIN
     --
       SET @l_sub_cd  = '56'
       SET @l_sub_desc   = 'CLOSED,REJECTED BY CDSL'
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
    IF @I=1
    BEGIN
      --
      SET @l_sub_cd  = '57'
      SET @l_sub_desc   = 'CLOSED,REJECTED BY SHR'
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
	SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	SET @l_code    = 'TRANS_STAT_NSDL_927'
	SET @l_desc   = 'AUTO DO INSTRUCTION TRANS STATUS'


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
      --
     END
     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	  IF @I=1
	  BEGIN
	    --
	 SET @l_sub_cd       = '21'
	 SET @l_sub_desc  = 'RECEIVED FROM NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET  @l_sub_cd   = '33'
	 SET @l_sub_desc  = 'ACCEPTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd     = '35'
	 SET @l_sub_desc  = 'PARTIALLY ACCEPTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd   = '41'
	 SET @l_sub_desc   = 'OVERDUE FROM NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '51'
	 SET @l_sub_desc   = 'CLOSED,SETTLED'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	       --
	 SET @l_sub_cd  = '53'
	 SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	   --
	 SET @l_sub_cd  = '54'
	 SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '55'
	 SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         END-----------------------------------------------------------------------
         
       IF @I = 1
	     BEGIN
	      --
		SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
		SET @l_code    = 'TRANS_STAT_NSDL_930'
		SET @l_desc   = 'DEFFERED DELIVERY ORDER INSTRUCTION TRANS STATUS'


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
	      --
	     END
	     SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
		  IF @I=1
		  BEGIN
		    --
		 SET @l_sub_cd       = '11'
		 SET @l_sub_desc  = 'CAPTURED'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET  @l_sub_cd   = '32'
		 SET @l_sub_desc  = 'IN TRANSIT TO NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd     = '33'
		 SET @l_sub_desc  = 'ACCEPTED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     IF @I=1
	     BEGIN
	       --
		 SET @l_sub_cd   = '37'
		 SET @l_sub_desc   = 'FUTURE DATED ORDER RECEIVED BY NSDL'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	   IF @I=1
	   BEGIN
	       --
	 SET @l_sub_cd  = '39'
	 SET @l_sub_desc   = 'CONFIRMATION SENT TO NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	       --
	 SET @l_sub_cd  = '41'
	 SET @l_sub_desc   = 'OVERDUE AT DM'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
       --
	 SET @l_sub_cd  = '42'
	 SET @l_sub_desc   = 'CONFIRMATION ACCEPTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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


	IF @I=1
	BEGIN
	       --
	 SET @l_sub_cd  = '51'
	 SET @l_sub_desc   = 'CLOSED,SETTLED'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '52'
	 SET @l_sub_desc   = 'CONFIRMATION REJECTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	 IF @I=1
	 BEGIN
	       --
		 SET @l_sub_cd  = '53'
		 SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
		 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     IF @I=1
     BEGIN
       --
	 SET @l_sub_cd  = '54'
	 SET @l_sub_desc   = 'CLOSED REJECTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	       --
	 SET @l_sub_cd  = '55'
	 SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	SET @l_code    = 'TRANS_STAT_NSDL_931'
	SET @l_desc   = 'DEFFERED DELIVERY OUT INTIMATION TRANS STATUS'


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
       --
      END
      SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	  IF @I=1
	  BEGIN
	    --
	 SET @l_sub_cd       = '10'
	 SET @l_sub_desc  = 'INTIMATION RECEIVED FROM NSDL'

	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      IF @I=1
      BEGIN
	--
	 SET  @l_sub_cd   = '11'
	 SET @l_sub_desc  = 'INTIMATION CANCELLED'

	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
      IF @I=1
     BEGIN
	--
	 SET @l_sub_cd  = '51'
	 SET @l_sub_desc   = 'CLOSED,SETTLED'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	       --
	 SET @l_sub_cd  = '53'
	 SET @l_sub_desc   = 'CLOSED,FAILED DURING SETTLEMENT'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

	IF @I=1
	BEGIN
	   --
	 SET @l_sub_cd  = '54'
	 SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
	 SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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

      
         -------------------------------------------------------------------------------------------------------------------
         IF @I = 1
	 BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_934'
	     SET @l_desc   = 'CM POOL TO CM POOL TRANS STATUS'
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
	   --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
        
         IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           -- 
             SET  @l_sub_cd   = '33'
             SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
         BEGIN
           --
             SET  @l_sub_cd   = '34'
             SET @l_sub_desc  = 'MATCHED BY NSDL'                                                                                              
             SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
         IF @I=1
	  BEGIN
	    --
	      SET  @l_sub_cd   = '37'
	      SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'                                                                                              
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
     SET @l_sub_cd   = '41'
     SET @l_sub_desc  = 'OVERDUE AT DM'                               
     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 
	 
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '53'
	     SET @l_sub_desc  = 'CLOSED,FAILED DURING SETTLEMENT'  
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
	 
	 
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '54'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_935'
	     SET @l_desc   = 'CM POOL TO CM POOL TRANS STATUS'
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
	    --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET @l_sub_cd       = '11'
	 	     SET @l_sub_desc  = 'CAPTURED'
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	         
	          IF @I=1
	 	 BEGIN
	 	   --
	 	     SET  @l_sub_cd   = '32'
	 	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	          IF @I=1
	          BEGIN
	            -- 
	              SET  @l_sub_cd   = '33'
	              SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
	              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	          IF @I=1
	          BEGIN
	            --
	              SET  @l_sub_cd   = '34'
	              SET @l_sub_desc  = 'MATCHED BY NSDL'                                                                                              
	              SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	          IF @I=1
	 	  BEGIN
	 	    --
	 	      SET  @l_sub_cd   = '37'
	 	      SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL'                                                                                              
	 	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	      SET @l_sub_cd   = '41'
	      SET @l_sub_desc  = 'OVERDUE AT DM'                               
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '53'
	     SET @l_sub_desc  = 'CLOSED,FAILED AT SETTLEMENT'  
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


	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd   = '54'
	     SET @l_sub_desc   = 'CANCELLATION REQUEST REJECTED BY NSDL'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code    = 'TRANS_STAT_NSDL_936'
	     SET @l_desc   = 'FREEZE STATUS TRANS STATUS'
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
	    --  
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd       = '11'
	     SET @l_sub_desc  = 'CAPTURED'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd      = '21'
	     SET @l_sub_desc  = 'RECEIVED FROM NSDL'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   --
	     SET  @l_sub_cd   = '32'
	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	 BEGIN
	   -- 
	     SET  @l_sub_cd   = '33'
	     SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '37'
	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL' 
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	     SET @l_sub_cd   = '38'
	     SET @l_sub_desc   = 'FREEZED'                  
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 
	 
	 
	 
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd     = '51'
	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	
	 	 
	 IF @I=1
	 BEGIN
	  --
	    SET @l_sub_cd   = '54'
	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 IF @I=1
	 BEGIN
	   --
	     SET @l_sub_cd  = '55'
	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 IF @I=1
	  BEGIN
	    --
	      SET @l_sub_cd   = 70
	      SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	  IF @I=1
	  BEGIN
	  --
	    SET @l_sub_cd  = 71
	    SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO'
	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       END----------------20
         IF @I = 1
	 BEGIN
	   --
	     SELECT @l_trantm_id = ISNULL(MAX(trantm_id),0)+1 FROM transaction_type_mstr
	     SET @l_code  = 'TRANS_STAT_NSDL_937'
	     SET @l_desc   = 'FREEZE STATUS TRANS STATUS'
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
	   --
	 END
	 SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
	 	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET @l_sub_cd       = '11'
	 	     SET @l_sub_desc  = 'CAPTURED'
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET @l_sub_cd      = '21'
	 	     SET @l_sub_desc  = 'RECEIVED FROM NSDL'
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET  @l_sub_cd   = '32'
	 	     SET @l_sub_desc  = 'IN TRANSIT TO NSDL'                                  
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	 IF @I=1
	 	 BEGIN
	 	   -- 
	 	     SET  @l_sub_cd   = '33'
	 	     SET @l_sub_desc  = 'ACCEPTED BY NSDL'                                 
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	     SET @l_sub_cd   = '37'
	 	     SET @l_sub_desc  = 'FUTURE DATED ORDER RECEIVED BY NSDL' 
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	     SET @l_sub_cd   = '38'
	 	     SET @l_sub_desc   = 'FREEZED'                  
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	 
	 	 
	 	 
	 	 
	 	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET @l_sub_cd     = '51'
	 	     SET @l_sub_desc  = 'CLOSED,SETTED'  
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
	 	 
	 	 	 
	 	 IF @I=1
	 	 BEGIN
	 	  --
	 	    SET @l_sub_cd   = '54'
	 	    SET @l_sub_desc   = 'CLOSED,REJECTED BY NSDL'
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
	 	 IF @I=1
	 	 BEGIN
	 	   --
	 	     SET @l_sub_cd  = '55'
	 	     SET @l_sub_desc   = 'CLOSED,CANCELLED BY CLIENT'
	 	     SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	 IF @I=1
	 	  BEGIN
	 	    --
	 	      SET @l_sub_cd   = 70
	 	      SET @l_sub_desc   = 'OPENED ON ACCOUNT OF AUTO CA'
	 	      SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
	 	  IF @I=1
	 	  BEGIN
	 	  --
	 	    SET @l_sub_cd  = 71
	 	    SET @l_sub_desc   = 'CLOSED ON ACCOUNT OF AUTO'
	 	    SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr
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
       END----------------20
	 
	END

GO
