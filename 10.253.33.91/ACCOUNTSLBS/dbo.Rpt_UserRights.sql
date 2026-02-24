-- Object: PROCEDURE dbo.Rpt_UserRights
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Procedure [dbo].[Rpt_UserRights]

   @voucher_type Varchar(2)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DISTINCT 

	U.UserCategory,
	U.UserStatusId,
	vtyp = convert(varchar, U.vtyp) +' ' + V.Vdesc,
	Booktype = convert(varchar, U.Booktype) +' ' + B.Description,
	U.NoDays,
	U.NoDaysD 

FROM 

	userrights U (nolock),
	vmast V (nolock),
	Booktype B (nolock),
	msajag.dbo.tblcategory T (nolock)

WHERE

	 U.vtyp = @voucher_type and
	 U.vtyp = V.Vtype and
	 U.Booktype=B.Booktype and
	 U.UserCategory=T.Fldcategorycode 

ORDER BY

	U.UserCategory,
	U.NoDays,
	U.NoDaysD

GO
