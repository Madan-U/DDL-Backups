-- Object: PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER_new1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[V2_OFFLINE_CLIENTMASTER_new1](                                          
          @ModifyDate    VARCHAR(11),                                          
          @ModifyType    VARCHAR(1),                                          
          @FromPartyCode VARCHAR(10),                                          
          @ToPartyCode   VARCHAR(10),                                          
          @BranchCd      VARCHAR(10),                                          
          @SubBroker     VARCHAR(10))                                          
AS                
    
/*    
declare    @ModifyDate    VARCHAR(11)    
declare          @ModifyType    VARCHAR(1)    
declare   @FromPartyCode VARCHAR(10)    
declare          @ToPartyCode   VARCHAR(10)    
declare          @BranchCd      VARCHAR(10)    
declare          @SubBroker     VARCHAR(10)    
    
set @ModifyDate = 'May 27 2008'    
set @ModifyType = 'I'    
set @FromPartyCode = ''    
set @ToPartyCode = ''    
set @BranchCd = 'All'    
set @SubBroker = 'All'    
*/    
    
                                            
/*                                                        
exec V2_Offline_ClientMaster_Test '20060217','I'                                                    
exec V2_Offline_ClientMaster_Test '20060406','u'                                         
exec V2_Offline_ClientMaster '20070827','I','N11509','N11509','ALL','ALL'                                         
*/                                                        
                                          
  SET @ModifyDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ModifyDate,'/',''),'-',''),112),11)                                          
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
         SELECT 'NEW'  FROM CLIENT_BROK_DETAILS (NOLOCK)                                      
      --   WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                 
         AND CL_CODE = CD.CL_CODE                                      
    AND EXCHANGE = 'NSE'                                      
         AND SEGMENT = 'CAPITAL'                               
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                 
         ),                                      
         (                                      
         SELECT 'YES'                                        
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                        
                   WHERE  E.EXCHANGE = 'NSE'                                        
                   AND E.SEGMENT = 'CAPITAL'                                        
                   AND E.CL_CODE = CD.CL_CODE                                 
       and E.Active_Date < @ModifyDate                           --and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ))),'NO')),                                      
                        BSE = (SELECT ISNULL((ISNULL((                                      
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                 
         AND CL_CODE = CD.CL_CODE                                      
         AND EXCHANGE = 'BSE'                                      
    AND SEGMENT = 'CAPITAL'                                      
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ),                                      
         (                                
         SELECT 'YES'                                        
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                        
  WHERE  E.EXCHANGE = 'BSE'                                        
                   AND E.SEGMENT = 'CAPITAL'                                        
                   AND E.CL_CODE = CD.CL_CODE                              
     and E.Active_Date < @ModifyDate                                 
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ))),'NO')),                                      
                        FO = (SELECT ISNULL((ISNULL((                                      
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                 
         AND CL_CODE = CD.CL_CODE                                      
         AND EXCHANGE = 'NSE'                                      
         AND SEGMENT = 'FUTURES'                                      
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ),                                      
         (                                      
         SELECT 'YES'                               
          FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                        
                   WHERE  E.EXCHANGE = 'NSE'                                        
                   AND E.SEGMENT = 'FUTURES'                                        
                   AND E.CL_CODE = CD.CL_CODE                                      
     and E.Active_Date < @ModifyDate                                 
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ))),'NO')),                                      
                        NCDX = (SELECT ISNULL((ISNULL((                                      
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                 
         WHERE LEFT(active_date,11) = @ModifyDate                                 
         AND CL_CODE = CD.CL_CODE                                      
         AND EXCHANGE = 'NCX'               
         AND SEGMENT = 'FUTURES'                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                      
         ),                                      
         (                                      
         SELECT 'YES'                                        
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                        
                   WHERE  E.EXCHANGE = 'NCX'                                        
                   AND E.SEGMENT = 'FUTURES'                                        
                   AND E.CL_CODE = CD.CL_CODE                                
     and E.Active_Date < @ModifyDate                                       
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ))),'NO')),                                      
                        MCX = (SELECT ISNULL((ISNULL((                                      
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                 
         AND CL_CODE = CD.CL_CODE                                      
         AND EXCHANGE = 'MCX'                                      
         AND SEGMENT = 'FUTURES'                                      
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ),                                      
         (                                      
         SELECT 'YES'                                        
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                        
                   WHERE  E.EXCHANGE = 'MCX'                                        
                   AND E.SEGMENT = 'FUTURES'                                        
                   AND E.CL_CODE = CD.CL_CODE                     
and E.Active_Date < @ModifyDate                                 
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                          
         ))),'NO'))                                        
  into #t    FROM     AngelNSECM.msajag.dbo.CLIENT_DETAILS CD (NOLOCK)                                        
               JOIN CLIENT_BROK_DETAILS CBD (NOLOCK)                                        
                 ON (CBD.CL_CODE = CD.CL_CODE)                                        
--      WHERE    LEFT(CBD.SYSTEMDATE,11) = @Modifydate                                        
         WHERE LEFT(CBD.active_date,11) = @ModifyDate                                 
        AND CBD.CL_CODE >= @FromPartyCode                                        
        AND CBD.CL_CODE <= @ToPartyCode                                        
        AND CD.BRANCH_CD = (CASE                                         
                       WHEN @BranchCd = '%' THEN CD.BRANCH_CD                                        
                              ELSE @BranchCd                                        
                            END)                                        
        AND CD.SUB_BROKER = (CASE                                         
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER                               
                               ELSE @SubBroker                                        
                             END)                                        
and cd.long_name not like '%close%'                            
and cd.party_code<>cd.introducer_id                             
/*and not exists         
(        select * from intranet.nsecourier.dbo.hist_temp_offlinemaster y where cbd.CL_CODE = y.cl_code        
) */                           
ORDER BY 2         
    
  
 insert into intranet.nsecourier.dbo.temp_offlinemaster    
 select *,@ModifyDate,getdate() from #t    
               
 insert into intranet.nsecourier.dbo.Hist_temp_offlinemaster    
 select *,@ModifyDate,getdate() from #t    
  
    
END

GO
