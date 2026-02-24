-- Object: PROCEDURE dbo.C_collcalselectpartysp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_collcalselectpartysp (
@exchange Varchar(3),
@segment Varchar(20),
@fromparty Varchar(10),
@toparty Varchar(10),
@accountdb Sysname)
As
Exec ('select Party_code From C_partyselectview Where Party_code >= "'+@fromparty+'" And Party_code <= "'+@toparty+'" And Exchange = "'+@exchange+'" And Segment ="'+@segment+'"
Union Select Distinct Party_code From ' + @accountdb + '.dbo.marginledger 
Where Party_code >="'+@fromparty+'" And Party_code <= "'+@toparty+'" Order By Party_code')

GO
