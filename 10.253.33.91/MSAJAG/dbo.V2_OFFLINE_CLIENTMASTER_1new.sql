-- Object: PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER_1new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[V2_OFFLINE_CLIENTMASTER_1new](                                                                              
          @ModifyDate    VARCHAR(11),                                                                              
          @ModifyType    VARCHAR(1),                                                                              
          @FromPartyCode VARCHAR(10),                                                                              
          @ToPartyCode   VARCHAR(10),                                                                              
          @BranchCd      VARCHAR(10),                                                                              
          @SubBroker     VARCHAR(10))                                                                              
AS                                                    
                                        
     set @ModifyDate =convert(datetime,@ModifyDate,103)                                    
                     
/*                            
declare    @ModifyDate    VARCHAR(11)                                        
declare          @ModifyType    VARCHAR(1)                                        
declare   @FromPartyCode VARCHAR(10)                                        
declare          @ToPartyCode   VARCHAR(10)                                        
declare          @BranchCd      VARCHAR(10)                                        
declare          @SubBroker     VARCHAR(10)                                        
                                        
set @ModifyDate = 'Jul 02 2008'                                        
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
                                
--print @ModifyDate                                                                              
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
   and inactive_from > getdate()+365                              
                                                       
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                                     
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                                                            
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'NSE'                            
     and E.inactive_from > getdate()+365                                                                              
                   AND E.SEGMENT = 'CAPITAL'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                                     
       and E.Active_Date < @ModifyDate                           --and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),   
  
                                                                         
                        BSE = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                                                          
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                          
         WHERE LEFT(active_date,11) = @ModifyDate                             
   and cbd.inactive_from > getdate()+365                         
         AND CL_CODE = CD.CL_CODE             
         AND EXCHANGE = 'BSE'                            
                                                                 
    AND SEGMENT = 'CAPITAL'                                
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                              
         (                                                                    
         SELECT 'YES'                                       
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
  WHERE  E.EXCHANGE = 'BSE'                            
     and e.inactive_from > getdate()+365                                                                             
                   AND E.SEGMENT = 'CAPITAL'                                                                   
                   AND E.CL_CODE = CD.CL_CODE                                                                  
     and E.Active_Date < @ModifyDate                               
                                               
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),                                                              
                        FO = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                                                          
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                          
         WHERE LEFT(active_date,11) = @ModifyDate                             
   and inactive_from > getdate()+365                                                                     
         AND CL_CODE = CD.CL_CODE                                                                          
         AND EXCHANGE = 'NSE'                                                                          
         AND SEGMENT = 'FUTURES'                                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                                                   
          FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'NSE'                           
       and E.inactive_from > getdate()+365                                          
                   AND E.SEGMENT = 'FUTURES'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                                          
     and E.Active_Date < @ModifyDate                                                                     
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),        
  
  
--------ADD BSEFO   
  
BSEFO = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                  
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                          
         WHERE LEFT(active_date,11) = @ModifyDate                             
   and inactive_from > getdate()+365                                                                     
         AND CL_CODE = CD.CL_CODE                                                                          
         AND EXCHANGE = 'BSE'                                                                          
         AND SEGMENT = 'FUTURES'                                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                                                   
          FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'BSE'                           
       and E.inactive_from > getdate()+365                                          
                   AND E.SEGMENT = 'FUTURES'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                                          
     and E.Active_Date < @ModifyDate                                                                     
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),       
  
  
-------END BSEFO  
                                                                    
NCDX = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                                                                          
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                     
         WHERE LEFT(active_date,11) = @ModifyDate                                 
 and inactive_from > getdate()+365                                                                  
         AND CL_CODE = CD.CL_CODE                                                                          
         AND EXCHANGE = 'NCX'                                
         AND SEGMENT = 'FUTURES'                                                              
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                             
         ),                                                                          
         (                                                                          
         SELECT 'YES'                           
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'NCX'                            
 and E.inactive_from > getdate()+365                                                                           
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
   and inactive_from > getdate()+365                                                                          
         AND EXCHANGE = 'MCX'                                                                          
         AND SEGMENT = 'FUTURES'                                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'MCX'                            
   and inactive_from > getdate()+365                                                                              
                   AND E.SEGMENT = 'FUTURES'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                         
and E.Active_Date < @ModifyDate                                                                     
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),   
  
---------new segment add  
MCD = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                          
         WHERE LEFT(active_date,11) = @ModifyDate                                                                     
         AND CL_CODE = CD.CL_CODE                              
   and inactive_from > getdate()+365                                                                          
         AND EXCHANGE = 'MCD'                                                                          
         AND SEGMENT = 'FUTURES'                                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'MCD'                            
   and inactive_from > getdate()+365                                                                              
                   AND E.SEGMENT = 'FUTURES'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                         
and E.Active_Date < @ModifyDate                                                                     
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO')),    
  
NSX = (SELECT ISNULL((ISNULL((                                                                          
         SELECT 'NEW' FROM CLIENT_BROK_DETAILS (NOLOCK)                              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                          
         WHERE LEFT(active_date,11) = @ModifyDate                                                                     
         AND CL_CODE = CD.CL_CODE                              
   and inactive_from > getdate()+365                                                                          
         AND EXCHANGE = 'NSX'                                                                          
         AND SEGMENT = 'FUTURES'                                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ),                                                                          
         (                                                                          
         SELECT 'YES'                                    
                    FROM   CLIENT_BROK_DETAILS E (NOLOCK)                                                                            
                   WHERE  E.EXCHANGE = 'NSX'                            
   and inactive_from > getdate()+365                                                                              
                   AND E.SEGMENT = 'FUTURES'                                                                            
                   AND E.CL_CODE = CD.CL_CODE                                                         
and E.Active_Date < @ModifyDate                                                                     
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                              
         ))),'NO'))   
-------end                                                                          
  into #t    FROM     AngelNSECM.msajag.dbo.CLIENT_DETAILS CD (NOLOCK)                                                                            
               JOIN CLIENT_BROK_DETAILS CBD (NOLOCK)                                                                            
                 ON (CBD.CL_CODE = CD.CL_CODE)     
--      WHERE    LEFT(CBD.SYSTEMDATE,11) = @Modifydate                                                                            
         WHERE LEFT(CBD.active_date,11) = @ModifyDate                             
  and cbd.inactive_from > getdate()+365                                                                     
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
and /*cd.long_name not like '%close%'                                                                
and*/ cd.party_code<>cd.introducer_id                                                                 
/*and not exists                                             
(        select * from intranet.nsecourier.dbo.hist_temp_offlinemaster y where cbd.CL_CODE = y.cl_code                                            
) */                                                               
ORDER BY 2                                             
                                        
                                      
--  insert into intranet.nsecourier.dbo.temp_offlinemaster                                        
--  select *,@ModifyDate,getdate() from #t where                                        
--                                                    
--  insert into intranet.nsecourier.dbo.Hist_temp_offlinemaster                                        
--  select *,@ModifyDate,getdate() from #t                                        
--                                         
                                                                 
                                            
                        
select *,                                    
case when nse = 'YES' then 1 else 0 end as nse1,                                    
case when bse = 'YES' then 1 else 0 end as bse1,                                    
case when fo = 'YES' then 1 else 0 end as fo1,                                     
case when ncdx = 'YES' then 1 else 0 end as ncdx1,                                    
case when mcx = 'YES' then 1 else 0 end as mcdx1,     
case when bsefo = 'YES' then 1 else 0 end as bsefo1,         
case when mcd = 'YES' then 1 else 0 end as mcd1,          
case when nsx = 'YES' then 1 else 0 end as nsx1          
                            
into #x from #t where long_name not like '%close%'                                    
                                    
select * into #y from #t where cl_code in                                       
(                                    
select CL_CODE from #x                                      
group by CL_CODE                                     
having sum(nse1+bse1+fo1+ncdx1+mcdx1+bsefo1+mcd1+nsx1) = 0                                    
)                       
-----                
            
select client_code into #c from intranet.nsecourier.dbo.delivered            
union all            
---select cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster            
select distinct cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster                   
select * into #z from #y where cl_code not in (select client_code from #c)            
            
            
                    
--select * from #y where cl_code not in (select client_code from intranet.nsecourier.dbo.delivered)             
--select * from #y where cl_code not in (select cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster)            
-------                            
                             
insert into intranet.nsecourier.dbo.temp_offlinemaster                                     
select *,@ModifyDate,getdate() from #t where cl_code in                                       
(                                    
select distinct cl_code from client_brok_details where cl_code in                                
(select cl_code from #z) and Inactive_from =  '2049-12-31 00:00:00.000' and Inactive_from > getdate()+365 and LEFT(active_date,11)=@ModifyDate                        
)               
              
---              
/*insert into intranet.nsecourier.dbo.temp_offlinemaster                                    
select *,@ModifyDate,getdate() from #t where cl_code in                                       
(                                    
select distinct cl_code from client_brok_details where cl_code not in                                
(select distinct * from hist_temp_offlinemaster where cl_code not in               
(select cl_code from #t) and Inactive_from =  '2049-12-31 00:00:00.000' and LEFT(active_date,11)=@ModifyDate                        
)              
) */             
----                          
                                   
insert into intranet.nsecourier.dbo.Hist_temp_offlinemaster                                        
select *,@ModifyDate,getdate()  from #t where cl_code in                                       
(                                    
select distinct cl_code from client_brok_details where cl_code in                                    
(select cl_code from #z) and Inactive_from =  '2049-12-31 00:00:00.000'  and Inactive_from > getdate()+365 and LEFT(active_date,11)=@ModifyDate                                         
)       
                        
insert into intranet.nsecourier.dbo.close_name                         
select *,@ModifyDate,getdate() from #t where long_name like '%close%'       
    
                                
             
                 
                                    
/*                                    
select distinct cl_code from client_brok_details where cl_code in                                    
(select cl_code from #y) and Inactive_from <> '2049-12-31 00:00:00.000'                                    
*/                                    
                         
END

GO
