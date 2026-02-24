-- Object: PROCEDURE dbo.rpt_proc_KYC_Offline_Client_List
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC rpt_proc_KYC_Offline_Client_List

@DateFrom DateTime,
@DateTo DateTime,
@StatusID VarChar(20),
@StatusName VarChar(50),
@BranchCode VarChar(20)

AS

SELECT  tmpPartyCode, tmpLongName, tmpBranchCode 
FROM  msajag.dbo.tmp_Client_Details 
where tmpPartyCode not in(select distinct party_code from KYC_MASTER) 
and tmpBranchCode like @BranchCode + '%' AND

	tmpBranchCode LIKE Case When @StatusID = 'BRANCH' Then @StatusName Else '%' End AND
	tmpTraderCode LIKe Case When @StatusID = 'TRADER' Then @StatusName Else '%' End AND
	tmpSubBrokerCode LIKE Case When @StatusID = 'SUBBROKER' Then @StatusName Else '%' End AND
	tmpFamilyCode LIKE Case When @StatusID = 'FAMILY' Then @StatusName Else '%' End AND
	tmpPartyCode LIKE Case When @StatusID = 'CLIENT' Then @StatusName Else '%' End

group by  tmpPartyCode,tmpLongName, tmpBranchCode

UNION ALL

SELECT  c2.Party_Code, c1.Long_Name, c1.Branch_Cd 
FROM  client1 c1, client2 c2, client5 c5
where c2.Party_Code not in(select distinct party_code from KYC_MASTER)

and c1.cl_code = c2.cl_code
and c2.cl_code = c5.cl_code
and c5.activefrom >= @DateFrom + ' 00:00:00' and c5.activefrom <= @DateTo + ' 23:59:59' 
and c1.Branch_cd like @BranchCode + '%' AND

	c1.branch_cd LIKE Case When @StatusID = 'BRANCH' Then @StatusName Else '%' End AND
	c1.trader LIKE Case When @StatusID = 'TRADER' Then @StatusName Else '%' End AND
	c1.sub_broker LIKE Case When @StatusID = 'SUBBROKER' Then @StatusName Else '%' End AND
	c1.family LIKE Case When @StatusID = 'FAMILY' Then @StatusName Else '%' End AND
	c1.cl_code LIKE Case When @StatusID = 'CLIENT' Then @StatusName Else '%' End

group by  c2.Party_Code, c1.Long_Name, c1.Branch_Cd

GO
