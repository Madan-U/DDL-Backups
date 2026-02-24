-- Object: PROCEDURE dbo.Rpt_Delpayinmatch
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_Delpayinmatch                
(@StatusId Varchar(15),@Statusname Varchar(25),@Sett_No Varchar(7), @Sett_Type Varchar(2), @BranchCd Varchar(10),@Opt int) AS              
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)      
set transaction isolation level read uncommitted                
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0,
collateral = 0 
Into #delpayinmatch                
From Client1 C1 (nolock), Client2 C2 (nolock), Multiisin M  (nolock), Deliveryclt D  (nolock)Left Outer Join Deltrans C (nolock)                 
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                 
And D.Party_Code = C.Party_Code And Drcr = 'C'                 
And Filler2 = 1 And Sharetype <> 'Auction')                
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                
And C1.Cl_Code = C2.Cl_Code            
And C2.Party_Code = D.Party_Code            
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)             
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin                
Having D.Qty > 0                 
                
set transaction isolation level read uncommitted      
Insert Into #delpayinmatch                
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                 
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                 
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                 
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0, collateral = 0                 
From Deltrans D (nolock), Client1 C1 (nolock), Client2 C2 (nolock)                
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                
And C1.Cl_Code = C2.Cl_Code            
And C2.Party_Code = D.Party_Code            
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
    'BROKER'          
                  End)             
Group By Isett_No, Isett_Type, D.Party_Code, Certno                
      
set transaction isolation level read uncommitted                
Insert Into #delpayinmatch                
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                 
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),        
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                 
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0, collateral = 0                
From BSEDB.Dbo.Deltrans D, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2                 
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                
And C1.Cl_Code = C2.Cl_Code            
And C2.Party_Code = D.Party_Code            
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)             
Group By Isett_No, Isett_Type, D.Party_Code, Certno                
      
set transaction isolation level read uncommitted      
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),     
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                            
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Deltrans D (nolock), Deliverydp Dp (nolock)                 
Where Filler2 = 1 And Drcr = 'D'                 
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                 
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                
    
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),     
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                  
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0)           
From BSEDB.Dbo.Deltrans D (nolock), BSEDB.Dbo.Deliverydp Dp  (nolock)                
Where Filler2 = 1 And Drcr = 'D'                 
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                 
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                

update #delpayinmatch set collateral = C.collateral
from (Select Party_Code, IsIn, collateral = isnull(Sum(Case When DrCr = 'C' Then Qty Else -Qty End),0)
from msajag.dbo.c_securitiesmst where party_code <> 'broker'
group by Party_Code, IsIn
having isnull(Sum(Case When DrCr = 'C' Then Qty Else -Qty End),0) > 0) c
Where c.Party_Code = #delpayinmatch.Party_Code And c.isin = #delpayinmatch.Certno

If Upper(@Branchcd) = 'All'             
begin      
 Select @Branchcd = '%'                
end      
      
If @Opt = 1                 
begin      
set transaction isolation level read uncommitted      
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge, collateral                
From #delpayinmatch R (nolock), Multiisin M (nolock), Client2 C2 (nolock), Client1 C1 (nolock)             
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                 
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                 
And C1.Branch_Cd Like @Branchcd                  
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
   when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
               else           
                        'BROKER'          
                  End)             
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,             
Certno, Hold, Pledge, BSEHold, BSEPledge, collateral         
Having Sum(Delqty) > 0                 
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                 
end      
Else      
begin      
set transaction isolation level read uncommitted                
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge,
collateral                
From #delpayinmatch R (nolock), Multiisin M (nolock), Client2 C2 (nolock), Client1 C1 (nolock)             
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                 
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                 
And C1.Branch_Cd Like @Branchcd                  
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then c1.branch_cd          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker          
                        when @StatusId = 'Trader' then c1.Trader          
                        when @StatusId = 'Family' then c1.Family          
                        when @StatusId = 'Area' then c1.Area          
                        when @StatusId = 'Region' then c1.Region          
                        when @StatusId = 'Client' then c2.party_code          
                  else           
                        'BROKER'          
                  End)             
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,             
Hold, Pledge, BSEHold, BSEPledge, collateral                
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                 
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd          
end

GO
