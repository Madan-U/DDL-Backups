-- Object: PROCEDURE dbo.rpt_Collateral_Ack_Released
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE    Proc rpt_Collateral_Ack_Released (@Exchange Varchar(3), @Segment Varchar(8), @DateFrom Varchar(11), @DateTo Varchar(11),    
 @PartyFrom Varchar(12), @PartyTo Varchar(12),@BGFLAG Varchar(3),@FDFLAG Varchar(3),@SECFLAG Varchar(3)) AS    
    
Select *    
From    
   (  
 /*FD Details*/
 Select c1.Party_Code, Long_name, L_Address1, isnull(L_Address2,'') L_Address2, isnull(L_Address3,'') L_Address3,     
       isnull(L_City,'') L_City, isnull(L_Zip,'') L_Zip, isnull(L_State,'') L_State, isnull(L_Nation,'') L_Nation, 
       FD_Bank_Name = isnull((case when F.Fd_Type = 'B' then (Select min(Bank_name) from CollateralBank
                          where bank_code = f.bank_code and active = 1 and Exchange = @Exchange and Segment = @Segment )
                     Else (case when F.Fd_Type = 'C' then (Select min(Company_Name) from CollateralCompany
                          where Company_Code = f.bank_code and active = 1 and Exchange = @Exchange and Segment = @Segment)end)
                     end),''),
       FD_Branch_Name = isnull((case when F.Fd_Type = 'B' then (Select min(Branch_name) from C_Bank_Branch_Master
                     where bank_code = f.bank_code and active = 1 and Exchange = @Exchange and Segment = @Segment)
                     end),''),
       F1.Fd_Type Fd_Type , F1.Bank_Code FD_Bank_Code, F1.FDR_No FDR_No, convert(varchar,Issue_Date,103) FD_Issue_Date,
       convert(varchar,Maturity_Date,103) FD_Maturity_Date,convert(varchar,Release_Date,103) FD_Receive_Date,First_Holder FD_First_Holder, f.Fd_Amount,  
	'' BG_Bank_Name,'' BG_Branch_Name,'' BG_Bank_Code,'' Bg_No,'' BG_Issue_Date,'' BG_Maturity_Date,
        '' BG_Receive_Date,0 BG_Amount,'' Sec_BankDpId,'' Sec_Dp_Acc_Code,'' Sec_Isin,'' Sec_Scrip_Cd,
        '' Sec_Series,0 Sec_Qty,'' Sec_EffDate,'' Sec_Bank_Name,    
        'FD' Coll_Type  
       from FixeddepositMst F, FixeddepositTrans F1,ClientMaster C1 where F1.Party_code Between @PartyFrom And @PartyTo 
       and F.Party_Code = F1.Party_code 
	and F.FDR_No = F1.FDR_No and DrCr = 'C'
	and C1.Party_Code = f.Party_Code
       and Trans_Date Between @DateFrom and @DateTo 
	and Exchange = @Exchange 
	and Segment = @Segment
	and @FDFLAG = 'FD'    
       
UNION
 /*bg Details*/
     Select C1.Party_Code, Long_name, L_Address1, isnull(L_Address2,'') L_Address2, isnull(L_Address3,'') L_Address3,     
            isnull(L_City,'') L_City, isnull(L_Zip,'') L_Zip, isnull(L_State,'') L_State, isnull(L_Nation,'') L_Nation,     
          
      '' FD_Bank_Name,'' FD_Branch_Name,'' Fd_Type,'' FD_Bank_Code,'' FDR_No,'' FD_Issue_Date,'' FD_Maturity_Date,    
      '' FD_Receive_Date,'' FD_First_Holder,0 Fd_Amount,  
       bg_Bank_Name = isnull((Select min(Bank_name) from CollateralBank
                          where bank_code = f.bank_code and active = 1 and Exchange = @Exchange and Segment = @Segment)
                     ,''),
       bg_Branch_Name = isnull((Select min(Branch_name) from C_Bank_Branch_Master
                     where bank_code = f.bank_code and active = 1 and Exchange = @Exchange and Segment = @Segment)
                     ,''),
        F1.Bank_Code BG_Bank_Code, F1.Bg_No Bg_No, convert(varchar,Issue_Date,103) BG_Issue_Date, 
	convert(varchar,Maturity_Date,103) BG_Maturity_Date, convert(varchar,Release_Date,103) BG_Receive_Date, 
	 F1.Bg_Amount Bg_Amount
	,'' Sec_BankDpId,'' Sec_Dp_Acc_Code,'' Sec_Isin,'' Sec_Scrip_Cd,'' Sec_Series,0 Sec_Qty,'' Sec_EffDate,
        '' Sec_Bank_Name, 'BG' Coll_Type    
       from BankGuaranteeTrans F1, BankGuaranteeMst F ,ClientMaster C1 
	 where C1.Party_Code = f.Party_Code 
	and F1.Party_code Between @PartyFrom And @PartyTo  
    and Trans_Date Between @DateFrom and @DateTo 
    and Exchange = @Exchange and Segment = @Segment
    and F.Party_Code = F1.Party_code and F.BG_No = F1.BG_No and DrCr = 'C'
    and @BGFLAG = 'BG'          


UNION
 /*SEC Details*/
	Select 
           C1.Party_Code, Long_name, L_Address1, isnull(L_Address2,'') L_Address2, isnull(L_Address3,'') L_Address3,     
	   isnull(L_City,'') L_City, isnull(L_Zip,'') L_Zip, isnull(L_State,'') L_State, isnull(L_Nation,'') L_Nation,     
	       
	   '' FD_Bank_Name,'' FD_Branch_Name,'' Fd_Type,'' FD_Bank_Code,'' FDR_No,'' FD_Issue_Date,'' FD_Maturity_Date,'' FD_Receive_Date,    
	   '' FD_First_Holder,0 Fd_Amount,'' BG_Bank_Name,'' BG_Branch_Name,'' BG_Bank_Code,'' Bg_No,'' BG_Issue_Date,    
	   '' BG_Maturity_Date,'' BG_Receive_Date,0 BG_Amount,    
	       	
	   BankDpId Sec_BankDpId, Dp_Acc_Code Sec_Dp_Acc_Code, C.Isin Sec_Isin, 
           Sec_Scrip_Cd = (Case When @Exchange='BSE' And @Segment='CAPITAL' Then '['+ C.Scrip_Cd +'] '+ IsNull(S2.Scrip_Cd,'') Else C.Scrip_Cd End),
           C.Series Sec_Series, Qty Sec_Qty, Convert(Varchar,EffDate,103) Sec_EffDate, 
           Sec_Bank_Name = isnull((Select Min(BankName) from Bank where BankId = C.BankDpId),''),    
   	   'SEC' Coll_Type     
           From C_Securitiesmst C Left Outer Join BSEDB.DBO.Scrip2 S2 On (C.Scrip_CD = S2.BSECODE), 
	   ClientMaster C1    
	   where C1.Party_Code = C.Party_Code    
	   And drcr = 'D' and active = 1     
	   and C1.party_code <> 'Broker' and Filler11 <> 'Exchange'     
	   And C1.Party_code between @PartyFrom and @PartyTo    
	   And EffDate BetWeen @DateFrom and @DateTo    
	   and C.Exchange = @Exchange    
	   and C.Segment = @Segment    
	   and @SECFLAG = 'SEC' 

) CollDetails  
Order by Party_Code,Coll_Type  ,FD_Receive_Date , BG_Receive_Date, Sec_EffDate

GO
