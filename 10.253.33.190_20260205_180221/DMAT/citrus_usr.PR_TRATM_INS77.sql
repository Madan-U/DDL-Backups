-- Object: PROCEDURE citrus_usr.PR_TRATM_INS77
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_TRATM_INS77]
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
                        SET @l_code='TRANS_ERR_CD_CDSL' 
			SET @l_desc ='TRANSACTION ERRORS'
			DELETE FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=(SELECT TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE ='TRANS_ERR_CD_CDSL')
		        DELETE FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'TRANS_ERR_CD_CDSL'
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
                    
                       

           	   	                                            
           		                                            
           	  
		    --BEGIN @I=117
		   WHILE @I<=117
		   BEGIN
		    --
		        SELECT @l_trastm_id= ISNULL(MAX(trastm_id),0)+1 FROM transaction_sub_type_mstr 
		        SELECT @l_trastm_tratm_id = MAX(trantm_id)  FROM transaction_type_mstr
                    
			

		    IF @I = 1
		    BEGIN
		      --
                        SET @l_sub_cd   = 'CIF0154-F'
                        SET @l_sub_desc = 'DP IS NOT ACTIVE'

		      --      
		    END 
		    ELSE IF @I = 2
		    BEGIN
		      --
                        SET @l_sub_cd  = 'CMN0003-F'
                        SET @l_sub_desc= 'DP ID DOES NOT EXIST'
                      --      
		    END 
		    ELSE IF  @I = 3
		    BEGIN
		      --
		        SET @l_sub_cd = 'CMN0004-F'
		        SET @l_sub_desc = 'ISIN CODE DOES NOT EXIST'
		     --     
		    END 
		    ELSE IF @I = 4
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN0012-F'
                        SET @l_sub_desc = 'BO-ISIN RECORD DOES NOT EXIST'
                      --
		    END 
		    ELSE IF  @I = 5
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN0015-F'
			SET @l_sub_desc  = 'BO ID DOES NOT EXISTS'
			--     
		    END    
		    ELSE IF @I = 6
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN0016-F'
			SET @l_sub_desc  = 'BO ISIN DOES NOT EXISTS'
		      --      
		    END
		    ELSE IF  @I = 7
		    BEGIN
		      --
			SET @l_sub_cd     = 'CMN0024-F'
			SET @l_sub_desc   = 'QUANTITY CANNOT BE NEGATIVE'
		      --     
		    END    
		    ELSE IF @I = 8
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN0029-F'
			SET @l_sub_desc  = 'SHARED MEMORY ERROR'
		      --      
		    END
		    ELSE IF  @I = 9
		    BEGIN
		      --
		        SET @l_sub_cd  = 'CMN0030-F'
		        SET @l_sub_desc  = 'INVALID TRANSACTION CODE'
		      --     
		    END    
		    ELSE IF @I = 10
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN0777-F'
                        SET @l_sub_desc = 'SECURITY VIOLATION'
                     --
		    END
		    ELSE IF  @I = 11
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN1013-E'
			SET @l_sub_desc = 'ISIN DOES NOT EXISTS'
		      --    
		    END    
		    ELSE IF @I = 12
		    BEGIN
		      --
		        SET @l_sub_cd     = 'CMN5102-E'
                        SET @l_sub_desc   = 'TRANSACTION QUANTITY SHOULD NOT BE ZERO '
                      --      
	            END
		    ELSE IF  @I = 13
		    BEGIN
		      --
		        SET @l_sub_cd   = 'CMN5103-E'
		        SET @l_sub_desc  = 'DECIMALS ARE NOT ALLOWED FOR THIS ISIN'
		     --     
		    END    
	            ELSE IF @I = 14
	            BEGIN
	             --
	               SET @l_sub_cd   = 'CMN5103-F'
                       SET @l_sub_desc   = 'ONLY SERVICE DP OR MAIN DP (OF THIS BRANCHDP) CAN INQUIRE ON BOS OF AN INACTIVE BRANCH DP/MAIN DP'
                     --      
	            END
		    ELSE IF @I = 15         
		    BEGIN
		      --
			SET @l_sub_cd   = 'CMN5104-F'
			SET @l_sub_desc  = 'BRANCH DP CANNOT INQUIRE ON BOS OF ANOTHER BRANCH DP'
		      --
		    END 
		    ELSE IF  @I = 16
		    BEGIN
		      --
			SET @l_sub_cd   = 'CMN5105-F'			
			SET @l_sub_desc = 'BRANCH DP CANNOT INQUIRE ON BOS OF ANOTHER BRANCH DP'
		      --    
                    END    
		    ELSE IF @I = 17
		    BEGIN
		      --
			SET @l_sub_cd      = 'CMN5106-E'
			SET @l_sub_desc    = 'TRANSACTION LOCKIN QUANTITY SHOULD NOT BE GREATER THAN TRANSACTION CURRENT QUANTITY'

		      --      
		    END
		    ELSE IF  @I = 18
		    BEGIN
		      --
			SET @l_sub_cd   = 'CMN5106-F'
                        SET @l_sub_desc  = 'BRANCH DP CANNOT INQUIRE ON BOS OF A MAIN DP'
                      --    
		    END    
		    ELSE IF @I = 19
		    BEGIN
		      --
		        SET @l_sub_cd      = 'CMN5107-F'
		        SET @l_sub_desc    = 'ONLY SERVICEDP CAN INQUIRE ON BOS OF AN INACTIVE DP/BRANCH DP'
                       --      
		    END
		    IF @I = 20
		    BEGIN
		      --
		        SET @l_sub_cd   = 'CMN5108-F'
                        SET @l_sub_desc = 'OTHER MAINDPS CANNOT ENQUIRE ON BO S OF A BRANCH DP'

		      --      
		    END 
		    ELSE IF @I = 21
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN5109-F'
			SET @l_sub_desc= 'THIS FUNCTION IS ALLOWED ONLY AT BRANCH DP'
		      --      
		    END 
		    ELSE IF  @I = 22
		    BEGIN
		      --
			SET @l_sub_cd = 'CMN5110-F'
			SET @l_sub_desc = 'BRANCH DP FUNCTION CALL FAILED'
		      --     
		    END 
		    ELSE IF @I = 23
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN5111-F'
			SET @l_sub_desc = 'BRANCH DP FUNCTION RECORD DOES NOT EXIST'
		      --
		    END 
		    ELSE IF  @I = 24
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN5112-F'
                        SET @l_sub_desc  = 'THIS FUNCTION IS ALLOWED ONLY FROM A  MAINDP'  
                      --     
		    END    
		    ELSE IF @I = 25
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN6002-F'
			SET @l_sub_desc  = 'NUMBER OF RECORDS DOES NOT MATCH WITH NO. OF RECORDS GIVEN IN THE CONTROL RECORD'
		      --      
		    END
		    ELSE IF  @I = 26
		    BEGIN
		      --
			SET @l_sub_cd     = 'CMN6003-F'
			SET @l_sub_desc   = 'IMPROPER CONTROL RECORD LENGTH'
		     --     
		    END    
		    ELSE IF @I = 27
		    BEGIN
		      --
			SET @l_sub_cd    = 'CMN6004-F'
			SET @l_sub_desc  = 'INVALID DP ID IN CONTROL RECORD'
		      --      
		    END
		    ELSE IF  @I = 28
		    BEGIN
		      --
		        SET @l_sub_cd  = 'CMN6052-E'
                        SET @l_sub_desc  = 'IMPROPER DETAIL RECORD LENGTH OR RECORD-DELIMITER NOT FOUND'
                      --     
		    END    
		    ELSE IF @I = 29
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN6056-E'
			SET @l_sub_desc = 'INVALID DATE FORMAT'
		      --
		    END
		    ELSE IF  @I = 30
		    BEGIN
		      --
			SET @l_sub_cd  = 'CMN6063-E'
                        SET @l_sub_desc = 'INVALID EXCHANGE ID'
                      --    
		    END    
		    ELSE IF @I = 31
		    BEGIN
		      --
			SET @l_sub_cd     = 'CMN6064-E'
			SET @l_sub_desc   = 'NOT MORE THAN TWO DECIMALS ARE ALLOWED FOR THIS ISIN'
		      --      
		    END
		    ELSE IF  @I = 32
		    BEGIN
		      --
			SET @l_sub_cd   = 'DEP2106-E'
			SET @l_sub_desc  = 'BO-ISIN IS CLOSED'
		      --     
		    END    
		    ELSE IF @I = 33
		    BEGIN
		     --
		       SET @l_sub_cd   = 'DEP2151-E'
		       SET @l_sub_desc   = 'QUANTITY IS NOT SUFFICIENT FOR DEBIT'
                     --      
		    END
		    ELSE IF @I = 34        
		    BEGIN
		      --
			SET @l_sub_cd   = 'DEP2025-E'
			SET @l_sub_desc  = 'OPERATION DISALLOWED AS BALANCE EXTRACTION IS IN PROGRESS'
		      --
		    END 
		    ELSE IF  @I = 35
		    BEGIN
		      --
			SET @l_sub_cd   = 'DEP2175-E'
	                SET @l_sub_desc    = 'INVALID LOCKIN REASON CODE'
	              --    
		    END    
		    ELSE IF @I = 36
		    BEGIN
		      --
			SET @l_sub_cd      = 'OFM1621-F'
                        SET @l_sub_desc    = 'BO IS INACTIVE'
                      --      
		    END
		    ELSE IF  @I = 37
		    BEGIN
		      --
			SET @l_sub_cd   = 'OFM1622-F'
                        SET @l_sub_desc  = 'BO IS NOT PERMITTED FOR THIS OPERATION'
                      --    
		    END    
		    ELSE IF @I = 38
		    BEGIN
		      --
		        SET @l_sub_cd      = 'OFM2010-F'
		        SET @l_sub_desc    = 'INVALID QUANTITY'
		      --      
		    END
		    IF @I = 39
		    BEGIN
		      --
			SET @l_sub_cd   = 'SEM1005-I'
			SET @l_sub_desc = 'BO ISIN A/C IS SUSPENDED'
		      --      
		    END 
		    ELSE IF @I = 40
		    BEGIN
		      --
			SET @l_sub_cd  = 'SEM1016-E'
			SET @l_sub_desc= 'CMID IS NOT PRESENT OR NOT VALID'
                      --      
		    END 
		    ELSE IF  @I = 41
		    BEGIN
		      --
			SET @l_sub_cd = 'SEM1025-F'
			SET @l_sub_desc = 'BO ISIN A/C IS FROZEN'
		      --     
		    END 
		    ELSE IF @I = 42
		    BEGIN
		      --
			SET @l_sub_cd  = 'SEM1026-I'
			SET @l_sub_desc = 'BO ISIN A/C IS CLOSED' 
		      --
		    END 
		    ELSE IF  @I = 43
		    BEGIN
		      --
			SET @l_sub_cd    = 'SEM1030-I'
			SET @l_sub_desc  = 'BO IS CLOSED'
		      --     
		    END    
		    ELSE IF @I = 44
		    BEGIN
		      --
			SET @l_sub_cd    = 'SEM2046-F'
			SET @l_sub_desc  = 'INVALID SETTLEMENT ID'
		      --      
		    END
		    ELSE IF  @I = 45
		    BEGIN
		      --
			SET @l_sub_cd     = 'SEM2047-F'
			SET @l_sub_desc   = 'INVALID CM ID'
		      --     
		    END    
		    ELSE IF @I = 46
		    BEGIN
		      --
			SET @l_sub_cd    = 'SEM2052-F'
			SET @l_sub_desc  = 'ISIN IS SUSPENDED FOR EITHER DEBIT/CREDIT OR FOR BOTH'
		      --      
		    END
		    ELSE IF  @I = 47
		    BEGIN
		      --
		      SET @l_sub_cd  = 'SEM5521-F'
		      SET @l_sub_desc  = 'INVALID ISIN'



		      --     
		    END    
		    ELSE IF @I = 48
		    BEGIN
		      --
			SET @l_sub_cd  = 'TMU0001-E'
                        SET @l_sub_desc = 'INVALID TRANCODE'

	              --
		    END
		    ELSE IF  @I = 49
		    BEGIN
		      --
			SET @l_sub_cd  = 'UPL0354-E'
			SET @l_sub_desc = 'INVALID CH ID'
		      --    
		    END    
		    ELSE IF @I = 50
		    BEGIN
		      --
			SET @l_sub_cd     = 'UPL0355-E'
                        SET @l_sub_desc   = 'INVALID SETTLEMENT ID '
                      --      
		    END
		    ELSE IF  @I = 51
		    BEGIN
		      --
			SET @l_sub_cd   = 'UPL0356-E'
			SET @l_sub_desc  = 'INVALID DEBIT BO ID'
		      --     
		    END    
		    ELSE IF @I = 52
		    BEGIN
		      --
		        SET @l_sub_cd   = 'UPL0357-E'
		        SET @l_sub_desc   = 'QUANTITY CANNOT EXCEED 999999999999.999'
		      --      
		    END
		    ELSE IF @I = 53       
		    BEGIN
		      --
			SET @l_sub_cd   = 'UPL0358-E'
			SET @l_sub_desc  = 'INVALID ISIN'

		      --
		    END 
		    ELSE IF  @I = 54
		    BEGIN
		      --
			SET @l_sub_cd   = 'UPL0359-E'
			SET @l_sub_desc    = 'INVALID CREDIT BO ID'
		      --    
		    END    
		    ELSE IF @I = 55
		    BEGIN
		      --
			SET @l_sub_cd      = 'UPL0360-E'
			SET @l_sub_desc    = 'THE DATE IN THE FILE IS NOT EQUAL TO BUSINESS DATE'


		      --      
		    END
		    ELSE IF  @I = 56
		    BEGIN
		      --
			SET @l_sub_cd   = 'UPL0361-E'
			SET @l_sub_desc    = 'SYSTEM ERROR, CONTACT HELPDESK'

			   --    
		    END    
		    ELSE IF @I = 57
		    BEGIN
		      --
			SET @l_sub_cd      = 'OFM1001-I'
			SET @l_sub_desc    = 'TRANSACTION SUCCESSFULLY SETUP'

		      --      
		    END
		    ELSE IF @I = 58
		    BEGIN
		      --
			SET @l_sub_cd  = 'OFM1002-I'
			SET @l_sub_desc= 'INQUIRY  SUCCESSFUL'
		      --      
		    END 
		    ELSE IF  @I = 59
		    BEGIN
		      --
			SET @l_sub_cd = 'OFM1003-I'
			SET @l_sub_desc = 'NO ROWS RETRIEVED FOR GIVEN CRITERIA'
		      --     
		    END 
		    ELSE IF @I = 60
		    BEGIN
		      --
			SET @l_sub_cd  = 'OFM1601-F'
			SET @l_sub_desc = 'BO NOT OF THIS DP'

		      --
		    END 
		    ELSE IF  @I = 61
		    BEGIN
		      --
			SET @l_sub_cd    = 'OFM1602-F'
			SET @l_sub_desc  = 'ISIN DOES NOT EXIST'

			  --     
		    END    
		    ELSE IF @I = 62
		    BEGIN
		      --
			SET @l_sub_cd    = 'OFM1620-F'
			SET @l_sub_desc  = 'INVALID Y/N FLAG'
		      --      
		    END
		    
		    
		    ELSE IF  @I = 63
		    BEGIN
		      --
			SET @l_sub_cd  = 'OFM1623-F'
			SET @l_sub_desc  = 'BO AND COUNTER BO CAN NOT BE SAME'
		      --     
		    END    
		
		    ELSE IF  @I = 64
		    BEGIN
		      --
			SET @l_sub_cd  = 'OFM2011-F'
			SET @l_sub_desc = 'MODIFICATION IS NOT ALLOWED SINCE TRADE IS ALREADY FORMED'
		      --    
		    END    
		    ELSE IF @I = 65
		    BEGIN
		      --
			SET @l_sub_cd     = 'OFM1605-F'
			SET @l_sub_desc   = 'VALID VALUES FOR CASH TRF ARE Y/N/X ONLY'
		      --      
		    END
		    -----------------------
		    ELSE IF  @I = 66
		    BEGIN
		      --
			SET @l_sub_cd   = '6001'
			SET @l_sub_desc  = 'INVALID SENDER DEPOSITORY ID '                                                  
		      --     
		    END    
		    ELSE IF @I = 67
		    BEGIN
		      --
			SET @l_sub_cd   = '6002'
			SET @l_sub_desc   = 'INVALID RECEIVER DEPOSITORY ID'                                                
		      --      
		    END
		    ELSE IF @I = 68    
		    BEGIN
		      --
			SET @l_sub_cd   = '6063'
			SET @l_sub_desc  = 'ACKNOWLEDGEMENT TYPE IN ERROR'                                                 
		      --
		    END 
		    ELSE IF  @I = 69
		    BEGIN
		      --
			SET @l_sub_cd   = '6064'
			SET @l_sub_desc  = '702 OR 705 SENT FOR REQUEST NOT SENT OR REQUEST NO'                            
		      --    
		    END    
		    ELSE IF @I = 70
		    BEGIN
		      --
			SET @l_sub_cd      = '6003'
			SET @l_sub_desc    = 'DUPLICATE BATCH ID'                                                            
		      --      
		    END
		    ELSE IF  @I = 71
		    BEGIN
		      --
			SET @l_sub_cd   = '6004'
			SET @l_sub_desc  = 'INVALID DATE '                                                                  
		      --    
		    END    
		    ELSE IF @I = 72
		    BEGIN
		      --
			SET @l_sub_cd      = '6048'
			SET @l_sub_desc    = 'BATCH SENDER IDENTIFICATION IS NOT VALID'                                     
		      --      
		    END
		    IF @I = 73
		    BEGIN
		      --
			SET @l_sub_cd   = '6007'
			SET @l_sub_desc = 'INVALID SENDER DEPOSITORY ID IN TRAILER'                                       
		      --      
		    END 
		    ELSE IF @I = 74
		    BEGIN
		      --
			SET @l_sub_cd  = '6008'
			SET @l_sub_desc= 'INVALID RECEIVER DEPOSITORY ID TRAILER'                                      
		      --      
		    END 
		    ELSE IF  @I = 75
		    BEGIN
		      --
			SET @l_sub_cd = '6009'
			SET @l_sub_desc = 'BATCH NUMBER DOES NOT EXIST IN SYSTEM'                                        
		     --     
		    END 
		    ELSE IF @I = 76
		    BEGIN
		      --
			SET @l_sub_cd  = '6010'
			SET @l_sub_desc = 'MISMATCH IN TOTAL NO. OF ISIN/BATCH'                                           
		      --
		    END 
		    ELSE IF  @I = 77
		    BEGIN
		      --
			SET @l_sub_cd    = '6011'
			SET @l_sub_desc  = 'MISMATCH IN TOTAL NO. OF 525 MESSAGES/BATCH'                                   
		     --     
		    END    
		    ELSE IF @I = 78
		    BEGIN
		      --
			SET @l_sub_cd    = '6012'
			SET @l_sub_desc  = 'MISMATCH IN TOTAL NO. OF DETAIL RECORDS/BATCH '                                
		      --      
		    END
		    ELSE IF  @I = 79
		    BEGIN
		      --
			SET @l_sub_cd     = '6013'
			SET @l_sub_desc   = 'MISMATCH IN TOTAL QTY/BATCH '                                                   
		      --     
		    END    
		    ELSE IF @I = 80
		    BEGIN
		      --
			SET @l_sub_cd    = '6049'
			SET @l_sub_desc  = 'INVALID SENDER DEPOSITORY ID IN 525'                                            

		      --      
		    END
		    ELSE IF  @I = 81
		    BEGIN
		      --
		      SET @l_sub_cd  = '6050'
		      SET @l_sub_desc  = 'INVALID RECEIVER DEPOSITORY ID 525 '
		      --     
		    END    
		    ELSE IF @I = 82
		    BEGIN
		      --
			SET @l_sub_cd  = '6051'
			SET @l_sub_desc = 'BATCH NUMBER DOES NOT EXIST IN SYSTEM'                                          
		      --
		    END
		    ELSE IF  @I = 83
		    BEGIN
		      --
			SET @l_sub_cd  = '6014'
			SET @l_sub_desc = 'INVALID PAGE NO'                                                              
		      --    
		    END    
		    ELSE IF @I = 84
		    BEGIN
		      --
			SET @l_sub_cd     = '6026'
			SET @l_sub_desc   = 'INVALID CONTINUATION INDICATOR'                                                
		      --      
		    END
		    ELSE IF  @I = 85
		    BEGIN
		      --
			SET @l_sub_cd   = '6015'
			SET @l_sub_desc  = 'INVALID FUNCTION OF MESSAGE'                                                   
		      --     
		    END    
		    ELSE IF @I = 86
		    BEGIN
		      --
			SET @l_sub_cd   = '6059'
			SET @l_sub_desc   = 'DUPLICATE REQUEST'                                                             
		      --      
		    END
		    ELSE IF @I = 87 
		    BEGIN
		      --
			SET @l_sub_cd   = '6060'
			SET @l_sub_desc  = 'CAME AFTER DEADLINE TIME'                                                      
		      --
		    END 
		    ELSE IF  @I = 88
		    BEGIN
		      --
			SET @l_sub_cd   = '6061'
			SET @l_sub_desc    = 'SIGNATURE ERROR'                                                               
		      --    
		    END    
		    ELSE IF @I = 89
		    BEGIN
		      --
			SET @l_sub_cd      = '6062'
			SET @l_sub_desc    = 'FORMAT ERROR'                                                                  
		      --      
		    END
		    ELSE IF  @I = 90
		    BEGIN
		      --
			SET @l_sub_cd   = '6055'
			SET @l_sub_desc  = 'RESPONSE RECEIVED FOR A REQUEST NOT SENT '                                      
		      --    
		    END    
		    ELSE IF @I = 91
		    BEGIN
		      --
			SET @l_sub_cd      = '6056'
			SET @l_sub_desc    = 'RESPONSE RECEIVED FOR A REQUEST THAT WAS REJECTED '
		      --      
		    END
		    IF @I = 92
		    BEGIN
		      --
			SET @l_sub_cd   = '6057'
			SET @l_sub_desc = 'SECURITY QUATITY MISMATCHED IN REQUEST AND RESPONS'
		      --      
		    END 
		    ELSE IF @I = 93
		    BEGIN
		       --
			 SET @l_sub_cd  = '6058'
			 SET @l_sub_desc= 'DUPLICATE RESPONSE'                                                             
		       --      
		    END 
		    ELSE IF  @I = 94
		    BEGIN
		      --
			SET @l_sub_cd = '6016'
			SET @l_sub_desc = 'INVALID ISIN '                                                                 
		     --     
		    END 
		    ELSE IF @I = 95
		    BEGIN
		      --
			SET @l_sub_cd  = '6017'
			SET @l_sub_desc = 'MISMATCH IN QTY/DFP'                                                          
		     --
		    END 
		    ELSE IF  @I = 96
		    BEGIN
		      --
			SET @l_sub_cd    = '6018'
			SET @l_sub_desc  = 'RECEIVER TRANSACTION REF. NO. IS NOT NONREF'                                   
		      --     
		    END    
		    ELSE IF @I = 97
		    BEGIN
		      --
			SET @l_sub_cd    = '6019'
			SET @l_sub_desc  = 'TYPE OF TRANSACTION IS NOT DELFREE '                                            
		      --      
		    END
		    ELSE IF  @I = 98
		    BEGIN
		      --
			SET @l_sub_cd     = '6020'
			SET @l_sub_desc   = 'SETTLEMENT DATE IS NOT SAME AS BUSINESS DATE'                                   
		      --     
		    END    
		    ELSE IF @I = 99
		    BEGIN
		      --
			SET @l_sub_cd    = '6021'
			SET @l_sub_desc  = 'DELIVERER OF SECURITIES IS SPACES '                                             
		      --      
		    END
		    ELSE IF  @I = 100
		    BEGIN
		      --
			SET @l_sub_cd  = '6022'
			SET @l_sub_desc  = 'INVALID BO_ID'                                                                 
		      --     
		    END    
		    ELSE IF @I = 101
		    BEGIN
		      --
			SET @l_sub_cd  = '6023'
			SET @l_sub_desc = 'Invalid BO_ID'                                                               
		       --
		    END
		    ELSE IF  @I = 102
		    BEGIN
		      --
			SET @l_sub_cd  = '6024'
			SET @l_sub_desc = 'INVALID SETTLEMENT ID'                                                          
		      --    
		    END    
		    ELSE IF @I = 103
		    BEGIN
		      --
			SET @l_sub_cd     = '6025'
			SET @l_sub_desc   = 'INVALID SETTLEMENT ID'                                                        
		      --      
		    END
		    ELSE IF  @I = 104
		    BEGIN
		      --
			SET @l_sub_cd   = '6053'
			SET @l_sub_desc  = 'INVALID SECURITY DECIMAL INDICATOR'                                             
		      --     
		    END    
		    ELSE IF @I = 105
		    BEGIN
		      --
			SET @l_sub_cd   = '6054'
			SET @l_sub_desc   = 'INVALID MARKET TYPE ' 
		      --
		    END
		    ELSE IF @I = 106 
		    BEGIN
		      --
			SET @l_sub_cd   = '6052'
			SET @l_sub_desc  = 'INVALID SECURITY TYPE'                                                          
		      --
		    END 
		    ELSE IF  @I = 107
		    BEGIN
		      --
			SET @l_sub_cd   = '3128'
			SET @l_sub_desc = 'SETTLEMENT CYCLE NUMBER NOT REQUIRED FOR HOUSE '                             
		      --    
		    END    
		    ELSE IF @I = 108
		    BEGIN
		      --
			SET @l_sub_cd      = '3129'
			SET @l_sub_desc    = 'MARKET TYPE NOT REQUIRED FOR HOUSE OR CLIENT ACCOUNT'                             
		      --      
		    END
		    ELSE IF  @I = 109
		    BEGIN
		      --
			SET @l_sub_cd   = '6027'
			SET @l_sub_desc  = 'FAILED AT MATCHING, NO RFP PRESENT'                                             
		      --    
		    END    
		    ELSE IF @I = 110
		    BEGIN
		      --
			SET @l_sub_cd      = '6028'
			SET @l_sub_desc    = 'RES RECEIVED FOR REJECTED REQ'                                                 
		      --      
		    END
		    IF @I = 111
		    BEGIN
		      --
			SET @l_sub_cd   = '6029'
			SET @l_sub_desc = 'RES RECEIVED BEFORE ACK'                           
		     --      
		    END 
		    ELSE IF @I =112
		    BEGIN
		      --
			SET @l_sub_cd  = '6030'
			SET @l_sub_desc= 'TRES RECEIVED FOR NON EXISTING REQ'                                             
		      --      
		    END 
		    ELSE IF  @I = 113
		    BEGIN
		      --
			SET @l_sub_cd = '6033'
			SET @l_sub_desc = 'W.R.T. REQ SOME ISINS ARE MISSING IN RES'                                      
		      --     
		    END 
		    ELSE IF @I = 114
		    BEGIN
		      --
			SET @l_sub_cd  = '6035'
			SET @l_sub_desc = 'W.R.T. REQ SOME DFPS ARE MISSING IN RES'                                        
		      --
		    END 
		    ELSE IF  @I = 115
		    BEGIN
		      --
			SET @l_sub_cd    = '6036'
			SET @l_sub_desc  = 'W.R.T. REQ SOME 525S ARE MISSING IN RES'                                        
			  --     
		    END    
		    ELSE IF @I = 116
		    BEGIN
		      --
			SET @l_sub_cd    = '6038'
			SET @l_sub_desc  = 'W.R.T. REQ SOME QTYS ARE MISSING IN RES'
		      --      
		    END
		    ELSE IF  @I = 117
		    BEGIN
		      --
			SET @l_sub_cd    = '6109'
			SET @l_sub_desc  = 'INVALID TRANSACTION TYPE IN RES'                                                
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
		  
		  
		   /* EXECUTE PR_TRATM_INS77  select * from transaction_type_mstr
		        select * from transaction_sub_type_mstr
		        DELETE FROM transaction_sub_type_mstr WHERE trastm_id=92
		        DELETE FROM transaction_type_mstr WHERE trantm_code ='226'
		        sp_help transaction_type_mstr8*/

GO
