-- Object: PROCEDURE dbo.Angel_Generate_Client_Login_BKP_20221010
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure Angel_Generate_Client_Login_BKP_20221010       
as        
set transaction isolation level read uncommitted        
set nocount on        
        
        
select pcode=a.party_code,pswd='S62       ',        
First_name=substring(short_name,1,charindex(' ',short_name+space(2))),        
Middle_name=substring(short_name,charindex(' ',short_name+space(2))+1,charindex(' ',short_name+space(2),charindex(' ',short_name+space(2))+1)-charindex(' ',short_name+space(2))),        
Last_name=ltrim(substring(short_name,charindex(' ',short_name+space(2),charindex(' ',short_name+space(2))+1),50)),        
sex=space(6),add1=' ',add2=' ',ph1=' ',ph2=' ',cat=20,aut=17,a.party_code,validupto=convert(varchar(11),getdate()+30)+' 23:59:59'          
into #File1         
from          
(select c1.short_name,c2.party_code from client1 c1, client2 c2, (select cl_code from client5 where inactivefrom > getdate())  c5         
where c1.cl_code=c2.cl_code and c5.cl_Code=c1.cl_code) a         
left outer join tblPradnyausers b on a.party_code=b.fldusername where b.fldusername is null         
    
update #File1 set pswd=b.encruppswd from intranet.ctcl.dbo.get_BoCliEncryptPswd b where #File1.pcode=b.party_Code    
    
        
update #file1 set sex=(Case when b.sex='M' then 'MALE' when b.sex='F' then 'FEMALE' else '' end) from client5 b        
where #file1.pcode=b.cl_code        
      
update #file1 set last_name=replace(middle_name,substring(middle_name,1,charindex('.',middle_name+space(2))),'')      
where last_name='' and ltrim(rtrim(middle_name)) like '%.%'      
      
update #file1 set middle_name=substring(middle_name,1,charindex('.',middle_name+space(2)))      
where ltrim(rtrim(middle_name)) like '%.%'      
      
update #file1 set add1='x' where last_name=''  and middle_name <> '' and middle_name not like '%.%'      
update #file1 set last_name=middle_name where add1='x'       
update #file1 set middle_name='' where add1='x'       
update #file1 set add1=''      
      
        
insert into tblPradnyausers 
select * from #file1         
        
insert into tblusercontrolmaster (FLDUSERID,FLDPWDEXPIRY,FLDMAXATTEMPT,FLDATTEMPTCNT,FLDSTATUS,FLDLOGINFLAG,FLDACCESSLVL,FLDIPADD,FLDTIMEOUT,FLDFIRSTLOGIN,FLDFORCELOGOUT)         
select FLDAUTO,15,3,0,0,0,'F','',20,'Y',0  from tblPradnyausers where fldusername=fldstname and fldauto not in (Select flduserid from tblusercontrolmaster)         
        
set nocount off

GO
