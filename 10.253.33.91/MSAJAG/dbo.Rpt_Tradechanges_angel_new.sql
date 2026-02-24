-- Object: PROCEDURE dbo.Rpt_Tradechanges_angel_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_Tradechanges_angel_new (@Sauda_date Varchar(11),@Type Char(1))                    
As                    
        
Set @Sauda_date = Convert(varchar(11),Convert(datetime,@Sauda_date,103))        
                    
IF @Type = 'N'        
Begin        
 IF Not Exists (Select * from Mis.Nse.dbo.nsechangesdetails where sauda_date = @Sauda_date)        
 Begin        
  Select wrong_code = Branch_id,correct_code =Party_code,              
  Symbol =Scrip_cd,Tradeqty,sell_buy,Marketrate,order_no,user_id  into #n        
  from settlement where sauda_date like @Sauda_date  + '%'                     
  and branch_id <> party_code and sett_type not in ('A','X')              
        
  Select wrong_code,x.branch_cd as WBranch_cd,correct_code,y.branch_cd as CBranch_cd,symbol,sell_buy,tradeqty,Marketrate,order_no,Sauda_Date = convert(datetime,@Sauda_date),user_id into #n1 from             
  (            
  select #n.*,b.branch_cd from #n             
  left outer join             
  client_details b on             
  #n.wrong_code = b.party_code            
  )x            
  left outer join            
  (select * from client_details) y           
  on x.correct_code = y.party_code         
        
  Insert into Mis.Nse.dbo.nsechangesdetails        
  (Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,Buy_Sell,Tradeqty,Marketrate,Order_No,Sauda_Date,TerminalId,Fld_Remarks,Fld_Flag,Fld_EnteredBy,Fld_ApprovedBy)        
  Select Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,sell_buy,sum(Tradeqty),avg(MarketRate),Order_No,      
  Sauda_Date,User_Id,'',0,'','' from #n1 group by      
  Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,sell_buy,Order_No,Sauda_Date,User_Id        
          
  Select 1        
 End        
 Else        
  Select 0        
End        
Else        
Begin        
 IF Not Exists (Select * from Mis.Nse.dbo.bsechangesdetails where sauda_date = @Sauda_date)        
 Begin        
  Select wrong_code = Branch_id,correct_code = Party_code,Script_cd=Settlement.Scrip_cd,Symbol = S2.Scrip_cd ,               
  Tradeqty,sell_buy,Marketrate ,order_no,user_id into #b from anand.bsedb_ab.dbo.settlement ,anand.bsedb_ab.dbo.Scrip2 S2               
  where sauda_date like @Sauda_date + '%'              
  and branch_id <> party_code and sett_type not in ('AD','AC') and User_Id not in(select UserId from anand.bsedb_ab.dbo.termparty)               
  and s2.Bsecode = Settlement.Scrip_cd             
  Order by Branch_id,party_code,Settlement.Scrip_cd         
        
  Select wrong_code,x.branch_cd as WBranch_cd,correct_code,y.branch_cd as CBranch_cd,Script_cd,symbol,sell_buy,tradeqty,Marketrate,order_no,Sauda_Date = convert(datetime,@Sauda_date),user_id into #b1 from             
  (            
  select #b.*,b.branch_cd from #b             
  left outer join             
  anand1.msajag.dbo.client_details b on             
  #b.wrong_code = b.party_code            
  )x            
  left outer join            
  (select * from anand1.msajag.dbo.client_details) y           
  on x.correct_code = y.party_code         
        
  Insert into Mis.Nse.dbo.bsechangesdetails        
  (Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,Scrip_Cd,Buy_Sell,Tradeqty,Marketrate,Order_No,Sauda_Date,TerminalId,Fld_Remarks,Fld_Flag,Fld_EnteredBy,Fld_ApprovedBy)        
  Select Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,Script_Cd,sell_buy,sum(Tradeqty),avg(MarketRate),Order_No,      
  Sauda_Date,User_Id,'',0,'','' from #b1 group by      
  Wrong_Code,WBranch_Cd,Correct_Code,CBranch_Cd,Symbol,Script_Cd,sell_buy,Order_No,Sauda_Date,User_Id       
          
  Select 1        
 End        
 Else        
  Select 0        
End

GO
