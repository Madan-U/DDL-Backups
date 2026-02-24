-- Object: PROCEDURE dbo.C_CollateralCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.C_CollateralCursor    Script Date: 12/26/2001 12:13:13 PM ******/

CREATE PROCEDURE C_CollateralCursor  
@Exchange Varchar(3),
@Segment Varchar(20),
@Party_Code Varchar(10),
@Trans_Date Varchar(11),
@Flag int
AS
/* Take the fd balance and bank code for the selected party and date*/
select isnull(balance,0) Balance, Fm.Bank_Code
From FixedDepositTrans F, FixedDepositMst Fm
where F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
	       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no
	       and f1.Trans_Date <=  @Trans_Date + ' 23:59')
and F.Party_Code = @Party_Code and Fm.Exchange = @Exchange and Fm.Segment = @Segment
and fm.party_Code =  f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status = 'V'

/*Declare
@@Balance money,
@@Bank_Code Varchar(20),
@@FdAmount Money,
@@BgAmount Money,
@@FdHairCut int,
@@BgHairCut int,
@@HairCut int,
@@Coll Cursor,
@@HairCutCur Cursor

Set  @@Coll = Cursor For
	 Take the fd balance and bank code for the selected party and date
	select isnull(balance,0) Balance, Fm.Bank_Code
	From FixedDepositTrans F, FixedDepositMst Fm
	where F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
 		       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no
		       and f1.Trans_Date <=  @Trans_Date + ' 23:59')
	and F.Party_Code = @Party_Code and Fm.Exchange = @Exchange and Fm.Segment = @Segment
	and fm.party_Code =  f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status = 'V'
Open @@Coll
Fetch Next From @@Coll Into @@Balance, @@Bank_Code
While @@Fetch_Status = 0
Begin
	 Select the haircut
	Set @@HairCutCur = Cursor For  		

	select HairCutPer = (Case when @party_code <> '' and @@bank_code <> '' 
			                   then (select haircut from fdhaircut where party_code = @party_code and bank_code = @@bank_code and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = @@bank_code AND Exchange = @Exchange and Segment = @Segment))
		   		Else (Case when @party_code <> '' and @@bank_code = '' 
			          		       then (select haircut from fdhaircut where party_code = @party_code and bank_code = '' and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = '' AND Exchange = @Exchange and Segment = @Segment))
		                   		Else (Case when @party_code = '' and @@bank_code <> '' 
			    			       then (select haircut from fdhaircut where party_code = @party_code and bank_code = @@bank_code and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = @@bank_code AND Exchange = @Exchange and Segment = @Segment))
						Else (Case when @party_code = '' and @@bank_code = '' 
				                       		      then (select HAICUT2 = ISNULL((SELECT haircut from fdhaircut where party_code = @party_code and bank_code = @@bank_code and Client_Type <> '' and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = @@bank_code and Client_Type <> '' AND Exchange = @Exchange and Segment = @Segment))
							     ,(select haircut from fdhaircut where party_code = @party_code and bank_code = @@bank_code and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = @@bank_code AND Exchange = @Exchange and Segment = @Segment))))
		  				           end)
		                         		          end)
				           end)
		  	            end)
	From Fdhaircut 
	where Exchange = @Exchange and Segment = @Segment
	and EffDate = ( Select max(Effdate) from fdhaircut where EffDate <= @Trans_Date + ' 23:59' and party_code = @party_code and bank_code = @@bank_code and Exchange = @Exchange and Segment = @Segment)
	and party_code = @party_code and bank_code = @@bank_code

	Open @@HairCutCur
	Fetch Next From @@HairCutCur Into @@HairCut
		
End
*/

GO
