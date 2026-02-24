-- Object: PROCEDURE dbo.DPC_GetTB_NB
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure [dbo].[DPC_GetTB_NB](@acdate as varchar(11),@tbdate as varchar(11),@segment as  varchar(10))    
as    
Truncate table DPC_TB_NB_TEMP  
---insert into DPC_TB_NB_TEMP select @segment,cltcode,drcr,vamt from dbo.DPC_TB_NB(@acdate,@tbdate)    
insert into DPC_TB_NB_TEMP 
Exec [DPC_TB_NB_Opt] @acdate,@tbdate,@segment

GO
