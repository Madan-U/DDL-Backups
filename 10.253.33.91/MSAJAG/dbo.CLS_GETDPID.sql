-- Object: PROCEDURE dbo.CLS_GETDPID
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



-- CLS_GetDpID 'in989898',1

create PROCEDURE [dbo].[CLS_GETDPID] 
	@dpid varchar(15),
	@flag int=0
AS
BEGIN
		--select distinct Dpid,Dpcltno from MSAJAG..Deliverydp
IF @flag=1
	BEGIN
		select Dpcltno from MSAJAG..Deliverydp where Dpid=@dpid
	END
ELSE
	select distinct Dpid from MSAJAG..Deliverydp
END

GO
