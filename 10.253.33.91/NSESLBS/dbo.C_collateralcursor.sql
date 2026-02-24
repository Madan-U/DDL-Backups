-- Object: PROCEDURE dbo.C_collateralcursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure C_collateralcursor  
@exchange Varchar(3),
@segment Varchar(20),
@party_code Varchar(10),
@trans_date Varchar(11),
@flag Int
As
Select Isnull(balance,0) Balance, Fm.bank_code
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
	       Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no
	       And F1.trans_date <=  @trans_date + ' 23:59')
And F.party_code = @party_code And Fm.exchange = @exchange And Fm.segment = @segment
And Fm.party_code =  F.party_code And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status = 'v'

GO
