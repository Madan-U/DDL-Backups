-- Object: VIEW citrus_usr.VW_OFFMKT_NXT
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


 --ALTER THIS VIEW UNDER SRE-34226
CREATE VIEW [citrus_usr].[VW_OFFMKT_NXT]      
AS      
  
select row_number() over (order by DPTDC_EXECUTION_DT) Sn_no,T.*,SB.long_name client_name,SB_broker.sbtag,TradeName sb_name from   
(  
SELECT * FROM [AGMUBODPL3].DMAT.CITRUS_USR.VW_OFFMKT_NXT  
Union all  
SELECT * FROM [AngelDP5].DMAT.CITRUS_USR.VW_OFFMKT_NXT  
Union all  
SELECT * FROM ANGELDP202.DMAT.CITRUS_USR.VW_OFFMKT_NXT 
 Union all  
SELECT * FROM abvsdp203.DMAT.CITRUS_USR.VW_OFFMKT_NXT
 Union all  
SELECT * FROM abvsdp204.DMAT.CITRUS_USR.VW_OFFMKT_NXT

) T left join [NXTProd].nxt.dbo.sb_client_details SB  
 on T.PARTY_CODE=SB.party_code  
 left join [MIS].SB_Comp.dbo.SB_Broker SB_Broker with(nolock)   
on SB.sub_broker=sb_broker.sbtag

GO
