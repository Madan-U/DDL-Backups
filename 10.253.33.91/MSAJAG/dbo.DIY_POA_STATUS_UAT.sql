-- Object: PROCEDURE dbo.DIY_POA_STATUS_UAT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc [dbo].[DIY_POA_STATUS_UAT] (@PARTY_CODE VARCHAR(10))
AS

declare @cnt int ,@diyflag int

 
 /*
	select @cnt = count(1) from (
	select PARTY_CODE from ANGELDEMAT.MSAJAG.DBO.MultiCltId  WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE 
	UNION 
	select PARTY_CODE from  ANGELDEMAT.BSEDB.DBO.MultiCltId  WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE )a */

	/* select distinct partycode into diyclient FROM  
			[172.31.16.75].Angel_WMS.DBO.po_acceptance_status a  
			WHERE date_time_stamp >= convert(varchar(11),getdate()-31,120)
			--AND CreationDate <=CONVERT(VARCHAR(11),@date,120) +' 23:59' AND   
		   AND ACTION ='SELL'   --and  isnull(convert(float, replace(Quantity,',','')),0) <>0 
			--and  ISNULL(SYMBOL,'') <> '' --AND ISNULL( ISIN,'')  <>'' --AND LEN(DPID)=16 */

	
	select @cnt = count(1) from (
	select PARTY_CODE from   MSAJAG.DBO.MultiCltId (nolock)  WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE 
	UNION 
	select PARTY_CODE from  ANAND.BSEDB_aB.DBO.MultiCltId with (nolock) WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE )a
	 
	select @diyflag =count(1) from diyclient (nolock) where partycode =@PARTY_CODE and partycode not in ('A126749')


IF (@PARTY_CODE IN ('N61558','A115390','A126749','M103737','P104922','S203000','H45178','T21077','S250357','S194943','S227494','J41740','R123896','A133377','A126749'))
  BEGIN
    SELECT @PARTY_CODE AS PARTY_CODE , 'I' POA_STATUS , (case when ISNULL(@diyflag ,0)>=1 then 'POA' else 'CDSL' end) FLAG
   RETURN  
  END



 if (ISNULL(@cnt,0) >= 1 )
   begin 
     SELECT @PARTY_CODE AS PARTY_CODE , 'I' POA_STATUS, (case when ISNULL(@diyflag ,0)>=1 then 'POA' else 'CDSL' end) FLAG
   RETURN
    END
    ELSE 
	  BEGIN 
	  	 SELECT @PARTY_CODE AS PARTY_CODE , 'A' POA_STATUS ,''FLAG
	  RETURN 
	  END

GO
