-- Object: PROCEDURE dbo.rpt_exchallpartyexch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/* exchangewise allparty ledger */
/* shows exchange for a particular company and account database */

CREATE  PROCEDURE rpt_exchallpartyexch

@company  varchar(50),
@accountdb varchar (15),
@sharedb varchar(15)

as


select  distinct exchange + '-' + segment from  msajag.dbo.multicompany 
where companyname=@company and accountdb=@accountdb and sharedb=@sharedb

GO
