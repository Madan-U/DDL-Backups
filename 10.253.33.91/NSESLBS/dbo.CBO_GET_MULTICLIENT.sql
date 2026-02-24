-- Object: PROCEDURE dbo.CBO_GET_MULTICLIENT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE   PROCEDURE [dbo].[CBO_GET_MULTICLIENT]
(
	
        @party_code VARCHAR(25)='',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END



	select 
	m.party_code,
	m.dpid,
	b.bankid,
	b.bankname,
	m.dptype,
	m.cltdpno,
	m.introducer,
	m.def,
	c.Depository1,
	c.DpId1,
	c.CltDpId1 
	from 
	multicltid m  
	left outer join client_Details c 
	on m.party_code=c.party_code
	left outer join bank b 
	on m.dpid=b.bankid 
	where m.party_code like  @party_code +'%'

GO
