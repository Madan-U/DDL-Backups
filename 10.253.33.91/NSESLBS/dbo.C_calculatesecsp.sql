-- Object: PROCEDURE dbo.C_calculatesecsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE   Procedure C_calculatesecsp(@exchange Varchar(3), @segment Varchar(20),@party_code Varchar(10),@cl_type Varchar(3),@effdate Varchar(11), @totalsecamount Money Output,   
    @totnoncash Money Output, @totcash Money Output, @orgtotcash Money Output, @orgtotnoncash Money Output)  
As  
Declare   
@@getclrate Cursor,  
@@get Cursor,  
@@getsec Cursor,  
@@bank_code Varchar(20),  
@@secamount Money,  
@@balance Money,  
@@haircut Money,  
@@cl_rate Money,  
@@scrip_cd Varchar(12),  
@@series Varchar(3),  
@@isin Varchar(20),  
@@qty Int,  
@@cashcompo  Money,  
@@camt Money,  
@@damt Money,  
@@drcr Varchar(1),  
@@group_cd Varchar(20),  
@@noncashcompo Money,  
@@cashncash Varchar(1),  
@@instrutype  Varchar(6),  
@@bg_no Varchar(20),  
@@maturity_dt Varchar(11),  
@@receive_dt Varchar(11),  
@@orgcashncash Money,  
@@totalsecamount Money,   
@@totnoncash Money,  
@@totcash Money,  
@@orgtotcash Money,  
@@orgtotnoncash Money  
  
 Set @@secamount   = 0   
 Set @@balance  = 0   
 Set @@haircut   = 0   
 Set @@cashcompo = 0  
 Set @@noncashcompo = 0    
 Set @@balance = 0     
 Set @@orgtotcash = 0  
 Set @@orgtotnoncash = 0  Set @@totnoncash  = 0  
 Set @@totcash = 0   
 Set @@totalsecamount  = 0  
  
 /*output Parameters*/  
 Set @totalsecamount  = 0   
 Set @totnoncash  = 0   
 Set @totcash   = 0   
 Set @orgtotcash  = 0  
 Set @orgtotnoncash  = 0  
  
 /* Calculation For Sec*/    
 Set @@instrutype  = 'sec'   
 /*get Cash Noncash */  
 Set @@get = Cursor For  
  Select Cn = Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = @party_code And Exchange = @exchange   
  And Segment = @segment And Client_type = '' And Instru_type Like @@instrutype + '%' And Active = 1  
  And Effdate = (select Max(effdate) From Instrutypemst   
  Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Client_type = '' And Exchange = @exchange   
  And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),  
   Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange   
   And Segment = @segment And Client_type = @cl_type And Client_type <> '' And Instru_type Like @@instrutype + '%' And Active = 1  
   And Effdate = (select Max(effdate) From Instrutypemst   
   Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @cl_type And Exchange = @exchange   
   And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),  
    Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange   
    And Segment = @segment And Client_type = '' And Instru_type Like @@instrutype + '%' And Active = 1  
    And Effdate = (select Max(effdate) From Instrutypemst   
    Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange   
    And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),'')  
   )  
  )    
 Open @@get  
 Fetch Next From @@get Into @@cashncash  
 Close @@get  
 Deallocate @@get      
   
 Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @party_code And Effdate Like @effdate + '%' And Coll_type = 'sec'  
  
 Set @@orgcashncash = 0  
 /*get Balance Bg Amount For Bg*/  
 Set @@getsec = Cursor For      
  Select Balqty = Sum(crqty) - Sum(drqty), Scrip_cd, Series, Isin   
  From C_calculatesecviewnew  
  Where Party_code = @party_code And Effdate <= @effdate + '  23:59:59' And Exchange = @exchange And Segment =  @segment  
  Group By Scrip_cd,series, Isin  
 Open @@getsec  
 Fetch Next From @@getsec Into @@qty, @@scrip_cd, @@series, @@isin  
 While @@fetch_status = 0  
 Begin    
  /*take The Group Code*/  
  Set @@get = Cursor For   
   Select Distinct Group_code  From Groupmst Where Scrip_cd = @@scrip_cd And Series Like @@series + '%'  
   And Exchange = @exchange And Segment = @segment And Active = 1  
   And Effdate = (select Max(effdate) From Groupmst   Where Scrip_cd = @@scrip_cd And Series Like @@series + '%'  
         And Exchange = @exchange And Segment = @segment  
         And Effdate <= @effdate + ' 23:59:59' And Active = 1)  
  Open @@get  
  Fetch Next From @@get Into @@group_cd  
  Close @@get  
  Deallocate @@get  
  Select @@cl_rate = 0   
  /*take The Closing Rate */  
  Set @@getclrate = Cursor For  
   Select Isnull(cl_rate,0) Cl_rate From C_valuation Where Scrip_cd = @@scrip_cd  And Series Like @@series + '%'  
   And Exchange = @exchange And Segment = @segment And  
   Sysdate = (select Max(sysdate) From C_valuation Where Sysdate <= @effdate + '  23:59:59' And   
   Scrip_cd = @@scrip_cd  And Series Like  @@series + '%'  
     And Exchange = @exchange And Segment = @segment)  
  Open @@getclrate  
  Fetch Next From @@getclrate Into @@cl_rate  
  Close @@getclrate  
  Deallocate @@getclrate    
  
  Set @@secamount = (@@qty * @@cl_rate)  
  Set @@orgcashncash = @@orgcashncash + @@secamount  /*added By Vaishali On 20-03-2002*/  
  
  /*take The Haircut*/  
  Set @@get = Cursor For  
   Select Haircut = Isnull((select Haircut From Securityhaircut Where Party_code = @party_code And Scrip_cd = @@scrip_cd And Series = @@series And   
    Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut   
    Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Scrip_cd = @@scrip_cd And Series = @@series And   
    Exchange = @exchange And Segment = @segment And Active = 1)),  
    Isnull((select Haircut From Securityhaircut Where Party_code = @party_code And Scrip_cd = '' And Exchange = @exchange   
    And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59'   
    And Party_code = @party_code And Scrip_cd = '' And Exchange = @exchange And Segment = @segment And Active = 1)),  
    Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = @@scrip_cd And Series = @@series And   
     Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate)   
     From Securityhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And   
     Scrip_cd = @@scrip_cd And Series = @@series And Exchange = @exchange And Segment = @segment And Active = 1)),  
     Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And   
      Group_cd = @@group_cd And Group_cd <> ''  And Exchange = @exchange And Segment = @segment   
      And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And   
      Party_code = '' And Scrip_cd = '' And Group_cd = @@group_cd And Group_cd <> '' And   
      Exchange = @exchange And Segment = @segment And Active = 1)),  
       Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And   
       Client_type = @cl_type And Client_type <> ''  And Exchange = @exchange And Segment = @segment   
       And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And   
       Party_code = '' And Scrip_cd = '' And Client_type = @cl_type And Client_type <> '' And   
       Exchange = @exchange And Segment = @segment And Active = 1)),  
        Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And Client_type = '' And Group_cd = ''  
        And Active = 1 And Exchange = @exchange And Segment = @segment And Effdate = (select Max(effdate)   
        From Securityhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And   
        Scrip_cd = ''  And Client_type = ''  And Group_cd = '' And Exchange = @exchange And Segment = @segment And Active = 1)),0)  
       )  
      )  
     )  
    )  
   )  
    
  Open @@get  
  Fetch Next From @@get Into @@haircut  
  If @@fetch_status = 0  
  Begin   
   Set  @@secamount = @@secamount - (@@secamount * @@haircut/100)  
  End  
  Close @@get  
  Deallocate @@get      
     
	Select  @@TotalSecAmount = @@TotalSecAmount +  isnull(@@SecAmount,0)

    
--  If @@cl_rate > 0    
   Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@party_code,@@scrip_cd,@@series,@@isin,@@cl_rate,(@@cl_rate * @@qty),  
   @@qty, @@haircut, @@secamount , @@cashcompo , @@noncashcompo ,'','','sec', @cl_type,'','',getdate(),@@cashncash,'','','','')  
   
  Fetch Next From @@getsec Into @@qty, @@scrip_cd, @@series, @@isin    
 End  
    
   
  
 If @@cashncash = 'c'  
 Begin    
  Set @@totcash = @@totcash + @@totalsecamount  
  Set @@orgtotcash = @@orgtotcash + @@orgcashncash   
 End  
 Else If @@cashncash = 'n'  
 Begin    
  Set @@totnoncash = @@totnoncash + @@totalsecamount  
  Select  @@OrgTotNonCash = @@OrgTotNonCash + isnull(@@OrgCashNcash ,0)
 End   
 Else   
 Begin    
  Set @@totnoncash = @@totnoncash + @@totalsecamount  
  Select  @@OrgTotNonCash = @@OrgTotNonCash + isnull(@@OrgCashNcash ,0)
 End  
  
 Set @totcash = @@totcash   
 Set @orgtotcash = @@orgtotcash   
 Set @totnoncash  = @@totnoncash   
 Select  @OrgTotNonCash = isnull(@@OrgTotNonCash,0)
 Set @totalsecamount =  @@totalsecamount  
  
Close @@getsec  
Deallocate @@getsec     
  
Select @totalsecamount ,@totcash ,@orgtotcash ,@totnoncash ,@orgtotnoncash

GO
