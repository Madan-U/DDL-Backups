-- Object: PROCEDURE dbo.Insertnodel_new
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure [dbo].[Insertnodel_new] 
@srno Int,    
@scrip_cd varchar(12) ,    
@series varchar(2),
@start_date varchar(11) ,    
@end_date varchar(11)
As     
declare 
@sett_no Varchar(7),    
@sett_type Varchar(2),  
@settledin Char(7)  

Select @Sett_Type = (Case When @series = 'BE' then 'W' Else 'N' End)

select @sett_no = Sett_No From Sett_Mst
Where Start_date like @start_date + '%'
And Sett_Type = @Sett_Type 

if @Sett_No is not null
begin
	select @settledin = Sett_No From Sett_Mst
	Where Sett_Type = @Sett_Type 
	And Start_date = (Select min(Start_Date) From Sett_Mst 
			  Where Start_Date > @end_date + ' 23:59:59' 
			  And Sett_Type = @Sett_Type)

	if @settledin is not null
	begin
		Delete From Nodel Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
		And Scrip_Cd = @Scrip_Cd And Series = @series
	
		Insert Into Nodel Values(@srno,@scrip_cd,@series,@sett_no,@sett_type,@start_date,@end_date + ' 23:59',@settledin)    
	end 
end

GO
