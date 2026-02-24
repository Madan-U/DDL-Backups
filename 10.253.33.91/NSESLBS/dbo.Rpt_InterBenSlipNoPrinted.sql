-- Object: PROCEDURE dbo.Rpt_InterBenSlipNoPrinted
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_InterBenSlipNoPrinted (@StatusId Varchar(20), @StatusName Varchar(50)) As    
Select D.Party_Code, C1.Long_Name, Scrip_Cd, Qty = Qty,     
ISett_no , ISett_Type, D.BDpId, BCltDpId, Reason  
From DelTrans D, Client1 C1, Client2 C2    
Where TrType = 1000 And DrCr = 'D'     
And Filler2 = 1 And Delivered = '0'
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
Order By D.Party_Code, C1.Long_Name, Scrip_Cd, ISett_no, ISett_Type, D.BDpId, BCltDpId,Reason

GO
