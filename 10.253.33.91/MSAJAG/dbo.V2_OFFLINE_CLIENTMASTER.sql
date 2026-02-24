-- Object: PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE  PROC V2_OFFLINE_CLIENTMASTER(
	  @StatusId	 Varchar(15),
	  @StatusName    Varchar(25),	      
          @ModifyDate    VARCHAR(11),      
          @ToDate        VARCHAR(11),      
          @ModifyType    VARCHAR(1),      
          @FromPartyCode VARCHAR(10),      
          @ToPartyCode   VARCHAR(10),      
          @BranchCd      VARCHAR(10),      
          @SubBroker     VARCHAR(10))      
AS                    
/*                    
exec V2_Offline_ClientMaster_Test '20060217','I'                
exec V2_Offline_ClientMaster_Test '20060406','u'                
*/                    
      
  SET @ModifyDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ModifyDate,'/',''),'-',''),112),11)      
  SET @ToDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ToDate,'/',''),'-',''),112),11)      
  IF ISNULL(@FromPartyCode,'') = ''      
      OR @FromPartyCode = '%'      
    BEGIN      
      SET @FromPartyCode = '0000000000'      
    END      
  IF ISNULL(@ToPartyCode,'') = ''      
      OR @ToPartyCode = '%'      
    BEGIN      
      SET @ToPartyCode = 'ZZZZZZZZZZ'      
    END      
  IF ISNULL(@BranchCd,'ALL') = 'ALL'      
    BEGIN      
      SET @BranchCd = '%'      
    END      
  IF ISNULL(@SubBroker,'ALL') = 'ALL'      
    BEGIN      
      SET @SubBroker = '%'      
    END      
  IF @ModifyType = 'I'      
    BEGIN      
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED    
      SELECT   DISTINCT CD.CL_CODE,    
                        CD.PARTY_CODE,    
                        CD.LONG_NAME,    
                        CD.BRANCH_CD,    
                        CD.SUB_BROKER,    
                        CD.TRADER,    
                        IMP_STATUS = 'NEW',    
                        NSE = (SELECT ISNULL((ISNULL((  
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)  
         WHERE SYSTEMDATE >= @ModifyDate  
	 AND SYSTEMDATE <= @TODATE + ' 23:59:59'
         AND CL_CODE = CD.CL_CODE  
         AND EXCHANGE = 'NSE'  
         AND SEGMENT = 'CAPITAL'  
         ),  
         (  
         SELECT 'YES'    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)    
                   WHERE  E.EXCHANGE = 'NSE'    
                   AND E.SEGMENT = 'CAPITAL'    
                   AND E.CL_CODE = CD.CL_CODE  
         ))),'NO')),  
                        BSE = (SELECT ISNULL((ISNULL((  
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)  
         WHERE SYSTEMDATE >= @ModifyDate  
	 AND SYSTEMDATE <= @TODATE + ' 23:59:59'
         AND CL_CODE = CD.CL_CODE  
         AND EXCHANGE = 'BSE'  
         AND SEGMENT = 'CAPITAL'  
         ),  
         (  
         SELECT 'YES'    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)    
                   WHERE  E.EXCHANGE = 'BSE'    
                   AND E.SEGMENT = 'CAPITAL'    
                   AND E.CL_CODE = CD.CL_CODE  
         ))),'NO')),  
                        FO = (SELECT ISNULL((ISNULL((  
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)  
         WHERE SYSTEMDATE >= @ModifyDate  
	 AND SYSTEMDATE <= @TODATE + ' 23:59:59'
         AND CL_CODE = CD.CL_CODE  
         AND EXCHANGE = 'NSE'  
         AND SEGMENT = 'FUTURES'  
         ),  
         (  
         SELECT 'YES'    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)    
                   WHERE  E.EXCHANGE = 'NSE'    
                   AND E.SEGMENT = 'FUTURES'    
                   AND E.CL_CODE = CD.CL_CODE  
         ))),'NO')),  
                        NCDX = (SELECT ISNULL((ISNULL((  
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)  
         WHERE SYSTEMDATE >= @ModifyDate  
	 AND SYSTEMDATE <= @TODATE + ' 23:59:59'
         AND CL_CODE = CD.CL_CODE  
         AND EXCHANGE = 'NCX'  
         AND SEGMENT = 'FUTURES'  
         ),  
         (  
         SELECT 'YES'    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)    
                   WHERE  E.EXCHANGE = 'NCX'    
                   AND E.SEGMENT = 'FUTURES'    
                   AND E.CL_CODE = CD.CL_CODE  
         ))),'NO')),  
                        MCX = (SELECT ISNULL((ISNULL((  
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)  
         WHERE SYSTEMDATE >= @ModifyDate  
	 AND SYSTEMDATE <= @TODATE + ' 23:59:59'
         AND CL_CODE = CD.CL_CODE  
         AND EXCHANGE = 'MCX'  
         AND SEGMENT = 'FUTURES'  
         ),  
         (  
         SELECT 'YES'    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)    
                   WHERE  E.EXCHANGE = 'MCX'    
                   AND E.SEGMENT = 'FUTURES'    
                   AND E.CL_CODE = CD.CL_CODE  
         ))),'NO'))    
      FROM     CLIENT_DETAILS CD (NOLOCK)    
               LEFT OUTER JOIN CLIENT_BROK_DETAILS CBD (NOLOCK)    
                 ON (CBD.CL_CODE = CD.CL_CODE)    
      WHERE ISNULL(CBD.SYSTEMDATE,ModifidedOn) >= @ModifyDate  
	 AND ISNULL(CBD.SYSTEMDATE,ModifidedOn) <= @TODATE + ' 23:59:59'    
        AND CD.CL_CODE >= @FromPartyCode    
        AND CD.CL_CODE <= @ToPartyCode    
        AND CD.BRANCH_CD = (CASE     
                              WHEN @BranchCd = '%' THEN CD.BRANCH_CD    
                              ELSE @BranchCd    
                            END)    
        AND CD.SUB_BROKER = (CASE     
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER    
                               ELSE @SubBroker    
                             END)
	And @StatusName =         
                  (case         
                        when @StatusId = 'BRANCH' then branch_cd        
                        when @StatusId = 'SUBBROKER' then sub_broker        
                        when @StatusId = 'Trader' then Trader        
                        when @StatusId = 'Family' then Family        
                        when @StatusId = 'Area' then Area        
                        when @StatusId = 'Region' then Region        
                        when @StatusId = 'Client' then party_code        
                  else         
                        'BROKER'        
                  End)     
      ORDER BY 2    
  END      
  IF @ModifyType = 'U'      
    BEGIN      
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED      
      SELECT DISTINCT CL_CODE,      
                      EXCHANGE,      
                      SEGMENT      
      INTO   #CLIENT_BROK_DETAILS_LOG      
      FROM   CLIENT_BROK_DETAILS_LOG WITH(INDEX(CBDL_IDX),NOLOCK)     
      WHERE  EDIT_ON >= @MODIFYDATE      
      AND EDIT_ON <= @TODATE + ' 23:59:59'	
    
      CREATE CLUSTERED INDEX TEMPIDX on #CLIENT_BROK_DETAILS_LOG (CL_CODE, EXCHANGE, SEGMENT)    
     
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED      
      SELECT   DISTINCT CD.CL_CODE,      
                        CD.PARTY_CODE,      
                        CD.LONG_NAME,      
                        CD.BRANCH_CD,      
                        CD.SUB_BROKER,      
                        CD.TRADER,      
                        IMP_STATUS = (SELECT ISNULL((SELECT DISTINCT 'UPDATED'      
                                                     FROM   CLIENT_DETAILS_LOG X WITH(INDEX(CDL_IDX),NOLOCK)      
                                                     WHERE  EDIT_ON >= @MODIFYDATE      
						      AND EDIT_ON <= @TODATE + ' 23:59:59'	     
                                                     AND X.CL_CODE = CD.CL_CODE),'NOT UPDATED')),      
                        NSE = (SELECT ISNULL((SELECT IMP_STATUS = (CASE       
                                                                     WHEN ISNULL(CBDL.CL_CODE,'') <> '' THEN 'UPDATED'      
                                                                     ELSE 'YES'      
                                                                   END)      
                                              FROM   CLIENT_BROK_DETAILS A (NOLOCK)      
                                                     LEFT OUTER JOIN #CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
                                                       ON (CBDL.EXCHANGE = A.EXCHANGE      
                                                           AND CBDL.SEGMENT = A.SEGMENT      
                                                           AND CBDL.CL_CODE = A.CL_CODE)      
                                              WHERE  A.EXCHANGE = 'NSE'      
                                              AND A.SEGMENT = 'CAPITAL'      
                                              AND A.CL_CODE = CD.CL_CODE),'NO')),      
                        BSE = (SELECT ISNULL((SELECT IMP_STATUS = (CASE       
                                                                     WHEN ISNULL(CBDL.CL_CODE,'') <> '' THEN 'UPDATED'      
                                                                     ELSE 'YES'      
                                                                   END)      
                                              FROM   CLIENT_BROK_DETAILS A (NOLOCK)      
                                                     LEFT OUTER JOIN #CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
                                                       ON (CBDL.EXCHANGE = A.EXCHANGE      
                                                           AND CBDL.SEGMENT = A.SEGMENT      
                             AND CBDL.CL_CODE = A.CL_CODE)      
                                              WHERE  A.EXCHANGE = 'BSE'      
                                              AND A.SEGMENT = 'CAPITAL'      
                                              AND A.CL_CODE = CD.CL_CODE),'NO')),      
                        FO = (SELECT ISNULL((SELECT IMP_STATUS = (CASE       
                                                                    WHEN ISNULL(CBDL.CL_CODE,'') <> '' THEN 'UPDATED'      
                                                                    ELSE 'YES'      
                                                                  END)      
                                             FROM   CLIENT_BROK_DETAILS A (NOLOCK)      
                                                    LEFT OUTER JOIN #CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
                                                      ON (CBDL.EXCHANGE = A.EXCHANGE      
                                                          AND CBDL.SEGMENT = A.SEGMENT      
                                                          AND CBDL.CL_CODE = A.CL_CODE)      
                                             WHERE  A.EXCHANGE = 'NSE'      
                                             AND A.SEGMENT = 'FUTURES'      
                                             AND A.CL_CODE = CD.CL_CODE),'NO')),      
                  NCDX = (SELECT ISNULL((SELECT IMP_STATUS = (CASE       
                                                                      WHEN ISNULL(CBDL.CL_CODE,'') <> '' THEN 'UPDATED'      
                                                                      ELSE 'YES'      
                                                                    END)      
                                               FROM   CLIENT_BROK_DETAILS A (NOLOCK)      
                                                      LEFT OUTER JOIN #CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
                                                        ON (CBDL.EXCHANGE = A.EXCHANGE      
                                                            AND CBDL.SEGMENT = A.SEGMENT      
                                                            AND CBDL.CL_CODE = A.CL_CODE)      
                                               WHERE  A.EXCHANGE = 'NCX'      
                                               AND A.SEGMENT = 'FUTURES'      
                                               AND A.CL_CODE = CD.CL_CODE),'NO')),      
                        MCX = (SELECT ISNULL((SELECT IMP_STATUS = (CASE       
                                                                     WHEN ISNULL(CBDL.CL_CODE,'') <> '' THEN 'UPDATED'      
                                                                     ELSE 'YES'      
                                                                   END)      
                                              FROM   CLIENT_BROK_DETAILS A (NOLOCK)      
                                                     LEFT OUTER JOIN #CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
                                                       ON (CBDL.EXCHANGE = A.EXCHANGE      
                                                           AND CBDL.SEGMENT = A.SEGMENT      
                                                           AND CBDL.CL_CODE = A.CL_CODE)      
                                              WHERE  A.EXCHANGE = 'MCX'      
                                              AND A.SEGMENT = 'FUTURES'      
                                              AND A.CL_CODE = CD.CL_CODE),'NO'))      
      FROM     CLIENT_DETAILS CD (NOLOCK)      
               LEFT OUTER JOIN CLIENT_BROK_DETAILS CBD (NOLOCK)      
                 ON (CBD.CL_CODE = CD.CL_CODE)      
      WHERE    CD.CL_CODE IN (SELECT DISTINCT CL_CODE      
                       FROM   CLIENT_DETAILS_LOG WITH(INDEX(CDL_IDX),NOLOCK)       
                       WHERE  EDIT_ON >= @MODIFYDATE      
      AND EDIT_ON <= @TODATE + ' 23:59:59'	
                       UNION       
                       SELECT DISTINCT CL_CODE      
        FROM   CLIENT_BROK_DETAILS_LOG WITH(INDEX(CBDL_IDX),NOLOCK)     
                       WHERE  EDIT_ON >= @MODIFYDATE      
      AND EDIT_ON <= @TODATE + ' 23:59:59'	)     
/*        AND CD.CL_CODE NOT IN (SELECT DISTINCT CL_CODE      
                               FROM   CLIENT_BROK_DETAILS      
                               WHERE  SYSTEMDATE = MODIFIEDON)           
*/
        AND CD.BRANCH_CD = (CASE       
                              WHEN @BranchCd = '%' THEN CD.BRANCH_CD      
                              ELSE @BranchCd      
                            END)      
        AND CD.SUB_BROKER = (CASE       
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER      
                               ELSE @SubBroker      
                             END)
        AND CD.CL_CODE >= @FromPartyCode      
        AND CD.CL_CODE <= @ToPartyCode
	And @StatusName =         
                  (case         
                        when @StatusId = 'BRANCH' then branch_cd        
                        when @StatusId = 'SUBBROKER' then sub_broker        
                        when @StatusId = 'Trader' then Trader        
                        when @StatusId = 'Family' then Family        
                        when @StatusId = 'Area' then Area        
                        when @StatusId = 'Region' then Region        
                        when @StatusId = 'Client' then party_code        
                  else         
                        'BROKER'        
                  End)       
      ORDER BY 2      
    END      
  IF @ModifyType = 'M'      
    BEGIN      
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED      
      SELECT   DISTINCT CD.CL_CODE,      
                CD.PARTY_CODE,      
                        CD.LONG_NAME,      
                        CD.BRANCH_CD,      
                        CD.SUB_BROKER,      
                        CD.TRADER,      
                        IMP_STATUS = 'MISSING',      
                        NSE = 'NO',      
                        BSE = 'NO',      
                        FO = 'NO',      
                        NCDX = 'NO',      
                        MCX = 'NO'      
      FROM     CLIENT_DETAILS CD (NOLOCK)      
		WHERE CL_CODE NOT IN (SELECT CL_CODE FROM CLIENT_BROK_DETAILS CBD (NOLOCK)      
                 WHERE CD.CL_CODE = CBD.CL_CODE)      
      AND CD.CL_CODE >= @FromPartyCode      
        AND CD.CL_CODE <= @ToPartyCode      
        AND CD.BRANCH_CD = (CASE       
                              WHEN @BranchCd = '%' THEN CD.BRANCH_CD      
                              ELSE @BranchCd      
                            END)      
        AND CD.SUB_BROKER = (CASE       
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER      
                               ELSE @SubBroker      
                             END)
	And @StatusName =         
                  (case         
                        when @StatusId = 'BRANCH' then branch_cd        
                        when @StatusId = 'SUBBROKER' then sub_broker        
                        when @StatusId = 'Trader' then Trader        
                        when @StatusId = 'Family' then Family        
                        when @StatusId = 'Area' then Area        
                        when @StatusId = 'Region' then Region        
                        when @StatusId = 'Client' then party_code        
                  else         
                        'BROKER'        
                  End)       
      ORDER BY 2      
    END

GO
