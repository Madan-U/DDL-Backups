-- Object: PROCEDURE dbo.Finalob
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Finalob (@sett_no Varchar(7),@sett_type Varchar(3)) As  
Delete From Finob Where Sett_no = @sett_no And Sett_type = @sett_type   
Insert Into Finob Select Sett_no,sett_type,getdate(),isnull(sum(pqty) ,0),isnull(sum(pamt) ,0),isnull(sum(sqty) ,0),isnull(sum(samt) ,0) From Tempfinalobl  
Where Sett_no = @sett_no And Sett_type = @sett_type   
Group By Sett_no,sett_type

GO
