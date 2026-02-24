-- Object: PROCEDURE dbo.USP_Kiran
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Procedure USP_Kiran(@branchcd varchar(20))      
as      
select * into #file1 
from client_details(nolock) where branch_cd=@branchcd and isnumeric(cl_code)=0           
    
select * into #file2 from client_brok_details where Cl_code in (select party_code from #file1)    
    
select  b.Cl_Code,Segment='CAPITAL',Exchange='BSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from anand.bsedb_AB.dbo.broktable a,#file2 b  where Table_no=Trd_Brok  and  Segment='CAPITAL' and Exchange='BSE' 
union      
select  b.Cl_Code,Segment='CAPITAL',Exchange='BSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from anand.bsedb_AB.dbo.broktable a,#file2 b  where Table_no=Del_Brok and Segment='CAPITAL' and Exchange='BSE' 
union      
select  b.Cl_Code,Segment='CAPITAL',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from broktable a,#file2 b  where Table_no=Trd_Brok  and  Segment='CAPITAL' and Exchange='NSE' 
union     
select  b.Cl_Code,Segment='CAPITAL',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from broktable a,#file2 b  where Table_no=Del_Brok and Segment='CAPITAL' and Exchange='NSE'  
union     
select  b.Cl_Code,Segment='FUTURES',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from angelfo.nsefo.dbo.broktable a,#file2 b  where Table_no=Fut_Brok and Segment='FUTURES' and Exchange='NSE' 
union      
select  b.Cl_Code,Segment='COMMODITIES',Exchange='MCX',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]
  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from angelcommodity.MCDX.dbo.broktable a,#file2 b  where Table_no=Fut_Brok and Exchange='MCX' 
union      
select   b.Cl_Code,Segment='COMMODITIES',Exchange='NCX',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]
  
,round_to [Round To ],Trd_Del [Slab Type ]      
 from angelcommodity.NCDX.dbo.broktable a,#file2 b  where Table_no=Fut_Brok and Exchange='NCX' order by b.Cl_Code

GO
