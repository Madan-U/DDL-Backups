-- Object: PROCEDURE dbo.SelectBranch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc SelectBranch
@Cltcode varchar(10)
As
select branch_cd ,costcode  from msajag.dbo.clientmaster,costmast 
where party_code = @cltcode
and branch_cd = costname

GO
