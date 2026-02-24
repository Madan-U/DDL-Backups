-- Object: PROCEDURE dbo.rpt_proc_KYC_Offline_Client_List
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC rpt_proc_KYC_Offline_Client_List

@DateFrom DateTime,
@DateTo DateTime,
@StatusID VarChar(20),
@StatusName VarChar(50),
@BranchCode VarChar(20),
@Exchange varchar(3),
@Segment varchar(7)
AS

SELECT  CD.Cl_Code as cl_code, Long_Name, Branch_cd 
FROM  msajag.dbo.Client_Details CD,msajag.dbo.Client_Brok_Details DBR
where CD.Cl_Code not in(select distinct party_code from KYC_MASTER) 
and CD.Cl_code = DBR.Cl_Code
and Branch_cd like @BranchCode + '%' 
and Exchange = @Exchange
and Segment = @Segment
and	Branch_cd LIKE Case When @StatusID = 'BRANCH' Then @StatusName Else '%' End AND
	Branch_cd LIKe Case When @StatusID = 'TRADER' Then @StatusName Else '%' End AND
	Branch_cd LIKE Case When @StatusID = 'SUBBROKER' Then @StatusName Else '%' End AND
	Branch_cd LIKE Case When @StatusID = 'FAMILY' Then @StatusName Else '%' End AND
	Branch_cd LIKE Case When @StatusID = 'CLIENT' Then @StatusName Else '%' End
and   active_Date >= @DateFrom + ' 00:00:00' and active_Date <= @DateTo + ' 23:59:59' 
group by  CD.Cl_Code,Long_Name, Branch_cd

GO
