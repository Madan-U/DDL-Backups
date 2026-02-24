-- Object: PROCEDURE dbo.Rpt_ClientBrokTableDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure Rpt_ClientBrokTableDetails
(@Party_Code Varchar(10))
As      

Select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,
normal,trd_del,val_perc,line_no,table_name,round_to,      
RoFig,ErrNum,NoZero,      
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else       
        ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else       
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else      
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else      
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else       
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'             
      end )end )end )end )end )end ),
Exchange, Segment, TableType = (Case When table_no = Trd_Brok Then 'TRADING' Else 'DELIVERY' End)
From Broktable, Client_Brok_Details C
where Cl_Code = @Party_Code
And (table_no = Trd_Brok
Or Table_No = Del_Brok) 
And Exchange = 'NSE' And Segment = 'CAPITAL'
Union All
Select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,
normal,trd_del,val_perc,line_no,table_name,round_to,      
RoFig,ErrNum,NoZero,      
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else       
        ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else       
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else      
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else      
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else       
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'             
      end )end )end )end )end )end ),
Exchange, Segment, TableType = (Case When table_no = Trd_Brok Then 'TRADING' Else 'DELIVERY' End)
From BSEDB..Broktable, Client_Brok_Details C
where Cl_Code = @Party_Code
And (table_no = Trd_Brok
Or Table_No = Del_Brok) 
And Exchange = 'BSE' And Segment = 'CAPITAL'
Union All
Select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,
normal,trd_del,val_perc,line_no,table_name,round_to,      
RoFig,ErrNum,NoZero,      
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else       
        ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else       
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else      
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else      
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else       
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'             
      end )end )end )end )end )end ),
Exchange, Segment, 
TableType = (Case When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok 
		       And Fut_Opt_Brok = Fut_Fut_Fin_Brok 
		       And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE ALL TYPE'
		  When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok Then 'FUTURE/OPTION NORMAL'
		  When table_no = Fut_Fut_Fin_Brok And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE/OPTION EXPIRY'
		  When table_no = Fut_Brok Then 'FUTURE NORMAL' 
	          When table_no = Fut_Opt_Brok Then 'OPTION NORMAL' 
	          When table_no = Fut_Fut_Fin_Brok Then 'FUTURE EXPIRY' 
	          When table_no = Fut_Opt_Exc Then 'OPTION EXERCISE' 
             End)
From NSEFO..Broktable, Client_Brok_Details C
where Cl_Code = @Party_Code
And (table_no = Fut_Brok
Or Table_No = Fut_Opt_Brok
Or Table_No = Fut_Fut_Fin_Brok
Or Table_No = Fut_Opt_Exc) 
And Exchange = 'NSE' And Segment = 'FUTURES'
Union All
Select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,
normal,trd_del,val_perc,line_no,table_name,round_to,      
RoFig,ErrNum,NoZero,      
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else       
     ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else       
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else      
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else      
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else       
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'             
      end )end )end )end )end )end ),
Exchange, Segment, 
TableType = (Case When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok 
		       And Fut_Opt_Brok = Fut_Fut_Fin_Brok 
		       And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE ALL TYPE'
		  When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok Then 'FUTURE/OPTION NORMAL'
		  When table_no = Fut_Fut_Fin_Brok And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE/OPTION EXPIRY'
		  When table_no = Fut_Brok Then 'FUTURE NORMAL' 
	          When table_no = Fut_Opt_Brok Then 'OPTION NORMAL' 
	          When table_no = Fut_Fut_Fin_Brok Then 'FUTURE EXPIRY' 
	          When table_no = Fut_Opt_Exc Then 'OPTION EXERCISE'
	          When table_no = Del_Brok Then 'DELIVERY BROKERAGE'  
             End)
From MCDX..Broktable, Client_Brok_Details C
where Cl_Code = @Party_Code
And (table_no = Fut_Brok
Or Table_No = Fut_Opt_Brok
Or Table_No = Fut_Fut_Fin_Brok
Or Table_No = Fut_Opt_Exc
Or Table_No = Del_Brok) 
And Exchange = 'MCX' And Segment = 'FUTURES'
Union All
Select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,
normal,trd_del,val_perc,line_no,table_name,round_to,      
RoFig,ErrNum,NoZero,      
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then 'ACTUAL'  else       
     ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 1P' else       
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then 'NEXT 5P' else      
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then 'PREV 1P' else      
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then 'PREV 5P' else       
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then 'BANKERS'             
      end )end )end )end )end )end ),
Exchange, Segment, 
TableType = (Case When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok 
		       And Fut_Opt_Brok = Fut_Fut_Fin_Brok 
		       And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE ALL TYPE'
		  When table_no = Fut_Brok And Fut_Brok = Fut_Opt_Brok Then 'FUTURE/OPTION NORMAL'
		  When table_no = Fut_Fut_Fin_Brok And Fut_Fut_Fin_Brok = Fut_Opt_Exc Then 'FUTURE/OPTION EXPIRY'
		  When table_no = Fut_Brok Then 'FUTURE NORMAL' 
	          When table_no = Fut_Opt_Brok Then 'OPTION NORMAL' 
	          When table_no = Fut_Fut_Fin_Brok Then 'FUTURE EXPIRY' 
	          When table_no = Fut_Opt_Exc Then 'OPTION EXERCISE' 
	          When table_no = Del_Brok Then 'DELIVERY BROKERAGE' 
             End)
From NCDX..Broktable, Client_Brok_Details C
where Cl_Code = @Party_Code
And (table_no = Fut_Brok
Or Table_No = Fut_Opt_Brok
Or Table_No = Fut_Fut_Fin_Brok
Or Table_No = Fut_Opt_Exc
Or Table_No = Del_Brok) 
And Exchange = 'NCX' And Segment = 'FUTURES'
order by Exchange, Segment, Table_no, Line_no, Upper_lim

GO
