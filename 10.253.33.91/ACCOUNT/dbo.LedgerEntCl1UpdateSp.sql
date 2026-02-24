-- Object: PROCEDURE dbo.LedgerEntCl1UpdateSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.LedgerEntCl1UpdateSp    Script Date: 20-Mar-01 11:43:34 PM ******/

/* Created by vaishali on 26/12/2000
  Used in the control LedgerEntry to update the credit limit
*/
CREATE PROCEDURE LedgerEntCl1UpdateSp
@crlimit as money,
@party_cd as varchar(10)
 AS
Update MSAJAG.DBO.client1 set credit_limit = credit_limit + @crlimit
where cl_code in(select cl_code from MSAJAG.DBO.client2
    where party_code = @party_cd)

GO
