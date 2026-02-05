-- Object: PROCEDURE citrus_usr.SLIP_NO
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

 --ALTER THIS VIEW UNDER SRE-34226

CREATE PROC [citrus_usr].[SLIP_NO] ( @SLIPNO  VARCHAR(20))
AS

Create table #slipno
(result varchar(25),Flag varchar(5))

Insert into #slipno
EXEC AGMUBODPL3.DMAT.citrus_usr.SLIP_NO @SLIPNO


Insert into #slipno
EXEC AngelDP5.DMAT.citrus_usr.SLIP_NO @SLIPNO

Insert into #slipno
EXEC ANGELDP202.DMAT.citrus_usr.SLIP_NO @SLIPNO
Insert into #slipno
EXEC ABVSDP203.DMAT.citrus_usr.SLIP_NO @SLIPNO
Insert into #slipno
EXEC ABVSDP204.DMAT.citrus_usr.SLIP_NO @SLIPNO

Select * from #slipno

GO
