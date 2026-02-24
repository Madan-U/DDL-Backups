-- Object: PROCEDURE dbo.sp_StockTrackingReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure sp_StockTrackingReport     
                                (@fromdate datetime, @todate datetime, @fromParty varchar(10), @toParty varchar(10), @fromScrip varchar(12), @toScrip varchar(12))    
as    
Select  s.Exchange, d.sett_no, d.sett_Type, Sec_PayIn = Convert(Varchar,Sec_Payin,103),     
d.Party_Code, d.Scrip_Cd, s1.long_name as ScripName, s1.series, d.CertNo,     
DpId = (Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.DpID     
      Else (Case When DrCr = 'C' And TrType <> 907    
                                  Then D.DpID     
            Else Case When DrCr = 'C'    
      Then 'FROM'    
      Else 'TO'    
        End        
          End)    
            End),    
CltDpId = (Case When DrCr = 'D' And TrType not in (907,1000)    
                         Then D.CltDpId     
              Else (Case When DrCr = 'C' And TrType <> 907    
                                          Then D.CltDpId     
                    Else Case When DrCr = 'C'    
              Then D.CltDpId     
              Else ISett_No + '-' + ISett_Type    
                End        
                   End)    
            End),    
PurQty = Sum(Case When DrCr = 'D' Then Qty Else 0 End),      
ExeDate = (Case When DrCr = 'D' Then Convert(Varchar,TransDate,103) Else '' End),     
SellQty = Sum(Case When DrCr = 'C' Then Qty Else 0 End),    
RecDate = (Case When DrCr = 'C' Then Convert(Varchar,TransDate,103) Else '' End),    
c1.Long_Name, c1.L_Address1, c1.L_Address2, c1.L_Address3, c1.L_city, c1.L_Zip, c1.L_State, c1.L_Nation, c1.Fax, c1.Res_Phone1,  
c1.Branch_cd, c1.Family, c1.trader, c1.pan_gir_no, convert(varchar,getdate(),103) as rptDate, D.TransDate    
From DelTrans d, Sett_Mst S, client1 c1, client2 c2 , scrip1 s1, scrip2 s2    
Where S.Sett_No = D.Sett_No    
And S.Sett_Type = D.Sett_Type    
And c2.cl_code = c1.cl_code    
And d.party_code = c2.party_code    
And d.scrip_cd = s2.scrip_cd    
And d.series = s1.series    
And s1.series = s2.series    
And s2.co_code = s1.co_code    
And CertNo Like 'IN%'    
And Filler2 = 1 And Delivered <> (Case When DrCr = 'C' Then '' Else '0' End)    
And TrType <> 906 And d.Party_Code <> 'BROKER'    
And CltDpId Not In (Select DpCltNo From DeliveryDp Dp Where D.DpId =Dp.DpId And D.CltDpId = DP.DpCltNo )    
And Sec_PayIn >= @fromdate and Sec_PayIn <= @todate    
And d.Party_Code >= @fromParty and d.Party_Code <= @toParty    
And d.Scrip_Cd >= @fromScrip and d.Scrip_Cd <= @toScrip    
Group By s.Exchange, d.sett_no, d.sett_Type,Convert(Varchar,Sec_Payin,103),     
d.Party_Code, d.Scrip_Cd, s1.long_name, s1.series, d.CertNo,     
(Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.DpID     
      Else (Case When DrCr = 'C' And TrType <> 907    
                                  Then D.DpID     
            Else Case When DrCr = 'C'    
      Then 'FROM'    
      Else 'TO'    
        End        
          End)    
            End),    
(Case When DrCr = 'D' And TrType not in (907,1000)    
                         Then D.CltDpId     
              Else (Case When DrCr = 'C' And TrType <> 907    
                                          Then D.CltDpId     
                    Else Case When DrCr = 'C'    
              Then D.CltDpId     
              Else ISett_No + '-' + ISett_Type    
                End        
                   End)    
            End),    
c1.Long_Name, c1.L_Address1, c1.L_Address2, c1.L_Address3, c1.L_city, c1.L_Zip, c1.L_State, c1.L_Nation, c1.Fax, c1.Res_Phone1,  
c1.Branch_cd, c1.Family, c1.trader, c1.pan_gir_no, D.TransDate, DrCr  
Union All    
Select  s.Exchange, d.sett_no, d.sett_Type, Sec_PayIn = Convert(Varchar,Sec_Payin,103),     
D.Party_Code, d.Scrip_Cd, s1.long_name as ScripName, s1.series, d.CertNo,     
DpId = (Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.DpID     
      Else (Case When DrCr = 'C'    
            Then 'FROM'    
            Else 'TO'    
     End)    
 End),    
CltDpId = (Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.CltDpId     
      Else (Case When DrCr = 'C'    
            Then HolderName    
            Else ISett_No + '-' + ISett_Type    
     End)    
 End),    
PurQty = Sum(Case When DrCr = 'D' Then Qty Else 0 End),      
ExeDate = (Case When DrCr = 'D' Then Convert(Varchar,TransDate,103) Else '' End),     
SellQty = Sum(Case When DrCr = 'C' Then Qty Else 0 End),    
RecDate = (Case When DrCr = 'C' Then Convert(Varchar,TransDate,103) Else '' End),    
c1.Long_Name, c1.L_Address1, c1.L_Address2, c1.L_Address3, c1.L_city, c1.L_Zip, c1.L_State, c1.L_Nation,c1.Fax, c1.Res_Phone1,     
c1.Branch_cd, c1.Family, c1.trader, c1.pan_gir_no, convert(varchar,getdate(),103) as rptDate, D.TransDate    
From DelTrans d, Sett_Mst S, client1 c1, client2 c2 , scrip1 s1, scrip2 s2    
Where S.Sett_No = D.Sett_No    
And S.Sett_Type = D.Sett_Type    
And c2.cl_code = c1.cl_code    
And d.party_code = c2.party_code    
And d.scrip_cd = s2.scrip_cd    
And d.series = s1.series    
And s1.series = s2.series    
And s2.co_code = s1.co_code    
And CertNo Like 'IN%'    
And Filler2 = 1 And Delivered <> (Case When DrCr = 'C' Then '' Else '0' End)    
And TrType <> 906 And d.Party_Code <> 'BROKER'    
And CltDpId In (Select DpCltNo From DeliveryDp Dp Where D.DpId =Dp.DpId And D.CltDpId = DP.DpCltNo )    
And Sec_PayIn >= @fromdate and Sec_PayIn <= @todate    
And d.Party_Code >= @fromParty and d.Party_Code <= @toParty    
And d.Scrip_Cd >= @fromScrip and d.Scrip_Cd <= @toScrip    
Group By s.Exchange, d.sett_no, d.sett_Type,Convert(Varchar,Sec_Payin,103),     
d.Party_Code, d.Scrip_Cd, s1.long_name, s1.series, d.CertNo,     
(Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.DpID     
      Else (Case When DrCr = 'C'    
            Then 'FROM'    
            Else 'TO'    
     End)    
 End),    
(Case When DrCr = 'D' And TrType not in (907,1000)     
             Then D.CltDpId     
      Else (Case When DrCr = 'C'    
            Then HolderName    
            Else ISett_No + '-' + ISett_Type    
     End)    
 End),    
c1.Long_Name, c1.L_Address1, c1.L_Address2, c1.L_Address3, c1.L_city, c1.L_Zip, c1.L_State, c1.L_Nation,c1.Fax, c1.Res_Phone1,     
c1.Branch_cd, c1.Family, c1.trader, c1.pan_gir_no, D.TransDate, DrCr    
Order By d.Party_Code, s1.long_name, D.Sett_No, S.Sec_PayIn, D.Sett_Type, D.TransDate

GO
