-- Object: PROCEDURE dbo.USP_branchwise_BrokDetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE Procedure [dbo].[USP_branchwise_BrokDetails](@branch_code as varchar(30))    
as          
select party_code,long_name,branch_cd,sub_broker into #file1 from client_details(nolock) where     
branch_cd=@branch_code    
    
        
select * into #file2 from AngelNSECM.msajag.dbo.client_brok_details where Cl_code in (select party_code from #file1)        
      
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join    
(select  Segment='CAPITAL',Exchange='BSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]   
  
   
,round_to [Round To ],Trd_Del [Slab Type ]          
 from AngelBSECM.bsedb_AB.dbo.broktable where Table_no in (select Trd_Brok from #file2 where Segment='CAPITAL' and Exchange='BSE') and  Val_perc='P')  b       
on a.Trd_Brok=b.[Table No ] and a.Segment='CAPITAL' and a.Exchange='BSE'    
union    
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join          
(select  Segment='CAPITAL',Exchange='BSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]   
  
   
,round_to [Round To ],Trd_Del [Slab Type ]          
 from AngelBSECM.bsedb_AB.dbo.broktable where Table_no in (select Del_Brok from #file2 where Segment='CAPITAL' and Exchange='BSE') and  Val_perc='P'     )b    
on a.Del_Brok=b.[Table No ] and a.Segment='CAPITAL' and a.Exchange='BSE'    
union      
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join          
(select  Segment='CAPITAL',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]   
  
   
,round_to [Round To ],Trd_Del [Slab Type ]          
 from AngelNSECM.msajag.dbo.broktable where Table_no in (select Trd_Brok from #file2 where Segment='CAPITAL' and Exchange='NSE') and  Val_perc='P'     )b    
on a.Trd_Brok=b.[Table No ] and a.Segment='CAPITAL' and a.Exchange='NSE'    
union     
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join        
(select  Segment='CAPITAL',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]   
  
   
,round_to [Round To ],Trd_Del [Slab Type ]          
 from AngelNSECM.msajag.dbo.broktable where Table_no in (select Del_Brok from #file2 where Segment='CAPITAL' and Exchange='NSE') and  Val_perc='P'     )b    
on a.Del_Brok=b.[Table No ] and a.Segment='CAPITAL' and a.Exchange='NSE'    
union     
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join         
(select  Segment='FUTURES',Exchange='NSE',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery ]   
  
   
,round_to [Round To ],Trd_Del [Slab Type ]          
 from angelfo.nsefo.dbo.broktable where Table_no in (select Fut_Brok from #file2 where Segment='FUTURES' and Exchange='NSE') and  Val_perc='P'      )b    
on a.Fut_Brok=b.[Table No ] and a.Segment='FUTURES' and a.Exchange='NSE'    
union     
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join           
(select  Segment='COMMODITIES',Exchange='MCX',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery 
  
]    
,round_to [Round To ],Trd_Del [Slab Type ]          
 from angelcommodity.MCDX.dbo.broktable where Table_no in (select Fut_Brok from #file2 where Exchange='MCX')  and  Val_perc='P'    )b    
on a.Fut_Brok=b.[Table No ] and a.Exchange='MCX'    
union          
select a.Cl_Code,b.* from     
(select Cl_Code,Exchange,Segment,Trd_Brok,Del_Brok,Fut_Brok from #file2)a    
inner join    
(select  Segment='COMMODITIES',Exchange='NCX',Table_No [Table No ],Line_No [Line No ],Upper_lim [Upper Limit (Rs.)],Val_perc [Val/Per ],Day_puc [Day Purchase],Day_Sales [Day Sales ],Sett_Purch [Sett. Purchase],sett_sales [Sett. Sales],def_table [Delivery 
  
]    
,round_to [Round To ],Trd_Del [Slab Type ]          
 from angelcommodity.NCDX.dbo.broktable where Table_no in (select Fut_Brok from #file2 where Exchange='NCX') and  Val_perc='P'  )b    
on a.Fut_Brok=b.[Table No ] and a.Exchange='NCX' 

drop table #file1
drop table #file2

GO
