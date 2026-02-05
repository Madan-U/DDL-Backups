-- Object: PROCEDURE citrus_usr.PR_TRATM_INS2
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*  EXECUTE PR_TRATM_INS2 
     select * from transaction_type_mstr
     select * from transaction_sub_type_mstr
      DELETE FROM transaction_sub_type_m
      sp_help transaction_type_mstr8 */
      
             
                   CREATE  PROCEDURE [citrus_usr].[PR_TRATM_INS2]
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
                        SET @l_code='NARR_CODE'
                        SET  @l_desc ='BOOKING NARRATION CODE'
                        SELECT @l_excm_id =excm_id FROM exchange_mstr where excm_cd='NSDL'
                        DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='NARR_CODE')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'NARR_CODE'
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
	            
	            
	           
			
	           --BEGING  @I=90
           	   WHILE @I<=90
	           BEGIN
	              --
	              
			SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
			SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 

                   
		    IF @I = 1
		    BEGIN
		      --
		        SET @l_sub_cd    = '011'
		        SET @l_sub_desc  = 'DEMAT REQUEST '
                      --      
		    END 
		    ELSE IF  @I = 2
		    BEGIN
		      --
		        SET @l_sub_cd     = '012'
		        SET @l_sub_desc  = 'DEMAT  ACCEPTANCE'
	              --     
		    END    
	            ELSE IF @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd   = '013'
		        SET @l_sub_desc = 'DEMAT REJECTION/CANCELLTION '
 
                    END 
		    ELSE IF  @I = 4
		    BEGIN
		      --
		        SET @l_sub_cd   = '021'
		        SET @l_sub_desc  = 'REMAT  REQUEST'
		      --     
		    END    
		    ELSE IF @I = 5
		    BEGIN
		      --
			
			SET @l_sub_cd    = '022'
			SET @l_sub_desc= 'REMAT  ACCEPTANCE '
			
		      --      
                    END
                    ELSE IF  @I = 6
		    BEGIN
		      --
		        
		        SET @l_sub_cd    = '023'
		        SET @l_sub_desc  = 'REMAT REJECTION/CANCELLTION' 
		      --     
		    END    
		    ELSE IF @I = 7
		    BEGIN
		      --
		        SET @l_sub_cd  = '031'
			SET @l_sub_desc  = 'INTRA DELIVERY FOR OFF MARKET TRADE '
                      --      
		    END
		    ELSE IF  @I = 8
		    BEGIN
		      --
                        SET @l_sub_cd     = '032'
			SET @l_sub_desc  = 'INTRA RECEIPT FOR OFF MARKET TRADE ' 
                      --     
		    END    
		    ELSE IF @I = 9
		    BEGIN
		      --
			SET @l_sub_cd    = '033'
			SET @l_sub_desc  = 'INTRA DELIVERY FOR OFF MARKET /MARKET TRADE'
		      --
		    END
                    ELSE IF  @I = 10
		    BEGIN
		      --
		        SET @l_sub_cd     = '034'
		        SET @l_sub_desc  = 'INTRA RECEIPT FOR OFF  MARKET /MARKET TRADE '
                        		        
		       --     
		    END    
		    ELSE IF @I = 11
		    BEGIN
		      --
			SET @l_sub_cd     = '041'
			SET @l_sub_desc  = 'INTRA DELIVERY FOR OFF MARKET /MARKET TRADE '
			
		      --      
                    END
                    ELSE IF  @I = 12
		    BEGIN
		      --
		        SET @l_sub_cd     = '042'
		        SET @l_sub_desc  = 'INTRA DELIVERY FOR OFF  MARKET /MARKET TRADE (FINAL)'
		        
		      --     
		    END    
		    ELSE IF @I = 13
		    BEGIN
		      --
	                SET @l_sub_cd    = '043'
			SET @l_sub_desc  = 'INTER TRANSFER REJECTION / CANCELLATION'
			
		      --      
                    END
                    ELSE IF @I = 14             
                    BEGIN
		      --
		       
		       SET @l_sub_cd    = '044'
		       SET @l_sub_desc  = 'INTER RECEIPT FOR OFF MARKET / MARKET  TRADE'
		      
		    END    
		    ELSE IF @I = 15
		    BEGIN
		      --
			SET @l_sub_cd   = '051'
			SET @l_sub_desc  = 'DELIVERY - OUT' 
			
                    END
                    ELSE IF @I = 16             
		    BEGIN
		      --
		        SET @l_sub_cd    = '052'
		        SET @l_sub_desc  = 'DEBIT FOR DELIVERY FOR SETTLEMENT NUMBER'
		      --
		    END  
		    ELSE IF @I = 17
		    BEGIN
		      --
			SET @l_sub_cd     = '053'
			SET @l_sub_desc  = 'DELIVERY-OUT CANCELLATION / REJECTION' 
		      --      
                    END
                    ELSE IF @I = 18
                    BEGIN
		     --
		       SET @l_sub_cd     = '054'
		       SET @l_sub_desc  = 'DELIVERY OUT INITIAL BOOKING'
		     --
		    END    
		    ELSE IF @I = 19
		    BEGIN
		      --
			SET @l_sub_cd     = '055'
			SET @l_sub_desc  = 'DELIVERY OUT ACKNOWLEDGMENT BOOKING '
			
		      --      
                    END 
                    ELSE IF @I = 20
		    BEGIN
	              --		
			
			SET @l_sub_cd   = '056'
			SET @l_sub_desc  = 'DELIVERY OUT REJECTION BOOKING'
			
                      --		    
		    END    
		    ELSE IF @I = 21
		    BEGIN
		      --
			
			SET @l_sub_cd    = '057'
			SET @l_sub_desc  = 'DELIVERY OUT CANCELLATION BOOKING'
			
		      --      
                    END 
                    ELSE IF @I = 22
		    BEGIN
		      --		
			
			SET @l_sub_cd     = '061'
			SET @l_sub_desc  = 'RECEIPT IN INITIAL BOOKING'
			
			  --		    
		    END    
		    ELSE IF @I = 23
		    BEGIN
		      --
			
			SET @l_sub_cd    = '062'
			SET @l_sub_desc  = 'CREDIT FOR RECEIPT FOR SETTLEMENT NUMBER'
			
		      --      
                    END 
                    ELSE IF @I = 24
		    BEGIN
		      --		
			
			SET @l_sub_cd     = '071'
			SET @l_sub_desc  = 'INTER SETTLEMENT DELIVERY'
			
			  --		    
		    END    
		    ELSE IF @I = 25
		    BEGIN
		      --
			
			SET @l_sub_cd     = '072'
			SET @l_sub_desc  = 'INTER SETTLEMENT RECEIPT'
			
		      --      
                    END 
                    ELSE IF @I = 26
		    BEGIN
		      --		
			
			SET @l_sub_cd     = '073'
			SET @l_sub_desc  = 'INTER SETTLEMENT INITIAL BOOKING'
			
			  --		    
		    END    
		    ELSE IF @I = 27
		    BEGIN
		      --
			
			SET @l_sub_cd    = '074'
			SET @l_sub_desc  = 'INTER SETTLEMENT ACCEPTANCE BOOKING'
			
		      --      
                    END 
                    ELSE IF @I = 28
		    BEGIN
		      --		
			
			SET @l_sub_cd     = '075'
			SET @l_sub_desc = 'INTER SETTLEMENT REJECTION BOOKING'
		      --		    
		    END    
		    ELSE IF @I = 29
		    BEGIN
		      --
			
			SET @l_sub_cd    = '076'
			SET @l_sub_desc = 'INTER SETTLEMENT FINAL BOOKING'
			
		      --      
                    END 
                    
                    ELSE IF @I = 30
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '082'
			SET @l_sub_desc  = 'CORPORATE ACTION - CREDIT'
			
	              --		    
		    END    
		    ELSE IF @I = 31
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '083'
			SET @l_sub_desc  = 'CORPORATE ACTION - DEBIT'
			
		      --      
                    END 
                    ELSE IF @I = 32
		    BEGIN
		      --		
			
			SET  @l_sub_cd    = '085'
			SET @l_sub_desc  = 'CREDIT FOR IPO'
			
		       --		    
		    END    
		    ELSE IF @I = 33
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '091'
			SET @l_sub_desc  = 'PLEDGE REQUEST'
			
		      --      
                    END 
                    ELSE IF @I = 34
		    BEGIN
		      --		
		        
		        SET  @l_sub_cd     = '092'
		        SET @l_sub_desc = 'PLEDGE CLOSURE / REJECTION / CANCELLATION'
		    
		      --		    
		    END    
	            ELSE IF @I = 35
	            BEGIN
	              --
		        
		        SET  @l_sub_cd     = '093'
		        SET @l_sub_desc  = 'PLEDGE INVOCATION - DELIVERY'
		       
	              --      
                    END 
                    ELSE IF @I = 36
	            BEGIN
	              --
		        
		        SET  @l_sub_cd     = '094'
		        SET @l_sub_desc  = 'PLEDGE INVOCATION - RECEIPT'
		       
	              --      
	            END 
		    ELSE IF @I = 37
                    BEGIN
	              --		
	                
	                SET  @l_sub_cd     = '101'
	                SET @l_sub_desc  = 'RELEASE OF LOCKED IN POSITION (BENEFICIARY)'
	              
	              --		    
		    END    
	            ELSE IF @I = 38
	            BEGIN
	              --
	                
	                SET  @l_sub_cd     = '102'
	                SET @l_sub_desc  = 'RELEASE OF LOCKED IN POSITION (PLEDGE)'
	               
	             --      
                    END 
                    ELSE IF @I = 39
	            BEGIN
	              --		
		        
		        SET  @l_sub_cd    = '103'
		        SET @l_sub_desc  = 'RELEASE OF LOCKED IN POSITION (REMAT)'
		        
	              --		    
	            END    
		    ELSE IF @I = 40
		    BEGIN
		      --
		        
		        SET  @l_sub_cd     = '111'
		        SET @l_sub_desc  = 'DELAYED PAY-OUT DELIVERY'
		       
		      --      
                    END 
                    ELSE IF @I = 41
		    BEGIN
		      --		
		        
		        SET  @l_sub_cd     = '112'
		        SET @l_sub_desc = 'DELAYED PAY-OUT DELIVERY (FINAL)'
		       
		      --		    
		    END    
		    ELSE IF @I = 42
		    BEGIN
		      --
		        
		        SET  @l_sub_cd     = '113'
		        SET @l_sub_desc = 'DELAYED PAY-OUT REJECTION'
		     
		      --      
                    END 
                    ELSE IF @I = 43
		    BEGIN
		      --		
		        
		        SET  @l_sub_cd    = '114'
		        SET @l_sub_desc  = 'DELAYED PAY-OUT RECEIPT'
		        
		      --		    
		    END    
		    ELSE IF @I = 44
		    BEGIN
		      --
		        
		        SET  @l_sub_cd    = '115'
		        SET @l_sub_desc  = 'TO DELAYED PAY-OUT(FINAL)'
		      
		      --      
                    END 
                    ELSE IF @I = 45
		    BEGIN
		      --		
		        
		        SET  @l_sub_cd    = '121'
		        SET @l_sub_desc  = 'NSDL POOL DELIVERY'
		      
		      --		    
		    END    
		    ELSE IF @I = 46
		    BEGIN
		      --
		        
		        SET @l_sub_cd     = '122'
		        SET @l_sub_desc = 'NSDL POOL DELIVERY (FINAL)'
		      
		      --      
                    END 
                    ELSE IF @I = 47
		    BEGIN
		      --
		        
		        SET  @l_sub_cd     = '123'
		        SET @l_sub_desc = 'NSDL POOL REJECTION'
		       
		      --      
		    END 
		    ELSE IF @I = 48
		    BEGIN
		      --		
		       
		        SET  @l_sub_cd     = '124'
		        SET @l_sub_desc  = 'NSDL POOL RECEIPT'
		     
		      --		    
		    END    
		    ELSE IF @I = 49
		    BEGIN
		      --
		        
		        SET  @l_sub_cd    = '125'
		        SET @l_sub_desc  = 'TO NSDL POOL(FINAL)'
		        
		      --      
                    END 
                    ELSE IF @I = 50
		    BEGIN
		      --		
		        
		        SET  @l_sub_cd     = '151'
		        SET @l_sub_desc = 'LEND INITIAL'
		       
		      --		    
		    END    
		    ELSE IF @I = 51
		    BEGIN
		      --
		       
		        SET  @l_sub_cd    = '152'
		        SET @l_sub_desc  = 'LEND ACKNOWLEDGEMENT - ACCEPTANCE'
		      
		      --      
                    END 
                    ELSE IF @I = 52
		    BEGIN
		      --		
			
			SET  @l_sub_cd  = '153'
			SET @l_sub_desc  = 'LEND ACKNOWLEDGEMENT - REJECTION'
			
		      --		    
		    END    
		    ELSE IF @I = 53
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '154'
			SET @l_sub_desc  = 'LEND CONFIRMATION - INTERMEDIARY'
			
		      --      
                    END 
                    ELSE IF @I = 54
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '155'
			SET @l_sub_desc = 'LEND CONFIRMATION - ACCEPTANCE'
			
		      --		    
		    END    
		    ELSE IF @I = 55
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '156'
			SET @l_sub_desc  = 'LEND CONFIRMATION - REJECTION'
			
		      --      
                    END 
                    ELSE IF @I = 56
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '157'
			SET @l_sub_desc  = 'LEND INITIAL AND ACCEPTANCE'
			
		      --      
			END 
		    ELSE IF @I = 57
	            BEGIN
		      --		
			
			SET  @l_sub_cd     = '161'
			SET @l_sub_desc  = 'BORROW CONFIRMATION - INITIAL (FOR NON-CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 58
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '162'
			SET @l_sub_desc = 'BORROW CONFIRMATION - ACCEPTANCE (FOR NON-CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 59
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '163'
			SET @l_sub_desc= 'BORROW CONFIRMATION - REJECTION (FOR NON-CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 60
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '164'
			SET @l_sub_desc  = 'BORROW CONFIRMATION (FOR NON-CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 61
		    BEGIN
		      --		
			
			SET  @l_sub_cd    = '165'
			SET @l_sub_desc  = 'BORROW CONFIRMATION  -ACCEPTANCE (FOR NON CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 62
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '171'
			SET @l_sub_desc  = 'SLB CLOSURE  - INITIAL (FOR NON-CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 63
		    BEGIN
		      --		
			
			SET  @l_sub_cd    = '172'
			SET @l_sub_desc  = 'SLB CLOSURE - ACCEPTANCE (FOR NON-CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 64
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '173'
			SET @l_sub_desc  = 'SLB CLOSURE - REJECTION(FOR NON-CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 65
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '174'
			SET @l_sub_desc  = 'SLB CLOSURE(FOR NON-CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 66
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '175'
			SET @l_sub_desc  = 'SLB CLOSURE - ACCEPTANCE (FOR NON CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 67
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '181'
			SET @l_sub_desc  = 'BORROW CONFIRMATION - INITIAL (FOR CM CLIENT)'
			

		      --      
		    END 
		    ELSE IF @I = 68
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '182'
			SET @l_sub_desc = 'BORROW CONFIRMATION - ACCEPTANCE (FOR CM CLIENT)'
		
		      --      
		    END 
		    ELSE IF @I = 69
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '183'
			SET @l_sub_desc  = 'BORROW CONFIRMATION - REJECTION (FOR CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 70
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '184'
			SET @l_sub_desc  = 'BORROW CONFIRMATION (FOR CM CLIENT)'
			

		      --		    
		    END    
	            ELSE IF @I = 71
	            BEGIN
	              --
		       
		        SET  @l_sub_cd     = '185'
		        SET @l_sub_desc  = 'BORROW CONFIRMATION ACCEPTANCE (FOR CM CLIENT)'
		      

	              --      
		    END 
		    ELSE IF @I = 72
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '191'
			SET @l_sub_desc  = 'SLB CLOSURE  - INITIAL (FOR CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 73
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '192'
			SET @l_sub_desc  = 'SLB CLOSURE - ACCEPTANCE (FOR CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 74
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '193'
			SET @l_sub_desc  = 'SLB CLOSURE - REJECTION(FOR CM CLIENT)'
			

		      --		    
		    END    
		    ELSE IF @I = 75
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '194'
			SET @l_sub_desc = 'SLB CLOSURE(FOR CM CLIENT)'
			

		      --      
		    END 
		    ELSE IF @I = 76
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '195'
			SET @l_sub_desc  = 'SLB CLOSURE - ACCEPTANCE (FOR CM CLIENT)'
			
		      --      
		    END 
		    ELSE IF @I = 77
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '201'
			SET @l_sub_desc  = 'INTER DEPOSITORY TRANSFER INITIAL DELIVERY BOOKING'
			

		      --		    
		    END    
		    ELSE IF @I = 78
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '202'
			SET @l_sub_desc  = 'DEBIT FOR DELIVERY TO CLIENT'
			

		      --      
		    END 
		    ELSE IF @I = 79
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '203'
			SET @l_sub_desc = 'INTER DEPOSITORY TRANSFER REJECTION DELIVERY BOOKING'
			
		      --      
		    END 
		    ELSE IF @I = 80
		    BEGIN
		      --
			
			SET  @l_sub_cd    = '204'
			SET @l_sub_desc = 'CREDIT FOR RECEIPT FROM CLIENT'
			
		      --      
		    END 
		    ELSE IF @I = 81
		    BEGIN
		      --		
			
			SET  @l_sub_cd    = '211'
			SET @l_sub_desc  = 'CM TO CM XFER INITIAL DELIVERY'
		

		      --		    
		    END    
		    ELSE IF @I = 82
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '212'
			SET @l_sub_desc = 'CM TO CM XFER CONFIRMATION DELIVERY'
			

		      --      
		    END 
		    ELSE IF @I = 83
		    BEGIN
		      --		
			
			SET  @l_sub_cd     = '213'
			SET @l_sub_desc  = 'CM TO CM XFER REJECTION DELIVERY'
			

		      --		    
		    END    
		    ELSE IF @I = 84
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '214'
			SET @l_sub_desc  = 'CM TO CM XFER CONFIRMATION RECEIPT'
			

		      --      
		    END 
		    ELSE IF @I = 85
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '223'
			SET @l_sub_desc  = 'DEFFERED DELIVERY ORDER INTIAL BOOKING'
			
		      --      
		    END 
		    ELSE IF @I = 86
		    BEGIN
		      --		
			
			SET  @l_sub_cd  = '224'
			SET @l_sub_desc  = 'DEFFERED DELIVERY ORDER FINAL BOOKING'
			

		      --		    
		    END    
		    ELSE IF @I = 87
		    BEGIN
		      --
			
			SET  @l_sub_cd     = '225'
			SET @l_sub_desc = 'DEFFERED DELIVERY ORDER REJECTION BOOKING'
			

		      --      
		    END 
		    ELSE IF @I = 88
		    BEGIN
		      --
			
			SET  @l_sub_cd     ='226'
			SET @l_sub_desc = 'DEFFERED DELIVERY ORDER CANCELLATION  BOOKING'
			
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
           	    PRINT CONVERT(VARCHAR,@I) 
                  END
                END

GO
