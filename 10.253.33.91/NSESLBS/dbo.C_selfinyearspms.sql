-- Object: PROCEDURE dbo.C_selfinyearspms
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_selfinyearspms (@effdate Varchar(11), @accountdb Varchar(20),@accountdbserver Varchar(15))
As
Exec ('select Left(convert(varchar,sdtcur,109),11) Sdtcur, Left(convert(varchar,ldtcur,109),11) Ldtcur
From ' + @accountdbserver + '.' + @accountdb + '.dbo.parameter
Where "' +@effdate+'"' + ' Between Sdtcur And Ldtcur')

GO
