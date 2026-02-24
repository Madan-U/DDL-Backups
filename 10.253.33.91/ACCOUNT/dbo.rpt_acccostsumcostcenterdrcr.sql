-- Object: PROCEDURE dbo.rpt_acccostsumcostcenterdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcostcenterdrcr    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsumcostcenterdrcr    Script Date: 11/28/2001 12:23:46 PM ******/


CREATE proc rpt_acccostsumcostcenterdrcr

@catcode smallint,
@grpcode varchar(20),
@vdt datetime,
@nextgrpcode varchar(20),
@samelevelgrpcode varchar(20),
@abovelevelgrpcode varchar(20),
@firstlevelgrpcode varchar(20),
@maincostcentergrpcode varchar(20)

as

/* finds debit and credit for clicked level */

select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and grpcode = @grpcode and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode

/*finds debit and credit for level below  clicked level */ 
union all 

select catcode, flag='next' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode=@catcode and (grpcode like @nextgrpcode and grpcode not like @grpcode) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode


/*finds debit and credit for same level  as clicked level */ 

union all 
select catcode, flag='same' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like @samelevelgrpcode and grpcode not like @grpcode) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode


/*finds debit and credit for level immediately above clicked level 
    flag is set to main because as per the program if flag is not set to main it will calculate drcr for all below levels since 
    we are calculating and showing levels below this selected level already there is no need to calculate dr cr of below levels 
    e.g  br01000000 is out put of this query and br01010000 is clicked so we have already shown levels below it, so don't take
    totals of levels within br01000000
 */ 

union all 
select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like @abovelevelgrpcode and grpcode not like @grpcode)and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode


/*finds debit and credit for levels above clicked level other than immdiate above level
   e.g query gives br02000000 if user has clicked br01010000
 */ 

union all 
select catcode, flag='' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like @firstlevelgrpcode and  grpcode not like @abovelevelgrpcode and  grpcode not like @maincostcentergrpcode )and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode


/*finds debit and credit for main level other than selected costcenters  */ 
union all 
select catcode, flag='' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like '__00000000' and grpcode not like @maincostcentergrpcode  ) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode

union all

/*finds debit and credit for main level for selected costcenters  */ 
select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like @maincostcentergrpcode ) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode ,costname,costcode
order by catcode,grpcode

GO
