-- Object: PROCEDURE dbo.DPC_GetTB
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE Procedure DPC_GetTB(@acdate as varchar(11),@tbdate as varchar(11),@segment as  varchar(10))  
as  
Truncate table DPC_TB_TEMP
insert into DPC_TB_TEMP select @segment,cltcode,drcr,vamt from dbo.DPC_TB(@acdate,@tbdate)

GO
