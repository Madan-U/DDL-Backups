-- Object: PROCEDURE dbo.C_SelFinYearSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create Proc C_SelFinYearSp (@EffDate Varchar(11), @AccountDb Varchar(20))
As
Exec ('Select Left(Convert(Varchar,sdtcur,109),11) SdtCur, Left(Convert(Varchar,ldtcur,109),11) Ldtcur
From ' + @AccountDb + '.Dbo.Parameter
Where "' +@EffDate+'"' + ' Between Sdtcur and Ldtcur')

GO
