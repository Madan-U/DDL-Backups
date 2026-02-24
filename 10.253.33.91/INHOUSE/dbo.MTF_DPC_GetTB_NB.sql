-- Object: PROCEDURE dbo.MTF_DPC_GetTB_NB
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure [dbo].[MTF_DPC_GetTB_NB](@acdate as varchar(11),@tbdate as varchar(11),@segment as  varchar(10))    
as    

  

Truncate table MTF_DPC_TB_NB_TEMP  
insert into MTF_DPC_TB_NB_TEMP 
/*select @segment,cltcode,drcr,vamt from dbo.MTF_DPC_TB_NB(@acdate,@tbdate)    */
Exec DPC_TB_NB_MTF_Opt @acdate,@tbdate,@segment

GO
