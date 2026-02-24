-- Object: VIEW citrus_usr.E_DIS_MKT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


    
    
        
    CREATE VIEW [citrus_usr].[E_DIS_MKT]          
AS          
        
----SELECT * FROM (        
----SELECT  BOID,ISIN,QTY,FLAG,REQUEST_DATE,NO_OF_DAYS ,DIS_TRXN_STATUS=ISNULL(DUMMY3,''),TRXN_ID=CDSL_TRXN_ID  FROM E_DIS_TRXN_DATA (NOLOCK)          
----WHERE REQUEST_DATE =CONVERT(VARCHAR(11),GETDATE(),120) AND ISNULL(DUMMY3,'') <>'E'          
----UNION ALL          
----SELECT  DPT3_BO_ID,DPT3_ISIN,DPT3_TXN_QUANTITY,DPT3_EDIS_TXN_TYPE,          
----DPT3_TXN_TIME= CONVERT(VARCHAR(11),GETDATE(),120) ---CAST(RIGHT(LEFT(DPT3_TXN_TIME,8),4)+'-'+RIGHT(LEFT(DPT3_TXN_TIME,4),2)+'-'+LEFT(DPT3_TXN_TIME,2) AS DATETIME)          
----,DPT3_VALIDITY_DAYS,DPT3_EDIS_TXN_STATUS,DPT3_TXN_ID          
----FROM DPT3_MSTR (NOLOCK) WHERE DPT3_EDIS_TXN_STATUS <>'E'  )A        
----WHERE CONVERT(VARCHAR(11),GETDATE(),120) BETWEEN REQUEST_DATE AND REQUEST_DATE+90         
        
SELECT DISTINCT  BOID,ISIN,QTY=(CASE WHEN CAST(ISNULL(PEND_QTY,0)AS FLOAT)>0 THEN CAST(ISNULL(PEND_QTY,0) AS FLOAT) ELSE QTY END )        
,FLAG,REQUEST_DATE=Trade_date,NO_OF_DAYS ,DIS_TRXN_STATUS=ISNULL(DUMMY3,''),TRXN_ID=CDSL_TRXN_ID   ,Sec_payin --,Sett_NO     
FROM  E_DIS_TRXN_DATA T (NOLOCK) ,(    
select replace(LEFT(CONVERT(VARCHAR,Sec_payin, 104), 10),'.','') as payindate,start_Date as Trade_date,Sec_payin as Sec_payin--,Sett_NO     
 from [ANGELDEMAT].msajag.dbo.sett_mst m with(Nolock)    
where start_Date >=convert(varchar(11),getdate()-7,120)    
and sett_type='N'    
 )S    
WHERE REQUEST_DATE >getdate()-7     
AND ISNULL(VALID,0)=0 AND ISNULL(DUMMY3,'')<>'E'         
and dummy2 =payindate    
--and Request_date>='2021-02-22'    
---and NO_of_days=5

GO
