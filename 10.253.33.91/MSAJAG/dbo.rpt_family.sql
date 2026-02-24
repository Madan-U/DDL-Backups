-- Object: PROCEDURE dbo.rpt_family
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_family    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_family    Script Date: 01/04/1980 5:06:27 AM ******/


/* familywise ledger */
/* finds families from client1 */

CREATE PROCEDURE rpt_family

@statusid varchar(15),
@statusname  varchar(25)


AS

if @statusid='broker'
begin
	select distinct family from client1
	order by family
end


if @statusid='family'
begin
	select distinct family from client1
	where family=@statusname
	order by family
end

GO
