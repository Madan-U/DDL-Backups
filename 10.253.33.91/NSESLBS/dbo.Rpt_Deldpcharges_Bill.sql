-- Object: PROCEDURE dbo.Rpt_Deldpcharges_Bill
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_Deldpcharges_Bill (@Fromdate Varchar(11), @Todate Varchar(11), @Fromparty Varchar(10), @Toparty Varchar(10) ) As
Select D.Party_Code, C1.Long_Name, L_Address1, L_Address2, L_Address3, L_City, L_State, L_Nation, L_Zip, Branch_Cd, 
Sett_No, Sett_Type, D.Scrip_Cd, Scrip_Name = S1.Long_Name, Transdate = Convert(Varchar, Transdate, 103), Qty, Amount = Totalcharges,
Service_Tax,  
Internalsliptype = (Case When Internalsliptype = 'Is' 
												  Then 'Inter Sett' 
												  When Internalsliptype = 'Po' 
												  Then 'Pay Out' 
												  When Internalsliptype = 'Pb' 
												  Then 'Held' 
												  When Internalsliptype = 'Bp' 
												  Then 'Pay In' 
												  When Internalsliptype = 'Om' 
												  Then 'Off Market' 
                             End), 
Transdet = (Case When Internalsliptype = 'Is' 
									Then Isett_No
									When Internalsliptype = 'Po' 
									Then Cltdpid 
									When Internalsliptype = 'Pb' 
									Then '' 
									When Internalsliptype = 'Bp' 
									Then '' 
									When Internalsliptype = 'Om' 
									Then Cltdpid
                  End), 
Dd = Day(Transdate), Mm = Month(Transdate), Yy = Year(Transdate)
From Deliverydpchargesfinalamount D, Client1 C1, Client2 C2, Scrip1 S1, Scrip2 S2 
Where C1.Cl_Code = C2.Cl_Code 
And C2.Party_Code = D.Party_Code
And Transdate > = @Fromdate And Transdate < = @Todate
And D.Party_Code> = @Fromparty And D.Party_Code < = @Toparty
And Totalcharges > 0 
And S1.Co_Code = S2.Co_Code
And S1.Series = S2.Series 
And S2.Scrip_cd = D.Scrip_Cd 
And S2.Series = D.Series 
Order By C1.Branch_Cd, D.Party_Code, Internalsliptype, Year(Transdate), Month(Transdate), Day(Transdate)

GO
