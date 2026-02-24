-- Object: PROCEDURE dbo.Billalltrade
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Billalltrade (@sett_no Varchar(7),@sett_type Varchar(2)) As   
Begin  
If ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0  
Begin  
 Exec Bserearrangesubbillflag @sett_no,@sett_type  
 Exec Bsegensubbillno @sett_no,@sett_type  
End  
Exec Bserearrangebillflagnew @sett_no,@sett_type /*added By Bhagyashree On 9-6-2001*/  
Exec Bsegeninsbillno @sett_no,@sett_type  
Exec Bsegenbillno @sett_no,@sett_type  
End

GO
