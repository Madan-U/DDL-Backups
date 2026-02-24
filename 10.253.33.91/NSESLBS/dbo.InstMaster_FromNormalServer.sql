-- Object: PROCEDURE dbo.InstMaster_FromNormalServer
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InstMaster_FromNormalServer
(@ForParty Varchar(10) = 'ALL') As  

Select @ForParty = (Case When @ForParty = '' Or @ForParty = '%' 
						 Then 'ALL' 
						 Else @ForParty 
					End)

if @ForParty = 'ALL' 
Begin
	Truncate table Client1  
	Truncate table Client2  
	Truncate table Client3  
	Truncate table Client4  
	Truncate table Client5  
	Truncate table Broktable  
	Truncate table InstClient_tbl  
	Truncate table Sett_mst  
	Truncate table Scrip1  
	Truncate table Scrip2  
	Truncate table Custodian  
	Truncate table MultiIsIn  
	Truncate table Ucc_Client  
	Truncate table TermParty  
	Truncate table TermLimit  
	Truncate table ClientTaxes_New  
	Truncate table ClientBrok_Scheme  
	  
	Insert into client1   
	select * from MTSRVR03.MSAJAG.DBO.Client1  
	  
	Insert into client2   
	select * from MTSRVR03.MSAJAG.DBO.Client2  
	  
	Insert into client3   
	select * from MTSRVR03.MSAJAG.DBO.Client3  
	  
	Insert into client4   
	select * from MTSRVR03.MSAJAG.DBO.Client4  
	  
	Insert into client5   
	select * from MTSRVR03.MSAJAG.DBO.Client5  
	  
	Insert into broktable   
	select * from MTSRVR03.MSAJAG.DBO.broktable  
	  
	Insert into InstClient_Tbl   
	select * from MTSRVR03.MSAJAG.DBO.Instclient_Tbl  
	  
	Insert into sett_mst   
	select * from MTSRVR03.MSAJAG.DBO.sett_mst  
	  
	Insert into Scrip1   
	select * from MTSRVR03.MSAJAG.DBO.Scrip1  
	  
	Insert into Scrip2   
	select * from MTSRVR03.MSAJAG.DBO.Scrip2  
	  
	Insert into Custodian   
	select * from MTSRVR03.MSAJAG.DBO.Custodian  
	  
	Insert into MultiIsIn   
	select * from MTSRVR03.MSAJAG.DBO.MultiIsIn  
	  
	Insert into Ucc_Client   
	select * from MTSRVR03.MSAJAG.DBO.Ucc_Client  
	  
	Insert into TermParty   
	select * from MTSRVR03.MSAJAG.DBO.TermParty  
	  
	Insert into TermLimit   
	select * from MTSRVR03.MSAJAG.DBO.TermLimit  
	  
	Insert into ClientTaxes_New   
	select * from MTSRVR03.MSAJAG.DBO.ClientTaxes_New  
	  
	Insert into ClientBrok_Scheme   
	select PARTY_CODE,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,BrokScheme,From_Date,To_Date  
	from MTSRVR03.MSAJAG.DBO.ClientBrok_Scheme
End
Else
Begin
	Delete From Client1 Where Cl_Code = @ForParty
	Delete From Client2 Where Cl_Code = @ForParty
	Delete From Client3 Where Cl_Code = @ForParty
	Delete From Client4 Where Cl_Code = @ForParty
	Delete From Client5 Where Cl_Code = @ForParty
	Delete From InstClient_tbl Where Partycode = @ForParty
	Delete From ClientTaxes_New Where Party_Code = @ForParty
	Delete From ClientBrok_Scheme Where Party_Code = @ForParty
	Delete From Ucc_Client Where Party_Code = @ForParty

	Insert into client1   
	select * from MTSRVR03.MSAJAG.DBO.Client1  
	Where Cl_Code = @ForParty

	Insert into client2   
	select * from MTSRVR03.MSAJAG.DBO.Client2  
    Where Cl_Code = @ForParty
	  
	Insert into client3   
	select * from MTSRVR03.MSAJAG.DBO.Client3  
	Where Cl_Code = @ForParty
  
	Insert into client4   
	select * from MTSRVR03.MSAJAG.DBO.Client4  
	Where Cl_Code = @ForParty
  
	Insert into client5   
	select * from MTSRVR03.MSAJAG.DBO.Client5  
	Where Cl_Code = @ForParty

	Insert into Ucc_Client   
	select * from MTSRVR03.MSAJAG.DBO.Ucc_Client  
    Where Party_Code = @ForParty
	
    Insert into ClientTaxes_New   
	select * from MTSRVR03.MSAJAG.DBO.ClientTaxes_New  
	Where Party_Code = @ForParty

	Insert into ClientBrok_Scheme   
	select PARTY_CODE,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,BrokScheme,From_Date,To_Date  
	from MTSRVR03.MSAJAG.DBO.ClientBrok_Scheme
    Where Party_Code = @ForParty

	Insert into InstClient_Tbl   
	select * from MTSRVR03.MSAJAG.DBO.Instclient_Tbl  
	Where Partycode = @ForParty

	delete from broktable   
	where table_no in (select table_no from ClientBrok_Scheme
    Where Party_Code = @ForParty)

	Insert into broktable   
	select * from MTSRVR03.MSAJAG.DBO.broktable
	where table_no in (select table_no from MTSRVR03.MSAJAG.DBO.ClientBrok_Scheme
    Where Party_Code = @ForParty)

	delete from Custodian   
	where custodiancode in (Select CltDpNo From Client2
	Where Cl_Code = @ForParty)

	Insert into Custodian   
	select * from MTSRVR03.MSAJAG.DBO.Custodian  
	where custodiancode in (Select CltDpNo From MTSRVR03.MSAJAG.DBO.Client2
	Where Cl_Code = @ForParty)  

End

GO
