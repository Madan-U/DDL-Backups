-- Object: PROCEDURE dbo.rpt_exchwiseallpartyparty
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartyparty    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartyparty    Script Date: 11/28/2001 12:23:49 PM ******/



CREATE PROCEDURE rpt_exchwiseallpartyparty



@clcode varchar(6)

as

select distinct party_code from msajag.dbo.clientmaster
where cl_code=@clcode

GO
