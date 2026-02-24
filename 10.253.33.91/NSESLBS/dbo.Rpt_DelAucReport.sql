-- Object: PROCEDURE dbo.Rpt_DelAucReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DelAucReport (@StatusId Varchar(20), @StatusName Varchar(35), @Sett_no Varchar(7), @Sett_Type Varchar(2)) as      
Select S.Party_Code, Long_Name = Replace(C1.Long_Name, ',', ''),  
S.Scrip_Cd, S.Series, Scrip_Name = S1.Long_Name, Qty=Sum(TradeQty),       
Rate = Sum(Case When Sell_Buy = 1 Then TradeQty*N_NetRate       
                                                    + (Case When Insurance_Chrg = 1       
                                                               Then S.Ins_chrg Else 0 END)      
               +  S.Other_Chrg       
                                                  Else TradeQty*N_NetRate       
                                                    - (Case When Insurance_Chrg = 1       
                                                               Then S.Ins_chrg Else 0 END)      
               -  S.Other_Chrg       
                 End) / Sum(TradeQty),      
Amt = Sum(Case When Sell_Buy = 1 Then TradeQty*N_NetRate       
                                                    + (Case When Insurance_Chrg = 1       
                                                               Then S.Ins_chrg Else 0 END)      
               +  S.Other_Chrg       
                                                  Else TradeQty*N_NetRate       
                                                    - (Case When Insurance_Chrg = 1       
                                                               Then S.Ins_chrg Else 0 END)      
               -  S.Other_Chrg       
                 End),      
Sett_no, Sett_Type,       
Remark = (Case When Sell_Buy = 1 Then 'PayIn' Else 'PayOut' End)      
From settlement S, Client1 C1, Client2 C2, Scrip2 S2, Scrip1 S1      
where C1.Cl_Code = C2.Cl_Code      
And C2.Party_Code = S.Party_Code      
And S1.Co_Code = S2.Co_Code      
And S1.Series = S2.Series      
And S.Scrip_Cd = S2.Scrip_CD      
And S.Series = S2.Series      
And sett_no = @Sett_No      
and sett_Type = @Sett_Type      
and auctionpart like 'F%'      
And MarketRate > 0      
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
Group by S.Party_Code, C1.Long_Name, S.Scrip_Cd, S.Series, S1.Long_Name, Sell_buy, Sett_no, Sett_Type      
Order By S.Scrip_Cd, S.Series, S.Party_Code, Sell_buy

GO
