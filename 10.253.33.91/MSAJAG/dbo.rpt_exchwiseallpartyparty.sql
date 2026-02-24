-- Object: PROCEDURE dbo.rpt_exchwiseallpartyparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartyparty    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartyparty    Script Date: 01/04/1980 5:06:26 AM ******/



CREATE PROCEDURE rpt_exchwiseallpartyparty



@clcode varchar(6)

as

select distinct party_code from clientmaster
where cl_code=@clcode

GO
