-- Object: PROCEDURE dbo.rpt_ExcessPayIn
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_EXCESSPAYIN
@settno varchar(7),        
@settype varchar(3),        
@OrdFlag Int        
as        

Select Sett_no,Sett_Type,scrip_cd,series,Party_code,  
BuyQty=Sum(Case When Inout = 'O' Then Qty Else 0 End),  
SellQty=Sum(Case When Inout = 'I' Then Qty Else 0 End)  
Into #DelCltView from DeliveryClt
Where Sett_No = @SettNo
And   Sett_Type = @settype
Group BY Sett_no,Sett_Type,scrip_cd,series,Party_code 

If @OrdFlag = 1           
Begin        
	select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,D.Series,
	ToRecive = D.SellQty, ToGive = D.BuyQty, 
	Recieved = IsNull(Sum(Case when DrCr = 'C' Then DE.Qty Else 0 End),0),
	Give = IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0),
	Short = IsNull(Sum(Case When DrCr = 'C' Then DE.Qty Else 0 End),0) - D.SellQty 
	     + D.BuyQty - IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0)
	From Client2 C2,Client1 C1, #DelCltView d Left Outer Join DelTrans de         
	On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type 
	     and de.scrip_cd = d.scrip_cd and de.series = d.series 
	     and de.party_code = d.party_code and filler2 = 1 
	     And ShareType <> 'AUCTION')        
	Where D.Sett_No = @SettNo 
	And D.Sett_Type = @settype         
	And D.Party_Code = C2.Party_Code 
	And C1.Cl_Code = C2.Cl_Code        
	And D.SellQty > 0 
	group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,D.SellQty, D.BuyQty       
	Having IsNull(Sum(Case When DrCr = 'C' Then DE.Qty Else 0 End),0) - D.SellQty 
	     + D.BuyQty - IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0) > 0 
	
	Union All      
	
	select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
	ToRecive = 0, ToGive = 0, 
	Recieved = IsNull(Sum(Case when DrCr = 'C' Then D.Qty Else 0 End),0),
	Give = IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0),
	Short = IsNull(Sum(Case When DrCr = 'C' Then D.Qty Else 0 End),0)  
	     - IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0)
	from Client2 C2,Client1 C1, DelTrans d         
	where d.sett_no like @settno and d.sett_type like @settype      
	And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code        
	and DrCr = 'C' and filler2 = 1 And ShareType <> 'AUCTION'         
	And D.Party_Code Not In (       
	Select Party_Code From #DelCltView DE      
	Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd         
	      And de.series = d.series and de.party_code = d.party_code )    
	group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.Series
	Having IsNull(Sum(Case When DrCr = 'C' Then D.Qty Else 0 End),0)  
	     - IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0) > 0     
	order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.Series  
End         
Else        
Begin        
	select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,D.Series,
	ToRecive = D.SellQty, ToGive = D.BuyQty, 
	Recieved = IsNull(Sum(Case when DrCr = 'C' Then DE.Qty Else 0 End),0),
	Give = IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0),
	Short = IsNull(Sum(Case When DrCr = 'C' Then DE.Qty Else 0 End),0) - D.SellQty 
	     + D.BuyQty - IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0)
	From Client2 C2,Client1 C1, #DelCltView d Left Outer Join DelTrans de         
	On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type 
	     and de.scrip_cd = d.scrip_cd and de.series = d.series 
	     and de.party_code = d.party_code and filler2 = 1 
	     And ShareType <> 'AUCTION')        
	Where D.Sett_No = @SettNo 
	And D.Sett_Type = @settype         
	And D.Party_Code = C2.Party_Code 
	And C1.Cl_Code = C2.Cl_Code        
	And D.SellQty > 0 
	group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,D.SellQty, D.BuyQty       
	Having IsNull(Sum(Case When DrCr = 'C' Then DE.Qty Else 0 End),0) - D.SellQty 
	     + D.BuyQty - IsNull(Sum(Case when DrCr = 'D' Then DE.Qty Else 0 End),0) > 0 
	
	Union All      
	
	select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
	ToRecive = 0, ToGive = 0, 
	Recieved = IsNull(Sum(Case when DrCr = 'C' Then D.Qty Else 0 End),0),
	Give = IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0),
	Short = IsNull(Sum(Case When DrCr = 'C' Then D.Qty Else 0 End),0)  
	     - IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0)
	from Client2 C2,Client1 C1, DelTrans d         
	where d.sett_no like @settno and d.sett_type like @settype      
	And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code        
	and DrCr = 'C' and filler2 = 1 And ShareType <> 'AUCTION'         
	And D.Party_Code Not In (       
	Select Party_Code From #DelCltView DE      
	Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd         
	      And de.series = d.series and de.party_code = d.party_code )    
	group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.Series
	Having IsNull(Sum(Case When DrCr = 'C' Then D.Qty Else 0 End),0)  
	     - IsNull(Sum(Case when DrCr = 'D' Then D.Qty Else 0 End),0) > 0    
	order by d.sett_no,d.sett_type,d.scrip_cd,d.Series,d.Party_Code,c1.Short_Name        
End

GO
