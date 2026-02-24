-- Object: PROCEDURE dbo.C_CollCalSelectPartySp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create Proc C_CollCalSelectPartySp (
@Exchange Varchar(3),
@Segment Varchar(20),
@FromParty Varchar(10),
@ToParty Varchar(10),
@AccountDb sysname)
As
exec ('Select Party_Code From C_PartySelectView where Party_code >= "'+@FromParty+'" and Party_Code <= "'+@ToParty+'" and Exchange = "'+@Exchange+'" and Segment ="'+@Segment+'"
union select distinct Party_code from ' + @AccountDb + '.dbo.MarginLedger 
where Party_code >="'+@FromParty+'" and Party_Code <= "'+@ToParty+'" order by Party_Code')

GO
