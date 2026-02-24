-- Object: PROCEDURE dbo.Remmissor_sharing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.remmissor_sharing    Script Date: 01/15/2005 1:14:02 Pm ******/
Create Proc Remmissor_sharing (@sett_no Varchar(7), @sett_type Varchar(2))
As

Delete From Remissor_trans_temp Where Sett_no = @sett_no And Sett_type = @sett_type

Insert Into Remissor_trans_temp
Select Sett_no,sett_type,party_code,remcode,branch_cd,
Trdbrok,delbrok,trdturnover,delturnover,
Rembrokerage=(case When Sharingtype = 'g' 
		   Then ( Case When Transtype = 'trd' 
		 	       Then (case When Trdbroknew > 0 
					  Then Round(trdbroknew*sharing/100,2)
				          Else 0 
				     End )
			       Else (case When Delbroknew > 0 
					  Then Round(delbroknew*sharing/100,2)
					  Else 0 
				     End )	
			  End )
		   When Sharingtype = 'r' 
		   Then ( Case When Transtype = 'trd' 
		 	       Then (case When Trdbroknew > Round(trdturnover*sharing/100,2)
				          Then Trdbroknew - Round(trdturnover*sharing/100,2)
					  Else 0 
				     End )	
			       Else (case When Delbroknew > Round(delturnover*sharing/100,2)
				          Then Delbroknew - Round(delturnover*sharing/100,2)
					  Else 0 
				     End )
			  End )
		   When Sharingtype = 't' 
		   Then ( Case When Transtype = 'trd' 
		 	       Then (case When Trdbroknew > Round(trdturnover*sharing/100,2)
				          Then Round(trdturnover*sharing/100,2)
					  Else 0 
				     End )	
			       Else (case When Delbroknew > Round(delturnover*sharing/100,2)
				          Then Round(delturnover*sharing/100,2)
					  Else 0 
				     End )
			  End )
		   Else 0
	      End ),
Sharingtype,sharing,transtype,charges
From 
(
Select Sett_no,sett_type,s.party_code,remcode,branch_cd,sharingtype,val_per,sharing,transtype,charges,
Trdbrok=(case When Transtype = 'trd' 
	      Then Sum(case When Billflag In (2,3) 
		            Then Tradeqty*brokapplied
                            Else 0
                       End)
              Else 0
	 End),
Delbrok=(case When Transtype = 'del' 
	      Then Sum(case When Billflag In (1,4,5) 
		            Then Tradeqty*nbrokapp
                            Else 0
                       End)
              Else 0
	 End),
Trdbroknew=(case When Transtype = 'trd' 
	      Then Sum(case When Billflag In (2,3) 
		            Then Tradeqty*brokapplied
                            Else 0
                       End)-sum(case When Billflag In (2,3) 
		                     Then (tradeqty*marketrate*charges/100)
                                     Else 0
                                End)
              Else 0
	 End),
Delbroknew=(case When Transtype = 'del' 
	      Then Sum(case When Billflag In (1,4,5) 
		            Then Tradeqty*nbrokapp
                            Else 0
                       End)-sum(case When Billflag In (1,4,5) 
		                     Then (tradeqty*marketrate*charges/100)
                                     Else 0
                                End)
              Else 0
	 End),
Trdturnover=(case When Transtype = 'trd' 
		  Then Sum(case When Billflag In (2,3) 
		                Then (tradeqty*marketrate) 
			        Else 0 
                           End)
                  Else 0 
             End ),
Delturnover=(case When Transtype = 'del' 
		  Then Sum(case When Billflag In (1,4,5) 
			        Then (tradeqty*marketrate) 
			        Else 0 
                           End)
                  Else 0 
             End )
From Settlement S, Remissor_master R, Client1 C1, Client2 C2
Where C1.cl_code = C2.cl_code 
And C2.party_code = S.party_code 
And S.party_code = R.party_code
And S.sauda_date Between Fromdate And Todate
And Sett_no = @sett_no And Sett_type = @sett_type
And Auctionpart Not In ('ap','ar','fp','fs','fl','fc','fa')
Group By Sett_no,sett_type,s.party_code,remcode,branch_cd,sharingtype,val_per,sharing,transtype,charges ) A
Where Trdturnover > 0 Or Delturnover > 0

GO
