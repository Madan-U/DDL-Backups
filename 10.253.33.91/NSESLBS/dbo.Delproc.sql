-- Object: PROCEDURE dbo.Delproc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure [dbo].[Delproc] (@sett_no Varchar(7),@sett_type Varchar(3) ) As  
Delete From MSAJAG.DBO.Delnet Where Sett_no = @sett_no And Sett_type =  @sett_type   
  
Insert Into MSAJAG.DBO.Delnet  
Select  Sett_no ,sett_type , Scrip_cd , Series,sum(pqty) 'tradeqty',inout = 'O'  
From Delpos  Where Sett_no = @sett_no And Sett_type = @sett_type  
Group By Sett_no ,sett_type , Scrip_cd , Series  
Having Sum(pqty) > 0   
  
Insert Into MSAJAG.DBO.Delnet  
Select  Sett_no ,sett_type , Scrip_cd , Series,sum(sqty) 'tradeqty',inout = 'I'  
From Delpos  Where Sett_no = @sett_no And Sett_type = @sett_type  
Group By Sett_no ,sett_type , Scrip_cd , Series  
Having Sum(sqty) > 0

GO
