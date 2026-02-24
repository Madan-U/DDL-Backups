-- Object: PROCEDURE dbo.SP_DPDetails_NXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
--SP_DPDetails_NXT 'RVO'  
--SP_DPDetails_NXT 'AJYC'  
--SP_DPDetails_NXT 'CBHO'  
CREATE procedure [dbo].[SP_DPDetails_NXT]   
@sub_broker varchar(20)  
--with recompile  
AS  
 BEGIN  
  --declare @sub_broker varchar(20)='RVO'  
  --drop table #dpdetails  
  SELECT SCD.sub_broker as sub_broker,SCD.long_name,DP.PARTY_CODE as PARTY_CODE ,DP.BankID as BankID,DP.Cltdpid as Cltdpid,DP.Depository,DEFDP into #dpdetails  
  FROM CLIENT4 DP with(Nolock)  
  inner join client_details SCD  
  on DP.PARTY_CODE=SCD.party_code  
  where sub_broker=@sub_broker  
  AND Depository IN ('CDSL','NSDL')  
  AND DP.Cltdpid!=''    
   
  UNION    
  
  SELECT SCD.sub_broker as sub_broker,SCD.long_name,DP.PARTY_CODE as PARTY_CODE ,DP.BankID as BankID ,DP.Cltdpid as Cltdpid,DP.Depository,DEFDP  
  FROM [AngelBSECM].BSEDB_AB.DBO.CLIENT4 DP with(Nolock)  
  inner join client_details SCD  
  on DP.PARTY_CODE=SCD.party_code  
  where sub_broker=@sub_broker  
  AND Depository IN ('CDSL','NSDL')  
  AND DP.Cltdpid!=''    
  
  UNION  
  
  SELECT SCD.sub_broker as sub_broker,SCD.long_name,DP.PARTY_CODE as PARTY_CODE ,DP.DPID AS BANKID,DP.CLTDPNO AS Cltdpid,DpType as Depository,Def  
  FROM MultiCltId DP with(Nolock)  
  inner join client_details SCD  
  on DP.PARTY_CODE=SCD.party_code  
  where sub_broker=@sub_broker  
    
  UNION   
  
  SELECT SCD.sub_broker as sub_broker,SCD.long_name,DP.PARTY_CODE as PARTY_CODE,DP.DPID AS BANKID,DP.CLTDPNO AS Cltdpid,DpType as Depository,Def  
  FROM [AngelBSECM].BSEDB_AB.DBO.MultiCltId DP with(Nolock)  
  inner join client_details SCD  
  on DP.PARTY_CODE=SCD.party_code  
  where sub_broker=@sub_broker  
    
  --drop table #dpdetails  
  --select D.*,B.BankName   
  --from #dpdetails D  
  --LEFT OUTER JOIN BANK B ON D.BankID=B.BankID   
  --ORDER BY D.party_code ASC  
  
  select sub_broker,long_name,PARTY_CODE, Cltdpid,BankName  
  into #DPFinal  
  from    
  (  
   select D.*,B.BankName   
   from(  
    select sub_broker, long_name, PARTY_CODE, BankID,  
    case when Depository='NSDL'   
     then BankID+Cltdpid   
     else Cltdpid   
    end as Cltdpid, Depository, DEFDP  
    from #dpdetails  
   )D  
   LEFT OUTER JOIN BANK B ON D.BankID=B.BankID  
  )A  
  group by sub_broker,long_name,PARTY_CODE, Cltdpid,BankName   
  ORDER BY party_code ASC  
  
  select   
  ROW_NUMBER() OVER(ORDER BY D.party_code ASC) AS id  
  ,RTRIM(LTRIM(D.PARTY_CODE)) as ClientCode  
  ,RTRIM(LTRIM(D.long_name)) as ClientName  
  ,RTRIM(LTRIM(D.Cltdpid)) DPId  
  ,ISNULL(RTRIM(LTRIM(UPI.[UPI])),'') AS UPIId  
  ,ISNULL(RTRIM(LTRIM(BCG.Name)),'') AS GroupName  
  ,ISNULL(RTRIM(LTRIM(BCC.SelectedUPIId)),'') AS SelectedUPIId  
  ,ISNULL(RTRIM(LTRIM(BANKNAME)),'') AS DP_NAME   
  ,case when BANKNAME like 'ANGEL BROKING LIMITED' then Cltdpid else '' end as DefaultDPID  
  FROM #DPFinal  D  
  LEFT JOIN [172.31.16.95].nxt.dbo.BulkIPO_ClientGroup_Clients BCC WITH(NOLOCK) ON RTRIM(LTRIM(BCC.PartyCode)) = RTRIM(LTRIM(D.party_code))    
  LEFT JOIN [172.31.16.95].nxt.dbo.BulkIPO_ClientGroup BCG WITH(NOLOCK) ON BCG.Id = BCC.GroupId    
  LEFT JOIN INTRANET.RISK.dbo.[TBL_IPO_Client_UPI] UPI WITH(NOLOCK) ON RTRIM(LTRIM(UPI.[PartyCode])) =  RTRIM(LTRIM(D.party_code))  
  
 END

GO
