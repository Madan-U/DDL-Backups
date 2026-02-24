-- Object: PROCEDURE dbo.GetMarginparty
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE GetMarginparty
@branch varchar(10)
AS

if @branch = 'ALL' 
begin
	select distinct  acname, cltcode from acmast a, marginledger m
	where a.cltcode = m.party_code  
end
else
begin
	select distinct  acname, cltcode from acmast a, marginledger m, msajag.dbo.clientmaster c
	where a.cltcode = m.party_code and m.party_code = c.party_code and branch_cd = @branch
end

GO
