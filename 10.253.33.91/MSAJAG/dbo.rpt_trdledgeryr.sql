-- Object: PROCEDURE dbo.rpt_trdledgeryr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* report traderledger
   file traderwise.asp
*/ 

create proc rpt_trdledgeryr
as

select styr=convert(varchar,sdtcur,103), endyr=convert(varchar,ldtcur,103) from account.dbo.parameter where
curyear=1

GO
