-- Object: PROCEDURE dbo.USP_OFFLINE_CNT_TRADE_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE [dbo].[USP_OFFLINE_CNT_TRADE_DATA]  
(  
 @OnDate DATE   
)  
AS  
BEGIN  
  
--DECLARE @OnDate DATE   
--SET @OnDate = '2022-07-26'  
IF OBJECT_ID('tempdb..#tbl_CNT_Omnesys_Final') IS NOT NULL  
    DROP TABLE #tbl_CNT_Omnesys_Final  
select distinct * INTO #tbl_CNT_Omnesys_Final from tbl_CNT_Omnesys_Final WHERE FILE_DATE =@OnDate 
--Select Distinct EXCHG_ORDER_NO, REMARKS, USERID, Time, Exchg, File_Date, Acc_id, OrderSource INTO #tbl_CNT_Omnesys_Final from tbl_CNT_Omnesys_Final (nolock) WHERE FILE_DATE =@OnDate 
create index IX_#tbl_CNT_Omnesys_Final  On #tbl_CNT_Omnesys_Final(USERID) INCLUDE(OrderSource,REMARKS)  
  
----select * from #tbl_CNT_Omnesys_Final WHERE OrderSource ='TWS'  
----and  (REMARKS  <>'' OR REMARKS IS NOT NULL)  AND LEN(REMARKS) >0  
--select Count(*), OrderSource , REMARKS from #tbl_CNT_Omnesys_Final    
--       --WHERE (REMARKS  <>'' OR REMARKS IS NOT NULL)  AND LEN(REMARKS) >0  
--Group by OrderSource , REMARKS  
  
------ TWS Point Clear for Offline   
--Select * from #tbl_CNT_Omnesys_Final  
--WHERE   OrderSource ='TWS' AND (REMARKS ='' OR REMARKS IS NULL)   
  
  
----- Point Number 2  OFF LIne   
--Select * from #tbl_CNT_Omnesys_Final  
--WHERE  REMARKS LIKE 'TradeNXT%'  ----(REMARKS ='TradeNXT_Dealer')  
  
--------------------- PURGING DATA  
  IF OBJECT_ID('tempdb..#OFFLIne') IS NOT NULL  
    DROP TABLE #OFFLIne  
  Select distinct * INTO #OFFLIne from #tbl_CNT_Omnesys_Final  
  WHERE   OrderSource ='TWS' AND (REMARKS ='' OR REMARKS IS NULL)   
  
  INSERT INTO #OFFLIne  
  Select distinct * from #tbl_CNT_Omnesys_Final  
  WHERE  REMARKS LIKE 'TradeNXT%Dealer%' -- AND OrderSource ='TWS'  
  
  --ALTER TABLE #OFFLIne   
  --ADD OrderType  VARCHAR(10)  
  
  --UPDATE #OFFLIne  
  --SET OrderType ='Offline'  
     
--; with A  
--AS  
--(  
--Select * , ROW_NUMBER() OVER(PARTITIOn BY USERID,ACC_ID Order by  ACC_ID ) RNK from #OFFLIne  
  
--) Select * from A where  RNK =1    
  
------------------ Remove duplicate entries   
   Delete from [AngelBSECM].INHOUSE.DBO.tbl_CTCL_Terminal_Data_Temp where OdinId like  'OdinId%'  
  
  
 ;  
  with A  
  AS  
  (Select * , Row_number() Over( Partition by OdinId ,Final_SB_Tag, Type  order by OdinId ) rnk   
  from [AngelBSECM].INHOUSE.DBO.tbl_CTCL_Terminal_Data_Temp   
  ) delete From A where RNK>1  
  
  
  truncate table tbl_CTCL_Terminal_OFFLINE_CNT_TRADE  
  INSERT INTO tbl_CTCL_Terminal_OFFLINE_CNT_TRADE  
 SELECT distinct  UserId CTCLID,ACC_ID ,  
         FILE_DATE Trade_Date ,  
  --OrderSource,  
  CASE when ISNULL(Remarks,'') ='TradeNXT_Dealer' THEN 'TradeNXT_Dealer'   
       WHEN ISNULL(Remarks,'') ='' AND OrderSource ='TWS' THEN 'TWS' END Remarks,  
  --CASE WHEN USERID = ACC_ID THEN 'ClientOrder' ELSE 'Others' END INITBY ,  
  count(*) ORDERCount  ,  
  --SUB BROKER,  
   --branch_code,  
   --CASE WHEN A.Sub_Broker IS NOT NULL THEN 'SubBroker' else 'XXXXXXXX' END   
    --[Final_SB_Tag],  
    Type CTCLID_TYPE ,  
    C.sub_broker  
  --  INTO tbl_CTCL_Terminal_OFFLINE_CNT_TRADE  
  From #OFFLIne  B  
 -- LEFT OUTER JOIN dustbin.dbo.[tbl_CTCL_Terminal Data_2_Mar_22_temp]  A  WITH (NOLOCK) ON  A.OdinId =B.UserId  
   LEFT OUTER JOIN [AngelBSECM].INHOUSE.DBO.tbl_CTCL_Terminal_Data_Temp A ON  A.OdinId =B.UserId  
    LEFT OUTER JOIN client_details C WITH(NOLOCK)  ON C.cl_code =B.ACC_ID  
  GROUP BY USERID,ACC_ID ,OrderSource,FILE_DATE ,ISNULL(Remarks,''),  
  [Type] ,sub_broker  
     
   SELECT distinct * FROM tbl_CTCL_Terminal_OFFLINE_CNT_TRADE  where CTCLID <>ACC_ID
 
 
  
  END

GO
