-- Object: PROCEDURE dbo.AcNameCodeSelect
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.AcNameCodeSelect    Script Date: 02/22/2002 1:56:02 PM ******/
CREATE Proc AcNameCodeSelect
@branch varchar(20)

AS

select distinct l.acname,l.cltcode from ledger l, acmast a
where l.cltcode = a.cltcode and accat = 4 and (branchcode = @branch or branchcode = 'ALL')

GO
