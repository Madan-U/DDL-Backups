-- Object: PROCEDURE dbo.rpt_broktabledetails_original
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_broktabledetails    Script Date: 10/17/02 2:10:08 PM ******/    
    
    
/* Modified by amit on 06/08/2002 to display additional field and round to*/    
/****** Object:  Stored Procedure dbo.rpt_broktabledetails    Script Date: 01/29/2002 10:53:13 PM ******/    
    
/****** Object:  Stored Procedure dbo.rpt_broktabledetails    Script Date: 12/26/2001 1:23:16 PM ******/    
CREATE procedure rpt_broktabledetails    
    
@tabno as int    
    
as    
    
select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,normal,trd_del,val_perc,line_no,table_name,round_to,    
RoFig,ErrNum,NoZero,    
    
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else     
        ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else     
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else    
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else    
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else     
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'    
     
      end )end )end )end )end )end )    
from broktable    
where table_no = @tabno    
order by table_no,line_no,upper_lim

GO
