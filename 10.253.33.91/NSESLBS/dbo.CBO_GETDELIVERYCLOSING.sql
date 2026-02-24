-- Object: PROCEDURE dbo.CBO_GETDELIVERYCLOSING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_GETDELIVERYCLOSING  
 (
  @transdate  VARCHAR(11),  
  @batchno    VARCHAR(10),  
  @Slipno     int=0,   
  @settno     VARCHAR(7),  
  @setttype   VARCHAR(2),  
  @partcode   VARCHAR(10),
  @flag       VARCHAR(1),  
	@STATUSID   VARCHAR(25) = 'BROKER',  
  @STATUSNAME VARCHAR(25) = 'BROKER'  
 )  
 AS  
  DECLARE  
	  @SQLVAR  int,  
	  @SQL Varchar(2000),  
	  @SB_COUNT INT  
 IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END  
  IF @FLAG <> 'A' AND @FLAG <> 'B' AND @FLAG <> 'C' AND @FLAG <> 'D' AND @FLAG <> 'E'AND @FLAG <> 'F'AND @FLAG <> 'G'    
   BEGIN  
   RAISERROR ('Flags Not Set Properly', 16, 1)  
  RETURN  
 END  
  IF @flag = 'A'  
  BEGIN  
   select
       distinct convert(varchar(11),transdate,103)as transdate
       from deltransTemp order by transdate
   END  
  Else IF @flag = 'B'  
    BEGIN  
         select
          distinct BatchNo = Convert(int,BatchNo)
              from DelTransTemp 
               where TransDate like Convert(varchar(11), Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and trtype<>'907' and party_code <> 'BROKER'
                     order by Convert(int,BatchNo)
         END    
   Else IF @flag = 'C'  
         BEGIN   
              select 
                 distinct SlipNo
                    from DelTransTemp 
                      where TransDate like Convert(varchar(11), Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and trtype<>'907' and party_code <> 'BROKER' 
                     END  
    Else IF @flag = 'D'  
    BEGIN  
        select
         distinct Sett_No
            from DelTransTemp
              where TransDate like Convert(varchar(11), Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and trtype<>'907' and party_code <> 'BROKER'  
         END   
     Else IF @flag = 'E'  
    BEGIN  
         select
            distinct sett_type
                from  deltranstemp
                   where TransDate like Convert(varchar(11), Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and party_code <> 'BROKER'    
         END  
       Else IF @flag = 'F'  
    BEGIN  
        select distinct scrip_cd from  deltranstemp where TransDate like Convert(varchar(11), Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and party_code <> 'BROKER'
        And Convert(Int,BatchNo) = @batchno And SlipNo = @Slipno And sett_No= @settno And sett_Type = @setttype
        And Party_Code = @partcode order by scrip_cd 
    END   
   Else IF @flag = 'G'  
    BEGIN  
        select distinct Party_Code from  deltranstemp where TransDate like Convert(varchar(11),  Convert(DateTime, @transdate,103), 109)+ '%' and filler2= 1 and party_code <> 'BROKER'  
    END

GO
